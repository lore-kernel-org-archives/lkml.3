Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaEHKYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:24:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25447 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaEHKYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:24:44 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-f9-536b5b6b62a9
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
Subject: [PATCH v2 1/10] fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Thu, 08 May 2014 19:24:42 +0900
Message-id: <003701cf6aa7$ba00c8d0$2e025a70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qp5ImXCTRP02WQyqa5euW3XEtIw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsWyRsSkRDc7OjvY4PJpIYulEy8xW2w5do/R
	Yua8O2wWe/aeZLG4vGsOm0Vrz092i0V9txgd2D1OLZLwaDpzlNlj9YWtjB59W1YxenzeJBfA
	GsVlk5Kak1mWWqRvl8CVsWLBNqaCZWIV//ZuY2lgbBDqYuTgkBAwkXjznqmLkRPIFJO4cG89
	WxcjF4eQwFJGie3rWtkhEiYSO/6dY4ZILGKUWPijlREkISTwl1Fiz2kJkEFsAtoSf7aIgoRF
	BDwlFh/fCjaIWWAlo8S94x/ZQBLCAr4Sb9pXs4LUswioSqw8YQwS5hWwlJj37DojhC0o8WPy
	PRYQm1lAS2L9zuNMELa8xOY1b5kh7lGQ2HH2NSPIGBEBPYljE8IhSkQk9r14xwiyVkLgGrvE
	xJcNYPUsAgIS3yYfYoH4V1Zi0wGoMZISB1fcYJnAKDYLyeZZSDbPQrJ5FpIVCxhZVjGKphYk
	FxQnpRcZ6hUn5haX5qXrJefnbmIExuHpf896dzDePmB9iDEZaP1EZinR5HxgHOeVxBsamxlZ
	mJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+MW+5kNUxXkVRgW
	yW7bbHJP4PWvuiVz7U4sl1hlusjoa5y12KYXYj4iqrI9J2/+WCEiMv+E9JNCPp3VimcTZ+5s
	ul+0yL9V+3/XgoXdZoqM2+wnrli2eMu2vzWvnM1dW4sLJyydva106XzZE1lrj10qnJD/5Ybs
	Wq6Gk3Mspb9KK/pNn8b3Ri9AiaU4I9FQi7moOBEALe2XtdkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd3s6Oxgg393OS2WTrzEbLHl2D1G
	i5nz7rBZ7Nl7ksXi8q45bBatPT/ZLRb13WJ0YPc4tUjCo+nMUWaP1Re2Mnr0bVnF6PF5k1wA
	a1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowVC7YxFSwTq/i3dxtLA2OD
	UBcjJ4eEgInEjn/nmCFsMYkL99azdTFycQgJLGKUWPijlREkISTwl1Fiz2mJLkYODjYBbYk/
	W0RBwiICnhKLj28Fq2cWWMkoce/4RzaQhLCAr8Sb9tWsIPUsAqoSK08Yg4R5BSwl5j27zghh
	C0r8mHyPBcRmFtCSWL/zOBOELS+xec1bqHsUJHacfc0IMkZEQE/i2IRwiBIRiX0v3jFOYBSY
	hWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwXH+TGoH48oGi0OM
	AhyMSjy8Gc5ZwUKsiWXFlbmHGCU4mJVEeHn8s4OFeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0
	OR+YgvJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgbGf9daT
	mjeXe9e/vCcqfGDK5Vs56yu3y275Fql3ced9C9N6tr0Fl/eUTF/oNTd874aoU080935Nvyj5
	1kyB9c16pdW/t97WWJ+9xz9Y5umdsoOaF3zfzvQ+JeKT8n9bgdL0mOo6v0e35Kx0c/1/Bdqc
	ufK4i0/6wry29PSmA66ul21mBZxcJaOkxFKckWioxVxUnAgAnBZ+uzcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FALLOC_FL_INSERT_RANGE command is the opposite command of
FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
add some data in the middle of file. FALLOC_FL_INSERT_RANGE will insert a range
of a file after shifting extents to right as given length.
and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
block boundary and use ftruncate(2) for crosses EOF.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |  8 +++++++-
 include/uapi/linux/falloc.h | 17 +++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 36662d0..74ed498 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -232,7 +232,8 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
+		     FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole and zero range are mutually exclusive */
@@ -250,6 +251,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (mode & ~FALLOC_FL_COLLAPSE_RANGE))
 		return -EINVAL;
 
+	/* Insert range should only be used exclusively. */
+	if ((mode & FALLOC_FL_INSERT_RANGE) &&
+	    (mode & ~FALLOC_FL_INSERT_RANGE))
+		return -EINVAL;
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index d1197ae..f4d12eb 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -41,4 +41,21 @@
  */
 #define FALLOC_FL_ZERO_RANGE		0x10
 
+/*
+ * FALLOC_FL_INSERT_RANGE is use to allocate disk space within the file size
+ * without overwriting any existing data. The contents of the file beyond offset
+ * are shifted towards right by len bytes to create space for inserting
+ * new disk blocks and in this space new zeroed out disk blocks are inserted.
+ * As such, this operation will increase the size of the file by len bytes.
+ * Different filesystems may implement different limitations on the granularity
+ * of the operation. Most will limit operations to filesystem block size
+ * boundaries, but this boundary may be larger or smaller depending on
+ * the filesystem and/or the configuration of the filesystem or file.
+ *
+ * Attempting to allocate new blocks using this flag at OR beyond the end of
+ * the file is considered an illegal operation - just use ftruncate(2) or
+ * fallocate(2) with mode 0 for such type of operations.
+ */
+#define FALLOC_FL_INSERT_RANGE		0x20
+
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.7.11-rc0

