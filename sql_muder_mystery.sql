-- ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City

SELECT name 
FROM sqlite_master
WHERE type = 'table'

-- crime_scene_report

						-- CREATE TABLE crime_scene_report ( date integer, type text, description text, city text )

-- drivers_license

						-- CREATE TABLE drivers_license ( id integer PRIMARY KEY, age integer, height integer, eye_color text, hair_color text, gender text, plate_number text, car_make text, car_model text )

-- person

						-- CREATE TABLE person ( id integer PRIMARY KEY, name text, license_id integer, address_number integer, address_street_name text, ssn integer, FOREIGN KEY (license_id) REFERENCES drivers_license(id) )

-- facebook_event_checkin

						-- CREATE TABLE facebook_event_checkin ( person_id integer, event_id integer, event_name text, date integer, FOREIGN KEY (person_id) REFERENCES person(id) )

-- interview

						-- CREATE TABLE interview ( person_id integer, transcript text, FOREIGN KEY (person_id) REFERENCES person(id) )

-- get_fit_now_member

						-- CREATE TABLE get_fit_now_member ( id text PRIMARY KEY, person_id integer, name text, membership_start_date integer, membership_status text, FOREIGN KEY (person_id) REFERENCES person(id) )

-- get_fit_now_check_in

						-- CREATE TABLE get_fit_now_check_in ( membership_id text, check_in_date integer, check_in_time integer, check_out_time integer, FOREIGN KEY (membership_id) REFERENCES get_fit_now_member(id) )

-- income

						-- CREATE TABLE income ( ssn integer PRIMARY KEY, annual_income integer )

-- solution

						-- CREATE TABLE solution ( user integer, value text )

------------------------------------------------------------------------------------

SELECT *
FROM crime_scene_report
WHERE date = 20180115 AND type = "murder" AND city = "SQL City"

-- 20180115	
-- murder
-- Security footage shows that there were 2 witnesses. 
-- 		The first witness lives at the last house on "Northwestern Dr".
--		The second witness, named Annabel, lives somewhere on "Franklin Ave".
-- SQL City


-- The first witness lives at the last house on "Northwestern Dr".

SELECT * 
FROM person
WHERE address_street_name ="Northwestern Dr"
ORDER BY address_number DESC

--	14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949


-- The second witness, named Annabel, lives somewhere on "Franklin Ave".

SELECT * 
FROM person
WHERE address_street_name ="Franklin Ave"
AND name LIKE "%Annabel%"

-- 16371	Annabel Miller	490173	103	Franklin Ave	318771143

-- Interview Morty

SELECT * 
FROM interview
WHERE person_id = "14887"

-- I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
-- The membership number on the bag started with "48Z". Only gold members have those bags.

-- The man got into a car with a plate that included "H42W".

SELECT *
FROM get_fit_now_member
WHERE membership_status = "gold"
AND id LIKE "%48Z%"

-- 48Z7A	28819	Joe Germuska	20160305	gold
-- 48Z55	67318	Jeremy Bowers	20160101	gold

SELECT *
FROM drivers_license
WHERE gender = "male" AND plate_number LIKE "%H42W%"

-- 423327	30	70	brown	brown	male	0H42W2	Chevrolet	Spark LS
-- 664760	21	71	black	black	male	4H42WR	Nissan	Altima

-- Interview Annabel

-- I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

SELECT *
FROM get_fit_now_member
WHERE name = "Annabel Miller"
-- 90081	16371	Annabel Miller	20160208	gold

-- Annabel Checkin Time
SELECT *
FROM get_fit_now_check_in
WHERE membership_id = "90081"
-- 90081	20180109	1600	1700

-- Joe Germuska Checkin Time
SELECT *
FROM get_fit_now_check_in
WHERE membership_id = "48Z7A"
-- 48Z7A	20180109	1600	1730
-- war eine halbe stunde länger als annabel da

-- Jeremy Bowers Checkin Time
SELECT *
FROM get_fit_now_check_in
WHERE membership_id = "48Z55"
-- 48Z55	20180109	1530	1700
-- war eine halbe stunde früher als annabel da

-- Event wo beide Zeugen und einer der Verdächtigen war:
SELECT *
FROM facebook_event_checkin
WHERE person_id = "67318" OR person_id = "14887" OR person_id = "16371"
-- 14887	4719	The Funky Grooves Tour	20180115
-- 16371	4719	The Funky Grooves Tour	20180115
-- 67318	4719	The Funky Grooves Tour	20180115
-- 67318	1143	SQL Symphony Concert	20171206

-- person info der beiden verdächtigen
SELECT *
FROM person
WHERE name = "Joe Germuska" OR name = "Jeremy Bowers"
-- 28819	Joe Germuska	173289	111	Fisk Rd	138909730
-- 67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279

-- einzige person wo license plate passt
SELECT *
FROM person
WHERE (name = "Joe Germuska" OR name = "Jeremy Bowers") AND (license_id = "423327" OR license_id = "664760")

-- 67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279

-- Solution 1

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
SELECT value FROM solution;

-- Congrats, you found the murderer!
-- But wait, there's more... If you think you're up for a challenge, try querying the 
-- interview transcript of the murderer to find the real villian behind this crime.
-- If you feel especially confident in your SQL skills, try to complete this final step
-- with no more than 2 queries. Use this same INSERT statement to check your answer.

SELECT *
FROM interview
WHERE person_id = "67318"

-- I was hired by a woman with a lot of money.
-- I don't know her name but I know she's around 5'5" (65") or 5'7" (67").
-- She has red hair and she drives a Tesla Model S.
-- I know that she attended the SQL Symphony Concert 3 times in December 2017. 

SELECT *
FROM drivers_license
WHERE car_make = "Tesla" AND car_model = "Model S" AND gender = "female"

SELECT *
FROM drivers_license
JOIN person ON person.license_id = drivers_license.id
JOIN income ON person.ssn = income.ssn
JOIN facebook_event_checkin ON facebook_event_checkin.person_id = person.id
WHERE car_make = "Tesla" AND car_model = "Model S" AND gender = "female"

--> Miranda Priestly

-- Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!