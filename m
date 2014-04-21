Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaDUMKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:10:12 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:32586 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbaDUMKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:10:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4IALAJVVNXQ6mu/2dsb2JhbABZgwarUZligR8XdIJTExwjGIECJBOIRQHNVY5ihD8BA45pigQBimqHZYMzO4EsBA
Date: Mon, 21 Apr 2014 14:10:03 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe <joe@perches.com>
Subject: [PATCH 2/2] FS/AFFS: pr_debug clean-up
Message-Id: <20140421141003.4629f6473eddf67bf544fbbb@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Remove AFFS: prefix (defined in pr_fmt)
-Use __func__
-Separate format/arguments on lines > 80 characters.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/affs.h     | 10 +++++-----
 fs/affs/amigaffs.c |  9 +++++----
 fs/affs/bitmap.c   |  8 ++++----
 fs/affs/dir.c      |  8 ++++----
 fs/affs/file.c     | 25 +++++++++++++++----------
 fs/affs/inode.c    | 14 ++++++++------
 fs/affs/namei.c    | 39 +++++++++++++++++++++++----------------
 fs/affs/super.c    | 19 ++++++++++---------
 fs/affs/symlink.c  |  2 +-
 9 files changed, 75 insertions(+), 59 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 347ee6f..9bca881 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -212,7 +212,7 @@ affs_set_blocksize(struct super_block *sb, int size)
 static inline struct buffer_head *
 affs_bread(struct super_block *sb, int block)
 {
-	pr_debug("affs_bread: %d\n", block);
+	pr_debug("%s: %d\n", __func__, block);
 	if (block >= AFFS_SB(sb)->s_reserved && block < AFFS_SB(sb)->s_partition_size)
 		return sb_bread(sb, block);
 	return NULL;
@@ -220,7 +220,7 @@ affs_bread(struct super_block *sb, int block)
 static inline struct buffer_head *
 affs_getblk(struct super_block *sb, int block)
 {
-	pr_debug("affs_getblk: %d\n", block);
+	pr_debug("%s: %d\n", __func__, block);
 	if (block >= AFFS_SB(sb)->s_reserved && block < AFFS_SB(sb)->s_partition_size)
 		return sb_getblk(sb, block);
 	return NULL;
@@ -229,7 +229,7 @@ static inline struct buffer_head *
 affs_getzeroblk(struct super_block *sb, int block)
 {
 	struct buffer_head *bh;
-	pr_debug("affs_getzeroblk: %d\n", block);
+	pr_debug("%s: %d\n", __func__, block);
 	if (block >= AFFS_SB(sb)->s_reserved && block < AFFS_SB(sb)->s_partition_size) {
 		bh = sb_getblk(sb, block);
 		lock_buffer(bh);
@@ -244,7 +244,7 @@ static inline struct buffer_head *
 affs_getemptyblk(struct super_block *sb, int block)
 {
 	struct buffer_head *bh;
-	pr_debug("affs_getemptyblk: %d\n", block);
+	pr_debug("%s: %d\n", __func__, block);
 	if (block >= AFFS_SB(sb)->s_reserved && block < AFFS_SB(sb)->s_partition_size) {
 		bh = sb_getblk(sb, block);
 		wait_on_buffer(bh);
@@ -257,7 +257,7 @@ static inline void
 affs_brelse(struct buffer_head *bh)
 {
 	if (bh)
-		pr_debug("affs_brelse: %lld\n", (long long) bh->b_blocknr);
+		pr_debug("%s: %lld\n", __func__, (long long) bh->b_blocknr);
 	brelse(bh);
 }
 
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index fa8ba6a..406b298 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -34,7 +34,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 	ino = bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, bh)->name + 1, AFFS_TAIL(sb, bh)->name[0]);
 
-	pr_debug("AFFS: insert_hash(dir=%u, ino=%d)\n", (u32)dir->i_ino, ino);
+	pr_debug("%s(dir=%u, ino=%d)\n", __func__, (u32)dir->i_ino, ino);
 
 	dir_bh = affs_bread(sb, dir->i_ino);
 	if (!dir_bh)
@@ -84,7 +84,8 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 	sb = dir->i_sb;
 	rem_ino = rem_bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, rem_bh)->name+1, AFFS_TAIL(sb, rem_bh)->name[0]);
-	pr_debug("AFFS: remove_hash(dir=%d, ino=%d, hashval=%d)\n", (u32)dir->i_ino, rem_ino, offset);
+	pr_debug("%s(dir=%d, ino=%d, hashval=%d)\n",
+		 __func__, (u32)dir->i_ino, rem_ino, offset);
 
 	bh = affs_bread(sb, dir->i_ino);
 	if (!bh)
@@ -147,7 +148,7 @@ affs_remove_link(struct dentry *dentry)
 	u32 link_ino, ino;
 	int retval;
 
-	pr_debug("AFFS: remove_link(key=%ld)\n", inode->i_ino);
+	pr_debug("%s(key=%ld)\n", __func__, inode->i_ino);
 	retval = -EIO;
 	bh = affs_bread(sb, inode->i_ino);
 	if (!bh)
@@ -279,7 +280,7 @@ affs_remove_header(struct dentry *dentry)
 	if (!inode)
 		goto done;
 
-	pr_debug("AFFS: remove_header(key=%ld)\n", inode->i_ino);
+	pr_debug("%s(key=%ld)\n", __func__, inode->i_ino);
 	retval = -EIO;
 	bh = affs_bread(sb, (u32)(long)dentry->d_fsdata);
 	if (!bh)
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index d9559f5..c8de511 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -17,7 +17,7 @@ affs_count_free_blocks(struct super_block *sb)
 	u32 free;
 	int i;
 
-	pr_debug("AFFS: count_free_blocks()\n");
+	pr_debug("%s()\n", __func__);
 
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
@@ -43,7 +43,7 @@ affs_free_block(struct super_block *sb, u32 block)
 	u32 blk, bmap, bit, mask, tmp;
 	__be32 *data;
 
-	pr_debug("AFFS: free_block(%u)\n", block);
+	pr_debug("%s(%u)\n", __func__, block);
 
 	if (block > sbi->s_partition_size)
 		goto err_range;
@@ -125,7 +125,7 @@ affs_alloc_block(struct inode *inode, u32 goal)
 	sb = inode->i_sb;
 	sbi = AFFS_SB(sb);
 
-	pr_debug("AFFS: balloc(inode=%lu,goal=%u): ", inode->i_ino, goal);
+	pr_debug("balloc(inode=%lu,goal=%u): ", inode->i_ino, goal);
 
 	if (AFFS_I(inode)->i_pa_cnt) {
 		pr_debug("%d\n", AFFS_I(inode)->i_lastalloc+1);
@@ -291,7 +291,7 @@ int affs_init_bitmap(struct super_block *sb, int *flags)
 			*flags |= MS_RDONLY;
 			goto out;
 		}
-		pr_debug("AFFS: read bitmap block %d: %d\n", blk, bm->bm_key);
+		pr_debug("read bitmap block %d: %d\n", blk, bm->bm_key);
 		bm->bm_free = memweight(bh->b_data + 4, sb->s_blocksize - 4);
 
 		/* Don't try read the extension if this is the last block,
diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index cbbda47..59f07be 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -54,8 +54,8 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 	u32			 ino;
 	int			 error = 0;
 
-	pr_debug("AFFS: readdir(ino=%lu,f_pos=%lx)\n",
-		 inode->i_ino, (unsigned long)ctx->pos);
+	pr_debug("%s(ino=%lu,f_pos=%lx)\n",
+		 __func__, inode->i_ino, (unsigned long)ctx->pos);
 
 	if (ctx->pos < 2) {
 		file->private_data = (void *)0;
@@ -81,7 +81,7 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 	 */
 	ino = (u32)(long)file->private_data;
 	if (ino && file->f_version == inode->i_version) {
-		pr_debug("AFFS: readdir() left off=%d\n", ino);
+		pr_debug("readdir() left off=%d\n", ino);
 		goto inside;
 	}
 
@@ -117,7 +117,7 @@ inside:
 
 			namelen = min(AFFS_TAIL(sb, fh_bh)->name[0], (u8)30);
 			name = AFFS_TAIL(sb, fh_bh)->name + 1;
-			pr_debug("AFFS: readdir(): dir_emit(\"%.*s\", "
+			pr_debug("readdir(): dir_emit(\"%.*s\", "
 				 "ino=%u), hash=%d, f_pos=%x\n",
 				 namelen, name, ino, hash_pos, (u32)ctx->pos);
 
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 8669b6e..12bff8c 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -45,7 +45,7 @@ const struct inode_operations affs_file_inode_operations = {
 static int
 affs_file_open(struct inode *inode, struct file *filp)
 {
-	pr_debug("AFFS: open(%lu,%d)\n",
+	pr_debug("open(%lu,%d)\n",
 		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
 	atomic_inc(&AFFS_I(inode)->i_opencnt);
 	return 0;
@@ -54,7 +54,7 @@ affs_file_open(struct inode *inode, struct file *filp)
 static int
 affs_file_release(struct inode *inode, struct file *filp)
 {
-	pr_debug("AFFS: release(%lu, %d)\n",
+	pr_debug("release(%lu, %d)\n",
 		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
 
 	if (atomic_dec_and_test(&AFFS_I(inode)->i_opencnt)) {
@@ -324,7 +324,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 	struct buffer_head	*ext_bh;
 	u32			 ext;
 
-	pr_debug("AFFS: get_block(%u, %lu)\n", (u32)inode->i_ino, (unsigned long)block);
+	pr_debug("%s(%u, %lu)\n",
+		 __func__, (u32)inode->i_ino, (unsigned long)block);
 
 	BUG_ON(block > (sector_t)0x7fffffffUL);
 
@@ -507,7 +508,8 @@ affs_do_readpage_ofs(struct file *file, struct page *page, unsigned from, unsign
 	u32 bidx, boff, bsize;
 	u32 tmp;
 
-	pr_debug("AFFS: read_page(%u, %ld, %d, %d)\n", (u32)inode->i_ino, page->index, from, to);
+	pr_debug("%s(%u, %ld, %d, %d)\n",
+		 __func__, (u32)inode->i_ino, page->index, from, to);
 	BUG_ON(from > to || to > PAGE_CACHE_SIZE);
 	kmap(page);
 	data = page_address(page);
@@ -542,7 +544,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 	u32 size, bsize;
 	u32 tmp;
 
-	pr_debug("AFFS: extent_file(%u, %d)\n", (u32)inode->i_ino, newsize);
+	pr_debug("%s(%u, %d)\n", __func__, (u32)inode->i_ino, newsize);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	bh = NULL;
 	size = AFFS_I(inode)->mmu_private;
@@ -608,7 +610,7 @@ affs_readpage_ofs(struct file *file, struct page *page)
 	u32 to;
 	int err;
 
-	pr_debug("AFFS: read_page(%u, %ld)\n", (u32)inode->i_ino, page->index);
+	pr_debug("%s(%u, %ld)\n", __func__, (u32)inode->i_ino, page->index);
 	to = PAGE_CACHE_SIZE;
 	if (((page->index + 1) << PAGE_CACHE_SHIFT) > inode->i_size) {
 		to = inode->i_size & ~PAGE_CACHE_MASK;
@@ -631,7 +633,8 @@ static int affs_write_begin_ofs(struct file *file, struct address_space *mapping
 	pgoff_t index;
 	int err = 0;
 
-	pr_debug("AFFS: write_begin(%u, %llu, %llu)\n", (u32)inode->i_ino, (unsigned long long)pos, (unsigned long long)pos + len);
+	pr_debug("%s(%u, %llu, %llu)\n", __func__, (u32)inode->i_ino,
+		 (unsigned long long)pos, (unsigned long long)pos + len);
 	if (pos > AFFS_I(inode)->mmu_private) {
 		/* XXX: this probably leaves a too-big i_size in case of
 		 * failure. Should really be updating i_size at write_end time
@@ -680,7 +683,9 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 	 * due to write_begin.
 	 */
 
-	pr_debug("AFFS: write_begin(%u, %llu, %llu)\n", (u32)inode->i_ino, (unsigned long long)pos, (unsigned long long)pos + len);
+	pr_debug("%s(%u, %llu, %llu)\n",
+		 __func__, (u32)inode->i_ino, (unsigned long long)pos,
+		(unsigned long long)pos + len);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	data = page_address(page);
 
@@ -802,7 +807,7 @@ affs_free_prealloc(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
-	pr_debug("AFFS: free_prealloc(ino=%lu)\n", inode->i_ino);
+	pr_debug("free_prealloc(ino=%lu)\n", inode->i_ino);
 
 	while (AFFS_I(inode)->i_pa_cnt) {
 		AFFS_I(inode)->i_pa_cnt--;
@@ -822,7 +827,7 @@ affs_truncate(struct inode *inode)
 	struct buffer_head *ext_bh;
 	int i;
 
-	pr_debug("AFFS: truncate(inode=%d, oldsize=%u, newsize=%u)\n",
+	pr_debug("truncate(inode=%d, oldsize=%u, newsize=%u)\n",
 		 (u32)inode->i_ino, (u32)AFFS_I(inode)->mmu_private, (u32)inode->i_size);
 
 	last_blk = 0;
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 96df91e..bec2d1a 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -34,7 +34,7 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 	if (!(inode->i_state & I_NEW))
 		return inode;
 
-	pr_debug("AFFS: affs_iget(%lu)\n", inode->i_ino);
+	pr_debug("affs_iget(%lu)\n", inode->i_ino);
 
 	block = inode->i_ino;
 	bh = affs_bread(sb, block);
@@ -175,7 +175,7 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	uid_t			 uid;
 	gid_t			 gid;
 
-	pr_debug("AFFS: write_inode(%lu)\n",inode->i_ino);
+	pr_debug("write_inode(%lu)\n", inode->i_ino);
 
 	if (!inode->i_nlink)
 		// possibly free block
@@ -220,7 +220,7 @@ affs_notify_change(struct dentry *dentry, struct iattr *attr)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	pr_debug("AFFS: notify_change(%lu,0x%x)\n",inode->i_ino,attr->ia_valid);
+	pr_debug("notify_change(%lu,0x%x)\n", inode->i_ino, attr->ia_valid);
 
 	error = inode_change_ok(inode,attr);
 	if (error)
@@ -258,7 +258,8 @@ void
 affs_evict_inode(struct inode *inode)
 {
 	unsigned long cache_page;
-	pr_debug("AFFS: evict_inode(ino=%lu, nlink=%u)\n", inode->i_ino, inode->i_nlink);
+	pr_debug("evict_inode(ino=%lu, nlink=%u)\n",
+		 inode->i_ino, inode->i_nlink);
 	truncate_inode_pages_final(&inode->i_data);
 
 	if (!inode->i_nlink) {
@@ -271,7 +272,7 @@ affs_evict_inode(struct inode *inode)
 	affs_free_prealloc(inode);
 	cache_page = (unsigned long)AFFS_I(inode)->i_lc;
 	if (cache_page) {
-		pr_debug("AFFS: freeing ext cache\n");
+		pr_debug("freeing ext cache\n");
 		AFFS_I(inode)->i_lc = NULL;
 		AFFS_I(inode)->i_ac = NULL;
 		free_page(cache_page);
@@ -350,7 +351,8 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 	u32 block = 0;
 	int retval;
 
-	pr_debug("AFFS: add_entry(dir=%u, inode=%u, \"%*s\", type=%d)\n", (u32)dir->i_ino,
+	pr_debug("%s(dir=%u, inode=%u, \"%*s\", type=%d)\n",
+		 __func__, (u32)dir->i_ino,
 	         (u32)inode->i_ino, (int)dentry->d_name.len, dentry->d_name.name, type);
 
 	retval = -EIO;
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 6dae1cc..035bd31 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -190,7 +190,8 @@ affs_find_entry(struct inode *dir, struct dentry *dentry)
 	toupper_t toupper = affs_get_toupper(sb);
 	u32 key;
 
-	pr_debug("AFFS: find_entry(\"%.*s\")\n", (int)dentry->d_name.len, dentry->d_name.name);
+	pr_debug("%s(\"%.*s\")\n",
+		 __func__, (int)dentry->d_name.len, dentry->d_name.name);
 
 	bh = affs_bread(sb, dir->i_ino);
 	if (!bh)
@@ -218,7 +219,8 @@ affs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 	struct buffer_head *bh;
 	struct inode *inode = NULL;
 
-	pr_debug("AFFS: lookup(\"%.*s\")\n",(int)dentry->d_name.len,dentry->d_name.name);
+	pr_debug("%s(\"%.*s\")\n",
+		 __func__, (int)dentry->d_name.len, dentry->d_name.name);
 
 	affs_lock_dir(dir);
 	bh = affs_find_entry(dir, dentry);
@@ -248,9 +250,9 @@ affs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 int
 affs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("AFFS: unlink(dir=%d, %lu \"%.*s\")\n", (u32)dir->i_ino,
-		 dentry->d_inode->i_ino,
-		 (int)dentry->d_name.len, dentry->d_name.name);
+	pr_debug("%s(dir=%d, %lu \"%.*s\")\n",
+		 __func__, (u32)dir->i_ino, dentry->d_inode->i_ino,
+		(int)dentry->d_name.len, dentry->d_name.name);
 
 	return affs_remove_header(dentry);
 }
@@ -262,7 +264,8 @@ affs_create(struct inode *dir, struct dentry *dentry, umode_t mode, bool excl)
 	struct inode	*inode;
 	int		 error;
 
-	pr_debug("AFFS: create(%lu,\"%.*s\",0%ho)\n",dir->i_ino,(int)dentry->d_name.len,
+	pr_debug("%s(%lu,\"%.*s\",0%ho)\n",
+		 __func__, dir->i_ino, (int)dentry->d_name.len,
 		 dentry->d_name.name,mode);
 
 	inode = affs_new_inode(dir);
@@ -291,8 +294,9 @@ affs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct inode		*inode;
 	int			 error;
 
-	pr_debug("AFFS: mkdir(%lu,\"%.*s\",0%ho)\n",dir->i_ino,
-		 (int)dentry->d_name.len,dentry->d_name.name,mode);
+	pr_debug("%s(%lu,\"%.*s\",0%ho)\n",
+		 __func__, dir->i_ino, (int)dentry->d_name.len,
+		 dentry->d_name.name, mode);
 
 	inode = affs_new_inode(dir);
 	if (!inode)
@@ -317,8 +321,8 @@ affs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 int
 affs_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("AFFS: rmdir(dir=%u, %lu \"%.*s\")\n", (u32)dir->i_ino,
-		 dentry->d_inode->i_ino,
+	pr_debug("%s(dir=%u, %lu \"%.*s\")\n",
+		__func__, (u32)dir->i_ino, dentry->d_inode->i_ino,
 		 (int)dentry->d_name.len, dentry->d_name.name);
 
 	return affs_remove_header(dentry);
@@ -334,8 +338,9 @@ affs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 	int			 i, maxlen, error;
 	char			 c, lc;
 
-	pr_debug("AFFS: symlink(%lu,\"%.*s\" -> \"%s\")\n",dir->i_ino,
-		 (int)dentry->d_name.len,dentry->d_name.name,symname);
+	pr_debug("%s(%lu,\"%.*s\" -> \"%s\")\n",
+		 __func__, dir->i_ino, (int)dentry->d_name.len,
+		 dentry->d_name.name, symname);
 
 	maxlen = AFFS_SB(sb)->s_hashsize * sizeof(u32) - 1;
 	inode  = affs_new_inode(dir);
@@ -404,7 +409,8 @@ affs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
 
-	pr_debug("AFFS: link(%u, %u, \"%.*s\")\n", (u32)inode->i_ino, (u32)dir->i_ino,
+	pr_debug("%s(%u, %u, \"%.*s\")\n",
+		 __func__, (u32)inode->i_ino, (u32)dir->i_ino,
 		 (int)dentry->d_name.len,dentry->d_name.name);
 
 	return affs_add_entry(dir, inode, dentry, ST_LINKFILE);
@@ -418,9 +424,10 @@ affs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct buffer_head *bh = NULL;
 	int retval;
 
-	pr_debug("AFFS: rename(old=%u,\"%*s\" to new=%u,\"%*s\")\n",
-		 (u32)old_dir->i_ino, (int)old_dentry->d_name.len, old_dentry->d_name.name,
-		 (u32)new_dir->i_ino, (int)new_dentry->d_name.len, new_dentry->d_name.name);
+	pr_debug("%s(old=%u,\"%*s\" to new=%u,\"%*s\")\n",
+		 __func__, (u32)old_dir->i_ino, (int)old_dentry->d_name.len,
+		 old_dentry->d_name.name, (u32)new_dir->i_ino,
+		(int)new_dentry->d_name.len, new_dentry->d_name.name);
 
 	retval = affs_check_name(new_dentry->d_name.name,
 				 new_dentry->d_name.len,
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 331fc8e..36f7b44 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -46,7 +46,7 @@ static void
 affs_put_super(struct super_block *sb)
 {
 	struct affs_sb_info *sbi = AFFS_SB(sb);
-	pr_debug("AFFS: put_super()\n");
+	pr_debug("%s()\n", __func__);
 
 	cancel_delayed_work_sync(&sbi->sb_work);
 }
@@ -319,7 +319,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 
 	save_mount_options(sb, data);
 
-	pr_debug("AFFS: read_super(%s)\n",data ? (const char *)data : "no options");
+	pr_debug("read_super(%s)\n", data ? (const char *)data : "no options");
 
 	sb->s_magic             = AFFS_SUPER_MAGIC;
 	sb->s_op                = &affs_sops;
@@ -358,7 +358,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 
 	size = sb->s_bdev->bd_inode->i_size >> 9;
-	pr_debug("AFFS: initial blocksize=%d, #blocks=%d\n", 512, size);
+	pr_debug("initial blocksize=%d, #blocks=%d\n", 512, size);
 
 	affs_set_blocksize(sb, PAGE_SIZE);
 	/* Try to find root block. Its location depends on the block size. */
@@ -373,7 +373,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 		sbi->s_root_block = root_block;
 		if (root_block < 0)
 			sbi->s_root_block = (reserved + size - 1) / 2;
-		pr_debug("AFFS: setting blocksize to %d\n", blocksize);
+		pr_debug("setting blocksize to %d\n", blocksize);
 		affs_set_blocksize(sb, blocksize);
 		sbi->s_partition_size = size;
 
@@ -388,7 +388,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 		 * block behind the calculated one. So we check this one, too.
 		 */
 		for (num_bm = 0; num_bm < 2; num_bm++) {
-			pr_debug("AFFS: Dev %s, trying root=%u, bs=%d, "
+			pr_debug("Dev %s, trying root=%u, bs=%d, "
 				"size=%d, reserved=%d\n",
 				sb->s_id,
 				sbi->s_root_block + num_bm,
@@ -510,7 +510,7 @@ got_root:
 		return -ENOMEM;
 	}
 
-	pr_debug("AFFS: s_flags=%lX\n",sb->s_flags);
+	pr_debug("s_flags=%lX\n", sb->s_flags);
 	return 0;
 }
 
@@ -530,7 +530,7 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	char			 volume[32];
 	char			*prefix = NULL;
 
-	pr_debug("AFFS: remount(flags=0x%x,opts=\"%s\")\n",*flags,data);
+	pr_debug("%s(flags=0x%x,opts=\"%s\")\n", __func__, *flags, data);
 
 	sync_filesystem(sb);
 	*flags |= MS_NODIRATIME;
@@ -578,8 +578,9 @@ affs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int		 free;
 	u64		 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
-	pr_debug("AFFS: statfs() partsize=%d, reserved=%d\n",AFFS_SB(sb)->s_partition_size,
-	     AFFS_SB(sb)->s_reserved);
+	pr_debug("%s() partsize=%d, reserved=%d\n",
+		 __func__, AFFS_SB(sb)->s_partition_size,
+		 AFFS_SB(sb)->s_reserved);
 
 	free          = affs_count_free_blocks(sb);
 	buf->f_type    = AFFS_SUPER_MAGIC;
diff --git a/fs/affs/symlink.c b/fs/affs/symlink.c
index ee00f08..f39b71c 100644
--- a/fs/affs/symlink.c
+++ b/fs/affs/symlink.c
@@ -21,7 +21,7 @@ static int affs_symlink_readpage(struct file *file, struct page *page)
 	char			 c;
 	char			 lc;
 
-	pr_debug("AFFS: follow_link(ino=%lu)\n",inode->i_ino);
+	pr_debug("follow_link(ino=%lu)\n", inode->i_ino);
 
 	err = -EIO;
 	bh = affs_bread(inode->i_sb, inode->i_ino);
-- 
1.9.1

