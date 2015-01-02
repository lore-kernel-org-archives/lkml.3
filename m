Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbbABJkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:40:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33831 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbbABJkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:40:36 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-60-54a667912e8f
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 1/11] fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Fri, 02 Jan 2015 18:40:33 +0900
Message-id: <003f01d02670$27a5e300$76f1a900$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmbqf4pP2mGmCLTbqtd03Gd/z5ww==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkRHdi+rIQg4ffrC2WTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYIvisklJzcksSy3St0vgyvi4djJjwVXRijUtxxkbGA8IdjFyckgImEj0nOxi
	grDFJC7cW8/WxcjFISSwlFFi8YmXLDBFkxY/AbOFBKYzSmy+GgRR9JdR4szMFtYuRg4ONgFt
	iT9bREFqRARcJebd/c4IUsMscIJRYv3kJWDNwgK+Es/WrwSzWQRUJRo3XmYDsXkFLCU2L1jH
	AmELSvyYfA/MZhbQkli/8zgThC0vsXnNW2aIgxQkdpx9zQixTE/ixbPD7BA1IhL7XrwDWywh
	cItdYs3OL0wQywQkvk0+xAJyqISArMSmA1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKs
	YhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiMz9P/nk3YwXjvgPUhRgEORiUeXoVrS0OEWBPL
	iitzDzGaAl00kVlKNDkfmATySuINjc2MLExNTI2NzC3NlMR5X0v9DBYSSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAOEfhvYsq66stbvV1Uzc73/5fzzH93+8e1/eiE49cfnKI0X0a42eBlktt
	m9W/7Lsh5Hhp/6bUUOtnVxbrTdLwczidd0lt5c+DQVHRKclVE55ITFy+jD9YRDDhaonEkUnV
	DuEHpv0xaf5vWKs7XSPYbQdznOPba0sk3c32Oqxxt4rbs7jWs+naciWW4oxEQy3mouJEAG5F
	sujKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoO7E9GUhBie/GlssnXiJ2eLd5yqL
	LcfuMVrMnHeHzWLP3pMsFpd3zWGzaO35yW6xqO8WowOHx6lFEh5NZ44ye6y+sJXR4/2+q2we
	fVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj49rJjAVX
	RSvWtBxnbGA8INjFyMkhIWAiMWnxExYIW0ziwr31bCC2kMB0RonNV4O6GLmA7L+MEmdmtrB2
	MXJwsAloS/zZIgpSIyLgKjHv7ndGkBpmgROMEusnLwEbJCzgK/Fs/Uowm0VAVaJx42WwobwC
	lhKbF6xjgbAFJX5MvgdmMwtoSazfeZwJwpaX2LzmLTPEQQoSO86+ZoRYpifx4tlhdogaEYl9
	L94xTmAUmIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHR/0x6
	B+OqBotDjAIcjEo8vArXloYIsSaWFVfmHmKU4GBWEuHtk1sSIsSbklhZlVqUH19UmpNafIjR
	FOjTicxSosn5wMSUVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXA
	qOCVXqled6js9KlqZhlPwfsrBX6W/Oia78ER57UnWTqxMChjvgu3q7LT7k2J3aZ6a2Y382m3
	ejJdcGfZbsFmVJCSfCCeu64/rEno1v4/J03W/6zZNffAj32Wv0PDDibbRWvfUzSbeyOkxfHm
	Jh/R/Xp5ooeWvZjrv4b52ut6v4PCX24zJNkrsRRnJBpqMRcVJwIApSgEBhQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FALLOC_FL_INSERT_RANGE command is the opposite command of
FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
for writing new data within a file after shifting extents to right as given
length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
that is block boundary and use ftruncate(2) for crosses EOF.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |  8 +++++++-
 include/uapi/linux/falloc.h | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

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
index d1197ae..1f20723 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -41,4 +41,19 @@
  */
 #define FALLOC_FL_ZERO_RANGE		0x10
 
+/*
+ * FALLOC_FL_INSERT_RANGE is use to insert space within the file size without
+ * overwriting any existing data. The contents of the file beyond offset are
+ * shifted towards right by len bytes to create a hole.  As such, this
+ * operation will increase the size of the file by len bytes.
+ * Different filesystems may implement different limitations on the granularity
+ * of the operation. Most will limit operations to filesystem block size
+ * boundaries, but this boundary may be larger or smaller depending on
+ * the filesystem and/or the configuration of the filesystem or file.
+ * Attempting to insert space using this flag at OR beyond the end of
+ * the file is considered an illegal operation - just use ftruncate(2) or
+ * fallocate(2) with mode 0 for such type of operations.
+ */
+#define FALLOC_FL_INSERT_RANGE		0x20
+
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.7.11-rc0

