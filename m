Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbbABQRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:17:00 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48083 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbABQQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:16:59 -0500
From: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Subject: [PATCH] fs: isofs: Fix bug in the way to check if the year is a leap year
Date: Fri,  2 Jan 2015 16:08:48 +0000
Message-Id: <1420214928-7104-1-git-send-email-oscar.forner.martinez@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way to check if the year is a leap year was incomplete.
It was checking only if the year can be divided by 4, that is
necessary but not a sufficient condition. It has to check as well
if the year can not be divided by 100 or if the year can be
divided by 400.

Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
---
 fs/isofs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/isofs/util.c b/fs/isofs/util.c
index 01e1ee7..d2dd602 100644
--- a/fs/isofs/util.c
+++ b/fs/isofs/util.c
@@ -38,7 +38,7 @@ int iso_date(char * p, int flag)
 			days += (year+1) / 4;
 		for (i = 1; i < month; i++)
 			days += monlen[i-1];
-		if (((year+2) % 4) == 0 && month > 2)
+		if (((year+2) % 4) == 0 && month > 2 && ((((year+2) % 100) != 0) || (((year+2) % 400) == 0)))
 			days++;
 		days += day - 1;
 		crtime = ((((days * 24) + hour) * 60 + minute) * 60)
-- 
2.2.1

