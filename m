Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3HELK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 07:10:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9300 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3HELKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:10:24 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-b5-51ff881efa2f
From: Phil Carmody <phil.carmody@partner.samsung.com>
To: apw@canonical.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org,
        Phil Carmody <phil.carmody@partner.samsung.com>
Subject: [PATCH 1/1] checkpatch: fix some whitespace issues caused by --fix
Date: Mon, 05 Aug 2013 14:08:52 +0300
Message-id: <1375700932-2851-1-git-send-email-phil.carmody@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xy7pyHf8DDXYsV7X4sFbDYvb9xywW
	l3fNYbPY/WopqwOLx6yGXjaPg+/2MHl8WXWN2ePzJrkAligum5TUnMyy1CJ9uwSujPPzFzMX
	3JCouLfjM3MD42/BLkZODgkBE4kT5w6xQdhiEhfurQeyuTiEBJYySqxcO58dwulkklh15SQL
	SBWbgKnElBXfmEBsEQE1iZaeaewgNrNAsMTjtzOYQWxhAW+JTdN6wWpYBFQlFk1/AWRzcPAK
	+Evc3O4DYkoIKEjMmWQzgZF7ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYwQz3/Zwbj4
	mNUhRgEORiUeXg2+/4FCrIllxZW5hxglOJiVRHivlQCFeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MK7doXOjf/k0n5u3BO833eZK+31thlnCkzmT7Hd4qPOWJ08rPq+gP1ddYae0PHd67guOwvlm
	55ONk5T28nN1N2/j3xMqcH/7Hu/rxtsbIo5bz8hb+iZ9asyGB0b17TJzSxUPiMpeO3rH+tOf
	//f3vT8uu1pl6tfda7x/GbvdZ7JbL/vhK1+g71UlluKMREMt5qLiRAAOCrtO2gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lines with incorrect spacing around an operator, such as:
  bystander, correct,incorrect
would get "fixed" to
  bystander,correct, incorrect
as the correct argument as well as the incorrectly-spaced operator
were both being trimmed. The correct argument only needs to be
right trimmed.

Signed-off-by: Phil Carmody <phil.carmody@partner.samsung.com>
---
 scripts/checkpatch.pl |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2ee9eb7..b5f4157 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1432,6 +1432,13 @@ sub check_absolute_file {
 	}
 }
 
+sub rtrim {
+	my ($string) = @_;
+
+	$string =~ s/\s+$//;
+
+	return $string;
+}
 sub trim {
 	my ($string) = @_;
 
@@ -2852,7 +2859,7 @@ sub process {
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
 						if (ERROR("SPACING",
 							  "space required after that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]) . " ";
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
 						}
 					}
@@ -2881,7 +2888,7 @@ sub process {
 						if (ERROR("SPACING",
 							  "space prohibited after that '$op' $at\n" . $hereptr)) {
 							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							$line_fixed = 1;
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;
@@ -2904,7 +2911,7 @@ sub process {
 						if (ERROR("SPACING",
 							  "space prohibited before that '$op' $at\n" . $hereptr)) {
 							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							$line_fixed = 1;
 						}
 					}
@@ -2912,7 +2919,7 @@ sub process {
 						if (ERROR("SPACING",
 							  "space prohibited after that '$op' $at\n" . $hereptr)) {
 							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							$line_fixed = 1;
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;
@@ -2931,7 +2938,7 @@ sub process {
 						if (ERROR("SPACING",
 							  "need consistent spacing around '$op' $at\n" . $hereptr)) {
 							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
 						}
 					}
@@ -2942,7 +2949,7 @@ sub process {
 					if ($ctx =~ /Wx./) {
 						if (ERROR("SPACING",
 							  "space prohibited before that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							$line_fixed = 1;
 						}
 					}
-- 
1.7.9.5

