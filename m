Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaHHFHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:07:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50995 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaHHFHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:07:36 -0400
X-AuditID: cbfee691-b7f306d000003d81-dc-53e45af93a01
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 9/10]  xfstests: fsstress: Add fallocate insert range
Date: Fri, 08 Aug 2014 14:07:05 +0900
Message-id: <004a01cfb2c6$98c4b250$ca4e16f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yv3OjJL5fopW9RcyywOOIcarnIQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkRPdn1JNgg82bVSzefa6y2HLsHqPF
	sgebWSxmzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	z5vkAlijuGxSUnMyy1KL9O0SuDJ+HJrLXDBLtOLqog7GBsafAl2MnBwSAiYSs7u+MUPYYhIX
	7q1n62Lk4hASWMoocfnHNnaYos5fa9ghEtMZJeb0XWeEcP4ySqx/vY61i5GDg01AW+LPFlGQ
	BhEBV4l5d78zgtjMAncYJX6tMQaxhQU8JNYfnAo2lEVAVeLnhU42EJtXwFJi7f05LBC2oMSP
	yfdYQEYyC+hIfJ0UATFGXmLzmrdQhypI7Dj7mhFilZ7Ep+0rmSBqRCT2vXgHdpqEwCV2iRuL
	L7JA7BKQ+Db5ENhMCQFZiU0HoOZIShxccYNlAqPYLCSbZyFsnoVk8ywkGxYwsqxiFE0tSC4o
	TkovMtUrTswtLs1L10vOz93ECIzI0/+eTdzBeP+A9SHGZKDtE5mlRJPzgRGdVxJvaGxmZGFq
	YmpsZG5pRpqwkjhv+qOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MmhnHW+1LJHV2HORP
	lo5foPjaZ1pmU9EzBfY97pxG0x4V1e9ZsHCS6JYy19cb/67r8i7JXrTgRo1iyg9PtUmMN115
	X5/6v7R00ryDjksSVas/r3nfJpHxMcwmJV22ff4jy6N/d2V4/ktpfHv38qxZqRJusR+Mp100
	kJfTN7u3xlM8pn7Hu7snlViKMxINtZiLihMBpFmfP94CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd2fUU+CDWacl7F497nKYsuxe4wW
	yx5sZrGYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8ePQXOaCWaIVVxd1
	MDYw/hToYuTkkBAwkej8tYYdwhaTuHBvPVsXIxeHkMB0Rok5fdcZIZy/jBLrX69j7WLk4GAT
	0Jb4s0UUpEFEwFVi3t3vjCA2s8AdRolfa4xBbGEBD4n1B6eCDWURUJX4eaGTDcTmFbCUWHt/
	DguELSjxY/I9FpCRzAI6El8nRUCMkZfYvOYtM8Q9ChI7zr5mhFilJ/Fp+0omiBoRiX0v3jFO
	YBSYhWTSLIRJs5BMmoWkYwEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Hh/JrWDcWWD
	xSFGAQ5GJR5ege7HwUKsiWXFlbmHGCU4mJVEeGs+A4V4UxIrq1KL8uOLSnNSiw8xmgL9OZFZ
	SjQ5H5iK8kriDY1NzIwsjcwNLYyMzZXEeQ+0WgcKCaQnlqRmp6YWpBbB9DFxcEo1MJbrVits
	E9ALyZV/c6fu3dPuC8vWcLXUODKEiGuHOG5w23Yp/BG/+YsNS7zkuT2ulPD4euzctuWQ/Mz1
	KfmT4z1efe3PdtWy/5IXY9jJ4TzTs697irPBjL+JVSZGrg9vTdU9wp1w8YjOH/998wxXTGY9
	oFlwiftB5NE7aaYSC+UUnS48Omz4UImlOCPRUIu5qDgRAGEovCkNAwAA
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

