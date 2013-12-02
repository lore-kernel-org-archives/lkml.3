Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3LBI23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:28:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21656 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3LBI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:28:26 -0500
X-AuditID: cbfee68f-b7f336d00000481b-b8-529c44a8c7ea
Message-id: <1385972847.2417.113.camel@kjgkr>
Subject: Re: [PATCH v2] f2fs: refactor bio-related operations
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 02 Dec 2013 17:27:27 +0900
In-reply-to: <1385792739-31405-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1385792739-31405-1-git-send-email-jaegeuk.kim@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zQ90VLnOCDKa3qVlcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmKC6blNSczLLUIn27BK6Mw1fOshXsPcdY8WfqVMYGxn0rGLsY
	OTkkBEwkpry7wQxhi0lcuLeerYuRi0NIYBmjxMPvnXBF6/c0QyUWMUps3j8XynnFKLF+7Vp2
	kCpeAV2Jw/evAyU4OIQFbCUuPXQEMdkEtIHqDUAqhAQUJd7uv8sKEhYBsi+/dwIxmQU8JHYd
	KwWpYBFQldjatwTsHE6g8LSmo0wQne4SM2b9YAOx+QVEJQ4v3A5WwyygLjFp3iKo85Ukdrd3
	skPE5SU2r3nLDHGXoMSPyfdYQA6WENjELtE76xsLxDIBiW+TD7GA3CAhICux6QDUHEmJgytu
	sExglJiFZMUsJGNnIRm7gJF5FaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZIdPXvYLx7wPoQ
	YzLQyonMUqLJ+cDozCuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs1NSC1KL4otKc
	1OJDjEwcnFINjDqua8+8aFglpZH91YRryuuTT1f92uTXnXv/jEZOe2vbKm/+WSnHGrc4t7mL
	pD/4XbtkS1Xq5K4D7z+nVc2M8Jz+MGGq1sUzfiJxmw4tDJ1pVv/C7MnSSXzLv8yK9X9jv+Fq
	l8O65LWXl0+y8fi2PmulsFDntcZrMdUvf/xjZGbmP6vWKMBgYanEUpyRaKjFXFScCACqIOaT
	xAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xgO4KlzlBBpuvyVlcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3Ml
	hbzE3FRbJRefAF23zBygHUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrG
	jMNXzrIV7D3HWPFn6lTGBsZ9Kxi7GDk5JARMJNbvaWaDsMUkLtxbD2RzcQgJLGKU2Lx/LpTz
	ilFi/dq17CBVvAK6EofvXwdKcHAIC9hKXHroCGKyCWgD1RuAVAgJKEq83X+XFSQsAmRffu8E
	YjILeEjsOlYKUsEioCqxtW8JM4jNCRSe1nSUCaLTXWLGrB9g1/ALiEocXrgdrIZZQF1i0rxF
	zBBXKknsbu9kh4jLS2xe85YZ4i5BiR+T77FMYBSahaRlFpKyWUjKFjAyr2IUTS1ILihOSs81
	1CtOzC0uzUvXS87P3cQIjt1nUjsYVzZYHGIU4GBU4uG9KDwnSIg1say4MvcQowQHs5IIL8vf
	2UFCvCmJlVWpRfnxRaU5qcWHGJOBvpvILCWanA9MK3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5o
	tQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLh9sXz00tJnkxVWTHz2bu+25qo3mXzTGJ0XTS1536Q0
	76dhbe8m3S3ZDixhHKz/Vb4mz5ji9LbyWpbzmQl7jxRb6W5hbRK61fqw2Ppa5H5h4eKCkOmJ
	YXH+Ky+rVxnHa2omLjf+v+2nwMVtX5bwR5dInv5U88OJLdLHps/guhl/yN690h8ff1NiKc5I
	NNRiLipOBAAoPqu8IQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o remove redundant codes

>From a480dfc915490f4bca7275f6fbb44fa34aa00eaa Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Sat, 30 Nov 2013 12:51:14 +0900
Subject: [PATCH] f2fs: refactor bio-related operations
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net

This patch integrates redundant bio operations on read and write IOs.

1. Move bio-related codes to the top of data.c.
2. Replace f2fs_submit_bio with f2fs_submit_merged_bio, which handles read
   bios additionally.
3. Introduce __submit_merged_bio to submit the merged bio.
4. Change f2fs_readpage to f2fs_submit_page_bio.
5. Introduce f2fs_submit_page_mbio to integrate previous submit_read_page and
   submit_write_page.

Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c        |  14 +-
 fs/f2fs/data.c              | 316 +++++++++++++++++++++++++++++---------------
 fs/f2fs/f2fs.h              |  12 +-
 fs/f2fs/gc.c                |   2 +-
 fs/f2fs/node.c              |  14 +-
 fs/f2fs/recovery.c          |   4 +-
 fs/f2fs/segment.c           | 164 +++--------------------
 include/trace/events/f2fs.h |  30 ++---
 8 files changed, 257 insertions(+), 299 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 40eea42..38f4a224 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -61,7 +61,8 @@ repeat:
 	if (PageUptodate(page))
 		goto out;
 
-	if (f2fs_readpage(sbi, page, index, READ_SYNC | REQ_META | REQ_PRIO))
+	if (f2fs_submit_page_bio(sbi, page, index,
+				READ_SYNC | REQ_META | REQ_PRIO))
 		goto repeat;
 
 	lock_page(page);
@@ -157,7 +158,8 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 	}
 
 	if (nwritten)
-		f2fs_submit_bio(sbi, type, nr_to_write == LONG_MAX);
+		f2fs_submit_merged_bio(sbi, type, nr_to_write == LONG_MAX,
+								WRITE);
 
 	return nwritten;
 }
@@ -590,7 +592,7 @@ retry:
 		 * We should submit bio, since it exists several
 		 * wribacking dentry pages in the freeing inode.
 		 */
-		f2fs_submit_bio(sbi, DATA, true);
+		f2fs_submit_merged_bio(sbi, DATA, true, WRITE);
 	}
 	goto retry;
 }
@@ -796,9 +798,9 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 
 	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "finish block_ops");
 
-	f2fs_submit_bio(sbi, DATA, true);
-	f2fs_submit_bio(sbi, NODE, true);
-	f2fs_submit_bio(sbi, META, true);
+	f2fs_submit_merged_bio(sbi, DATA, true, WRITE);
+	f2fs_submit_merged_bio(sbi, NODE, true, WRITE);
+	f2fs_submit_merged_bio(sbi, META, true, WRITE);
 
 	/*
 	 * update checkpoint pack index
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c9a76f8..4e2fc09 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -25,6 +25,204 @@
 #include <trace/events/f2fs.h>
 
 /*
+ * Low-level block read/write IO operations.
+ */
+static struct bio *__bio_alloc(struct block_device *bdev, int npages)
+{
+	struct bio *bio;
+
+	/* No failure on bio allocation */
+	bio = bio_alloc(GFP_NOIO, npages);
+	bio->bi_bdev = bdev;
+	bio->bi_private = NULL;
+	return bio;
+}
+
+static void f2fs_read_end_io(struct bio *bio, int err)
+{
+	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+
+	do {
+		struct page *page = bvec->bv_page;
+
+		if (--bvec >= bio->bi_io_vec)
+			prefetchw(&bvec->bv_page->flags);
+
+		if (uptodate) {
+			SetPageUptodate(page);
+		} else {
+			ClearPageUptodate(page);
+			SetPageError(page);
+		}
+		unlock_page(page);
+	} while (bvec >= bio->bi_io_vec);
+
+	bio_put(bio);
+}
+
+static void f2fs_write_end_io(struct bio *bio, int err)
+{
+	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct f2fs_sb_info *sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);
+
+	do {
+		struct page *page = bvec->bv_page;
+
+		if (--bvec >= bio->bi_io_vec)
+			prefetchw(&bvec->bv_page->flags);
+
+		if (!uptodate) {
+			SetPageError(page);
+			set_bit(AS_EIO, &page->mapping->flags);
+			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
+			sbi->sb->s_flags |= MS_RDONLY;
+		}
+		end_page_writeback(page);
+		dec_page_count(sbi, F2FS_WRITEBACK);
+	} while (bvec >= bio->bi_io_vec);
+
+	if (bio->bi_private)
+		complete(bio->bi_private);
+
+	if (!get_pages(sbi, F2FS_WRITEBACK) &&
+			!list_empty(&sbi->cp_wait.task_list))
+		wake_up(&sbi->cp_wait);
+
+	bio_put(bio);
+}
+
+static void __submit_merged_bio(struct f2fs_sb_info *sbi,
+				struct f2fs_bio_info *io,
+				enum page_type type, bool sync, int rw)
+{
+	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+
+	if (!io->bio)
+		return;
+
+	if (btype == META)
+		rw |= REQ_META;
+
+	if (is_read_io(rw)) {
+		if (sync)
+			rw |= READ_SYNC;
+		submit_bio(rw, io->bio);
+		trace_f2fs_submit_read_bio(sbi->sb, rw, type, io->bio);
+		io->bio = NULL;
+		return;
+	}
+
+	if (sync)
+		rw |= WRITE_SYNC;
+	if (type >= META_FLUSH)
+		rw |= WRITE_FLUSH_FUA;
+
+	/*
+	 * META_FLUSH is only from the checkpoint procedure, and we should wait
+	 * this metadata bio for FS consistency.
+	 */
+	if (type == META_FLUSH) {
+		DECLARE_COMPLETION_ONSTACK(wait);
+		io->bio->bi_private = &wait;
+		submit_bio(rw, io->bio);
+		wait_for_completion(&wait);
+	} else {
+		submit_bio(rw, io->bio);
+	}
+	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
+	io->bio = NULL;
+}
+
+void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
+				enum page_type type, bool sync, int rw)
+{
+	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+	struct f2fs_bio_info *io;
+
+	io = is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
+
+	mutex_lock(&io->io_mutex);
+	__submit_merged_bio(sbi, io, type, sync, rw);
+	mutex_unlock(&io->io_mutex);
+}
+
+/*
+ * Fill the locked page with data located in the block address.
+ * Return unlocked page.
+ */
+int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
+					block_t blk_addr, int rw)
+{
+	struct block_device *bdev = sbi->sb->s_bdev;
+	struct bio *bio;
+
+	trace_f2fs_submit_page_bio(page, blk_addr, rw);
+
+	/* Allocate a new bio */
+	bio = __bio_alloc(bdev, 1);
+
+	/* Initialize the bio */
+	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+	bio->bi_end_io = is_read_io(rw) ? f2fs_read_end_io : f2fs_write_end_io;
+
+	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
+		bio_put(bio);
+		f2fs_put_page(page, 1);
+		return -EFAULT;
+	}
+
+	submit_bio(rw, bio);
+	return 0;
+}
+
+void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
+			block_t blk_addr, enum page_type type, int rw)
+{
+	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+	struct block_device *bdev = sbi->sb->s_bdev;
+	struct f2fs_bio_info *io;
+	int bio_blocks;
+
+	io = is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
+
+	verify_block_addr(sbi, blk_addr);
+
+	mutex_lock(&io->io_mutex);
+
+	if (!is_read_io(rw))
+		inc_page_count(sbi, F2FS_WRITEBACK);
+
+	if (io->bio && io->last_block_in_bio != blk_addr - 1)
+		__submit_merged_bio(sbi, io, type, true, rw);
+alloc_new:
+	if (io->bio == NULL) {
+		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+		io->bio = __bio_alloc(bdev, bio_blocks);
+		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+		io->bio->bi_end_io = is_read_io(rw) ? f2fs_read_end_io :
+							f2fs_write_end_io;
+		/*
+		 * The end_io will be assigned at the sumbission phase.
+		 * Until then, let bio_add_page() merge consecutive IOs as much
+		 * as possible.
+		 */
+	}
+
+	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
+							PAGE_CACHE_SIZE) {
+		__submit_merged_bio(sbi, io, type, true, rw);
+		goto alloc_new;
+	}
+
+	io->last_block_in_bio = blk_addr;
+
+	mutex_unlock(&io->io_mutex);
+	trace_f2fs_submit_page_mbio(page, rw, type, blk_addr);
+}
+
+/*
  * Lock ordering for the change of data block address:
  * ->data_page
  *  ->node_page
@@ -238,7 +436,7 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 		return page;
 	}
 
-	err = f2fs_readpage(sbi, page, dn.data_blkaddr,
+	err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
 					sync ? READ_SYNC : READA);
 	if (err)
 		return ERR_PTR(err);
@@ -299,7 +497,7 @@ repeat:
 		return page;
 	}
 
-	err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
+	err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr, READ_SYNC);
 	if (err)
 		return ERR_PTR(err);
 
@@ -349,7 +547,8 @@ repeat:
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 	} else {
-		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
+		err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
+								READ_SYNC);
 		if (err)
 			return ERR_PTR(err);
 		lock_page(page);
@@ -373,110 +572,6 @@ repeat:
 	return page;
 }
 
-static void read_end_io(struct bio *bio, int err)
-{
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-
-	do {
-		struct page *page = bvec->bv_page;
-
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-
-		if (uptodate) {
-			SetPageUptodate(page);
-		} else {
-			ClearPageUptodate(page);
-			SetPageError(page);
-		}
-		unlock_page(page);
-	} while (bvec >= bio->bi_io_vec);
-	bio_put(bio);
-}
-
-/*
- * Fill the locked page with data located in the block address.
- * Return unlocked page.
- */
-int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
-					block_t blk_addr, int type)
-{
-	struct block_device *bdev = sbi->sb->s_bdev;
-	struct bio *bio;
-
-	trace_f2fs_readpage(page, blk_addr, type);
-
-	/* Allocate a new bio */
-	bio = f2fs_bio_alloc(bdev, 1);
-
-	/* Initialize the bio */
-	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
-	bio->bi_end_io = read_end_io;
-
-	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
-		bio_put(bio);
-		f2fs_put_page(page, 1);
-		return -EFAULT;
-	}
-
-	submit_bio(type, bio);
-	return 0;
-}
-
-void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
-{
-	struct f2fs_bio_info *io = &sbi->read_io;
-
-	if (!io->bio)
-		return;
-
-	trace_f2fs_submit_read_bio(sbi->sb, rw, META, io->bio);
-
-	mutex_lock(&io->io_mutex);
-	if (io->bio) {
-		submit_bio(rw, io->bio);
-		io->bio = NULL;
-	}
-	mutex_unlock(&io->io_mutex);
-}
-
-void submit_read_page(struct f2fs_sb_info *sbi, struct page *page,
-					block_t blk_addr, int rw)
-{
-	struct block_device *bdev = sbi->sb->s_bdev;
-	struct f2fs_bio_info *io = &sbi->read_io;
-	int bio_blocks;
-
-	verify_block_addr(sbi, blk_addr);
-
-	mutex_lock(&io->io_mutex);
-
-	if (io->bio && io->last_block_in_bio != blk_addr - 1) {
-		submit_bio(rw, io->bio);
-		io->bio = NULL;
-	}
-alloc_new:
-	if (io->bio == NULL) {
-		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
-		io->bio = f2fs_bio_alloc(bdev, bio_blocks);
-		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
-		io->bio->bi_end_io = read_end_io;
-	}
-
-	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
-							PAGE_CACHE_SIZE) {
-		submit_bio(rw, io->bio);
-		io->bio = NULL;
-		goto alloc_new;
-	}
-
-	io->last_block_in_bio = blk_addr;
-
-	mutex_unlock(&io->io_mutex);
-	trace_f2fs_submit_read_page(page, rw, META, blk_addr);
-}
-
 /*
  * This function should be used by the data read flow only where it
  * does not check the "create" flag that indicates block allocation.
@@ -638,7 +733,7 @@ write:
 		goto redirty_out;
 
 	if (wbc->for_reclaim)
-		f2fs_submit_bio(sbi, DATA, true);
+		f2fs_submit_merged_bio(sbi, DATA, true, WRITE);
 
 	clear_cold_data(page);
 out:
@@ -690,7 +785,7 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 	ret = write_cache_pages(mapping, wbc, __f2fs_writepage, mapping);
 	if (locked)
 		mutex_unlock(&sbi->writepages);
-	f2fs_submit_bio(sbi, DATA, (wbc->sync_mode == WB_SYNC_ALL));
+	f2fs_submit_merged_bio(sbi, DATA, wbc->sync_mode == WB_SYNC_ALL, WRITE);
 
 	remove_dirty_dir_inode(inode);
 
@@ -741,7 +836,8 @@ repeat:
 	if (dn.data_blkaddr == NEW_ADDR) {
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 	} else {
-		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
+		err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
+							READ_SYNC);
 		if (err)
 			return err;
 		lock_page(page);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ca33cda..10eca02 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -364,6 +364,7 @@ enum page_type {
 	META_FLUSH,
 };
 
+#define is_read_io(rw)	(((rw) & 1) == READ)
 struct f2fs_bio_info {
 	struct bio *bio;		/* bios to merge */
 	sector_t last_block_in_bio;	/* last block number */
@@ -1093,9 +1094,6 @@ void clear_prefree_segments(struct f2fs_sb_info *);
 int npages_for_summary_flush(struct f2fs_sb_info *);
 void allocate_new_segments(struct f2fs_sb_info *);
 struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
-struct bio *f2fs_bio_alloc(struct block_device *, int);
-void f2fs_submit_bio(struct f2fs_sb_info *, enum page_type, bool);
-void f2fs_wait_on_page_writeback(struct page *, enum page_type, bool);
 void write_meta_page(struct f2fs_sb_info *, struct page *);
 void write_node_page(struct f2fs_sb_info *, struct page *, unsigned int,
 					block_t, block_t *);
@@ -1106,6 +1104,7 @@ void recover_data_page(struct f2fs_sb_info *, struct page *,
 				struct f2fs_summary *, block_t, block_t);
 void rewrite_node_page(struct f2fs_sb_info *, struct page *,
 				struct f2fs_summary *, block_t, block_t);
+void f2fs_wait_on_page_writeback(struct page *, enum page_type, bool);
 void write_data_summaries(struct f2fs_sb_info *, block_t);
 void write_node_summaries(struct f2fs_sb_info *, block_t);
 int lookup_journal_in_cursum(struct f2fs_summary_block *,
@@ -1141,15 +1140,16 @@ void destroy_checkpoint_caches(void);
 /*
  * data.c
  */
+void f2fs_submit_merged_bio(struct f2fs_sb_info *, enum page_type, bool, int);
+int f2fs_submit_page_bio(struct f2fs_sb_info *, struct page *, block_t, int);
+void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *, block_t,
+							enum page_type, int);
 int reserve_new_block(struct dnode_of_data *);
 int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
 void update_extent_cache(block_t, struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
-int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
-void f2fs_submit_read_bio(struct f2fs_sb_info *, int);
-void submit_read_page(struct f2fs_sb_info *, struct page *, block_t, int);
 int do_write_data_page(struct page *);
 
 /*
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 5fa54c1..2886aef 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -631,7 +631,7 @@ next_iput:
 		goto next_step;
 
 	if (gc_type == FG_GC) {
-		f2fs_submit_bio(sbi, DATA, true);
+		f2fs_submit_merged_bio(sbi, DATA, true, WRITE);
 
 		/*
 		 * In the case of FG_GC, it'd be better to reclaim this victim
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index d0ab003..0e1a3df 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -106,11 +106,11 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 			f2fs_put_page(page, 1);
 			continue;
 		}
-		submit_read_page(sbi, page, index, READ_SYNC | REQ_META);
+		f2fs_submit_page_mbio(sbi, page, index, META, READ);
 		mark_page_accessed(page);
 		f2fs_put_page(page, 0);
 	}
-	f2fs_submit_read_bio(sbi, READ_SYNC | REQ_META);
+	f2fs_submit_merged_bio(sbi, META, true, READ);
 }
 
 static struct nat_entry *__lookup_nat_cache(struct f2fs_nm_info *nm_i, nid_t n)
@@ -891,7 +891,7 @@ fail:
  * LOCKED_PAGE: f2fs_put_page(page, 1)
  * error: nothing
  */
-static int read_node_page(struct page *page, int type)
+static int read_node_page(struct page *page, int rw)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
 	struct node_info ni;
@@ -906,7 +906,7 @@ static int read_node_page(struct page *page, int type)
 	if (PageUptodate(page))
 		return LOCKED_PAGE;
 
-	return f2fs_readpage(sbi, page, ni.blk_addr, type);
+	return f2fs_submit_page_bio(sbi, page, ni.blk_addr, rw);
 }
 
 /*
@@ -1136,8 +1136,8 @@ continue_unlock:
 	}
 
 	if (wrote)
-		f2fs_submit_bio(sbi, NODE, wbc->sync_mode == WB_SYNC_ALL);
-
+		f2fs_submit_merged_bio(sbi, NODE, wbc->sync_mode == WB_SYNC_ALL,
+									WRITE);
 	return nwritten;
 }
 
@@ -1592,7 +1592,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 		 */
 		ClearPageUptodate(page);
 
-		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
+		if (f2fs_submit_page_bio(sbi, page, addr, READ_SYNC))
 			goto out;
 
 		lock_page(page);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index fdc8116..c209b86 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -143,7 +143,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		err = f2fs_readpage(sbi, page, blkaddr, READ_SYNC);
+		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
 		if (err)
 			goto out;
 
@@ -386,7 +386,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		err = f2fs_readpage(sbi, page, blkaddr, READ_SYNC);
+		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
 		if (err)
 			goto out;
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 0db4027..ca9adf5 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -787,146 +787,6 @@ static const struct segment_allocation default_salloc_ops = {
 	.allocate_segment = allocate_segment_by_default,
 };
 
-static void f2fs_end_io_write(struct bio *bio, int err)
-{
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct f2fs_sb_info *sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);
-
-	do {
-		struct page *page = bvec->bv_page;
-
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-		if (!uptodate) {
-			SetPageError(page);
-			if (page->mapping)
-				set_bit(AS_EIO, &page->mapping->flags);
-
-			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
-			sbi->sb->s_flags |= MS_RDONLY;
-		}
-		end_page_writeback(page);
-		dec_page_count(sbi, F2FS_WRITEBACK);
-	} while (bvec >= bio->bi_io_vec);
-
-	if (bio->bi_private)
-		complete(bio->bi_private);
-
-	if (!get_pages(sbi, F2FS_WRITEBACK) &&
-			!list_empty(&sbi->cp_wait.task_list))
-		wake_up(&sbi->cp_wait);
-
-	bio_put(bio);
-}
-
-struct bio *f2fs_bio_alloc(struct block_device *bdev, int npages)
-{
-	struct bio *bio;
-
-	/* No failure on bio allocation */
-	bio = bio_alloc(GFP_NOIO, npages);
-	bio->bi_bdev = bdev;
-	bio->bi_private = NULL;
-
-	return bio;
-}
-
-static void do_submit_bio(struct f2fs_sb_info *sbi,
-				enum page_type type, bool sync)
-{
-	int rw = sync ? WRITE_SYNC : WRITE;
-	enum page_type btype = PAGE_TYPE_OF_BIO(type);
-	struct f2fs_bio_info *io = &sbi->write_io[btype];
-
-	if (!io->bio)
-		return;
-
-	if (type >= META_FLUSH)
-		rw = WRITE_FLUSH_FUA;
-
-	if (btype == META)
-		rw |= REQ_META;
-
-	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
-
-	/*
-	 * META_FLUSH is only from the checkpoint procedure, and we should wait
-	 * this metadata bio for FS consistency.
-	 */
-	if (type == META_FLUSH) {
-		DECLARE_COMPLETION_ONSTACK(wait);
-		io->bio->bi_private = &wait;
-		submit_bio(rw, io->bio);
-		wait_for_completion(&wait);
-	} else {
-		submit_bio(rw, io->bio);
-	}
-	io->bio = NULL;
-}
-
-void f2fs_submit_bio(struct f2fs_sb_info *sbi, enum page_type type, bool sync)
-{
-	struct f2fs_bio_info *io = &sbi->write_io[PAGE_TYPE_OF_BIO(type)];
-
-	if (!io->bio)
-		return;
-
-	mutex_lock(&io->io_mutex);
-	do_submit_bio(sbi, type, sync);
-	mutex_unlock(&io->io_mutex);
-}
-
-static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
-				block_t blk_addr, enum page_type type)
-{
-	struct block_device *bdev = sbi->sb->s_bdev;
-	struct f2fs_bio_info *io = &sbi->write_io[type];
-	int bio_blocks;
-
-	verify_block_addr(sbi, blk_addr);
-
-	mutex_lock(&io->io_mutex);
-
-	inc_page_count(sbi, F2FS_WRITEBACK);
-
-	if (io->bio && io->last_block_in_bio != blk_addr - 1)
-		do_submit_bio(sbi, type, false);
-alloc_new:
-	if (io->bio == NULL) {
-		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
-		io->bio = f2fs_bio_alloc(bdev, bio_blocks);
-		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
-		io->bio->bi_end_io = f2fs_end_io_write;
-		/*
-		 * The end_io will be assigned at the sumbission phase.
-		 * Until then, let bio_add_page() merge consecutive IOs as much
-		 * as possible.
-		 */
-	}
-
-	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
-							PAGE_CACHE_SIZE) {
-		do_submit_bio(sbi, type, false);
-		goto alloc_new;
-	}
-
-	io->last_block_in_bio = blk_addr;
-
-	mutex_unlock(&io->io_mutex);
-	trace_f2fs_submit_write_page(page, WRITE, type, blk_addr);
-}
-
-void f2fs_wait_on_page_writeback(struct page *page,
-				enum page_type type, bool sync)
-{
-	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
-	if (PageWriteback(page)) {
-		f2fs_submit_bio(sbi, type, sync);
-		wait_on_page_writeback(page);
-	}
-}
-
 static bool __has_curseg_space(struct f2fs_sb_info *sbi, int type)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
@@ -1040,7 +900,7 @@ static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
 		fill_node_footer_blkaddr(page, NEXT_FREE_BLKADDR(sbi, curseg));
 
 	/* writeout dirty page into bdev */
-	submit_write_page(sbi, page, *new_blkaddr, p_type);
+	f2fs_submit_page_mbio(sbi, page, *new_blkaddr, p_type, WRITE);
 
 	mutex_unlock(&curseg->curseg_mutex);
 }
@@ -1048,7 +908,7 @@ static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
 void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
 {
 	set_page_writeback(page);
-	submit_write_page(sbi, page, page->index, META);
+	f2fs_submit_page_mbio(sbi, page, page->index, META, WRITE);
 }
 
 void write_node_page(struct f2fs_sb_info *sbi, struct page *page,
@@ -1078,7 +938,7 @@ void write_data_page(struct inode *inode, struct page *page,
 void rewrite_data_page(struct f2fs_sb_info *sbi, struct page *page,
 					block_t old_blk_addr)
 {
-	submit_write_page(sbi, page, old_blk_addr, DATA);
+	f2fs_submit_page_mbio(sbi, page, old_blk_addr, DATA, WRITE);
 }
 
 void recover_data_page(struct f2fs_sb_info *sbi,
@@ -1165,8 +1025,8 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 
 	/* rewrite node page */
 	set_page_writeback(page);
-	submit_write_page(sbi, page, new_blkaddr, NODE);
-	f2fs_submit_bio(sbi, NODE, true);
+	f2fs_submit_page_mbio(sbi, page, new_blkaddr, NODE, WRITE);
+	f2fs_submit_merged_bio(sbi, NODE, true, WRITE);
 	refresh_sit_entry(sbi, old_blkaddr, new_blkaddr);
 
 	locate_dirty_segment(sbi, old_cursegno);
@@ -1176,6 +1036,16 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 	mutex_unlock(&curseg->curseg_mutex);
 }
 
+void f2fs_wait_on_page_writeback(struct page *page,
+				enum page_type type, bool sync)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
+	if (PageWriteback(page)) {
+		f2fs_submit_merged_bio(sbi, type, sync, WRITE);
+		wait_on_page_writeback(page);
+	}
+}
+
 static int read_compacted_summaries(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
@@ -1723,13 +1593,13 @@ repeat:
 			continue;
 		}
 
-		submit_read_page(sbi, page, blk_addr, READ_SYNC | REQ_META);
+		f2fs_submit_page_mbio(sbi, page, blk_addr, META, READ);
 
 		mark_page_accessed(page);
 		f2fs_put_page(page, 0);
 	}
 
-	f2fs_submit_read_bio(sbi, READ_SYNC | REQ_META);
+	f2fs_submit_merged_bio(sbi, META, true, READ);
 	return blkno - start;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 204fcc3..3b9f28d 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -434,7 +434,7 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
 		__entry->err)
 );
 
-TRACE_EVENT_CONDITION(f2fs_readpage,
+TRACE_EVENT_CONDITION(f2fs_submit_page_bio,
 
 	TP_PROTO(struct page *page, sector_t blkaddr, int type),
 
@@ -641,18 +641,22 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 		__entry->size)
 );
 
-DEFINE_EVENT(f2fs__submit_bio, f2fs_submit_write_bio,
+DEFINE_EVENT_CONDITION(f2fs__submit_bio, f2fs_submit_write_bio,
 
 	TP_PROTO(struct super_block *sb, int rw, int type, struct bio *bio),
 
-	TP_ARGS(sb, rw, type, bio)
+	TP_ARGS(sb, rw, type, bio),
+
+	TP_CONDITION(bio)
 );
 
-DEFINE_EVENT(f2fs__submit_bio, f2fs_submit_read_bio,
+DEFINE_EVENT_CONDITION(f2fs__submit_bio, f2fs_submit_read_bio,
 
 	TP_PROTO(struct super_block *sb, int rw, int type, struct bio *bio),
 
-	TP_ARGS(sb, rw, type, bio)
+	TP_ARGS(sb, rw, type, bio),
+
+	TP_CONDITION(bio)
 );
 
 DECLARE_EVENT_CLASS(f2fs__page,
@@ -701,7 +705,7 @@ DEFINE_EVENT(f2fs__page, f2fs_vm_page_mkwrite,
 	TP_ARGS(page, type)
 );
 
-DECLARE_EVENT_CLASS(f2fs_io_page,
+TRACE_EVENT(f2fs_submit_page_mbio,
 
 	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
 
@@ -733,20 +737,6 @@ DECLARE_EVENT_CLASS(f2fs_io_page,
 		(unsigned long long)__entry->block)
 );
 
-DEFINE_EVENT(f2fs_io_page, f2fs_submit_write_page,
-
-	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
-
-	TP_ARGS(page, rw, type, blk_addr)
-);
-
-DEFINE_EVENT(f2fs_io_page, f2fs_submit_read_page,
-
-	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
-
-	TP_ARGS(page, rw, type, blk_addr)
-);
-
 TRACE_EVENT(f2fs_write_checkpoint,
 
 	TP_PROTO(struct super_block *sb, bool is_umount, char *msg),
-- 
1.8.4.474.g128a96c



-- 
Jaegeuk Kim
Samsung

