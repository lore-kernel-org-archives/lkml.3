Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbbAZFqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:46:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52148 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbbAZFqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:46:16 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-6b-54c5d4a64c3a
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2 02/10] f2fs: simplfy a field name in struct
 f2fs_extent,extent_info
Date: Mon, 26 Jan 2015 13:45:30 +0800
Message-id: <005e01d0392b$65dfb100$319f1300$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA5Dpdam1ovj0CxT6qdnha1+ZU0aA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd3lV46GGEztY7W4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxtaGV8wF
	n2Qqrp4+y9bA+Fmsi5GTQ0LAROLStHPsELaYxIV769lAbCGBRYwS51aYdDFyAdk/GCX+nVvA
	CJJgE1CRWN7xnwnEFhHwkpi0/wQLiM0s4CHR2PGdFcQWFkiSmDV9E5jNIqAqsb7tG1gNr4Cl
	xL3135khbEGJH5PvQfVqSazfeZwJwpaX2LzmLTPEQQoSO86+ZoTYpScx6+IvRogacYmNR26x
	TGAUmIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEh/Ux6B+Oq
	BotDjAIcjEo8vBqNR0OEWBPLiitzDzFKcDArifCWTwEK8aYkVlalFuXHF5XmpBYfYpTmYFES
	51WybwsREkhPLEnNTk0tSC2CyTJxcEo1MCYLxf9gZTxdtPnyi5AOptmXtKLidffM3zrr9clN
	57ddEn7ts/zjH7F9275YG6Tl6ssukrGJFTgdMP+4/D+Rlf+6UnVqv3Dfeb5yi8sh6V0pJfLt
	3Lt9rrWVfHmrqd6wyluRITDD3Wf91A2bF1jPlJl858DTHS/sz9+V29PdKVTPZ3JwRtivc0+V
	WIozEg21mIuKEwGLcFXeZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename a filed name from 'blk_addr' to 'blk' in struct {f2fs_extent,extent_info}
as annotation of this field descripts its meaning well to us.

By this way, we can avoid long statement in code of following patches.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c          | 13 ++++++-------
 fs/f2fs/f2fs.h          |  6 +++---
 include/linux/f2fs_fs.h |  2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index fece5cc..935a23b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -268,7 +268,7 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 
 	start_fofs = fi->ext.fofs;
 	end_fofs = fi->ext.fofs + fi->ext.len - 1;
-	start_blkaddr = fi->ext.blk_addr;
+	start_blkaddr = fi->ext.blk;
 
 	if (pgofs >= start_fofs && pgofs <= end_fofs) {
 		unsigned int blkbits = inode->i_sb->s_blocksize_bits;
@@ -313,8 +313,8 @@ void update_extent_cache(struct dnode_of_data *dn)
 
 	start_fofs = fi->ext.fofs;
 	end_fofs = fi->ext.fofs + fi->ext.len - 1;
-	start_blkaddr = fi->ext.blk_addr;
-	end_blkaddr = fi->ext.blk_addr + fi->ext.len - 1;
+	start_blkaddr = fi->ext.blk;
+	end_blkaddr = fi->ext.blk + fi->ext.len - 1;
 
 	/* Drop and initialize the matched extent */
 	if (fi->ext.len == 1 && fofs == start_fofs)
@@ -324,7 +324,7 @@ void update_extent_cache(struct dnode_of_data *dn)
 	if (fi->ext.len == 0) {
 		if (dn->data_blkaddr != NULL_ADDR) {
 			fi->ext.fofs = fofs;
-			fi->ext.blk_addr = dn->data_blkaddr;
+			fi->ext.blk = dn->data_blkaddr;
 			fi->ext.len = 1;
 		}
 		goto end_update;
@@ -333,7 +333,7 @@ void update_extent_cache(struct dnode_of_data *dn)
 	/* Front merge */
 	if (fofs == start_fofs - 1 && dn->data_blkaddr == start_blkaddr - 1) {
 		fi->ext.fofs--;
-		fi->ext.blk_addr--;
+		fi->ext.blk--;
 		fi->ext.len++;
 		goto end_update;
 	}
@@ -351,8 +351,7 @@ void update_extent_cache(struct dnode_of_data *dn)
 			fi->ext.len = fofs - start_fofs;
 		} else {
 			fi->ext.fofs = fofs + 1;
-			fi->ext.blk_addr = start_blkaddr +
-					fofs - start_fofs + 1;
+			fi->ext.blk = start_blkaddr + fofs - start_fofs + 1;
 			fi->ext.len -= fofs - start_fofs + 1;
 		}
 	} else {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f1452a3..f67efec 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -272,7 +272,7 @@ enum {
 
 struct extent_info {
 	unsigned int fofs;	/* start offset in a file */
-	u32 blk_addr;		/* start block address of the extent */
+	u32 blk;		/* start block address of the extent */
 	unsigned int len;	/* length of the extent */
 };
 
@@ -314,7 +314,7 @@ static inline void get_extent_info(struct extent_info *ext,
 					struct f2fs_extent i_ext)
 {
 	ext->fofs = le32_to_cpu(i_ext.fofs);
-	ext->blk_addr = le32_to_cpu(i_ext.blk_addr);
+	ext->blk = le32_to_cpu(i_ext.blk);
 	ext->len = le32_to_cpu(i_ext.len);
 }
 
@@ -322,7 +322,7 @@ static inline void set_raw_extent(struct extent_info *ext,
 					struct f2fs_extent *i_ext)
 {
 	i_ext->fofs = cpu_to_le32(ext->fofs);
-	i_ext->blk_addr = cpu_to_le32(ext->blk_addr);
+	i_ext->blk = cpu_to_le32(ext->blk);
 	i_ext->len = cpu_to_le32(ext->len);
 }
 
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index e993b0b..295acfa 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -148,7 +148,7 @@ struct f2fs_orphan_block {
  */
 struct f2fs_extent {
 	__le32 fofs;		/* start file offset of the extent */
-	__le32 blk_addr;	/* start block address of the extent */
+	__le32 blk;		/* start block address of the extent */
 	__le32 len;		/* lengh of the extent */
 } __packed;
 
-- 
2.2.1


