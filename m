Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbbADMmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 07:42:50 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:51258 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADMms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 07:42:48 -0500
X-Greylist: delayed 160428 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2015 07:42:48 EST
From: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Subject: [PATCH v2] fs: isofs: Fix bug in the way to check if the year is a leap year
Date: Sun,  4 Jan 2015 12:42:25 +0000
Message-Id: <1420375345-3967-1-git-send-email-oscar.forner.martinez@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the whole algorithm for a call to mktime64 that takes
care of all that details.

Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
---
 fs/isofs/util.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/isofs/util.c b/fs/isofs/util.c
index 01e1ee7..a3f953a 100644
--- a/fs/isofs/util.c
+++ b/fs/isofs/util.c
@@ -2,6 +2,7 @@
  *  linux/fs/isofs/util.c
  */
 
+#include <linux/time.h>
 #include "isofs.h"
 
 /* 
@@ -31,18 +32,7 @@ int iso_date(char * p, int flag)
 	if (year < 0) {
 		crtime = 0;
 	} else {
-		int monlen[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
-
-		days = year * 365;
-		if (year > 2)
-			days += (year+1) / 4;
-		for (i = 1; i < month; i++)
-			days += monlen[i-1];
-		if (((year+2) % 4) == 0 && month > 2)
-			days++;
-		days += day - 1;
-		crtime = ((((days * 24) + hour) * 60 + minute) * 60)
-			+ second;
+		crtime = mktime64(year+1970, month, day, hour, minute, second);
 
 		/* sign extend */
 		if (tz & 0x80)
-- 
1.9.1

