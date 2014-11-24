Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaKXGQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:16:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10404 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKXGQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:16:32 -0500
X-AuditID: cbfee68f-f791c6d000004834-1d-5472cd3eb7c9
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v6 1/10] fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Mon, 24 Nov 2014 15:16:29 +0900
Message-id: <002a01d007ae$2f6b9cf0$8e42d6d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAHrBeG8J/bMgPHSEiPWkEfCIHn8g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkUNfubFGIwZ2XHBZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NYrLJiU1J7MstUjfLoEr4+PayYwFV0Ur1rQcZ2xgPCDYxcjJISFgIvHjzksmCFtM4sK99Wxd
	jFwcQgJLGSWOTr7A0sXIAVb0en0CRHwRo0Tr+sksEM5fRomONzOZQIrYBLQl/mwRBRkkIuAq
	Me/ud0aQGmaQQRcfP2EESQgL+Er8ajzFDlLPIqAq8aDTByTMK2ApsfD/SzYIW1Dix+R7LCA2
	s4CWxPqdx5kgbHmJzWveMkMcqiCx4+xrRohdehL9V84zQ9SISOx78Q5sr4TAJXaJY6e/gjWz
	CAhIfJt8COoZWYlNB6DmSEocXHGDZQKj2Cwkq2chWT0LyepZSFYsYGRZxSiaWpBcUJyUXmSs
	V5yYW1yal66XnJ+7iREYi6f/PevfwXj3gPUhRgEORiUe3hnri0KEWBPLiitzDzGaAl00kVlK
	NDkfGPF5JfGGxmZGFqYmpsZG5pZmSuK8C6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpg
	3KO060P9rb1GG/nCeif+WyPi5NRcO8FZJSVd7kxTeyzzifzfdjfNqi05BS+EnW+oCan6daF0
	4fcPO/ZcELK4Z3btS1jao2m2kXk8omaNe67X/8uxlov2sFAT3PK9f7UJk2tHhbDC1+2n+3fu
	0ZwtJnRy/WanH2wfXTfwvH8tcFabwbJoVo6ZEktxRqKhFnNRcSIA8nnWP8ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jAV27s0UhBu1tjBZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bHtZMZC66KVqxpOc7YwHhA
	sIuRg0NCwETi9fqELkZOIFNM4sK99WxdjFwcQgKLGCVa109mgXD+Mkp0vJnJBNLAJqAt8WeL
	KEiDiICrxLy73xlBapgFljJKXHz8hBEkISzgK/Gr8RQ7SD2LgKrEg04fkDCvgKXEwv8v2SBs
	QYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHGQgsSOs68ZIXbpSfRfOc8MUSMise/FO8YJjAKz
	kIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjONKfSe9gXNVgcYhR
	gINRiYd3xvqiECHWxLLiytxDjBIczEoivGf/FYYI8aYkVlalFuXHF5XmpBYfYjQFenQis5Ro
	cj4wCeWVxBsam5gZWRqZG1oYGZsrifPeuJkbIiSQnliSmp2aWpBaBNPHxMEp1cBoKP219psM
	E1fayZ8LcuLntuzL3lH3/c+iGobyPOUHFj9zM9cfLUh9Yv6qQjHnrcOhrY/lz2p8vSzz+ua/
	G3mFkpz1mp/+7079VXx9Cu+SC1NO2HxYJCTqlDbVIt06ec5k+wjvfUp+J/WWChwJzBYT8jzP
	5cp2sUhQyqqf2TW0QnD/n/KshTOVWIozEg21mIuKEwHN7b0gCgMAAA==
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

