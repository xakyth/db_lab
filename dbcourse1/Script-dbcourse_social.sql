/* Delete the tables if they already exist */
drop table if exists Highschooler;
drop table if exists Friend;
drop table if exists Likes;

/* Create the schema for our tables */
create table Highschooler(ID int, name text, grade int);
create table Friend(ID1 int, ID2 int);
create table Likes(ID1 int, ID2 int);

/* Populate the tables with our data */
insert into Highschooler values (1510, 'Jordan', 9);
insert into Highschooler values (1689, 'Gabriel', 9);
insert into Highschooler values (1381, 'Tiffany', 9);
insert into Highschooler values (1709, 'Cassandra', 9);
insert into Highschooler values (1101, 'Haley', 10);
insert into Highschooler values (1782, 'Andrew', 10);
insert into Highschooler values (1468, 'Kris', 10);
insert into Highschooler values (1641, 'Brittany', 10);
insert into Highschooler values (1247, 'Alexis', 11);
insert into Highschooler values (1316, 'Austin', 11);
insert into Highschooler values (1911, 'Gabriel', 11);
insert into Highschooler values (1501, 'Jessica', 11);
insert into Highschooler values (1304, 'Jordan', 12);
insert into Highschooler values (1025, 'John', 12);
insert into Highschooler values (1934, 'Kyle', 12);
insert into Highschooler values (1661, 'Logan', 12);

insert into Friend values (1510, 1381);
insert into Friend values (1510, 1689);
insert into Friend values (1689, 1709);
insert into Friend values (1381, 1247);
insert into Friend values (1709, 1247);
insert into Friend values (1689, 1782);
insert into Friend values (1782, 1468);
insert into Friend values (1782, 1316);
insert into Friend values (1782, 1304);
insert into Friend values (1468, 1101);
insert into Friend values (1468, 1641);
insert into Friend values (1101, 1641);
insert into Friend values (1247, 1911);
insert into Friend values (1247, 1501);
insert into Friend values (1911, 1501);
insert into Friend values (1501, 1934);
insert into Friend values (1316, 1934);
insert into Friend values (1934, 1304);
insert into Friend values (1304, 1661);
insert into Friend values (1661, 1025);
insert into Friend select ID2, ID1 from Friend;

insert into Likes values(1689, 1709);
insert into Likes values(1709, 1689);
insert into Likes values(1782, 1709);
insert into Likes values(1911, 1247);
insert into Likes values(1247, 1468);
insert into Likes values(1641, 1468);
insert into Likes values(1316, 1304);
insert into Likes values(1501, 1934);
insert into Likes values(1934, 1501);
insert into Likes values(1025, 1101);


/*Q1 Find the names of all students who are friends with someone named Gabriel. */
SELECT name
FROM Highschooler
WHERE ID in (SELECT Friend.ID2
			 FROM Friend, (SELECT ID
				        	FROM Highschooler
							WHERE Highschooler.name = 'Gabriel') r1
			 WHERE Friend.ID1 = r1.ID);
			 
/*Q2 For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. */
SELECT r2.name, r2.grade, h2.name, h2.grade
FROM Highschooler h2, (SELECT h.name as name, h.grade as grade, l.ID2 as ID2
						FROM Highschooler h join Likes l
						ON h.ID = l.ID1) r2
WHERE h2.ID = r2.ID2 and r2.grade - h2.grade >= 2;

/*Q3 For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. */
SELECT h2.name, h2.grade, r1.name, r1.grade
FROM Highschooler h2, Likes l2, (SELECT h.name, h.grade, h.ID, l.ID2 
							     FROM Highschooler h join Likes l
								 ON h.ID = l.ID1) r1
WHERE h2.ID = l2.ID1 and h2.ID = r1.ID2 and l2.ID2 = r1.ID and h2.name < r1.name;

/*Q4 Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. */
SELECT name, grade
FROM Highschooler h 
WHERE h.ID not in (SELECT ID1 as ID
					FROM Likes
					union 
					SELECT ID2 as ID
					FROM Likes)
ORDER BY grade, name

/*Q5 For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */
SELECT h.name, h.grade, h2.name, h2.grade
FROM Highschooler h, Highschooler h2, (SELECT l.ID1, l.ID2
	FROM Likes l
	WHERE l.ID2 not in (SELECT ID1 FROM Likes)) r1
WHERE h.ID = r1.ID1 and h2.ID = r1.ID2 

/*Q6 Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. */
SELECT r1.name, r1.grade
FROM (SELECT h1.name, h1.grade
	FROM Friend f, Highschooler h1, Highschooler h2
	WHERE f.ID1 = h1.ID and f.ID2 = h2.ID and h1.grade = h2.grade
	EXCEPT 
	SELECT h1.name, h1.grade
	FROM Friend f, Highschooler h1, Highschooler h2
	WHERE f.ID1 = h1.ID and f.ID2 = h2.ID and h1.grade <> h2.grade) r1
ORDER BY r1.grade, r1.name;

/*Q7 For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. */
/* TODO: */


/*TODO: Q8 Find the difference between the number of students in the school and the number of different first names. */

/*TODO: Q9 Find the name and grade of all students who are liked by more than one other student.*/



		