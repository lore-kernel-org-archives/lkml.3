Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaHHFFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:05:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25580 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbaHHFFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:05:36 -0400
X-AuditID: cbfee690-b7f526d000003627-57-53e45a9c38fb
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 1/10] fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Fri, 08 Aug 2014 14:05:32 +0900
Message-id: <004201cfb2c6$61514ae0$23f3e0a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yvfwyPw+5qhA+QPi4KCaFScV1QQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkRHdO1JNggy+tShbvPldZbDl2j9Fi
	2YPNLBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKpvH
	501yAaxRXDYpqTmZZalF+nYJXBkf105mLLgqWrGm5ThjA+MBwS5GDg4JAROJX8/tuhg5gUwx
	iQv31rN1MXJxCAksZZQ4tHYZE0TCROL1mR52iMR0RonTNyYyQjh/GSUu3rnIBDKJTUBb4s8W
	UZAGEQFXiXl3vzOC2MwCdxglfq0xBrGFBXwlbm7aCDaURUBVYvf2k2A2r4ClxIJ5P6BsQYkf
	k++xgIxkFtCR+DopAmKMvMTmNW+ZIe5RkNhx9jUjxCo9ictbnrJA1IhI7HvxDuw0CYFL7BKH
	/0xkhtglIPFt8iEWiIdlJTYdgJojKXFwxQ2WCYxis5BsnoWweRaSzbOQbFjAyLKKUTS1ILmg
	OCm9yESvODG3uDQvXS85P3cTIzAeT/97NmEH470D1ocYk4G2T2SWEk3OB8ZzXkm8obGZkYWp
	iamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwcr+OaV+8cMq/jbcC
	p72wVtTPvTJb7NMtl8S38d6WWeFvbGRXxStM5t7NcnDDNOGv6cnT/VPVzxTv7d36TatpdbPM
	1+lVXh83HnstYpbvNEnwRtS2Q+XTvR7/a7irK1is1fZ0956ZXOFTj3Zml38q/DB71/+TOWu+
	3Yle2O7y6Uv+7gm+Xlv2zFViKc5INNRiLipOBACmz6Xz3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd05UU+CDW4ukLJ497nKYsuxe4wW
	yx5sZrGYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8XHtZMaCq6IVa1qO
	MzYwHhDsYuTkkBAwkXh9pocdwhaTuHBvPVsXIxeHkMB0RonTNyYyQjh/GSUu3rnI1MXIwcEm
	oC3xZ4soSIOIgKvEvLvfGUFsZoE7jBK/1hiD2MICvhI3N21kArFZBFQldm8/CWbzClhKLJj3
	A8oWlPgx+R4LyEhmAR2Jr5MiIMbIS2xe85YZ4h4FiR1nXzNCrNKTuLzlKQtEjYjEvhfvGCcw
	CsxCMmkWwqRZSCbNQtKxgJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwvD+T3sG4qsHi
	EKMAB6MSD69A9+NgIdbEsuLK3EOMEhzMSiK8NZ+BQrwpiZVVqUX58UWlOanFhxhNgf6cyCwl
	mpwPTEV5JfGGxiZmRpZG5oYWRsbmSuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoYZ3m63He7
	EtfWzm5zc/t9uTqGvKszdHu+MRh41lWddjopz6I8lyFyiU3KB/dpa2/2vz4avntu6idX/3y7
	ZAWBGMtfjAvMZ9aGV388dT27eq8cg9hfrcPBRZGNTuEFM+1/aVRurtSbU3SmcdWxRYLKjUvs
	J7x6sFTz7seVm4+uNclyPbNiAfNjJZbijERDLeai4kQAXhQ+Rw0DAAA=
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

