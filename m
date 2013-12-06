Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab3LFGQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:16:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50983 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3LFGQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:16:13 -0500
X-AuditID: cbfee690-b7f676d00000310d-63-52a16bab6421
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Chao Yu <chao2.yu@samsung.com>
Subject: [PATCH] f2fs: add unlikely() macro for compiler more aggressively
Date: Fri, 06 Dec 2013 15:15:09 +0900
Message-id: <1386310509-5864-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t8zY93V2QuDDK7u57b43/SRzeL6rr9M
	FpcWuVvs2XuSxeLyrjlsDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujLPLrrIV
	9K1krmg9e5yxgfHbRaYuRk4OCQETiQMvrrBC2GISF+6tZ+ti5OIQEljGKLH84lZmmKJtq0Aa
	QBLTGSUals6HcpqZJGZ+Wg3UwsHBJqAtsXm/AUiDiACzxIKp5xlBapgFNjFKLHjzjh0kISzg
	JXHy5w1GEJtFQFVi5bHjLCA2r4CbRNOmWywQ27Qltj2fCNYsIfCaTeJR8xl2iAYBiW+TD7GA
	LJMQkJXYdADqOkmJgytusExgFFzAyLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyQkJ+xg
	vHfA+hBjMtC4icxSosn5wJDOK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQZGK+bl/dd3agiFv8wv/fi81JrHa2Pmzl15ti9/+k5nlyz+5bWEh6l7
	weRzfVOMpqj6fj1f9tIm49HpYm+H92+nXftQ91dv/enVYYoyU2bEbpI5ZXr7ocf+w2dX8pQk
	T1mhWWHitkVsk/oiwcvxb/7q8zfXd82doB0WW9fDZ7l18pe2nC38t4zOKrEUZyQaajEXFScC
	AJ9f1tNfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jQd1V2QuDDNa/t7H43/SRzeL6rr9M
	FpcWuVvs2XuSxeLyrjlsDqweuxd8ZvLo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xoyzy66yFfStZK5oPXucsYHx20WmLkZODgkBE4ltq2BsMYkL99az
	dTFycQgJTGeUaFg6nwnCaWaSmPlpNVCGg4NNQFti834DkAYRAWaJBVPPM4LUMAtsYpRY8OYd
	O0hCWMBL4uTPG4wgNouAqsTKY8dZQGxeATeJpk23WCC2aUtsez6RcQIj9wJGhlWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwQH/THoH46oGi0OMAhyMSjy8HKsWBAmxJpYVV+YeYpTgYFYS
	4e0RXxgkxJuSWFmVWpQfX1Sak1p8iDEZaPtEZinR5HxgNOaVxBsam5gZWRqZWRiZmJuTJqwk
	znuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6Nj/NcP/fbPLdR3cgkyHJy9kuOeBS/v0yo1IfsK
	E8tJahXTYwoeczyr0Nvf9jqw69aaGSfu/D3BIsD8fNLHpqdWFzdfeJgQkFf91vPqMlczNTNm
	Vt+XbiXds/aXiW9rd1BZsSBba3u6TucWlX+/PO0NZv378mTzm4W9SmsPB1/y3Gk+saFmF7cS
	S3FGoqEWc1FxIgBC8Tf8vAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds unlikely() macro into the most of codes.
The basic rule is to add that when:
- checking unusual errors,
- checking page mappings,
- and the other unlikely conditions.

Cc: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  22 ++++++----
 fs/f2fs/data.c       |  63 +++++++++++++--------------
 fs/f2fs/dir.c        |  10 ++---
 fs/f2fs/file.c       |  23 +++++-----
 fs/f2fs/gc.c         |  19 ++++-----
 fs/f2fs/inode.c      |  12 +++---
 fs/f2fs/namei.c      |  24 ++++++-----
 fs/f2fs/node.c       | 117 +++++++++++++++++++++++++++------------------------
 fs/f2fs/recovery.c   |  10 ++---
 fs/f2fs/segment.c    |  42 +++++++++---------
 fs/f2fs/super.c      |  83 ++++++++++++++++++------------------
 fs/f2fs/xattr.c      |  28 ++++++------
 12 files changed, 234 insertions(+), 219 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6b21066..25b67bb 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -34,7 +34,7 @@ struct page *grab_meta_page(struct f2fs_sb_info *sbi, pgoff_t index)
 	struct page *page = NULL;
 repeat:
 	page = grab_cache_page(mapping, index);
-	if (!page) {
+	if (unlikely(!page)) {
 		cond_resched();
 		goto repeat;
 	}
@@ -54,7 +54,7 @@ struct page *get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index)
 	struct page *page;
 repeat:
 	page = grab_cache_page(mapping, index);
-	if (!page) {
+	if (unlikely(!page)) {
 		cond_resched();
 		goto repeat;
 	}
@@ -66,7 +66,7 @@ repeat:
 		goto repeat;
 
 	lock_page(page);
-	if (page->mapping != mapping) {
+	if (unlikely(page->mapping != mapping)) {
 		f2fs_put_page(page, 1);
 		goto repeat;
 	}
@@ -142,7 +142,7 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 				PAGECACHE_TAG_DIRTY,
 				min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
-		if (unlikely(nr_pages == 0))
+		if (nr_pages == 0)
 			break;
 
 		for (i = 0; i < nr_pages; i++) {
@@ -425,7 +425,7 @@ int get_valid_checkpoint(struct f2fs_sb_info *sbi)
 	unsigned long long cp_start_blk_no;
 
 	sbi->ckpt = kzalloc(blk_size, GFP_KERNEL);
-	if (!sbi->ckpt)
+	if (unlikely(!sbi->ckpt))
 		return -ENOMEM;
 	/*
 	 * Finding out valid cp block involves read both
@@ -473,7 +473,7 @@ static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
 	list_for_each(this, head) {
 		struct dir_inode_entry *entry;
 		entry = list_entry(this, struct dir_inode_entry, list);
-		if (entry->inode == inode)
+		if (unlikely(entry->inode == inode))
 			return -EEXIST;
 	}
 	list_add_tail(&new->list, head);
@@ -485,6 +485,7 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct dir_inode_entry *new;
+	int ret;
 
 	if (!S_ISDIR(inode->i_mode))
 		return;
@@ -494,7 +495,8 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
 	INIT_LIST_HEAD(&new->list);
 
 	spin_lock(&sbi->dir_inode_lock);
-	if (__add_dirty_inode(inode, new))
+	ret = __add_dirty_inode(inode, new);
+	if (unlikely(ret))
 		kmem_cache_free(inode_entry_slab, new);
 
 	inc_page_count(sbi, F2FS_DIRTY_DENTS);
@@ -508,12 +510,14 @@ void add_dirty_dir_inode(struct inode *inode)
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct dir_inode_entry *new =
 			f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
+	int ret;
 
 	new->inode = inode;
 	INIT_LIST_HEAD(&new->list);
 
 	spin_lock(&sbi->dir_inode_lock);
-	if (__add_dirty_inode(inode, new))
+	ret = __add_dirty_inode(inode, new);
+	if (unlikely(ret))
 		kmem_cache_free(inode_entry_slab, new);
 	spin_unlock(&sbi->dir_inode_lock);
 }
@@ -783,7 +787,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	/* Here, we only have one bio having CP pack */
 	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
 
-	if (!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) {
+	if (unlikely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG))) {
 		clear_prefree_segments(sbi);
 		F2FS_RESET_SB_DIRT(sbi);
 	}
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2ce5a9e..c6d0322 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -49,11 +49,11 @@ static void f2fs_read_end_io(struct bio *bio, int err)
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
 
-		if (uptodate) {
-			SetPageUptodate(page);
-		} else {
+		if (unlikely(!uptodate)) {
 			ClearPageUptodate(page);
 			SetPageError(page);
+		} else {
+			SetPageUptodate(page);
 		}
 		unlock_page(page);
 	} while (bvec >= bio->bi_io_vec);
@@ -73,7 +73,7 @@ static void f2fs_write_end_io(struct bio *bio, int err)
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
 
-		if (!uptodate) {
+		if (unlikely(!uptodate)) {
 			SetPageError(page);
 			set_bit(AS_EIO, &page->mapping->flags);
 			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
@@ -157,6 +157,7 @@ int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
 {
 	struct block_device *bdev = sbi->sb->s_bdev;
 	struct bio *bio;
+	int ret;
 
 	trace_f2fs_submit_page_bio(page, blk_addr, rw);
 
@@ -167,7 +168,8 @@ int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
 	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
 	bio->bi_end_io = is_read_io(rw) ? f2fs_read_end_io : f2fs_write_end_io;
 
-	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
+	ret = bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
+	if (unlikely(ret < PAGE_CACHE_SIZE)) {
 		bio_put(bio);
 		f2fs_put_page(page, 1);
 		return -EFAULT;
@@ -249,7 +251,7 @@ int reserve_new_block(struct dnode_of_data *dn)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
 
-	if (is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC))
+	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
 		return -EPERM;
 	if (unlikely(!inc_valid_block_count(sbi, dn->inode, 1)))
 		return -ENOSPC;
@@ -416,7 +418,7 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, index, LOOKUP_NODE);
-	if (err)
+	if (unlikely(err))
 		return ERR_PTR(err);
 	f2fs_put_dnode(&dn);
 
@@ -424,11 +426,11 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 		return ERR_PTR(-ENOENT);
 
 	/* By fallocate(), there is no cached page, but with NEW_ADDR */
-	if (dn.data_blkaddr == NEW_ADDR)
+	if (unlikely(dn.data_blkaddr == NEW_ADDR))
 		return ERR_PTR(-EINVAL);
 
 	page = grab_cache_page_write_begin(mapping, index, AOP_FLAG_NOFS);
-	if (!page)
+	if (unlikely(!page))
 		return ERR_PTR(-ENOMEM);
 
 	if (PageUptodate(page)) {
@@ -438,12 +440,12 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 
 	err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
 					sync ? READ_SYNC : READA);
-	if (err)
+	if (unlikely(err))
 		return ERR_PTR(err);
 
 	if (sync) {
 		wait_on_page_locked(page);
-		if (!PageUptodate(page)) {
+		if (unlikely(!PageUptodate(page))) {
 			f2fs_put_page(page, 0);
 			return ERR_PTR(-EIO);
 		}
@@ -466,18 +468,18 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 
 repeat:
 	page = grab_cache_page_write_begin(mapping, index, AOP_FLAG_NOFS);
-	if (!page)
+	if (unlikely(!page))
 		return ERR_PTR(-ENOMEM);
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, index, LOOKUP_NODE);
-	if (err) {
+	if (unlikely(err)) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(err);
 	}
 	f2fs_put_dnode(&dn);
 
-	if (dn.data_blkaddr == NULL_ADDR) {
+	if (unlikely(dn.data_blkaddr == NULL_ADDR)) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-ENOENT);
 	}
@@ -498,15 +500,15 @@ repeat:
 	}
 
 	err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr, READ_SYNC);
-	if (err)
+	if (unlikely(err))
 		return ERR_PTR(err);
 
 	lock_page(page);
-	if (!PageUptodate(page)) {
+	if (unlikely(!PageUptodate(page))) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
-	if (page->mapping != mapping) {
+	if (unlikely(page->mapping != mapping)) {
 		f2fs_put_page(page, 1);
 		goto repeat;
 	}
@@ -532,12 +534,11 @@ struct page *get_new_data_page(struct inode *inode,
 
 	set_new_dnode(&dn, inode, npage, npage, 0);
 	err = f2fs_reserve_block(&dn, index);
-	if (err)
+	if (unlikely(err))
 		return ERR_PTR(err);
-
 repeat:
 	page = grab_cache_page(mapping, index);
-	if (!page)
+	if (unlikely(!page))
 		return ERR_PTR(-ENOMEM);
 
 	if (PageUptodate(page))
@@ -549,14 +550,14 @@ repeat:
 	} else {
 		err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
 								READ_SYNC);
-		if (err)
+		if (unlikely(err))
 			return ERR_PTR(err);
 		lock_page(page);
-		if (!PageUptodate(page)) {
+		if (unlikely(!PageUptodate(page))) {
 			f2fs_put_page(page, 1);
 			return ERR_PTR(-EIO);
 		}
-		if (page->mapping != mapping) {
+		if (unlikely(page->mapping != mapping)) {
 			f2fs_put_page(page, 1);
 			goto repeat;
 		}
@@ -598,7 +599,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, pgofs, LOOKUP_NODE_RA);
-	if (err) {
+	if (unlikely(err)) {
 		trace_f2fs_get_data_block(inode, iblock, bh_result, err);
 		return (err == -ENOENT) ? 0 : err;
 	}
@@ -651,7 +652,7 @@ int do_write_data_page(struct page *page)
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, page->index, LOOKUP_NODE);
-	if (err)
+	if (unlikely(err))
 		return err;
 
 	old_blk_addr = dn.data_blkaddr;
@@ -727,7 +728,7 @@ write:
 		f2fs_unlock_op(sbi);
 		need_balance_fs = true;
 	}
-	if (err == -ENOENT)
+	if (unlikely(err == -ENOENT))
 		goto out;
 	else if (err)
 		goto redirty_out;
@@ -807,7 +808,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	f2fs_balance_fs(sbi);
 repeat:
 	page = grab_cache_page_write_begin(mapping, index, flags);
-	if (!page)
+	if (unlikely(!page))
 		return -ENOMEM;
 	*pagep = page;
 
@@ -816,7 +817,7 @@ repeat:
 	err = f2fs_reserve_block(&dn, index);
 	f2fs_unlock_op(sbi);
 
-	if (err) {
+	if (unlikely(err)) {
 		f2fs_put_page(page, 1);
 		return err;
 	}
@@ -838,14 +839,14 @@ repeat:
 	} else {
 		err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
 							READ_SYNC);
-		if (err)
+		if (unlikely(err))
 			return err;
 		lock_page(page);
-		if (!PageUptodate(page)) {
+		if (unlikely(!PageUptodate(page))) {
 			f2fs_put_page(page, 1);
 			return -EIO;
 		}
-		if (page->mapping != mapping) {
+		if (unlikely(page->mapping != mapping)) {
 			f2fs_put_page(page, 1);
 			goto repeat;
 		}
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 0cc26ba..0fe6fa3 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -337,12 +337,12 @@ static struct page *init_inode_metadata(struct inode *inode,
 
 	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
 		page = new_inode_page(inode, name);
-		if (IS_ERR(page))
+		if (unlikely(IS_ERR(page)))
 			return page;
 
 		if (S_ISDIR(inode->i_mode)) {
 			err = make_empty_dir(inode, dir, page);
-			if (err)
+			if (unlikely(err))
 				goto error;
 		}
 
@@ -357,7 +357,7 @@ static struct page *init_inode_metadata(struct inode *inode,
 		wait_on_page_writeback(page);
 	} else {
 		page = get_node_page(F2FS_SB(dir->i_sb), inode->i_ino);
-		if (IS_ERR(page))
+		if (unlikely(IS_ERR(page)))
 			return page;
 
 		wait_on_page_writeback(page);
@@ -475,7 +475,7 @@ start:
 
 	for (block = bidx; block <= (bidx + nblock - 1); block++) {
 		dentry_page = get_new_data_page(dir, NULL, block, true);
-		if (IS_ERR(dentry_page))
+		if (unlikely(IS_ERR(dentry_page)))
 			return PTR_ERR(dentry_page);
 
 		dentry_blk = kmap(dentry_page);
@@ -494,7 +494,7 @@ add_dentry:
 	wait_on_page_writeback(dentry_page);
 
 	page = init_inode_metadata(inode, dir, name);
-	if (IS_ERR(page)) {
+	if (unlikely(IS_ERR(page))) {
 		err = PTR_ERR(page);
 		goto fail;
 	}
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2b47adc..62cab5f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -45,14 +45,14 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = f2fs_reserve_block(&dn, page->index);
 	f2fs_unlock_op(sbi);
-	if (err)
+	if (unlikely(err))
 		goto out;
 
 	file_update_time(vma->vm_file);
 	lock_page(page);
-	if (page->mapping != inode->i_mapping ||
+	if (unlikely(page->mapping != inode->i_mapping ||
 			page_offset(page) > i_size_read(inode) ||
-			!PageUptodate(page)) {
+			!PageUptodate(page))) {
 		unlock_page(page);
 		err = -EFAULT;
 		goto out;
@@ -120,12 +120,12 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		.for_reclaim = 0,
 	};
 
-	if (f2fs_readonly(inode->i_sb))
+	if (unlikely(f2fs_readonly(inode->i_sb)))
 		return 0;
 
 	trace_f2fs_sync_file_enter(inode);
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (ret) {
+	if (unlikely(ret)) {
 		trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
 		return ret;
 	}
@@ -163,7 +163,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			file_got_pino(inode);
 			mark_inode_dirty_sync(inode);
 			ret = f2fs_write_inode(inode, NULL);
-			if (ret)
+			if (unlikely(ret))
 				goto out;
 		}
 	} else {
@@ -171,11 +171,11 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		while (!sync_node_pages(sbi, inode->i_ino, &wbc)) {
 			mark_inode_dirty_sync(inode);
 			ret = f2fs_write_inode(inode, NULL);
-			if (ret)
+			if (unlikely(ret))
 				goto out;
 		}
 		ret = wait_on_node_pages_writeback(sbi, inode->i_ino);
-		if (ret)
+		if (unlikely(ret))
 			goto out;
 		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 	}
@@ -241,7 +241,7 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
 		return;
 
 	lock_page(page);
-	if (page->mapping != inode->i_mapping) {
+	if (unlikely(page->mapping != inode->i_mapping)) {
 		f2fs_put_page(page, 1);
 		return;
 	}
@@ -268,7 +268,7 @@ static int truncate_blocks(struct inode *inode, u64 from)
 	f2fs_lock_op(sbi);
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, free_from, LOOKUP_NODE);
-	if (err) {
+	if (unlikely(err)) {
 		if (err == -ENOENT)
 			goto free_next;
 		f2fs_unlock_op(sbi);
@@ -431,7 +431,7 @@ int truncate_hole(struct inode *inode, pgoff_t pg_start, pgoff_t pg_end)
 
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		err = get_dnode_of_data(&dn, index, LOOKUP_NODE);
-		if (err) {
+		if (unlikely(err)) {
 			if (err == -ENOENT)
 				continue;
 			return err;
@@ -516,7 +516,6 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 		if (ret)
 			break;
 
-
 		if (pg_start == pg_end)
 			new_size = offset + len;
 		else if (index == pg_start && off_start)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2886aef..2d6c443 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -99,7 +99,7 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 	if (!test_opt(sbi, BG_GC))
 		goto out;
 	gc_th = kmalloc(sizeof(struct f2fs_gc_kthread), GFP_KERNEL);
-	if (!gc_th) {
+	if (unlikely(!gc_th)) {
 		err = -ENOMEM;
 		goto out;
 	}
@@ -114,12 +114,11 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
 	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
 			"f2fs_gc-%u:%u", MAJOR(dev), MINOR(dev));
-	if (IS_ERR(gc_th->f2fs_gc_task)) {
+	if (unlikely(IS_ERR(gc_th->f2fs_gc_task))) {
 		err = PTR_ERR(gc_th->f2fs_gc_task);
 		kfree(gc_th);
 		sbi->gc_thread = NULL;
 	}
-
 out:
 	return err;
 }
@@ -127,7 +126,7 @@ out:
 void stop_gc_thread(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_gc_kthread *gc_th = sbi->gc_thread;
-	if (!gc_th)
+	if (unlikely(!gc_th))
 		return;
 	kthread_stop(gc_th->f2fs_gc_task);
 	kfree(gc_th);
@@ -424,7 +423,7 @@ next_step:
 			continue;
 		}
 		node_page = get_node_page(sbi, nid);
-		if (IS_ERR(node_page))
+		if (unlikely(IS_ERR(node_page)))
 			continue;
 
 		/* set page dirty and write it */
@@ -597,14 +596,14 @@ next_step:
 
 		if (phase == 2) {
 			inode = f2fs_iget(sb, dni.ino);
-			if (IS_ERR(inode))
+			if (unlikely(IS_ERR(inode)))
 				continue;
 
 			start_bidx = start_bidx_of_node(nofs, F2FS_I(inode));
 
 			data_page = find_data_page(inode,
 					start_bidx + ofs_in_node, false);
-			if (IS_ERR(data_page))
+			if (unlikely(IS_ERR(data_page)))
 				goto next_iput;
 
 			f2fs_put_page(data_page, 0);
@@ -616,7 +615,7 @@ next_step:
 								F2FS_I(inode));
 				data_page = get_lock_data_page(inode,
 						start_bidx + ofs_in_node);
-				if (IS_ERR(data_page))
+				if (unlikely(IS_ERR(data_page)))
 					continue;
 				move_data_page(inode, data_page, gc_type);
 				stat_inc_data_blk_count(sbi, 1);
@@ -695,7 +694,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi)
 
 	INIT_LIST_HEAD(&ilist);
 gc_more:
-	if (!(sbi->sb->s_flags & MS_ACTIVE))
+	if (unlikely(!(sbi->sb->s_flags & MS_ACTIVE)))
 		goto stop;
 
 	if (gc_type == BG_GC && has_not_enough_free_secs(sbi, nfree)) {
@@ -737,7 +736,7 @@ int __init create_gc_caches(void)
 {
 	winode_slab = f2fs_kmem_cache_create("f2fs_gc_inodes",
 			sizeof(struct inode_entry), NULL);
-	if (!winode_slab)
+	if (unlikely(!winode_slab))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index d0eaa9f..98d194c 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -69,16 +69,18 @@ static int do_read_inode(struct inode *inode)
 	struct page *node_page;
 	struct f2fs_node *rn;
 	struct f2fs_inode *ri;
+	int ret;
 
 	/* Check if ino is within scope */
-	if (check_nid_range(sbi, inode->i_ino)) {
+	ret = check_nid_range(sbi, inode->i_ino);
+	if (unlikely(ret)) {
 		f2fs_msg(inode->i_sb, KERN_ERR, "bad inode number: %lu",
 			 (unsigned long) inode->i_ino);
 		return -EINVAL;
 	}
 
 	node_page = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(node_page))
+	if (unlikely(IS_ERR(node_page)))
 		return PTR_ERR(node_page);
 
 	rn = F2FS_NODE(node_page);
@@ -123,7 +125,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	int ret = 0;
 
 	inode = iget_locked(sb, ino);
-	if (!inode)
+	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
 
 	if (!(inode->i_state & I_NEW)) {
@@ -134,7 +136,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 		goto make_now;
 
 	ret = do_read_inode(inode);
-	if (ret)
+	if (unlikely(ret))
 		goto bad_inode;
 make_now:
 	if (ino == F2FS_NODE_INO(sbi)) {
@@ -218,7 +220,7 @@ int update_inode_page(struct inode *inode)
 	struct page *node_page;
 
 	node_page = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(node_page))
+	if (unlikely(IS_ERR(node_page)))
 		return PTR_ERR(node_page);
 
 	update_inode(inode, node_page);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 575adac..41d729b 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -27,14 +27,16 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	nid_t ino;
 	struct inode *inode;
 	bool nid_free = false;
+	bool success;
 	int err;
 
 	inode = new_inode(sb);
-	if (!inode)
+	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
 
 	f2fs_lock_op(sbi);
-	if (!alloc_nid(sbi, &ino)) {
+	success = alloc_nid(sbi, &ino);
+	if (unlikely(!success)) {
 		f2fs_unlock_op(sbi);
 		err = -ENOSPC;
 		goto fail;
@@ -58,7 +60,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	inode->i_generation = sbi->s_next_generation++;
 
 	err = insert_inode_locked(inode);
-	if (err) {
+	if (unlikely(err)) {
 		err = -EINVAL;
 		nid_free = true;
 		goto out;
@@ -74,7 +76,7 @@ fail:
 	trace_f2fs_new_inode(inode, err);
 	make_bad_inode(inode);
 	iput(inode);
-	if (nid_free)
+	if (unlikely(nid_free))
 		alloc_nid_failed(sbi, ino);
 	return ERR_PTR(err);
 }
@@ -120,7 +122,7 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	f2fs_balance_fs(sbi);
 
 	inode = f2fs_new_inode(dir, mode);
-	if (IS_ERR(inode))
+	if (unlikely(IS_ERR(inode)))
 		return PTR_ERR(inode);
 
 	if (!test_opt(sbi, DISABLE_EXT_IDENTIFY))
@@ -205,7 +207,7 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 		f2fs_put_page(page, 0);
 
 		inode = f2fs_iget(dir->i_sb, ino);
-		if (IS_ERR(inode))
+		if (unlikely(IS_ERR(inode)))
 			return ERR_CAST(inode);
 	}
 
@@ -230,7 +232,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 
 	f2fs_lock_op(sbi);
 	err = acquire_orphan_inode(sbi);
-	if (err) {
+	if (unlikely(err)) {
 		f2fs_unlock_op(sbi);
 		kunmap(page);
 		f2fs_put_page(page, 0);
@@ -258,7 +260,7 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 	f2fs_balance_fs(sbi);
 
 	inode = f2fs_new_inode(dir, S_IFLNK | S_IRWXUGO);
-	if (IS_ERR(inode))
+	if (unlikely(IS_ERR(inode)))
 		return PTR_ERR(inode);
 
 	inode->i_op = &f2fs_symlink_inode_operations;
@@ -294,7 +296,7 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	f2fs_balance_fs(sbi);
 
 	inode = f2fs_new_inode(dir, S_IFDIR | mode);
-	if (IS_ERR(inode))
+	if (unlikely(IS_ERR(inode)))
 		return PTR_ERR(inode);
 
 	inode->i_op = &f2fs_dir_inode_operations;
@@ -348,7 +350,7 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
 	f2fs_balance_fs(sbi);
 
 	inode = f2fs_new_inode(dir, mode);
-	if (IS_ERR(inode))
+	if (unlikely(IS_ERR(inode)))
 		return PTR_ERR(inode);
 
 	init_special_inode(inode, inode->i_mode, rdev);
@@ -415,7 +417,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out_dir;
 
 		err = acquire_orphan_inode(sbi);
-		if (err)
+		if (unlikely(err))
 			goto put_out_dir;
 
 		if (update_dent_inode(old_inode, &new_dentry->d_name)) {
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 2e41636..b6780f5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -99,7 +99,7 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 		index = current_nat_addr(sbi, nid);
 
 		page = grab_cache_page(mapping, index);
-		if (!page)
+		if (unlikely(!page))
 			continue;
 		if (PageUptodate(page)) {
 			mark_page_accessed(page);
@@ -149,11 +149,13 @@ int is_checkpointed_node(struct f2fs_sb_info *sbi, nid_t nid)
 static struct nat_entry *grab_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid)
 {
 	struct nat_entry *new;
+	int ret;
 
 	new = kmem_cache_alloc(nat_entry_slab, GFP_ATOMIC);
-	if (!new)
+	if (unlikely(!new))
 		return NULL;
-	if (radix_tree_insert(&nm_i->nat_root, nid, new)) {
+	ret = radix_tree_insert(&nm_i->nat_root, nid, new);
+	if (unlikely(ret)) {
 		kmem_cache_free(nat_entry_slab, new);
 		return NULL;
 	}
@@ -173,7 +175,7 @@ retry:
 	e = __lookup_nat_cache(nm_i, nid);
 	if (!e) {
 		e = grab_nat_entry(nm_i, nid);
-		if (!e) {
+		if (unlikely(!e)) {
 			write_unlock(&nm_i->nat_tree_lock);
 			goto retry;
 		}
@@ -195,7 +197,7 @@ retry:
 	e = __lookup_nat_cache(nm_i, ni->nid);
 	if (!e) {
 		e = grab_nat_entry(nm_i, ni->nid);
-		if (!e) {
+		if (unlikely(!e)) {
 			write_unlock(&nm_i->nat_tree_lock);
 			goto retry;
 		}
@@ -410,7 +412,7 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 
 	if (!npage[0]) {
 		npage[0] = get_node_page(sbi, nids[0]);
-		if (IS_ERR(npage[0]))
+		if (unlikely(IS_ERR(npage[0])))
 			return PTR_ERR(npage[0]);
 	}
 	parent = npage[0];
@@ -424,15 +426,16 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 		bool done = false;
 
 		if (!nids[i] && mode == ALLOC_NODE) {
-			/* alloc new node */
-			if (!alloc_nid(sbi, &(nids[i]))) {
+			bool success = alloc_nid(sbi, &(nids[i]));
+
+			if (unlikely(!success)) {
 				err = -ENOSPC;
 				goto release_pages;
 			}
 
 			dn->nid = nids[i];
 			npage[i] = new_node_page(dn, noffset[i], NULL);
-			if (IS_ERR(npage[i])) {
+			if (unlikely(IS_ERR(npage[i]))) {
 				alloc_nid_failed(sbi, nids[i]);
 				err = PTR_ERR(npage[i]);
 				goto release_pages;
@@ -443,7 +446,7 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 			done = true;
 		} else if (mode == LOOKUP_NODE_RA && i == level && level > 1) {
 			npage[i] = get_node_page_ra(parent, offset[i - 1]);
-			if (IS_ERR(npage[i])) {
+			if (unlikely(IS_ERR(npage[i]))) {
 				err = PTR_ERR(npage[i]);
 				goto release_pages;
 			}
@@ -458,7 +461,7 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 
 		if (!done) {
 			npage[i] = get_node_page(sbi, nids[i]);
-			if (IS_ERR(npage[i])) {
+			if (unlikely(IS_ERR(npage[i]))) {
 				err = PTR_ERR(npage[i]);
 				f2fs_put_page(npage[0], 0);
 				goto release_out;
@@ -529,7 +532,7 @@ static int truncate_dnode(struct dnode_of_data *dn)
 	page = get_node_page(sbi, dn->nid);
 	if (IS_ERR(page) && PTR_ERR(page) == -ENOENT)
 		return 1;
-	else if (IS_ERR(page))
+	else if (unlikely(IS_ERR(page)))
 		return PTR_ERR(page);
 
 	/* Make dnode_of_data for parameter */
@@ -558,7 +561,7 @@ static int truncate_nodes(struct dnode_of_data *dn, unsigned int nofs,
 	trace_f2fs_truncate_nodes_enter(dn->inode, dn->nid, dn->data_blkaddr);
 
 	page = get_node_page(sbi, dn->nid);
-	if (IS_ERR(page)) {
+	if (unlikely(IS_ERR(page))) {
 		trace_f2fs_truncate_nodes_exit(dn->inode, PTR_ERR(page));
 		return PTR_ERR(page);
 	}
@@ -571,7 +574,7 @@ static int truncate_nodes(struct dnode_of_data *dn, unsigned int nofs,
 				continue;
 			rdn.nid = child_nid;
 			ret = truncate_dnode(&rdn);
-			if (ret < 0)
+			if (unlikely(ret < 0))
 				goto out_err;
 			set_nid(page, i, 0, false);
 		}
@@ -588,7 +591,7 @@ static int truncate_nodes(struct dnode_of_data *dn, unsigned int nofs,
 			if (ret == (NIDS_PER_BLOCK + 1)) {
 				set_nid(page, i, 0, false);
 				child_nofs += ret;
-			} else if (ret < 0 && ret != -ENOENT) {
+			} else if (unlikely(ret < 0 && ret != -ENOENT)) {
 				goto out_err;
 			}
 		}
@@ -631,7 +634,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 	for (i = 0; i < depth - 1; i++) {
 		/* refernece count'll be increased */
 		pages[i] = get_node_page(sbi, nid[i]);
-		if (IS_ERR(pages[i])) {
+		if (unlikely(IS_ERR(pages[i]))) {
 			depth = i + 1;
 			err = PTR_ERR(pages[i]);
 			goto fail;
@@ -646,7 +649,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 			continue;
 		dn->nid = child_nid;
 		err = truncate_dnode(dn);
-		if (err < 0)
+		if (unlikely(err < 0))
 			goto fail;
 		set_nid(pages[idx], i, 0, false);
 	}
@@ -688,7 +691,7 @@ int truncate_inode_blocks(struct inode *inode, pgoff_t from)
 	level = get_node_path(F2FS_I(inode), from, offset, noffset);
 restart:
 	page = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(page)) {
+	if (unlikely(IS_ERR(page))) {
 		trace_f2fs_truncate_inode_blocks_exit(inode, PTR_ERR(page));
 		return PTR_ERR(page);
 	}
@@ -707,7 +710,7 @@ restart:
 		if (!offset[level - 1])
 			goto skip_partial;
 		err = truncate_partial_nodes(&dn, &rn->i, offset, level);
-		if (err < 0 && err != -ENOENT)
+		if (unlikely(err < 0 && err != -ENOENT))
 			goto fail;
 		nofs += 1 + NIDS_PER_BLOCK;
 		break;
@@ -716,7 +719,7 @@ restart:
 		if (!offset[level - 1])
 			goto skip_partial;
 		err = truncate_partial_nodes(&dn, &rn->i, offset, level);
-		if (err < 0 && err != -ENOENT)
+		if (unlikely(err < 0 && err != -ENOENT))
 			goto fail;
 		break;
 	default:
@@ -745,12 +748,12 @@ skip_partial:
 		default:
 			BUG();
 		}
-		if (err < 0 && err != -ENOENT)
+		if (unlikely(err < 0 && err != -ENOENT))
 			goto fail;
 		if (offset[1] == 0 &&
 				rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK]) {
 			lock_page(page);
-			if (page->mapping != node_mapping) {
+			if (unlikely(page->mapping != node_mapping)) {
 				f2fs_put_page(page, 1);
 				goto restart;
 			}
@@ -780,7 +783,7 @@ int truncate_xattr_node(struct inode *inode, struct page *page)
 		return 0;
 
 	npage = get_node_page(sbi, nid);
-	if (IS_ERR(npage))
+	if (unlikely(IS_ERR(npage)))
 		return PTR_ERR(npage);
 
 	F2FS_I(inode)->i_xattr_nid = 0;
@@ -806,12 +809,14 @@ void remove_inode_page(struct inode *inode)
 	struct page *page;
 	nid_t ino = inode->i_ino;
 	struct dnode_of_data dn;
+	int err;
 
 	page = get_node_page(sbi, ino);
-	if (IS_ERR(page))
+	if (unlikely(IS_ERR(page)))
 		return;
 
-	if (truncate_xattr_node(inode, page)) {
+	err = truncate_xattr_node(inode, page);
+	if (unlikely(err)) {
 		f2fs_put_page(page, 1);
 		return;
 	}
@@ -841,14 +846,14 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	struct page *page;
 	int err;
 
-	if (is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC))
+	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
 		return ERR_PTR(-EPERM);
 
 	page = grab_cache_page(mapping, dn->nid);
-	if (!page)
+	if (unlikely(!page))
 		return ERR_PTR(-ENOMEM);
 
-	if (!inc_valid_node_count(sbi, dn->inode)) {
+	if (unlikely(!inc_valid_node_count(sbi, dn->inode))) {
 		err = -ENOSPC;
 		goto fail;
 	}
@@ -898,7 +903,7 @@ static int read_node_page(struct page *page, int rw)
 
 	get_node_info(sbi, page->index, &ni);
 
-	if (ni.blk_addr == NULL_ADDR) {
+	if (unlikely(ni.blk_addr == NULL_ADDR)) {
 		f2fs_put_page(page, 1);
 		return -ENOENT;
 	}
@@ -926,7 +931,7 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 	f2fs_put_page(apage, 0);
 
 	apage = grab_cache_page(mapping, nid);
-	if (!apage)
+	if (unlikely(!apage))
 		return;
 
 	err = read_node_page(apage, READA);
@@ -943,21 +948,21 @@ struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
 	int err;
 repeat:
 	page = grab_cache_page(mapping, nid);
-	if (!page)
+	if (unlikely(!page))
 		return ERR_PTR(-ENOMEM);
 
 	err = read_node_page(page, READ_SYNC);
-	if (err < 0)
+	if (unlikely(err < 0))
 		return ERR_PTR(err);
 	else if (err == LOCKED_PAGE)
 		goto got_it;
 
 	lock_page(page);
-	if (!PageUptodate(page)) {
+	if (unlikely(!PageUptodate(page))) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
-	if (page->mapping != mapping) {
+	if (unlikely(page->mapping != mapping)) {
 		f2fs_put_page(page, 1);
 		goto repeat;
 	}
@@ -986,11 +991,11 @@ struct page *get_node_page_ra(struct page *parent, int start)
 		return ERR_PTR(-ENOENT);
 repeat:
 	page = grab_cache_page(mapping, nid);
-	if (!page)
+	if (unlikely(!page))
 		return ERR_PTR(-ENOMEM);
 
 	err = read_node_page(page, READ_SYNC);
-	if (err < 0)
+	if (unlikely(err < 0))
 		return ERR_PTR(err);
 	else if (err == LOCKED_PAGE)
 		goto page_hit;
@@ -1010,12 +1015,12 @@ repeat:
 	blk_finish_plug(&plug);
 
 	lock_page(page);
-	if (page->mapping != mapping) {
+	if (unlikely(page->mapping != mapping)) {
 		f2fs_put_page(page, 1);
 		goto repeat;
 	}
 page_hit:
-	if (!PageUptodate(page)) {
+	if (unlikely(!PageUptodate(page))) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
@@ -1173,9 +1178,9 @@ int wait_on_node_pages_writeback(struct f2fs_sb_info *sbi, nid_t ino)
 		cond_resched();
 	}
 
-	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
+	if (unlikely(test_and_clear_bit(AS_ENOSPC, &mapping->flags)))
 		ret2 = -ENOSPC;
-	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+	if (unlikely(test_and_clear_bit(AS_EIO, &mapping->flags)))
 		ret2 = -EIO;
 	if (!ret)
 		ret = ret2;
@@ -1202,7 +1207,7 @@ static int f2fs_write_node_page(struct page *page,
 	get_node_info(sbi, nid, &ni);
 
 	/* This page is already truncated */
-	if (ni.blk_addr == NULL_ADDR) {
+	if (unlikely(ni.blk_addr == NULL_ADDR)) {
 		dec_page_count(sbi, F2FS_DIRTY_NODES);
 		unlock_page(page);
 		return 0;
@@ -1502,7 +1507,7 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *i;
 
-	if (!nid)
+	if (unlikely(!nid))
 		return;
 
 	spin_lock(&nm_i->free_nid_list_lock);
@@ -1535,7 +1540,7 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 	struct page *ipage;
 
 	ipage = grab_cache_page(mapping, ino);
-	if (!ipage)
+	if (unlikely(!ipage))
 		return -ENOMEM;
 
 	/* Should not use this inode  from free nid list */
@@ -1578,7 +1583,7 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 	for (; page_idx < start + nrpages; page_idx++) {
 		/* alloc temporal page for read node summary info*/
 		page = alloc_page(GFP_F2FS_ZERO);
-		if (!page) {
+		if (unlikely(!page)) {
 			struct page *tmp;
 			list_for_each_entry_safe(page, tmp, pages, lru) {
 				list_del(&page->lru);
@@ -1621,20 +1626,20 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 
 		/* read ahead node pages */
 		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
-		if (err)
+		if (unlikely(err))
 			return err;
 
 		list_for_each_entry_safe(page, tmp, &page_list, lru) {
 
 			lock_page(page);
-			if(PageUptodate(page)) {
+			if (unlikely(!PageUptodate(page))) {
+				err = -EIO;
+			} else {
 				rn = F2FS_NODE(page);
 				sum_entry->nid = rn->footer.nid;
 				sum_entry->version = 0;
 				sum_entry->ofs_in_node = 0;
 				sum_entry++;
-			} else {
-				err = -EIO;
 			}
 
 			list_del(&page->lru);
@@ -1674,7 +1679,7 @@ retry:
 			continue;
 		}
 		ne = grab_nat_entry(nm_i, nid);
-		if (!ne) {
+		if (unlikely(!ne)) {
 			write_unlock(&nm_i->nat_tree_lock);
 			goto retry;
 		}
@@ -1811,12 +1816,12 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	nm_i->next_scan_nid = le32_to_cpu(sbi->ckpt->next_free_nid);
 	nm_i->bitmap_size = __bitmap_size(sbi, NAT_BITMAP);
 	version_bitmap = __bitmap_ptr(sbi, NAT_BITMAP);
-	if (!version_bitmap)
+	if (unlikely(!version_bitmap))
 		return -EFAULT;
 
 	nm_i->nat_bitmap = kmemdup(version_bitmap, nm_i->bitmap_size,
 					GFP_KERNEL);
-	if (!nm_i->nat_bitmap)
+	if (unlikely(!nm_i->nat_bitmap))
 		return -ENOMEM;
 	return 0;
 }
@@ -1826,11 +1831,11 @@ int build_node_manager(struct f2fs_sb_info *sbi)
 	int err;
 
 	sbi->nm_info = kzalloc(sizeof(struct f2fs_nm_info), GFP_KERNEL);
-	if (!sbi->nm_info)
+	if (unlikely(!sbi->nm_info))
 		return -ENOMEM;
 
 	err = init_node_manager(sbi);
-	if (err)
+	if (unlikely(err))
 		return err;
 
 	build_free_nids(sbi);
@@ -1845,7 +1850,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 	nid_t nid = 0;
 	unsigned int found;
 
-	if (!nm_i)
+	if (unlikely(!nm_i))
 		return;
 
 	/* destroy free nid list */
@@ -1881,12 +1886,12 @@ int __init create_node_manager_caches(void)
 {
 	nat_entry_slab = f2fs_kmem_cache_create("nat_entry",
 			sizeof(struct nat_entry), NULL);
-	if (!nat_entry_slab)
+	if (unlikely(!nat_entry_slab))
 		return -ENOMEM;
 
 	free_nid_slab = f2fs_kmem_cache_create("free_nid",
 			sizeof(struct free_nid), NULL);
-	if (!free_nid_slab) {
+	if (unlikely(!free_nid_slab)) {
 		kmem_cache_destroy(nat_entry_slab);
 		return -ENOMEM;
 	}
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index d075465..95eeb85 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -136,7 +136,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 
 	/* read node page */
 	page = alloc_page(GFP_F2FS_ZERO);
-	if (!page)
+	if (unlikely(!page))
 		return -ENOMEM;
 	lock_page(page);
 
@@ -144,7 +144,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 		struct fsync_inode_entry *entry;
 
 		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
-		if (err)
+		if (unlikely(err))
 			return err;
 
 		lock_page(page);
@@ -169,7 +169,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 
 			/* add this fsync inode to the list */
 			entry = kmem_cache_alloc(fsync_entry_slab, GFP_NOFS);
-			if (!entry) {
+			if (unlikely(!entry)) {
 				err = -ENOMEM;
 				break;
 			}
@@ -379,7 +379,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 
 	/* read node page */
 	page = alloc_page(GFP_F2FS_ZERO);
-	if (!page)
+	if (unlikely(!page))
 		return -ENOMEM;
 
 	lock_page(page);
@@ -388,7 +388,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 		struct fsync_inode_entry *entry;
 
 		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
-		if (err)
+		if (unlikely(err))
 			return err;
 
 		lock_page(page);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index ca9adf5..a4c4bc4 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1450,18 +1450,18 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 
 	/* allocate memory for SIT information */
 	sit_i = kzalloc(sizeof(struct sit_info), GFP_KERNEL);
-	if (!sit_i)
+	if (unlikely(!sit_i))
 		return -ENOMEM;
 
 	SM_I(sbi)->sit_info = sit_i;
 
 	sit_i->sentries = vzalloc(TOTAL_SEGS(sbi) * sizeof(struct seg_entry));
-	if (!sit_i->sentries)
+	if (unlikely(!sit_i->sentries))
 		return -ENOMEM;
 
 	bitmap_size = f2fs_bitmap_size(TOTAL_SEGS(sbi));
 	sit_i->dirty_sentries_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!sit_i->dirty_sentries_bitmap)
+	if (unlikely(!sit_i->dirty_sentries_bitmap))
 		return -ENOMEM;
 
 	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
@@ -1469,15 +1469,15 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 			= kzalloc(SIT_VBLOCK_MAP_SIZE, GFP_KERNEL);
 		sit_i->sentries[start].ckpt_valid_map
 			= kzalloc(SIT_VBLOCK_MAP_SIZE, GFP_KERNEL);
-		if (!sit_i->sentries[start].cur_valid_map
-				|| !sit_i->sentries[start].ckpt_valid_map)
+		if (unlikely(!sit_i->sentries[start].cur_valid_map
+				|| !sit_i->sentries[start].ckpt_valid_map))
 			return -ENOMEM;
 	}
 
 	if (sbi->segs_per_sec > 1) {
 		sit_i->sec_entries = vzalloc(TOTAL_SECS(sbi) *
 					sizeof(struct sec_entry));
-		if (!sit_i->sec_entries)
+		if (unlikely(!sit_i->sec_entries))
 			return -ENOMEM;
 	}
 
@@ -1489,7 +1489,7 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 	src_bitmap = __bitmap_ptr(sbi, SIT_BITMAP);
 
 	dst_bitmap = kmemdup(src_bitmap, bitmap_size, GFP_KERNEL);
-	if (!dst_bitmap)
+	if (unlikely(!dst_bitmap))
 		return -ENOMEM;
 
 	/* init SIT information */
@@ -1516,19 +1516,19 @@ static int build_free_segmap(struct f2fs_sb_info *sbi)
 
 	/* allocate memory for free segmap information */
 	free_i = kzalloc(sizeof(struct free_segmap_info), GFP_KERNEL);
-	if (!free_i)
+	if (unlikely(!free_i))
 		return -ENOMEM;
 
 	SM_I(sbi)->free_info = free_i;
 
 	bitmap_size = f2fs_bitmap_size(TOTAL_SEGS(sbi));
 	free_i->free_segmap = kmalloc(bitmap_size, GFP_KERNEL);
-	if (!free_i->free_segmap)
+	if (unlikely(!free_i->free_segmap))
 		return -ENOMEM;
 
 	sec_bitmap_size = f2fs_bitmap_size(TOTAL_SECS(sbi));
 	free_i->free_secmap = kmalloc(sec_bitmap_size, GFP_KERNEL);
-	if (!free_i->free_secmap)
+	if (unlikely(!free_i->free_secmap))
 		return -ENOMEM;
 
 	/* set all segments as dirty temporarily */
@@ -1550,7 +1550,7 @@ static int build_curseg(struct f2fs_sb_info *sbi)
 	int i;
 
 	array = kzalloc(sizeof(*array) * NR_CURSEG_TYPE, GFP_KERNEL);
-	if (!array)
+	if (unlikely(!array))
 		return -ENOMEM;
 
 	SM_I(sbi)->curseg_array = array;
@@ -1558,7 +1558,7 @@ static int build_curseg(struct f2fs_sb_info *sbi)
 	for (i = 0; i < NR_CURSEG_TYPE; i++) {
 		mutex_init(&array[i].curseg_mutex);
 		array[i].sum_blk = kzalloc(PAGE_CACHE_SIZE, GFP_KERNEL);
-		if (!array[i].sum_blk)
+		if (unlikely(!array[i].sum_blk))
 			return -ENOMEM;
 		array[i].segno = NULL_SEGNO;
 		array[i].next_blkoff = 0;
@@ -1583,7 +1583,7 @@ static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
 		prev_blk_addr = blk_addr;
 repeat:
 		page = grab_cache_page(mapping, blk_addr);
-		if (!page) {
+		if (unlikely(!page)) {
 			cond_resched();
 			goto repeat;
 		}
@@ -1697,7 +1697,7 @@ static int init_victim_secmap(struct f2fs_sb_info *sbi)
 	unsigned int bitmap_size = f2fs_bitmap_size(TOTAL_SECS(sbi));
 
 	dirty_i->victim_secmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dirty_i->victim_secmap)
+	if (unlikely(!dirty_i->victim_secmap))
 		return -ENOMEM;
 	return 0;
 }
@@ -1709,7 +1709,7 @@ static int build_dirty_segmap(struct f2fs_sb_info *sbi)
 
 	/* allocate memory for dirty segments list information */
 	dirty_i = kzalloc(sizeof(struct dirty_seglist_info), GFP_KERNEL);
-	if (!dirty_i)
+	if (unlikely(!dirty_i))
 		return -ENOMEM;
 
 	SM_I(sbi)->dirty_info = dirty_i;
@@ -1719,7 +1719,7 @@ static int build_dirty_segmap(struct f2fs_sb_info *sbi)
 
 	for (i = 0; i < NR_DIRTY_TYPE; i++) {
 		dirty_i->dirty_segmap[i] = kzalloc(bitmap_size, GFP_KERNEL);
-		if (!dirty_i->dirty_segmap[i])
+		if (unlikely(!dirty_i->dirty_segmap[i]))
 			return -ENOMEM;
 	}
 
@@ -1763,7 +1763,7 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	int err;
 
 	sm_info = kzalloc(sizeof(struct f2fs_sm_info), GFP_KERNEL);
-	if (!sm_info)
+	if (unlikely(!sm_info))
 		return -ENOMEM;
 
 	/* init sm info */
@@ -1784,13 +1784,13 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->max_discards = 0;
 
 	err = build_sit_info(sbi);
-	if (err)
+	if (unlikely(err))
 		return err;
 	err = build_free_segmap(sbi);
-	if (err)
+	if (unlikely(err))
 		return err;
 	err = build_curseg(sbi);
-	if (err)
+	if (unlikely(err))
 		return err;
 
 	/* reinit free segmap based on SIT */
@@ -1798,7 +1798,7 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 
 	init_free_segmap(sbi);
 	err = build_dirty_segmap(sbi);
-	if (err)
+	if (unlikely(err))
 		return err;
 
 	init_min_max_mtime(sbi);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 22b07c3..7159e2f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -101,7 +101,7 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 	unsigned int *ui;
 
 	ptr = __struct_ptr(sbi, a->struct_type);
-	if (!ptr)
+	if (unlikely(!ptr))
 		return -EINVAL;
 
 	ui = (unsigned int *)(ptr + a->offset);
@@ -119,13 +119,13 @@ static ssize_t f2fs_sbi_store(struct f2fs_attr *a,
 	ssize_t ret;
 
 	ptr = __struct_ptr(sbi, a->struct_type);
-	if (!ptr)
+	if (unlikely(!ptr))
 		return -EINVAL;
 
 	ui = (unsigned int *)(ptr + a->offset);
 
 	ret = kstrtoul(skip_spaces(buf), 0, &t);
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		return ret;
 	*ui = t;
 	return count;
@@ -626,7 +626,7 @@ static struct inode *f2fs_nfs_get_inode(struct super_block *sb,
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	struct inode *inode;
 
-	if (ino < F2FS_ROOT_INO(sbi))
+	if (unlikely(ino < F2FS_ROOT_INO(sbi)))
 		return ERR_PTR(-ESTALE);
 
 	/*
@@ -635,9 +635,9 @@ static struct inode *f2fs_nfs_get_inode(struct super_block *sb,
 	 * inodes so everything is OK.
 	 */
 	inode = f2fs_iget(sb, ino);
-	if (IS_ERR(inode))
+	if (unlikely(IS_ERR(inode)))
 		return ERR_CAST(inode);
-	if (generation && inode->i_generation != generation) {
+	if (unlikely(generation && inode->i_generation != generation)) {
 		/* we didn't find the right inode.. */
 		iput(inode);
 		return ERR_PTR(-ESTALE);
@@ -698,7 +698,7 @@ static int sanity_check_raw_super(struct super_block *sb,
 	}
 
 	/* Currently, support only 4KB page cache size */
-	if (F2FS_BLKSIZE != PAGE_CACHE_SIZE) {
+	if (unlikely(F2FS_BLKSIZE != PAGE_CACHE_SIZE)) {
 		f2fs_msg(sb, KERN_INFO,
 			"Invalid page_cache_size (%lu), supports only 4KB\n",
 			PAGE_CACHE_SIZE);
@@ -707,20 +707,20 @@ static int sanity_check_raw_super(struct super_block *sb,
 
 	/* Currently, support only 4KB block size */
 	blocksize = 1 << le32_to_cpu(raw_super->log_blocksize);
-	if (blocksize != F2FS_BLKSIZE) {
+	if (unlikely(blocksize != F2FS_BLKSIZE)) {
 		f2fs_msg(sb, KERN_INFO,
 			"Invalid blocksize (%u), supports only 4KB\n",
 			blocksize);
 		return 1;
 	}
 
-	if (le32_to_cpu(raw_super->log_sectorsize) !=
-					F2FS_LOG_SECTOR_SIZE) {
+	if (unlikely(le32_to_cpu(raw_super->log_sectorsize) !=
+					F2FS_LOG_SECTOR_SIZE)) {
 		f2fs_msg(sb, KERN_INFO, "Invalid log sectorsize");
 		return 1;
 	}
-	if (le32_to_cpu(raw_super->log_sectors_per_block) !=
-					F2FS_LOG_SECTORS_PER_BLOCK) {
+	if (unlikely(le32_to_cpu(raw_super->log_sectors_per_block) !=
+					F2FS_LOG_SECTORS_PER_BLOCK)) {
 		f2fs_msg(sb, KERN_INFO, "Invalid log sectors per block");
 		return 1;
 	}
@@ -740,10 +740,10 @@ static int sanity_check_ckpt(struct f2fs_sb_info *sbi)
 	fsmeta += le32_to_cpu(ckpt->rsvd_segment_count);
 	fsmeta += le32_to_cpu(raw_super->segment_count_ssa);
 
-	if (fsmeta >= total)
+	if (unlikely(fsmeta >= total))
 		return 1;
 
-	if (is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) {
+	if (unlikely(is_set_ckpt_flags(ckpt, CP_ERROR_FLAG))) {
 		f2fs_msg(sbi->sb, KERN_ERR, "A bug case: need to run fsck");
 		return 1;
 	}
@@ -789,14 +789,14 @@ static int read_raw_super_block(struct super_block *sb,
 
 retry:
 	*raw_super_buf = sb_bread(sb, block);
-	if (!*raw_super_buf) {
+	if (unlikely(!*raw_super_buf)) {
 		f2fs_msg(sb, KERN_ERR, "Unable to read %dth superblock",
 				block + 1);
-		if (block == 0) {
+		if (unlikely(block != 0)) {
+			return -EIO;
+		} else {
 			block++;
 			goto retry;
-		} else {
-			return -EIO;
 		}
 	}
 
@@ -808,11 +808,11 @@ retry:
 		brelse(*raw_super_buf);
 		f2fs_msg(sb, KERN_ERR, "Can't find a valid F2FS filesystem "
 				"in %dth superblock", block + 1);
-		if(block == 0) {
+		if(unlikely(block != 0)) {
+			return -EINVAL;
+		} else {
 			block++;
 			goto retry;
-		} else {
-			return -EINVAL;
 		}
 	}
 
@@ -830,17 +830,17 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* allocate memory for f2fs-specific super block info */
 	sbi = kzalloc(sizeof(struct f2fs_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (unlikely(!sbi))
 		return -ENOMEM;
 
 	/* set a block size */
-	if (!sb_set_blocksize(sb, F2FS_BLKSIZE)) {
+	if (unlikely(!sb_set_blocksize(sb, F2FS_BLKSIZE))) {
 		f2fs_msg(sb, KERN_ERR, "unable to set blocksize");
 		goto free_sbi;
 	}
 
 	err = read_raw_super_block(sb, &raw_super, &raw_super_buf);
-	if (err)
+	if (unlikely(err))
 		goto free_sbi;
 
 	sb->s_fs_info = sbi;
@@ -894,7 +894,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* get an inode for meta space */
 	sbi->meta_inode = f2fs_iget(sb, F2FS_META_INO(sbi));
-	if (IS_ERR(sbi->meta_inode)) {
+	if (unlikely(IS_ERR(sbi->meta_inode))) {
 		f2fs_msg(sb, KERN_ERR, "Failed to read F2FS meta data inode");
 		err = PTR_ERR(sbi->meta_inode);
 		goto free_sb_buf;
@@ -929,13 +929,13 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* setup f2fs internal modules */
 	err = build_segment_manager(sbi);
-	if (err) {
+	if (unlikely(err)) {
 		f2fs_msg(sb, KERN_ERR,
 			"Failed to initialize F2FS segment manager");
 		goto free_sm;
 	}
 	err = build_node_manager(sbi);
-	if (err) {
+	if (unlikely(err)) {
 		f2fs_msg(sb, KERN_ERR,
 			"Failed to initialize F2FS node manager");
 		goto free_nm;
@@ -945,7 +945,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* get an inode for node space */
 	sbi->node_inode = f2fs_iget(sb, F2FS_NODE_INO(sbi));
-	if (IS_ERR(sbi->node_inode)) {
+	if (unlikely(IS_ERR(sbi->node_inode))) {
 		f2fs_msg(sb, KERN_ERR, "Failed to read node inode");
 		err = PTR_ERR(sbi->node_inode);
 		goto free_nm;
@@ -956,18 +956,19 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* read root inode and dentry */
 	root = f2fs_iget(sb, F2FS_ROOT_INO(sbi));
-	if (IS_ERR(root)) {
+	if (unlikely(IS_ERR(root))) {
 		f2fs_msg(sb, KERN_ERR, "Failed to read root inode");
 		err = PTR_ERR(root);
 		goto free_node_inode;
 	}
-	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
+	if (unlikely(!S_ISDIR(root->i_mode) || !root->i_blocks ||
+						!root->i_size)) {
 		err = -EINVAL;
 		goto free_root_inode;
 	}
 
 	sb->s_root = d_make_root(root); /* allocate root dentry */
-	if (!sb->s_root) {
+	if (unlikely(!sb->s_root)) {
 		err = -ENOMEM;
 		goto free_root_inode;
 	}
@@ -992,7 +993,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	err = f2fs_build_stats(sbi);
-	if (err)
+	if (unlikely(err))
 		goto free_gc;
 
 	if (f2fs_proc_root)
@@ -1014,7 +1015,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	init_completion(&sbi->s_kobj_unregister);
 	err = kobject_init_and_add(&sbi->s_kobj, &f2fs_ktype, NULL,
 							"%s", sb->s_id);
-	if (err)
+	if (unlikely(err))
 		goto fail;
 
 	return 0;
@@ -1066,7 +1067,7 @@ static int __init init_inodecache(void)
 {
 	f2fs_inode_cachep = f2fs_kmem_cache_create("f2fs_inode_cache",
 			sizeof(struct f2fs_inode_info), NULL);
-	if (f2fs_inode_cachep == NULL)
+	if (unlikely(f2fs_inode_cachep == NULL))
 		return -ENOMEM;
 	return 0;
 }
@@ -1086,27 +1087,27 @@ static int __init init_f2fs_fs(void)
 	int err;
 
 	err = init_inodecache();
-	if (err)
+	if (unlikely(err))
 		goto fail;
 	err = create_node_manager_caches();
-	if (err)
+	if (unlikely(err))
 		goto free_inodecache;
 	err = create_segment_manager_caches();
-	if (err)
+	if (unlikely(err))
 		goto free_node_manager_caches;
 	err = create_gc_caches();
-	if (err)
+	if (unlikely(err))
 		goto free_segment_manager_caches;
 	err = create_checkpoint_caches();
-	if (err)
+	if (unlikely(err))
 		goto free_gc_caches;
 	f2fs_kset = kset_create_and_add("f2fs", NULL, fs_kobj);
-	if (!f2fs_kset) {
+	if (unlikely(!f2fs_kset)) {
 		err = -ENOMEM;
 		goto free_checkpoint_caches;
 	}
 	err = register_filesystem(&f2fs_fs_type);
-	if (err)
+	if (unlikely(err))
 		goto free_kset;
 	f2fs_create_root_stats();
 	f2fs_proc_root = proc_mkdir("fs/f2fs", NULL);
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index aa7a3f1..ce9e062 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -142,7 +142,7 @@ static int f2fs_xattr_advise_set(struct dentry *dentry, const char *name,
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (strcmp(name, "") != 0)
+	if (unlikely(strcmp(name, "") != 0))
 		return -EINVAL;
 	if (!inode_owner_or_capable(inode))
 		return -EPERM;
@@ -287,7 +287,7 @@ static void *read_all_xattrs(struct inode *inode, struct page *ipage)
 			inline_addr = inline_xattr_addr(ipage);
 		} else {
 			page = get_node_page(sbi, inode->i_ino);
-			if (IS_ERR(page))
+			if (unlikely(IS_ERR(page)))
 				goto fail;
 			inline_addr = inline_xattr_addr(page);
 		}
@@ -302,7 +302,7 @@ static void *read_all_xattrs(struct inode *inode, struct page *ipage)
 
 		/* The inode already has an extended attribute block. */
 		xpage = get_node_page(sbi, F2FS_I(inode)->i_xattr_nid);
-		if (IS_ERR(xpage))
+		if (unlikely(IS_ERR(xpage)))
 			goto fail;
 
 		xattr_addr = page_address(xpage);
@@ -335,9 +335,11 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 
 	inline_size = inline_xattr_size(inode);
 
-	if (hsize > inline_size && !F2FS_I(inode)->i_xattr_nid)
-		if (!alloc_nid(sbi, &new_nid))
+	if (hsize > inline_size && !F2FS_I(inode)->i_xattr_nid) {
+		bool success = alloc_nid(sbi, &new_nid);
+		if (unlikely(!success))
 			return -ENOSPC;
+	}
 
 	/* write to inline xattr */
 	if (inline_size) {
@@ -348,7 +350,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 			inline_addr = inline_xattr_addr(ipage);
 		} else {
 			page = get_node_page(sbi, inode->i_ino);
-			if (IS_ERR(page)) {
+			if (unlikely(IS_ERR(page))) {
 				alloc_nid_failed(sbi, new_nid);
 				return PTR_ERR(page);
 			}
@@ -368,7 +370,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 	/* write to xattr node block */
 	if (F2FS_I(inode)->i_xattr_nid) {
 		xpage = get_node_page(sbi, F2FS_I(inode)->i_xattr_nid);
-		if (IS_ERR(xpage)) {
+		if (unlikely(IS_ERR(xpage))) {
 			alloc_nid_failed(sbi, new_nid);
 			return PTR_ERR(xpage);
 		}
@@ -377,7 +379,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 		struct dnode_of_data dn;
 		set_new_dnode(&dn, inode, NULL, NULL, new_nid);
 		xpage = new_node_page(&dn, XATTR_NODE_OFFSET, ipage);
-		if (IS_ERR(xpage)) {
+		if (unlikely(IS_ERR(xpage))) {
 			alloc_nid_failed(sbi, new_nid);
 			return PTR_ERR(xpage);
 		}
@@ -408,7 +410,7 @@ int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
 	name_len = strlen(name);
 
 	base_addr = read_all_xattrs(inode, NULL);
-	if (!base_addr)
+	if (unlikely(!base_addr))
 		return -ENOMEM;
 
 	entry = __find_xattr(base_addr, name_index, name_len, name);
@@ -444,7 +446,7 @@ ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 	size_t rest = buffer_size;
 
 	base_addr = read_all_xattrs(inode, NULL);
-	if (!base_addr)
+	if (unlikely(!base_addr))
 		return -ENOMEM;
 
 	list_for_each_xattr(entry, base_addr) {
@@ -496,7 +498,7 @@ static int __f2fs_setxattr(struct inode *inode, int name_index,
 		return -ERANGE;
 
 	base_addr = read_all_xattrs(inode, ipage);
-	if (!base_addr)
+	if (unlikely(!base_addr))
 		goto exit;
 
 	/* find entry with wanted name. */
@@ -522,7 +524,7 @@ static int __f2fs_setxattr(struct inode *inode, int name_index,
 		if (found)
 			free = free + ENTRY_SIZE(here);
 
-		if (free < newsize) {
+		if (unlikely(free < newsize)) {
 			error = -ENOSPC;
 			goto exit;
 		}
@@ -562,7 +564,7 @@ static int __f2fs_setxattr(struct inode *inode, int name_index,
 	}
 
 	error = write_all_xattrs(inode, new_hsize, base_addr, ipage);
-	if (error)
+	if (unlikely(error))
 		goto exit;
 
 	if (is_inode_flag_set(fi, FI_ACL_MODE)) {
-- 
1.8.4.474.g128a96c

