Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaAQUsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:48:35 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:55710 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAQUsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:48:32 -0500
Message-ID: <52D99637.7080703@gmail.com>
Date: Fri, 17 Jan 2014 14:44:39 -0600
From: Chris Fries <ccfries@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Thunderbird/3.1.18
MIME-Version: 1.0
To: cfries@motorola.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: clean checkpatch warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Fries <cfries@motorola.com>

Fixed a variety of trivial checkpatch warnings.  The only delta should
be some minor formatting on log strings that were split / too long.

Signed-off-by: Chris Fries <cfries@motorola.com>
---
 fs/f2fs/data.c     |  2 +-
 fs/f2fs/debug.c    |  2 +-
 fs/f2fs/dir.c      |  5 +++--
 fs/f2fs/f2fs.h     |  6 +++---
 fs/f2fs/file.c     |  2 +-
 fs/f2fs/inode.c    | 12 ++++++++----
 fs/f2fs/node.c     |  2 +-
 fs/f2fs/recovery.c | 12 ++++++------
 fs/f2fs/segment.c  |  6 ++++--
 fs/f2fs/segment.h  | 13 +++++++------
 fs/f2fs/super.c    |  8 +++++---
 11 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index bda889e..f5fac16 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -792,7 +792,7 @@ static int f2fs_write_data_page(struct page *page,
 	int err = 0;
 	struct f2fs_io_info fio = {
 		.type = DATA,
-		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC: WRITE,
+		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
 	};
 
 	if (page->index < end_index)
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 6e4ac9a..63cb7e2 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -245,7 +245,7 @@ static int stat_show(struct seq_file *s, void *v)
 		seq_printf(s, "  - node blocks : %d\n", si->node_blks);
 		seq_printf(s, "\nExtent Hit Ratio: %d / %d\n",
 			   si->hit_ext, si->total_ext);
-		seq_printf(s, "\nBalancing F2FS Async:\n");
+		seq_puts(s, "\nBalancing F2FS Async:\n");
 		seq_printf(s, "  - nodes: %4d in %4d\n",
 			   si->ndirty_node, si->node_pages);
 		seq_printf(s, "  - dents: %4d in dirs:%4d\n",
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index f815ca0..cd055b6 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -430,7 +430,8 @@ next:
  * Caller should grab and release a rwsem by calling f2fs_lock_op() and
  * f2fs_unlock_op().
  */
-int __f2fs_add_link(struct inode *dir, const struct qstr *name, struct inode *inode)
+int __f2fs_add_link(struct inode *dir, const struct qstr *name,
+						struct inode *inode)
 {
 	unsigned int bit_pos;
 	unsigned int level;
@@ -631,7 +632,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 
 	bit_pos = ((unsigned long)ctx->pos % NR_DENTRY_IN_BLOCK);
 
-	for ( ; n < npages; n++) {
+	for (; n < npages; n++) {
 		dentry_page = get_lock_data_page(inode, n);
 		if (IS_ERR(dentry_page))
 			continue;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ee304fb..5ab3981 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -607,9 +607,9 @@ static inline int check_nid_range(struct f2fs_sb_info *sbi, nid_t nid)
 static inline int F2FS_HAS_BLOCKS(struct inode *inode)
 {
 	if (F2FS_I(inode)->i_xattr_nid)
-		return (inode->i_blocks > F2FS_DEFAULT_ALLOCATED_BLOCKS + 1);
+		return inode->i_blocks > F2FS_DEFAULT_ALLOCATED_BLOCKS + 1;
 	else
-		return (inode->i_blocks > F2FS_DEFAULT_ALLOCATED_BLOCKS);
+		return inode->i_blocks > F2FS_DEFAULT_ALLOCATED_BLOCKS;
 }
 
 static inline bool inc_valid_block_count(struct f2fs_sb_info *sbi,
@@ -1231,7 +1231,7 @@ struct f2fs_stat_info {
 
 static inline struct f2fs_stat_info *F2FS_STAT(struct f2fs_sb_info *sbi)
 {
-	return (struct f2fs_stat_info*)sbi->stat_info;
+	return (struct f2fs_stat_info *)sbi->stat_info;
 }
 
 #define stat_inc_call_count(si)		((si)->call_count++)
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 14511b0..85e91ca 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -202,7 +202,7 @@ int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 	raw_node = F2FS_NODE(dn->node_page);
 	addr = blkaddr_in_node(raw_node) + ofs;
 
-	for ( ; count > 0; count--, addr++, dn->ofs_in_node++) {
+	for (; count > 0; count--, addr++, dn->ofs_in_node++) {
 		block_t blkaddr = le32_to_cpu(*addr);
 		if (blkaddr == NULL_ADDR)
 			continue;
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index ffa4c6d..4d67ed7 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -42,9 +42,11 @@ static void __get_inode_rdev(struct inode *inode, struct f2fs_inode *ri)
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
 			S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		if (ri->i_addr[0])
-			inode->i_rdev = old_decode_dev(le32_to_cpu(ri->i_addr[0]));
+			inode->i_rdev =
+				old_decode_dev(le32_to_cpu(ri->i_addr[0]));
 		else
-			inode->i_rdev = new_decode_dev(le32_to_cpu(ri->i_addr[1]));
+			inode->i_rdev =
+				new_decode_dev(le32_to_cpu(ri->i_addr[1]));
 	}
 }
 
@@ -52,11 +54,13 @@ static void __set_inode_rdev(struct inode *inode, struct f2fs_inode *ri)
 {
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 		if (old_valid_dev(inode->i_rdev)) {
-			ri->i_addr[0] = cpu_to_le32(old_encode_dev(inode->i_rdev));
+			ri->i_addr[0] =
+				cpu_to_le32(old_encode_dev(inode->i_rdev));
 			ri->i_addr[1] = 0;
 		} else {
 			ri->i_addr[0] = 0;
-			ri->i_addr[1] = cpu_to_le32(new_encode_dev(inode->i_rdev));
+			ri->i_addr[1] =
+				cpu_to_le32(new_encode_dev(inode->i_rdev));
 			ri->i_addr[2] = 0;
 		}
 	}
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b8c9301..226a05a 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1196,7 +1196,7 @@ static int f2fs_write_node_page(struct page *page,
 	struct node_info ni;
 	struct f2fs_io_info fio = {
 		.type = NODE,
-		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC: WRITE,
+		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
 	};
 
 	if (unlikely(sbi->por_doing))
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 655791e..976a7a9 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -95,9 +95,9 @@ out_unmap_put:
 	kunmap(page);
 	f2fs_put_page(page, 0);
 out:
-	f2fs_msg(inode->i_sb, KERN_NOTICE, "recover_inode and its dentry: "
-			"ino = %x, name = %s, dir = %lx, err = %d",
-			ino_of_node(ipage), raw_inode->i_name,
+	f2fs_msg(inode->i_sb, KERN_NOTICE,
+			"%s: ino = %x, name = %s, dir = %lx, err = %d",
+			__func__, ino_of_node(ipage), raw_inode->i_name,
 			IS_ERR(dir) ? 0 : dir->i_ino, err);
 	return err;
 }
@@ -366,9 +366,9 @@ err:
 	f2fs_put_dnode(&dn);
 	f2fs_unlock_op(sbi);
 out:
-	f2fs_msg(sbi->sb, KERN_NOTICE, "recover_data: ino = %lx, "
-			"recovered_data = %d blocks, err = %d",
-			inode->i_ino, recovered, err);
+	f2fs_msg(sbi->sb, KERN_NOTICE,
+		"recover_data: ino = %lx, recovered = %d blocks, err = %d",
+		inode->i_ino, recovered, err);
 	return err;
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a934e6f..e82423fb 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -946,7 +946,8 @@ void write_data_page(struct page *page, struct dnode_of_data *dn,
 	do_write_page(sbi, page, dn->data_blkaddr, new_blkaddr, &sum, fio);
 }
 
-void rewrite_data_page(struct page *page, block_t old_blkaddr, struct f2fs_io_info *fio)
+void rewrite_data_page(struct page *page, block_t old_blkaddr,
+					struct f2fs_io_info *fio)
 {
 	struct inode *inode = page->mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
@@ -1647,7 +1648,8 @@ static void build_sit_entries(struct f2fs_sb_info *sbi)
 
 			mutex_lock(&curseg->curseg_mutex);
 			for (i = 0; i < sits_in_cursum(sum); i++) {
-				if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
+				if (le32_to_cpu(segno_in_journal(sum, i))
+								== start) {
 					sit = sit_in_journal(sum, i);
 					mutex_unlock(&curseg->curseg_mutex);
 					goto got_it;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index e9a10bd..5731682 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -448,8 +448,8 @@ static inline int reserved_sections(struct f2fs_sb_info *sbi)
 
 static inline bool need_SSR(struct f2fs_sb_info *sbi)
 {
-	return ((prefree_segments(sbi) / sbi->segs_per_sec)
-			+ free_sections(sbi) < overprovision_sections(sbi));
+	return (prefree_segments(sbi) / sbi->segs_per_sec)
+			+ free_sections(sbi) < overprovision_sections(sbi);
 }
 
 static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi, int freed)
@@ -460,18 +460,19 @@ static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi, int freed)
 	if (unlikely(sbi->por_doing))
 		return false;
 
-	return ((free_sections(sbi) + freed) <= (node_secs + 2 * dent_secs +
-						reserved_sections(sbi)));
+	return (free_sections(sbi) + freed) <= (node_secs + 2 * dent_secs +
+						reserved_sections(sbi));
 }
 
 static inline bool excess_prefree_segs(struct f2fs_sb_info *sbi)
 {
-	return (prefree_segments(sbi) > SM_I(sbi)->rec_prefree_segments);
+	return prefree_segments(sbi) > SM_I(sbi)->rec_prefree_segments;
 }
 
 static inline int utilization(struct f2fs_sb_info *sbi)
 {
-	return div_u64((u64)valid_user_blocks(sbi) * 100, sbi->user_block_count);
+	return div_u64((u64)valid_user_blocks(sbi) * 100,
+					sbi->user_block_count);
 }
 
 /*
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b070f30..1a85f83 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -535,7 +535,8 @@ static int segment_info_seq_show(struct seq_file *seq, void *offset)
 {
 	struct super_block *sb = seq->private;
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
-	unsigned int total_segs = le32_to_cpu(sbi->raw_super->segment_count_main);
+	unsigned int total_segs =
+			le32_to_cpu(sbi->raw_super->segment_count_main);
 	int i;
 
 	for (i = 0; i < total_segs; i++) {
@@ -816,8 +817,9 @@ retry:
 	/* sanity checking of raw super */
 	if (sanity_check_raw_super(sb, *raw_super)) {
 		brelse(*raw_super_buf);
-		f2fs_msg(sb, KERN_ERR, "Can't find a valid F2FS filesystem "
-				"in %dth superblock", block + 1);
+		f2fs_msg(sb, KERN_ERR,
+			"Can't find valid F2FS filesystem in %dth superblock",
+								block + 1);
 		if (block == 0) {
 			block++;
 			goto retry;
-- 
1.8.0

