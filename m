Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaHVI2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:28:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12812 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaHVI2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:28:47 -0400
X-AuditID: cbfee61b-f79f86d00000144c-a9-53f6fccb4152
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/3 v2] f2fs: use macro for code readability
Date: Fri, 22 Aug 2014 16:17:38 +0800
Message-id: <000101cfbde1$a16c14e0$e4443ea0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+94XdbCLjvBccxSu+9Xq0/ZIYtXw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd3Tf74FGzy5qG7xZP0sZotLi9wt
	Lu+aw+bA7LFpVSebx+4Fn5k8Pm+SC2CO4rJJSc3JLEst0rdL4Mo4ceohY0GXdsXpu89YGhh3
	KXcxcnJICJhIHNnyhgnCFpO4cG89WxcjF4eQwHRGifX7V0M5Pxgl7hx/xgxSxSagIrG84z9Y
	hwiQfWjRZXYQm1nAQ6Kx4zsriC0s4Cbx9ct8sHoWAVWJP0cWgdXwClhKnFm0FMoWlPgx+R4L
	RK+WxPqdx5kgbHmJzWveMkNcpCCx4+xrRohdehKbf76F2iUusfHILZYJjAKzkIyahWTULCSj
	ZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOICfSe9gXNVgcYhRgINRiYc34svX
	YCHWxLLiytxDjBIczEoivJvmfQsW4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1
	OzW1ILUIJsvEwSnVwLgx5MP1GcoTn+8Q/XlEm8tU6KSI9vIVqsxp6y425JdMdbm7I+LtfP+V
	vYUvH8Y4VCvHqR8/ErL8qA+/I+9i8cVaKx6scelvCa/0mHPI1cbB33LmxtzZE+6vPF8vqysu
	Hvw0UufbvUUaNwK5RHd/T+7pL5tYeDBfYYPEpi72cOWVTJ/3c/zbeEGJpTgj0VCLuag4EQDX
	RNlsXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces DEF_NIDS_PER_INODE/GET_ORPHAN_BLOCKS/F2FS_CP_PACKS macro
instead of numbers in code for readability.

change log from v1:
 o fix typo pointed out by Jaegeuk Kim.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c    | 21 ++++++++++-----------
 include/linux/f2fs_fs.h | 13 ++++++++++---
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index c9c08d5..ec3b7a5 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -443,8 +443,8 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	struct f2fs_orphan_block *orphan_blk = NULL;
 	unsigned int nentries = 0;
 	unsigned short index;
-	unsigned short orphan_blocks = (unsigned short)((sbi->n_orphans +
-		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
+	unsigned short orphan_blocks =
+			(unsigned short)GET_ORPHAN_BLOCKS(sbi->n_orphans);
 	struct page *page = NULL;
 	struct ino_entry *orphan = NULL;
 
@@ -837,7 +837,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	ckpt->elapsed_time = cpu_to_le64(get_mtime(sbi));
 	ckpt->valid_block_count = cpu_to_le64(valid_user_blocks(sbi));
 	ckpt->free_segment_count = cpu_to_le32(free_segments(sbi));
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < NR_CURSEG_NODE_TYPE; i++) {
 		ckpt->cur_node_segno[i] =
 			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_NODE));
 		ckpt->cur_node_blkoff[i] =
@@ -845,7 +845,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 		ckpt->alloc_type[i + CURSEG_HOT_NODE] =
 				curseg_alloc_type(sbi, i + CURSEG_HOT_NODE);
 	}
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < NR_CURSEG_DATA_TYPE; i++) {
 		ckpt->cur_data_segno[i] =
 			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_DATA));
 		ckpt->cur_data_blkoff[i] =
@@ -860,24 +860,23 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 
 	/* 2 cp  + n data seg summary + orphan inode blocks */
 	data_sum_blocks = npages_for_summary_flush(sbi);
-	if (data_sum_blocks < 3)
+	if (data_sum_blocks < NR_CURSEG_DATA_TYPE)
 		set_ckpt_flags(ckpt, CP_COMPACT_SUM_FLAG);
 	else
 		clear_ckpt_flags(ckpt, CP_COMPACT_SUM_FLAG);
 
-	orphan_blocks = (sbi->n_orphans + F2FS_ORPHANS_PER_BLOCK - 1)
-					/ F2FS_ORPHANS_PER_BLOCK;
+	orphan_blocks = GET_ORPHAN_BLOCKS(sbi->n_orphans);
 	ckpt->cp_pack_start_sum = cpu_to_le32(1 + cp_payload_blks +
 			orphan_blocks);
 
 	if (is_umount) {
 		set_ckpt_flags(ckpt, CP_UMOUNT_FLAG);
-		ckpt->cp_pack_total_block_count = cpu_to_le32(2 +
+		ckpt->cp_pack_total_block_count = cpu_to_le32(F2FS_CP_PACKS+
 				cp_payload_blks + data_sum_blocks +
 				orphan_blocks + NR_CURSEG_NODE_TYPE);
 	} else {
 		clear_ckpt_flags(ckpt, CP_UMOUNT_FLAG);
-		ckpt->cp_pack_total_block_count = cpu_to_le32(2 +
+		ckpt->cp_pack_total_block_count = cpu_to_le32(F2FS_CP_PACKS +
 				cp_payload_blks + data_sum_blocks +
 				orphan_blocks);
 	}
@@ -1022,8 +1021,8 @@ void init_ino_entry_info(struct f2fs_sb_info *sbi)
 	 * for cp pack we can have max 1020*504 orphan entries
 	 */
 	sbi->n_orphans = 0;
-	sbi->max_orphans = (sbi->blocks_per_seg - 2 - NR_CURSEG_TYPE)
-				* F2FS_ORPHANS_PER_BLOCK;
+	sbi->max_orphans = (sbi->blocks_per_seg - F2FS_CP_PACKS -
+			NR_CURSEG_TYPE) * F2FS_ORPHANS_PER_BLOCK;
 }
 
 int __init create_checkpoint_caches(void)
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 0ed77f3..08ed2b0 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -90,6 +90,8 @@ struct f2fs_super_block {
 #define CP_ORPHAN_PRESENT_FLAG	0x00000002
 #define CP_UMOUNT_FLAG		0x00000001
 
+#define F2FS_CP_PACKS		2	/* # of checkpoint packs */
+
 struct f2fs_checkpoint {
 	__le64 checkpoint_ver;		/* checkpoint block version number */
 	__le64 user_block_count;	/* # of user blocks */
@@ -126,6 +128,9 @@ struct f2fs_checkpoint {
  */
 #define F2FS_ORPHANS_PER_BLOCK	1020
 
+#define GET_ORPHAN_BLOCKS(n)	((n + F2FS_ORPHANS_PER_BLOCK - 1) / \
+					F2FS_ORPHANS_PER_BLOCK)
+
 struct f2fs_orphan_block {
 	__le32 ino[F2FS_ORPHANS_PER_BLOCK];	/* inode numbers */
 	__le32 reserved;	/* reserved */
@@ -147,6 +152,7 @@ struct f2fs_extent {
 #define F2FS_NAME_LEN		255
 #define F2FS_INLINE_XATTR_ADDRS	50	/* 200 bytes for inline xattrs */
 #define DEF_ADDRS_PER_INODE	923	/* Address Pointers in an Inode */
+#define DEF_NIDS_PER_INODE	5	/* Node IDs in an Inode */
 #define ADDRS_PER_INODE(fi)	addrs_per_inode(fi)
 #define ADDRS_PER_BLOCK		1018	/* Address Pointers in a Direct Block */
 #define NIDS_PER_BLOCK		1018	/* Node IDs in an Indirect Block */
@@ -166,8 +172,9 @@ struct f2fs_extent {
 #define MAX_INLINE_DATA		(sizeof(__le32) * (DEF_ADDRS_PER_INODE - \
 						F2FS_INLINE_XATTR_ADDRS - 1))
 
-#define INLINE_DATA_OFFSET	(PAGE_CACHE_SIZE - sizeof(struct node_footer) \
-			- sizeof(__le32) * (DEF_ADDRS_PER_INODE + 5 - 1))
+#define INLINE_DATA_OFFSET	(PAGE_CACHE_SIZE - sizeof(struct node_footer) -\
+				sizeof(__le32) * (DEF_ADDRS_PER_INODE + \
+				DEF_NIDS_PER_INODE - 1))
 
 struct f2fs_inode {
 	__le16 i_mode;			/* file mode */
@@ -197,7 +204,7 @@ struct f2fs_inode {
 
 	__le32 i_addr[DEF_ADDRS_PER_INODE];	/* Pointers to data blocks */
 
-	__le32 i_nid[5];		/* direct(2), indirect(2),
+	__le32 i_nid[DEF_NIDS_PER_INODE];	/* direct(2), indirect(2),
 						double_indirect(1) node id */
 } __packed;
 
-- 
2.0.1.474.g72c7794


