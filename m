Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3LJIEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:04:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9316 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3LJIEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:04:14 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-aa-52a6caf2a9b2
Message-id: <1386662580.2101.149.camel@kjgkr>
Subject: Re: [PATCH v2] f2fs: add unlikely() macro for compiler more
 aggressively
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Andi Kleen <andi@firstfloor.org>
Cc: "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 17:03:00 +0900
In-reply-to: <87siu5vnvk.fsf@tassilo.jf.intel.com>
References: <1386310509-5864-1-git-send-email-jaegeuk.kim@samsung.com>
 <87siu5vnvk.fsf@tassilo.jf.intel.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zfd1Pp5YFGVxvErE4cu07u8WlRe4W
	e/aeZLG4vGsOmwOLx/ydHxk9di/4zOTxeZNcAHMUl01Kak5mWWqRvl0CV8alzR/YC6bnVLS9
	mc7awHgirIuRg0NCwETi0tbwLkZOIFNM4sK99WxdjFwcQgLLGCXm3ZzECpEwkTg1fwqYLSSw
	iFHi/H1eiKJXjBKn50xlBknwCuhKbD60jx3EFhYIlnh4azozyAI2AW2JzfsNIHoVJd7uv8sK
	EhYRUJE4fooPZAyzwClGiatvzoHNZxFQlWjePBFsJKeAkcSs1x1MIPVCAnkSG+bWg4T5BUQl
	Di/cDlbCLKAuMWneImaIM5Ukdrd3skPE5SU2r3kLdZmgxI/J91hAdkkIHGOXeLisjQ1il4DE
	t8mHWCDhICux6QDUHEmJgytusExglJiFZMUsJGNnIRm7gJF5FaNoakFyQXFSepGpXnFibnFp
	Xrpecn7uJkZItE3cwXj/gPUhxmSglROZpUST84HRmlcSb2hsZmRhamJqbGRuaUaasJI4b/qj
	pCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjIcC1W4fMRf5u0+N40X72TNPL7zRSnfNuLFk
	8cvDD17waj36bGQZJjQpQ/3J25MTt3Pcnf2w/Lzccq+jm2oLLGdOeL6X/T+HvUF0d55adq1O
	5wa+Cv+1B4J2+D71rtATELW5tM1y8vetDsoLo85fWPPwR6FBic+1FzFaAi0ZUvPD1ue5T78R
	8ECJpTgj0VCLuag4EQCXcb3DzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd1Pp5YFGfRP47U4cu07u8WlRe4W
	e/aeZLG4vGsOmwOLx/ydHxk9di/4zOTxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPGpc0f2Aum51S0vZnO2sB4IqyLkZNDQsBE4tT8KawQtpjEhXvr2UBsIYFF
	jBLn7/N2MXIB2a8YJU7PmcoMkuAV0JXYfGgfO4gtLBAs8fDWdKA4BwebgLbE5v0GEL2KEm/3
	32UFCYsIqEgcP8UHMoZZ4BSjxNU358B2sQioSjRvngg2klPASGLW6w4mkHohgTyJDXPrQcL8
	AqIShxduBythFlCXmDRvETPEmUoSu9s72SHi8hKb17yFukxQ4sfkeywTGIVmIWmZhaRsFpKy
	BYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/mZ1A7GlQ0WhxgFOBiVeHgLGJYFCbEm
	lhVX5h5ilOBgVhLh9awDCvGmJFZWpRblxxeV5qQWH2JMBnpuIrOUaHI+MNHklcQbGpuYGVka
	mVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAMj672XMWVRx/c98fO68fXytDON
	0yV2Jhw5xrBxWta6t3tPb+D58HDSnb1tmycUmsv/+2rO0vq24eHNUwWO7Nsbz0w9d8kx5KXF
	zLURx9IC/FduuTe7Q4o9UXhx9tqyx8f9cqfMfH6zjiFetmfT3AvG/BOal0rXGHDNNd8atUBL
	d+rHTUdnSHubOCmxFGckGmoxFxUnAgDDiT78KgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d373d7084e4d132fa596fd5def1b9a9843e1410f Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Fri, 6 Dec 2013 15:00:58 +0900
Subject: [PATCH] f2fs: add unlikely() macro for compiler more
aggressively

This patch adds unlikely() macro into the most of codes.
The basic rule is to add that when:
- checking unusual errors,
- checking page mappings,
- and the other unlikely conditions.

Change log from v1:
 - Don't add unlikely for the NULL test and error test: advised by Andi
Kleen.

Cc: Chao Yu <chao2.yu@samsung.com>
Cc: Andi Kleen <andi@firstfloor.org>
Reviewed-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 10 +++++-----
 fs/f2fs/data.c       | 29 ++++++++++++++---------------
 fs/f2fs/file.c       |  9 ++++-----
 fs/f2fs/gc.c         |  3 +--
 fs/f2fs/node.c       | 28 ++++++++++++++--------------
 fs/f2fs/recovery.c   |  2 +-
 fs/f2fs/super.c      | 14 +++++++-------
 fs/f2fs/xattr.c      |  2 +-
 8 files changed, 47 insertions(+), 50 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6b21066..cf505eb 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -66,7 +66,7 @@ repeat:
 		goto repeat;
 
 	lock_page(page);
-	if (page->mapping != mapping) {
+	if (unlikely(page->mapping != mapping)) {
 		f2fs_put_page(page, 1);
 		goto repeat;
 	}
@@ -473,7 +473,7 @@ static int __add_dirty_inode(struct inode *inode,
struct dir_inode_entry *new)
 	list_for_each(this, head) {
 		struct dir_inode_entry *entry;
 		entry = list_entry(this, struct dir_inode_entry, list);
-		if (entry->inode == inode)
+		if (unlikely(entry->inode == inode))
 			return -EEXIST;
 	}
 	list_add_tail(&new->list, head);
@@ -783,7 +783,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi,
bool is_umount)
 	/* Here, we only have one bio having CP pack */
 	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
 
-	if (!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) {
+	if (unlikely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG))) {
 		clear_prefree_segments(sbi);
 		F2FS_RESET_SB_DIRT(sbi);
 	}
@@ -840,11 +840,11 @@ int __init create_checkpoint_caches(void)
 {
 	orphan_entry_slab = f2fs_kmem_cache_create("f2fs_orphan_entry",
 			sizeof(struct orphan_inode_entry), NULL);
-	if (unlikely(!orphan_entry_slab))
+	if (!orphan_entry_slab)
 		return -ENOMEM;
 	inode_entry_slab = f2fs_kmem_cache_create("f2fs_dirty_dir_entry",
 			sizeof(struct dir_inode_entry), NULL);
-	if (unlikely(!inode_entry_slab)) {
+	if (!inode_entry_slab) {
 		kmem_cache_destroy(orphan_entry_slab);
 		return -ENOMEM;
 	}
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2ce5a9e..5607393 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -49,11 +49,11 @@ static void f2fs_read_end_io(struct bio *bio, int
err)
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
@@ -73,7 +73,7 @@ static void f2fs_write_end_io(struct bio *bio, int
err)
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
 
-		if (!uptodate) {
+		if (unlikely(!uptodate)) {
 			SetPageError(page);
 			set_bit(AS_EIO, &page->mapping->flags);
 			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
@@ -249,7 +249,7 @@ int reserve_new_block(struct dnode_of_data *dn)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
 
-	if (is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC))
+	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
 		return -EPERM;
 	if (unlikely(!inc_valid_block_count(sbi, dn->inode, 1)))
 		return -ENOSPC;
@@ -424,7 +424,7 @@ struct page *find_data_page(struct inode *inode,
pgoff_t index, bool sync)
 		return ERR_PTR(-ENOENT);
 
 	/* By fallocate(), there is no cached page, but with NEW_ADDR */
-	if (dn.data_blkaddr == NEW_ADDR)
+	if (unlikely(dn.data_blkaddr == NEW_ADDR))
 		return ERR_PTR(-EINVAL);
 
 	page = grab_cache_page_write_begin(mapping, index, AOP_FLAG_NOFS);
@@ -443,7 +443,7 @@ struct page *find_data_page(struct inode *inode,
pgoff_t index, bool sync)
 
 	if (sync) {
 		wait_on_page_locked(page);
-		if (!PageUptodate(page)) {
+		if (unlikely(!PageUptodate(page))) {
 			f2fs_put_page(page, 0);
 			return ERR_PTR(-EIO);
 		}
@@ -477,7 +477,7 @@ repeat:
 	}
 	f2fs_put_dnode(&dn);
 
-	if (dn.data_blkaddr == NULL_ADDR) {
+	if (unlikely(dn.data_blkaddr == NULL_ADDR)) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-ENOENT);
 	}
@@ -502,11 +502,11 @@ repeat:
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
@@ -534,7 +534,6 @@ struct page *get_new_data_page(struct inode *inode,
 	err = f2fs_reserve_block(&dn, index);
 	if (err)
 		return ERR_PTR(err);
-
 repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page)
@@ -552,11 +551,11 @@ repeat:
 		if (err)
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
@@ -841,11 +840,11 @@ repeat:
 		if (err)
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
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2b47adc..5accc96 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -50,9 +50,9 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct
*vma,
 
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
@@ -120,7 +120,7 @@ int f2fs_sync_file(struct file *file, loff_t start,
loff_t end, int datasync)
 		.for_reclaim = 0,
 	};
 
-	if (f2fs_readonly(inode->i_sb))
+	if (unlikely(f2fs_readonly(inode->i_sb)))
 		return 0;
 
 	trace_f2fs_sync_file_enter(inode);
@@ -241,7 +241,7 @@ static void truncate_partial_data_page(struct inode
*inode, u64 from)
 		return;
 
 	lock_page(page);
-	if (page->mapping != inode->i_mapping) {
+	if (unlikely(page->mapping != inode->i_mapping)) {
 		f2fs_put_page(page, 1);
 		return;
 	}
@@ -516,7 +516,6 @@ static int expand_inode_data(struct inode *inode,
loff_t offset,
 		if (ret)
 			break;
 
-
 		if (pg_start == pg_end)
 			new_size = offset + len;
 		else if (index == pg_start && off_start)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2886aef..29ceb9d 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -119,7 +119,6 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 		kfree(gc_th);
 		sbi->gc_thread = NULL;
 	}
-
 out:
 	return err;
 }
@@ -695,7 +694,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi)
 
 	INIT_LIST_HEAD(&ilist);
 gc_more:
-	if (!(sbi->sb->s_flags & MS_ACTIVE))
+	if (unlikely(!(sbi->sb->s_flags & MS_ACTIVE)))
 		goto stop;
 
 	if (gc_type == BG_GC && has_not_enough_free_secs(sbi, nfree)) {
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 2e41636..6c6ef77 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -750,7 +750,7 @@ skip_partial:
 		if (offset[1] == 0 &&
 				rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK]) {
 			lock_page(page);
-			if (page->mapping != node_mapping) {
+			if (unlikely(page->mapping != node_mapping)) {
 				f2fs_put_page(page, 1);
 				goto restart;
 			}
@@ -841,14 +841,14 @@ struct page *new_node_page(struct dnode_of_data
*dn,
 	struct page *page;
 	int err;
 
-	if (is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC))
+	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
 		return ERR_PTR(-EPERM);
 
 	page = grab_cache_page(mapping, dn->nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	if (!inc_valid_node_count(sbi, dn->inode)) {
+	if (unlikely(!inc_valid_node_count(sbi, dn->inode))) {
 		err = -ENOSPC;
 		goto fail;
 	}
@@ -898,7 +898,7 @@ static int read_node_page(struct page *page, int rw)
 
 	get_node_info(sbi, page->index, &ni);
 
-	if (ni.blk_addr == NULL_ADDR) {
+	if (unlikely(ni.blk_addr == NULL_ADDR)) {
 		f2fs_put_page(page, 1);
 		return -ENOENT;
 	}
@@ -953,11 +953,11 @@ repeat:
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
@@ -1010,12 +1010,12 @@ repeat:
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
@@ -1173,9 +1173,9 @@ int wait_on_node_pages_writeback(struct
f2fs_sb_info *sbi, nid_t ino)
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
@@ -1202,7 +1202,7 @@ static int f2fs_write_node_page(struct page *page,
 	get_node_info(sbi, nid, &ni);
 
 	/* This page is already truncated */
-	if (ni.blk_addr == NULL_ADDR) {
+	if (unlikely(ni.blk_addr == NULL_ADDR)) {
 		dec_page_count(sbi, F2FS_DIRTY_NODES);
 		unlock_page(page);
 		return 0;
@@ -1627,14 +1627,14 @@ int restore_node_summary(struct f2fs_sb_info
*sbi,
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
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index d075465..a3f4542 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -430,7 +430,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 
 	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
 			sizeof(struct fsync_inode_entry), NULL);
-	if (unlikely(!fsync_entry_slab))
+	if (!fsync_entry_slab)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&inode_list);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 22b07c3..68df44a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -626,7 +626,7 @@ static struct inode *f2fs_nfs_get_inode(struct
super_block *sb,
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	struct inode *inode;
 
-	if (ino < F2FS_ROOT_INO(sbi))
+	if (unlikely(ino < F2FS_ROOT_INO(sbi)))
 		return ERR_PTR(-ESTALE);
 
 	/*
@@ -637,7 +637,7 @@ static struct inode *f2fs_nfs_get_inode(struct
super_block *sb,
 	inode = f2fs_iget(sb, ino);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
-	if (generation && inode->i_generation != generation) {
+	if (unlikely(generation && inode->i_generation != generation)) {
 		/* we didn't find the right inode.. */
 		iput(inode);
 		return ERR_PTR(-ESTALE);
@@ -740,10 +740,10 @@ static int sanity_check_ckpt(struct f2fs_sb_info
*sbi)
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
@@ -808,7 +808,7 @@ retry:
 		brelse(*raw_super_buf);
 		f2fs_msg(sb, KERN_ERR, "Can't find a valid F2FS filesystem "
 				"in %dth superblock", block + 1);
-		if(block == 0) {
+		if (block == 0) {
 			block++;
 			goto retry;
 		} else {
@@ -834,7 +834,7 @@ static int f2fs_fill_super(struct super_block *sb,
void *data, int silent)
 		return -ENOMEM;
 
 	/* set a block size */
-	if (!sb_set_blocksize(sb, F2FS_BLKSIZE)) {
+	if (unlikely(!sb_set_blocksize(sb, F2FS_BLKSIZE))) {
 		f2fs_msg(sb, KERN_ERR, "unable to set blocksize");
 		goto free_sbi;
 	}
@@ -1066,7 +1066,7 @@ static int __init init_inodecache(void)
 {
 	f2fs_inode_cachep = f2fs_kmem_cache_create("f2fs_inode_cache",
 			sizeof(struct f2fs_inode_info), NULL);
-	if (f2fs_inode_cachep == NULL)
+	if (!f2fs_inode_cachep)
 		return -ENOMEM;
 	return 0;
 }
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index aa7a3f1..b0fb8a2 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -522,7 +522,7 @@ static int __f2fs_setxattr(struct inode *inode, int
name_index,
 		if (found)
 			free = free + ENTRY_SIZE(here);
 
-		if (free < newsize) {
+		if (unlikely(free < newsize)) {
 			error = -ENOSPC;
 			goto exit;
 		}
-- 
1.8.4.474.g128a96c



-- 
Jaegeuk Kim
Samsung

