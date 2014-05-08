Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaEHKg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:36:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20370 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaEHKgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:36:25 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-e1-536b5e27678b
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
Subject: [PATCH v2 9/9] xfstests: fsstress: Add fallocate insert range
Date: Thu, 08 May 2014 19:36:23 +0900
Message-id: <003f01cf6aa9$5ba9b6a0$12fd23e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qqUyE+5riHYd7SUWMy47eodWXvw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkSFcjLjvYYEW9xdKJl5gtthy7x2gx
	c94dNos9e0+yWFzeNYfNorXnJ7vFor5bjA7sHqcWSXg0nTnK7LH6wlZGj74tqxg9Pm+SC2CN
	4rJJSc3JLEst0rdL4MrYcOApW8Es0YoVb48zNTD+FOhi5OSQEDCRuDRzHiuELSZx4d56ti5G
	Lg4hgaWMEu/ObmKDKTrX84YVIrGIUWLxojOMEM5fRomPb5+wdzFycLAJaEv82SIK0iAi4Cmx
	+PhWsEnMAisZJe4d/wg2SVjATeLlr0PsIDaLgKrEmfZjYDavgKXE8VUzGCFsQYkfk++xgNjM
	AloS63ceZ4Kw5SU2r3nLDHGRgsSOs68ZIZbpSWw9fYcVokZEYt+Ld2DHSQhcYpd42L6GFWKZ
	gMS3yYdYQA6VEJCV2HQAao6kxMEVN1gmMIrNQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelF
	xnrFibnFpXnpesn5uZsYgdF4+t+z/h2Mdw9YH2JMBlo/kVlKNDkfGM15JfGGxmZGFqYmpsZG
	5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRQExvhUCqhQBP1bwjyYFS
	nCri61pPfdSJ7Vqx4Cr3kzcunaFZU9dd2B2eH3Vj479PHoG/NeZYb5vvWLvvseVZ8VvedUfe
	Pfp6bsKGaQzexu92eaq/E5iU9K60R05zUvgU4w0WPpHXpTy2KG+quq3fVfbmtdQL/YajRfxH
	Tn7MlSuYvubXoRuxSizFGYmGWsxFxYkA/6sqVNwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV31uOxgg641ZhZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aGA0/ZCmaJVqx4e5ypgfGn
	QBcjJ4eEgInEuZ43rBC2mMSFe+vZuhi5OIQEFjFKLF50hhHC+cso8fHtE/YuRg4ONgFtiT9b
	REEaRAQ8JRYf3wrWwCywklHi3vGPbCAJYQE3iZe/DrGD2CwCqhJn2o+B2bwClhLHV81ghLAF
	JX5MvscCYjMLaEms33mcCcKWl9i85i0zxEUKEjvOvmaEWKYnsfX0HVaIGhGJfS/eMU5gFJiF
	ZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB0f5MegfjqgaLQ4wC
	HIxKPLwZzlnBQqyJZcWVuYcYJTiYlUR4efyzg4V4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5
	H5iI8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcZ1j3rsP
	dx7orFv4ICVa6fEsj99s9j+C3113KEg6VOh1pdFav6e0IMhw9YKoN4tn3ZfPv8DL9ujpCe7o
	XV4rShc2Ffyeq6eSMjMl9NjlyqaeX95Jrd0LxP+EW8TPC7mq55t390TyXauX7737jlZVelxV
	j/S/UnNb8pn5/tf+xl6Jl2yu/+V2UmIpzkg01GIuKk4EAAaFLNQ6AwAA
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
index 8180f66..8f64787 100644
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

