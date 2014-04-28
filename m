Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaD1JvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:51:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43224 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaD1JvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:51:02 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-af-535e248547a0
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: consider fallocated space for SEEK_DATA
Date: Mon, 28 Apr 2014 18:48:49 +0900
Message-id: <1398678529-11067-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1398678529-11067-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1398678529-11067-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t8zA91Wlbhgg/XdrBbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZZw6qF/wWKJi1ok3
	zA2MN4S7GDk5JARMJHaePs0MYYtJXLi3nq2LkYtDSGAZo8Sj1jY2mKLenxuZIRLTGSWaZ9xl
	hXA6mSQOP53J2MXIwcEmoC2xeb8BSIOIALPEgqnnGUFqmAUmMEr8X/SeBaRGWMBJ4uE8IZAa
	FgFViTMd3xhBbF4Bd4lDn9czQizTltj2fCLYSE4BD4k1j4NBTCGgktl3SkAmSgj8ZpPYdmEy
	E8QYAYlvkw+BTZcQkJXYdADqF0mJgytusExgFF7AyLCKUTS1ILmgOCm9yEivODG3uDQvXS85
	P3cTIyRY+3Yw3jxgfYgxGWjcRGYp0eR8YLDnlcQbGpsZWZiamBobmVuakSasJM676GFSkJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQZGMZYMoe4le/2Pez1weX7ow163o8KTcnZOu55QV3bQ
	LWX3ucc5f165te0RStDZrv79165Frx+9dZOKPB7/+8nTC8sLGE4WGbi8Vlj19sb6q5dqJUyX
	z9HMM1FqCan612tnsIBj2vSZz1sr7VYeDjfi7kzZttZoi8j/Q1Yru6qmODhc/vAv5HiAqxJL
	cUaioRZzUXEiAMRwBAJsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jQd1Wlbhgg5+zGS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4dVC/4LFExawTb5gbGG8IdzFyckgImEj0/tzIDGGLSVy4t56ti5GLQ0hg
	OqNE84y7rBBOJ5PE4aczGbsYOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4DUCAs4
	STycJwRSwyKgKnGm4xsjiM0r4C5x6PN6Rohl2hLbnk8EG8kp4CGx5nEwiCkEVDL7TskERt4F
	jAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj4Zn0DsZVDRaHGAU4GJV4eCPmxAYLsSaW
	FVfmHmKU4GBWEuHdLxEXLMSbklhZlVqUH19UmpNafIgxGeimicxSosn5wDjNK4k3NDYxM7I0
	MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGFbdL6x4uKddeOIf35jlvvqUr
	GRMnxcU94703qbOR6+h6g7KlLfYdnRo/zvxMvf6rdaP8Y5llE+fpxT3uWfy34cQsh2vrfxRG
	dVVL3IhNYN2xu138e2rSo6a1rifX2Gvt6Nt7YaLZ0saZC7auzFx6KWXzy9CTKftXJmWJneFe
	d8Nq5bkPs+eaeiixFGckGmoxFxUnAgD2LrP1yQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an amount of data are allocated though fallocate and user writes a couple of
data among the space, f2fs should return the data offset made by user when
SEEK_DATA is requested.

For example, (N: NEW_ADDR by fallocate, X: NEW_ADDR by user)
1) fallocate 0 ~ 10MB
f -> N N N N N N N N N N N N ... N

2) write 4KB at 5MB offset
f -> N N N N N X N N N N N N ... N

3) SEEK_DATA from 0 should return 5MB offset

So, this patch adds a routine to search the first dirty page to handle that.
Then, the SEEK_DATA flow skips NEW_ADDR offsets until any dirty page is found.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/file.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 3112857..b9f4fbf 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -19,6 +19,7 @@
 #include <linux/compat.h>
 #include <linux/uaccess.h>
 #include <linux/mount.h>
+#include <linux/pagevec.h>
 
 #include "f2fs.h"
 #include "node.h"
@@ -194,13 +195,48 @@ out:
 	return ret;
 }
 
+static pgoff_t __get_first_dirty_index(struct address_space *mapping,
+						pgoff_t pgofs, int whence)
+{
+	struct pagevec pvec;
+	int nr_pages;
+
+	if (whence != SEEK_DATA)
+		return 0;
+
+	/* find first dirty page index */
+	pagevec_init(&pvec, 0);
+	nr_pages = pagevec_lookup_tag(&pvec, mapping, &pgofs, PAGECACHE_TAG_DIRTY, 1);
+	pgofs = nr_pages ? pvec.pages[0]->index: LONG_MAX;
+	pagevec_release(&pvec);
+	return pgofs;
+}
+
+static bool __found_offset(block_t blkaddr, pgoff_t dirty, pgoff_t pgofs,
+							int whence)
+{
+	switch (whence) {
+	case SEEK_DATA:
+		if ((blkaddr == NEW_ADDR && dirty == pgofs) ||
+			(blkaddr != NEW_ADDR && blkaddr != NULL_ADDR))
+			return true;
+		break;
+	case SEEK_HOLE:
+		if (blkaddr == NULL_ADDR)
+			return true;
+		break;
+	}
+	return false;
+}
+
 static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
 	loff_t maxbytes = inode->i_sb->s_maxbytes;
 	struct dnode_of_data dn;
-	pgoff_t pgofs, end_offset;
-	loff_t data_ofs = offset, isize;
+	pgoff_t pgofs, end_offset, dirty;
+	loff_t data_ofs = offset;
+	loff_t isize;
 	int err = 0;
 
 	mutex_lock(&inode->i_mutex);
@@ -218,6 +254,8 @@ static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 
 	pgofs = (pgoff_t)(offset >> PAGE_CACHE_SHIFT);
 
+	dirty = __get_first_dirty_index(inode->i_mapping, pgofs, whence);
+
 	for (; data_ofs < isize; data_ofs = pgofs << PAGE_CACHE_SHIFT) {
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		err = get_dnode_of_data(&dn, pgofs, LOOKUP_NODE_RA);
@@ -244,8 +282,7 @@ static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 			block_t blkaddr;
 			blkaddr = datablock_addr(dn.node_page, dn.ofs_in_node);
 
-			if ((whence == SEEK_DATA && blkaddr != NULL_ADDR) ||
-				(whence == SEEK_HOLE && blkaddr == NULL_ADDR)) {
+			if (__found_offset(blkaddr, dirty, pgofs, whence)) {
 				f2fs_put_dnode(&dn);
 				goto found;
 			}
-- 
1.8.4.474.g128a96c

