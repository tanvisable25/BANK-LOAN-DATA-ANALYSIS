create database if not exists financial_data;
use financial_data;

CREATE TABLE financial(
id int,
address_state char(2),
application_type varchar(50),
emp_length varchar(50),
emp_title varchar(100),
home_ownership varchar(50),
grade varchar(50),
issue_date varchar(50),
last_credit_pull_date varchar(50),
last_payment_date varchar(50),
loan_status varchar(50),
next_payment_date varchar(50),
member_id int,
purpose varchar(50),
sub_grade varchar(50),
term varchar(50),
verification_status varchar(50),
annual_income decimal(12,2),
dti decimal(5,5),
installment decimal(7,2),
int_rate decimal(5,5),
loan_amount int,
total_acc int,
total_payment int);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/financial.csv"
 INTO TABLE financial
FIELDS TERMINATED BY ','
optionally enclosed by '"'
 lines terminated by '\n'
IGNORE 1 lines;


SET SQL_SAFE_UPDATES = 0;
alter table financial rename column address_state TO STATE;

SELECT ISSUE_DATE,str_to_date(issue_date,'%d-%m-%Y') as final_issue_date FROM financial;
SELECT last_credit_pull_date,str_to_date(last_credit_pull_date,'%d-%m-%Y') as final_last_credit_pull_date FROM financial;
SELECT last_payment_date,str_to_date(last_payment_date,'%d-%m-%Y') as final_last_payment_date FROM financial;
SELECT next_payment_date,str_to_date(next_payment_date,'%d-%m-%Y') as final_next_payment_date FROM financial;

update financial set final_issue_date=str_to_date(issue_date,'%d-%m-%Y'),
final_last_credit_pull_date=str_to_date(last_credit_pull_date,'%d-%m-%Y'),
final_last_payment_date=str_to_date(last_payment_date,'%d-%m-%Y'),
final_next_payment_date=str_to_date(next_payment_date,'%d-%m-%Y');

select*from financial;

alter table financial drop column issue_date,drop column last_credit_pull_date,drop column last_payment_date, drop column next_payment_date;

alter table financial add column final_issue_date date,
add column final_last_credit_pull_date date, add column final_last_payment_date date, add column final_next_payment_date date;

select sum(loan_amount) as total_funded_amount from financial 
where day(final_issue_date) = 10 and month(final_issue_date) = 08 and year(final_issue_date) = 2021;

select sum(total_payment) as total_amount_received from financial 
where day(final_issue_date) = 10 and month(final_issue_date) = 08 and year(final_issue_date) = 2021;

select round(avg(int_rate),4) *100 as avg_interest_rate from financial
where month(final_issue_date) = 12 and year(final_issue_date) = 2021;

select count(id) as good_loan_application from financial 
where loan_status = 'fully_paid' or loan_status = 'current';

SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM financial
WHERE MONTH(final_issue_date) = 12;

	SELECT loan_status, member_id,
        COUNT(id),-- AS LoanCount,
        SUM(total_payment),-- AS Total_Amount_Received,
        SUM(loan_amount),-- AS Total_Funded_Amount,
        AVG(int_rate * 100),-- AS Interest_Rate,
        AVG(dti * 100)-- AS DTI
    FROM financial
    GROUP BY member_id,loan_status;
 	SELECT member_id,loan_amount FROM financial where member_id=70699;
    
    
    select id,member_id,loan_amount,COUNT(id) over(partition by member_id);


