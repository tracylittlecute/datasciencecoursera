## read data for train
train_X <- read.table('X_train.txt') 
train_y <- read.table('y_train.txt')
train_subject <- read.table('subject_train.txt')
train <- cbind(train_subject,train_y,train_X)

## read data for test
test_X <- read.table('X_test.txt') 
test_y <- read.table('y_test.txt')
test_subject <- read.table('subject_test.txt')
test <- cbind(test_subject,test_y,test_X)

## merge the train data and test data into one data
data_full <- rbind(train,test) 

## change column names to descriptive names
col_names <- read.table('features.txt')
colnames(data_full) <- c('subject','activity',as.character(col_names[,2]))

## extract data with 'mean' and 'std' in the column name
Mean <- grep('mean()',names(data_full),fixed=TRUE)
Std <- grep('std()',names(data_full),fixed = TRUE)
index <- c(Mean,Std)
data_extract <- data_full[,c(1,2,index)]

## calculate average of 'mean' and 'std' measurements grouping by subject and activity
valid_col_names <- make.names(names=names(data_extract),unique = TRUE,allow_ = TRUE)
names(data_extract) <- valid_col_names
data_melt <- melt(data_extract,id.vars = c('subject','activity'))
data_grp <- data_melt %>% group_by(subject,activity,variable) %>% summarize(mean(value))

## label activity with descriptive names
act_labels <- read.table('activity_labels.txt')
colnames(act_labels) <- c('number','activity_name')
data_final <- merge(data_grp,act_labels,by.x='activity',by.y='number')

## write output to a txt file
write.table(data_final,file='output.txt',row.names = FALSE)
