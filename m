Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbbABJnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:43:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25278 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbbABJmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:42:53 -0500
X-AuditID: cbfee68d-f79296d000004278-a4-54a6681b88c7
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 10/11]  xfstests: fsstress: Add fallocate insert range
 operation
Date: Fri, 02 Jan 2015 18:42:51 +0900
Message-id: <004801d02670$79bd5bf0$6d3813d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmb9IfZ2V2rPOwQ8ewSgB4b5rvuw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkRFc6Y1mIwe41FhZLJ15itnj3ucpi
	y7F7jBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKptH
	35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZfw4NJe5YJZoxdVFHYwNjD8Fuhg5OSQETCSm3rzF
	BmGLSVy4tx7I5uIQEljKKNF88CILTFHf5XXMEInpjBKH7ixghXD+Mkr8OD6TsYuRg4NNQFvi
	zxZRkAYRAVeJeXe/M4LUMAucYJRYP3kJ2CRhgVCJ+Q+fMYHYLAKqEgc/TmAEsXkFLCUOdt9k
	hrAFJX5MvgdWzyygJbF+53EmCFteYvOat8wQFylI7Dj7mhFimZ7E+2cHoepFJPa9eAe2WELg
	HrtE46Qd7BDLBCS+TT7EAnKohICsxKYDUHMkJQ6uuMEygVFsFpLVs5CsnoVk9SwkKxYwsqxi
	FE0tSC4oTkovMtQrTswtLs1L10vOz93ECIzQ0/+e9e5gvH3A+hCjAAejEg+vwrWlIUKsiWXF
	lbmHGE2BLprILCWanA9MA3kl8YbGZkYWpiamxkbmlmZK4ryKUj+DhQTSE0tSs1NTC1KL4otK
	c1KLDzEycXBKNTBeTHzmlHWrouO7fO285YYOX0PZrtWaTW6tjPZ15td+mJSl66KV96FJulX8
	+ZGtn3ha2pu8J394YmGV3il/d5rTZ4fCDkdvj09GNysLHbWUww7PVZtU8vJCwbT5unpszPoH
	gzLbf62V9RPKaV/3f5Nj73RetpVHLniqdv0617xinRXP0k+mu5RYijMSDbWYi4oTAZPVZyDL	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoK50xrIQgwfLDCyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx49Bc5oJZ
	ohVXF3UwNjD+FOhi5OSQEDCR6Lu8jhnCFpO4cG89WxcjF4eQwHRGiUN3FrBCOH8ZJX4cn8nY
	xcjBwSagLfFniyhIg4iAq8S8u98ZQWqYBU4wSqyfvIQFJCEsECox/+EzJhCbRUBV4uDHCYwg
	Nq+ApcTB7pvMELagxI/J98DqmQW0JNbvPM4EYctLbF7zFuoiBYkdZ18zQizTk3j/7CBUvYjE
	vhfvGCcwCsxCMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg+H8m
	tYNxZYPFIUYBDkYlHl6Fa0tDhFgTy4orcw8xSnAwK4nw9sktCRHiTUmsrEotyo8vKs1JLT7E
	aAr06URmKdHkfGBqyiuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRq
	YOy6+OHN7986j/UW/VYt2Owj+J25dVb0w6d6+2o0+hcKlMe4cwZc7Hi5r6i/+2upwhTB/3cP
	Lte5fNzh3sRKn7kfJyXtusP6KT/+qGrhgl4pAYvEBZWTeYo4Fn8uvORvnmAqu85z6R7vuPrO
	2LfTGvt/l239KfehV25WSb2Y+gwrqxN7vkYusVRiKc5INNRiLipOBADVBBHSFQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds insert operation support for fsstress, which is
meant to exercise fallocate FALLOC_FL_INSERT_RANGE support.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 ltp/fsstress.c | 19 ++++++++++++++++---
 src/global.h   |  4 ++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index b56fe5c..aa3e0c3 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -72,6 +72,7 @@ typedef enum {
 	OP_PUNCH,
 	OP_ZERO,
 	OP_COLLAPSE,
+	OP_INSERT,
 	OP_READ,
 	OP_READLINK,
 	OP_RENAME,
@@ -170,6 +171,7 @@ void	mknod_f(int, long);
 void	punch_f(int, long);
 void	zero_f(int, long);
 void	collapse_f(int, long);
+void	insert_f(int, long);
 void	read_f(int, long);
 void	readlink_f(int, long);
 void	rename_f(int, long);
@@ -209,6 +211,7 @@ opdesc_t	ops[] = {
 	{ OP_PUNCH, "punch", punch_f, 1, 1 },
 	{ OP_ZERO, "zero", zero_f, 1, 1 },
 	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
+	{ OP_INSERT, "insert", insert_f, 1, 1 },
 	{ OP_READ, "read", read_f, 1, 0 },
 	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
@@ -2176,6 +2179,7 @@ struct print_flags falloc_flags [] = {
 	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
 	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
+	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
 	{ -1, NULL}
 };
 
@@ -2227,10 +2231,11 @@ do_fallocate(int opno, long r, int mode)
 	off %= maxfsize;
 	len = (off64_t)(random() % (1024 * 1024));
 	/*
-	 * Collapse range requires off and len to be block aligned, make it
-	 * more likely to be the case.
+	 * Collapse/insert range requires off and len to be block aligned,
+	 * make it more likely to be the case.
 	 */
-	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && (opno % 2)) {
+	if ((mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)) &&
+		(opno % 2)) {
 		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
 		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
 	}
@@ -2656,6 +2661,14 @@ collapse_f(int opno, long r)
 }
 
 void
+insert_f(int opno, long r)
+{
+#ifdef HAVE_LINUX_FALLOC_H
+	do_fallocate(opno, r, FALLOC_FL_INSERT_RANGE);
+#endif
+}
+
+void
 read_f(int opno, long r)
 {
 	char		*buf;
diff --git a/src/global.h b/src/global.h
index 8180f66..f63246b 100644
--- a/src/global.h
+++ b/src/global.h
@@ -172,6 +172,10 @@
 #define FALLOC_FL_ZERO_RANGE		0x10
 #endif
 
+#ifndef FALLOC_FL_INSERT_RANGE
+#define FALLOC_FL_INSERT_RANGE		0x20
+#endif
+
 #endif /* HAVE_LINUX_FALLOC_H */
 
 #endif /* GLOBAL_H */
-- 
1.7.11-rc0

