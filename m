Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3J2GyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:54:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55525 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3J2Gxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:53:55 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-ef-526f5b8004e9
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: add an option to avoid unnecessary BUG_ONs
Date: Tue, 29 Oct 2013 15:53:12 +0900
Message-id: <1383029592-17477-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1383029592-17477-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1383029592-17477-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zA92G6Pwgg5OvFC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgypg55yBbwaJ2xooV
	xyYyNzCuyO9i5OSQEDCR+NT9iB3CFpO4cG89WxcjF4eQwDJGiUOnHrLAFJ1fspoVxBYSmM4o
	8Wu6NkRRM5PE3Fu/GbsYOTjYBLQlNu83AKkREWCWWDD1PCNIDbPABEaJ/4vegw0SFnCV2Pz9
	JiOIzSKgKrFlxj2wOK+Au0TH+QlQy7Qltj2fCFbDKeAhsXbWFTaIxe4SVy5PZIOo+c0mseec
	L8QcAYlvkw+xgNwgISArsekAM0SJpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kpFecmFtcmpeu
	l5yfu4kRErJ9OxhvHrA+xJgMNG4is5Rocj4w5PNK4g2NzYwsTE1MjY3MLc1IE1YS5130MClI
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2PFwSPvdCruGzLdD+vh+T7FYOW1sg1L4+XKPjM/
	b97QUjHJN6zE+0b/2dWrJRU28RdZ3TnaxR0tO0ukIXQd35xbE36xLrBT1L8tt5p1rpx9uqf3
	j5P3RZqDfczZJxWsvG199YZJwYGnmyWkRXlPv3bNW6RvLpx0eH7h6y9sVQWnnlirtyQI6imx
	FGckGmoxFxUnAgBVuFTzbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQd2G6Pwgg723pS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yYOecgW8GidsaKFccmMjcwrsjvYuTkkBAwkTi/ZDUrhC0mceHeejYQW0hg
	OqPEr+naXYxcQHYzk8TcW78Zuxg5ONgEtCU27zcAqRERYJZYMPU8I0gNs8AERon/i96zgCSE
	BVwlNn+/yQhiswioSmyZcQ8szivgLtFxfgILxDJtiW3PJ4LVcAp4SKyddQVqsbvElcsT2SYw
	8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwTz6R3MK5qsDjEKMDBqMTDa8GWHyTE
	mlhWXJl7iFGCg1lJhHdHMFCINyWxsiq1KD++qDQntfgQYzLQVROZpUST84HxmlcSb2hsYmZk
	aWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjP4t2Q8+10nUONx6bO9XW379
	vpjS9eWrFq28eLT/dt/rJbcOHcsuMnX23/1epentlO/5mrNkC159PFSVePHljX9vPxQZ1Yl4
	3HIvezdN/u2jULtnP8Tv9sbP6q2anzbTZ7sEy6wNf2qDH2Uk75JN/3fe5PcT9vZNXF+CeXkk
	L92QfnzHi71XsFCJpTgj0VCLuag4EQAberv1zQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you want to remove unnecessary BUG_ONs, you can just turn off F2FS_CHECK_FS
in your kernel config.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 10 +++++-----
 fs/f2fs/data.c       |  4 ++--
 fs/f2fs/dir.c        |  2 +-
 fs/f2fs/f2fs.h       | 22 ++++++++++++++--------
 fs/f2fs/file.c       |  2 +-
 fs/f2fs/inode.c      |  2 +-
 fs/f2fs/node.c       | 42 +++++++++++++++++++++---------------------
 fs/f2fs/recovery.c   | 10 +++++-----
 fs/f2fs/segment.c    | 16 ++++++++--------
 fs/f2fs/segment.h    | 10 ++++++----
 fs/f2fs/xattr.c      |  2 +-
 11 files changed, 65 insertions(+), 57 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6526f50..d430157 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -142,8 +142,8 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 			lock_page(page);
-			BUG_ON(page->mapping != mapping);
-			BUG_ON(!PageDirty(page));
+			f2fs_bug_on(page->mapping != mapping);
+			f2fs_bug_on(!PageDirty(page));
 			clear_page_dirty_for_io(page);
 			if (f2fs_write_meta_page(page, &wbc)) {
 				unlock_page(page);
@@ -208,7 +208,7 @@ int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 void release_orphan_inode(struct f2fs_sb_info *sbi)
 {
 	mutex_lock(&sbi->orphan_inode_mutex);
-	BUG_ON(sbi->n_orphans == 0);
+	f2fs_bug_on(sbi->n_orphans == 0);
 	sbi->n_orphans--;
 	mutex_unlock(&sbi->orphan_inode_mutex);
 }
@@ -252,7 +252,7 @@ void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 		if (orphan->ino == ino) {
 			list_del(&orphan->list);
 			kmem_cache_free(orphan_entry_slab, orphan);
-			BUG_ON(sbi->n_orphans == 0);
+			f2fs_bug_on(sbi->n_orphans == 0);
 			sbi->n_orphans--;
 			break;
 		}
@@ -263,7 +263,7 @@ void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 static void recover_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 {
 	struct inode *inode = f2fs_iget(sbi->sb, ino);
-	BUG_ON(IS_ERR(inode));
+	f2fs_bug_on(IS_ERR(inode));
 	clear_nlink(inode);
 
 	/* truncate all the data during iput */
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c8887d8..aa3438c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -110,7 +110,7 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
 	pgoff_t fofs, start_fofs, end_fofs;
 	block_t start_blkaddr, end_blkaddr;
 
-	BUG_ON(blk_addr == NEW_ADDR);
+	f2fs_bug_on(blk_addr == NEW_ADDR);
 	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
 							dn->ofs_in_node;
 
@@ -436,7 +436,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 	}
 
 	/* It does not support data allocation */
-	BUG_ON(create);
+	f2fs_bug_on(create);
 
 	if (dn.data_blkaddr != NEW_ADDR && dn.data_blkaddr != NULL_ADDR) {
 		int i;
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index c9d53fc..594fc1b 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -139,7 +139,7 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 	bool room = false;
 	int max_slots = 0;
 
-	BUG_ON(level > MAX_DIR_HASH_DEPTH);
+	f2fs_bug_on(level > MAX_DIR_HASH_DEPTH);
 
 	nbucket = dir_buckets(level);
 	nblock = bucket_blocks(level);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a61cc5f..6aaefdb 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -20,6 +20,12 @@
 #include <linux/kobject.h>
 #include <linux/sched.h>
 
+#ifdef CONFIG_F2FS_CHECK_FS
+#define f2fs_bug_on(condition)	BUG_ON(condition)
+#else
+#define f2fs_bug_on(condition)
+#endif
+
 /*
  * For mount options
  */
@@ -584,8 +590,8 @@ static inline int dec_valid_block_count(struct f2fs_sb_info *sbi,
 						blkcnt_t count)
 {
 	spin_lock(&sbi->stat_lock);
-	BUG_ON(sbi->total_valid_block_count < (block_t) count);
-	BUG_ON(inode->i_blocks < count);
+	f2fs_bug_on(sbi->total_valid_block_count < (block_t) count);
+	f2fs_bug_on(inode->i_blocks < count);
 	inode->i_blocks -= count;
 	sbi->total_valid_block_count -= (block_t)count;
 	spin_unlock(&sbi->stat_lock);
@@ -717,9 +723,9 @@ static inline void dec_valid_node_count(struct f2fs_sb_info *sbi,
 {
 	spin_lock(&sbi->stat_lock);
 
-	BUG_ON(sbi->total_valid_block_count < count);
-	BUG_ON(sbi->total_valid_node_count < count);
-	BUG_ON(inode->i_blocks < count);
+	f2fs_bug_on(sbi->total_valid_block_count < count);
+	f2fs_bug_on(sbi->total_valid_node_count < count);
+	f2fs_bug_on(inode->i_blocks < count);
 
 	inode->i_blocks -= count;
 	sbi->total_valid_node_count -= count;
@@ -740,7 +746,7 @@ static inline unsigned int valid_node_count(struct f2fs_sb_info *sbi)
 static inline void inc_valid_inode_count(struct f2fs_sb_info *sbi)
 {
 	spin_lock(&sbi->stat_lock);
-	BUG_ON(sbi->total_valid_inode_count == sbi->total_node_count);
+	f2fs_bug_on(sbi->total_valid_inode_count == sbi->total_node_count);
 	sbi->total_valid_inode_count++;
 	spin_unlock(&sbi->stat_lock);
 }
@@ -748,7 +754,7 @@ static inline void inc_valid_inode_count(struct f2fs_sb_info *sbi)
 static inline int dec_valid_inode_count(struct f2fs_sb_info *sbi)
 {
 	spin_lock(&sbi->stat_lock);
-	BUG_ON(!sbi->total_valid_inode_count);
+	f2fs_bug_on(!sbi->total_valid_inode_count);
 	sbi->total_valid_inode_count--;
 	spin_unlock(&sbi->stat_lock);
 	return 0;
@@ -769,7 +775,7 @@ static inline void f2fs_put_page(struct page *page, int unlock)
 		return;
 
 	if (unlock) {
-		BUG_ON(!PageLocked(page));
+		f2fs_bug_on(!PageLocked(page));
 		unlock_page(page);
 	}
 	page_cache_release(page);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2d4190a..58ed19a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -296,7 +296,7 @@ static int truncate_blocks(struct inode *inode, u64 from)
 		count = ADDRS_PER_BLOCK;
 
 	count -= dn.ofs_in_node;
-	BUG_ON(count < 0);
+	f2fs_bug_on(count < 0);
 
 	if (dn.ofs_in_node || IS_INODE(dn.node_page)) {
 		truncate_data_blocks_range(&dn, count);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 7377ca3..d0eaa9f 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -266,7 +266,7 @@ void f2fs_evict_inode(struct inode *inode)
 			inode->i_ino == F2FS_META_INO(sbi))
 		goto no_delete;
 
-	BUG_ON(atomic_read(&F2FS_I(inode)->dirty_dents));
+	f2fs_bug_on(atomic_read(&F2FS_I(inode)->dirty_dents));
 	remove_dirty_dir_inode(inode);
 
 	if (inode->i_nlink || is_bad_inode(inode))
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 304d5ce..8e331d5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -204,7 +204,7 @@ retry:
 		}
 		e->ni = *ni;
 		e->checkpointed = true;
-		BUG_ON(ni->blk_addr == NEW_ADDR);
+		f2fs_bug_on(ni->blk_addr == NEW_ADDR);
 	} else if (new_blkaddr == NEW_ADDR) {
 		/*
 		 * when nid is reallocated,
@@ -212,19 +212,19 @@ retry:
 		 * So, reinitialize it with new information.
 		 */
 		e->ni = *ni;
-		BUG_ON(ni->blk_addr != NULL_ADDR);
+		f2fs_bug_on(ni->blk_addr != NULL_ADDR);
 	}
 
 	if (new_blkaddr == NEW_ADDR)
 		e->checkpointed = false;
 
 	/* sanity check */
-	BUG_ON(nat_get_blkaddr(e) != ni->blk_addr);
-	BUG_ON(nat_get_blkaddr(e) == NULL_ADDR &&
+	f2fs_bug_on(nat_get_blkaddr(e) != ni->blk_addr);
+	f2fs_bug_on(nat_get_blkaddr(e) == NULL_ADDR &&
 			new_blkaddr == NULL_ADDR);
-	BUG_ON(nat_get_blkaddr(e) == NEW_ADDR &&
+	f2fs_bug_on(nat_get_blkaddr(e) == NEW_ADDR &&
 			new_blkaddr == NEW_ADDR);
-	BUG_ON(nat_get_blkaddr(e) != NEW_ADDR &&
+	f2fs_bug_on(nat_get_blkaddr(e) != NEW_ADDR &&
 			nat_get_blkaddr(e) != NULL_ADDR &&
 			new_blkaddr == NEW_ADDR);
 
@@ -495,10 +495,10 @@ static void truncate_node(struct dnode_of_data *dn)
 
 	get_node_info(sbi, dn->nid, &ni);
 	if (dn->inode->i_blocks == 0) {
-		BUG_ON(ni.blk_addr != NULL_ADDR);
+		f2fs_bug_on(ni.blk_addr != NULL_ADDR);
 		goto invalidate;
 	}
-	BUG_ON(ni.blk_addr == NULL_ADDR);
+	f2fs_bug_on(ni.blk_addr == NULL_ADDR);
 
 	/* Deallocate node address */
 	invalidate_blocks(sbi, ni.blk_addr);
@@ -822,7 +822,7 @@ int remove_inode_page(struct inode *inode)
 	}
 
 	/* 0 is possible, after f2fs_new_inode() is failed */
-	BUG_ON(inode->i_blocks != 0 && inode->i_blocks != 1);
+	f2fs_bug_on(inode->i_blocks != 0 && inode->i_blocks != 1);
 	set_new_dnode(&dn, inode, page, page, ino);
 	truncate_node(&dn);
 	return 0;
@@ -863,7 +863,7 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	get_node_info(sbi, dn->nid, &old_ni);
 
 	/* Reinitialize old_ni with new node page */
-	BUG_ON(old_ni.blk_addr != NULL_ADDR);
+	f2fs_bug_on(old_ni.blk_addr != NULL_ADDR);
 	new_ni = old_ni;
 	new_ni.ino = dn->inode->i_ino;
 	set_node_addr(sbi, &new_ni, NEW_ADDR);
@@ -969,7 +969,7 @@ repeat:
 		goto repeat;
 	}
 got_it:
-	BUG_ON(nid != nid_of_node(page));
+	f2fs_bug_on(nid != nid_of_node(page));
 	mark_page_accessed(page);
 	return page;
 }
@@ -1163,7 +1163,7 @@ static int f2fs_write_node_page(struct page *page,
 
 	/* get old block addr of this node page */
 	nid = nid_of_node(page);
-	BUG_ON(page->index != nid);
+	f2fs_bug_on(page->index != nid);
 
 	get_node_info(sbi, nid, &ni);
 
@@ -1349,7 +1349,7 @@ static void scan_nat_page(struct f2fs_nm_info *nm_i,
 			break;
 
 		blk_addr = le32_to_cpu(nat_blk->entries[i].block_addr);
-		BUG_ON(blk_addr == NEW_ADDR);
+		f2fs_bug_on(blk_addr == NEW_ADDR);
 		if (blk_addr == NULL_ADDR) {
 			if (add_free_nid(nm_i, start_nid, true) < 0)
 				break;
@@ -1420,14 +1420,14 @@ retry:
 
 	/* We should not use stale free nids created by build_free_nids */
 	if (nm_i->fcnt && !sbi->on_build_free_nids) {
-		BUG_ON(list_empty(&nm_i->free_nid_list));
+		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
 		list_for_each(this, &nm_i->free_nid_list) {
 			i = list_entry(this, struct free_nid, list);
 			if (i->state == NID_NEW)
 				break;
 		}
 
-		BUG_ON(i->state != NID_NEW);
+		f2fs_bug_on(i->state != NID_NEW);
 		*nid = i->nid;
 		i->state = NID_ALLOC;
 		nm_i->fcnt--;
@@ -1455,7 +1455,7 @@ void alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid)
 
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
-	BUG_ON(!i || i->state != NID_ALLOC);
+	f2fs_bug_on(!i || i->state != NID_ALLOC);
 	__del_from_free_nid_list(i);
 	spin_unlock(&nm_i->free_nid_list_lock);
 }
@@ -1473,7 +1473,7 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
-	BUG_ON(!i || i->state != NID_ALLOC);
+	f2fs_bug_on(!i || i->state != NID_ALLOC);
 	if (nm_i->fcnt > 2 * MAX_FREE_NIDS) {
 		__del_from_free_nid_list(i);
 	} else {
@@ -1676,7 +1676,7 @@ to_nat_page:
 			nat_blk = page_address(page);
 		}
 
-		BUG_ON(!nat_blk);
+		f2fs_bug_on(!nat_blk);
 		raw_ne = nat_blk->entries[nid - start_nid];
 flush_now:
 		new_blkaddr = nat_get_blkaddr(ne);
@@ -1780,11 +1780,11 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 	/* destroy free nid list */
 	spin_lock(&nm_i->free_nid_list_lock);
 	list_for_each_entry_safe(i, next_i, &nm_i->free_nid_list, list) {
-		BUG_ON(i->state == NID_ALLOC);
+		f2fs_bug_on(i->state == NID_ALLOC);
 		__del_from_free_nid_list(i);
 		nm_i->fcnt--;
 	}
-	BUG_ON(nm_i->fcnt);
+	f2fs_bug_on(nm_i->fcnt);
 	spin_unlock(&nm_i->free_nid_list_lock);
 
 	/* destroy nat cache */
@@ -1798,7 +1798,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 			__del_from_nat_cache(nm_i, e);
 		}
 	}
-	BUG_ON(nm_i->nat_cnt);
+	f2fs_bug_on(nm_i->nat_cnt);
 	write_unlock(&nm_i->nat_tree_lock);
 
 	kfree(nm_i->nat_bitmap);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index b278c68..fdc8116 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -311,8 +311,8 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	wait_on_page_writeback(dn.node_page);
 
 	get_node_info(sbi, dn.nid, &ni);
-	BUG_ON(ni.ino != ino_of_node(page));
-	BUG_ON(ofs_of_node(dn.node_page) != ofs_of_node(page));
+	f2fs_bug_on(ni.ino != ino_of_node(page));
+	f2fs_bug_on(ofs_of_node(dn.node_page) != ofs_of_node(page));
 
 	for (; start < end; start++) {
 		block_t src, dest;
@@ -322,9 +322,9 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 
 		if (src != dest && dest != NEW_ADDR && dest != NULL_ADDR) {
 			if (src == NULL_ADDR) {
-				int err = reserve_new_block(&dn);
+				err = reserve_new_block(&dn);
 				/* We should not get -ENOSPC */
-				BUG_ON(err);
+				f2fs_bug_on(err);
 			}
 
 			/* Check the previous node page having this index */
@@ -447,7 +447,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 
 	/* step #2: recover data */
 	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
-	BUG_ON(!list_empty(&inode_list));
+	f2fs_bug_on(!list_empty(&inode_list));
 out:
 	destroy_fsync_dnodes(&inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8f92c18..c7161de 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -192,7 +192,7 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 	new_vblocks = se->valid_blocks + del;
 	offset = GET_SEGOFF_FROM_SEG0(sbi, blkaddr) & (sbi->blocks_per_seg - 1);
 
-	BUG_ON((new_vblocks >> (sizeof(unsigned short) << 3) ||
+	f2fs_bug_on((new_vblocks >> (sizeof(unsigned short) << 3) ||
 				(new_vblocks > sbi->blocks_per_seg)));
 
 	se->valid_blocks = new_vblocks;
@@ -232,7 +232,7 @@ void invalidate_blocks(struct f2fs_sb_info *sbi, block_t addr)
 	unsigned int segno = GET_SEGNO(sbi, addr);
 	struct sit_info *sit_i = SIT_I(sbi);
 
-	BUG_ON(addr == NULL_ADDR);
+	f2fs_bug_on(addr == NULL_ADDR);
 	if (addr == NEW_ADDR)
 		return;
 
@@ -347,7 +347,7 @@ find_other_zone:
 		if (dir == ALLOC_RIGHT) {
 			secno = find_next_zero_bit(free_i->free_secmap,
 							TOTAL_SECS(sbi), 0);
-			BUG_ON(secno >= TOTAL_SECS(sbi));
+			f2fs_bug_on(secno >= TOTAL_SECS(sbi));
 		} else {
 			go_left = 1;
 			left_start = hint - 1;
@@ -363,7 +363,7 @@ find_other_zone:
 		}
 		left_start = find_next_zero_bit(free_i->free_secmap,
 							TOTAL_SECS(sbi), 0);
-		BUG_ON(left_start >= TOTAL_SECS(sbi));
+		f2fs_bug_on(left_start >= TOTAL_SECS(sbi));
 		break;
 	}
 	secno = left_start;
@@ -402,7 +402,7 @@ skip_left:
 	}
 got_it:
 	/* set it as dirty segment in free segmap */
-	BUG_ON(test_bit(segno, free_i->free_segmap));
+	f2fs_bug_on(test_bit(segno, free_i->free_segmap));
 	__set_inuse(sbi, segno);
 	*newseg = segno;
 	write_unlock(&free_i->segmap_lock);
@@ -773,7 +773,7 @@ static int __get_segment_type(struct page *page, enum page_type p_type)
 		return __get_segment_type_4(page, p_type);
 	}
 	/* NR_CURSEG_TYPE(6) logs by default */
-	BUG_ON(sbi->active_logs != NR_CURSEG_TYPE);
+	f2fs_bug_on(sbi->active_logs != NR_CURSEG_TYPE);
 	return __get_segment_type_6(page, p_type);
 }
 
@@ -850,7 +850,7 @@ void write_data_page(struct inode *inode, struct page *page,
 	struct f2fs_summary sum;
 	struct node_info ni;
 
-	BUG_ON(old_blkaddr == NULL_ADDR);
+	f2fs_bug_on(old_blkaddr == NULL_ADDR);
 	get_node_info(sbi, dn->nid, &ni);
 	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
 
@@ -1240,7 +1240,7 @@ static struct page *get_next_sit_page(struct f2fs_sb_info *sbi,
 	/* get current sit block page without lock */
 	src_page = get_meta_page(sbi, src_off);
 	dst_page = grab_meta_page(sbi, dst_off);
-	BUG_ON(PageDirty(src_page));
+	f2fs_bug_on(PageDirty(src_page));
 
 	src_addr = page_address(src_page);
 	dst_addr = page_address(dst_page);
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index abe7094..001d4c4 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -522,16 +522,13 @@ static inline unsigned short curseg_blkoff(struct f2fs_sb_info *sbi, int type)
 	return curseg->next_blkoff;
 }
 
+#ifdef CONFIG_F2FS_CHECK_FS
 static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int segno)
 {
 	unsigned int end_segno = SM_I(sbi)->segment_count - 1;
 	BUG_ON(segno > end_segno);
 }
 
-/*
- * This function is used for only debugging.
- * NOTE: In future, we have to remove this function.
- */
 static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
 {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
@@ -565,6 +562,11 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
 			valid_blocks++;
 	BUG_ON(GET_SIT_VBLOCKS(raw_sit) != valid_blocks);
 }
+#else
+#define check_seg_range(sbi, segno)
+#define verify_block_addr(sbi, blk_addr)
+#define check_block_count(sbi, segno, raw_sit)
+#endif
 
 static inline pgoff_t current_sit_addr(struct f2fs_sb_info *sbi,
 						unsigned int start)
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index f685138..89d506d 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -372,7 +372,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 			alloc_nid_failed(sbi, new_nid);
 			return PTR_ERR(xpage);
 		}
-		BUG_ON(new_nid);
+		f2fs_bug_on(new_nid);
 	} else {
 		struct dnode_of_data dn;
 		set_new_dnode(&dn, inode, NULL, NULL, new_nid);
-- 
1.8.4.474.g128a96c

