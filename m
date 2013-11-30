Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3K3BtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 20:49:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40076 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3K3BtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 20:49:06 -0500
X-AuditID: cbfee691-b7f666d0000048b0-ab-5299441192ef
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: remove the own bi_private allocation
Date: Sat, 30 Nov 2013 10:48:05 +0900
Message-id: <1385776085-21163-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ11Bl5lBBmtusFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbG75yB7wSLlisVP
	/BoYb8p0MXJySAiYSDQv7WWBsMUkLtxbz9bFyMUhJLCMUWLdm342mKKnB8+xQiSmM0pcnbKX
	HcJpZpI49uUgUxcjBwebgLbE5v0GIA0iAswSC6aeZwSpYRaYwCjxf9F7sBXCAtYSJ0+9YwSx
	WQRUJS71djKD2LwC7hJbJs9khtimLbHt+USwZgmBx2wSF35uYYZoEJD4NvkQC8gyCQFZiU0H
	oOolJQ6uuMEygVFwASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQEJy4g/H+AetDjMlA
	4yYyS4km5wNDOK8k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGDed2yR09YN6V45FyUtlVd+yy5efB1+J7Gxbtu5O0avUgwmOu9Y1u21afVavLO7Q
	51uvtG5xf7nGp5l/n0/zq/NR/bCeVj/pvh9O11fP3JNpyRC2ROFGis3Fd1J9v6fO7PhuzvOl
	9ev/m5Nv+Oo8iWE9crv3a8F+LkZuz47bXp3Wb/7/3MdbP0OJpTgj0VCLuag4EQBedKb7VwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV1Bl5lBBrO7mC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zY3XOQvWCRcsXiJ34NjDdluhg5OSQETCSeHjzHCmGLSVy4t56ti5GLQ0hg
	OqPE1Sl72SGcZiaJY18OMnUxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAtY
	S5w89Y4RxGYRUJW41NvJDGLzCrhLbJk8kxlim7bEtucTGScwci9gZFjFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERzgz6R2MK5ssDjEKMDBqMTDa/F6RpAQa2JZcWXuIUYJDmYlEd5nD4BC
	vCmJlVWpRfnxRaU5qcWHGJOBtk9klhJNzgdGX15JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOF
	BNITS1KzU1MLUotgtjBxcEo1MGZ9nHNYqlhF4zHDq8fhmpd060LnSCwRC072b+DnMplT+Nby
	oUJJ2ZO9m5V2iOde1GBV69l+tuKF/+XLE3wfzTrxY3OJ+a4D+3I0uB9ujFJ46adn/EZCz6dv
	p8abJBWzI0HvXI94WuV6+mvvPi22pnDi4t73m6albdd7yedze7Zm9oqFtvP29imxFGckGmox
	FxUnAgCJHLh3tAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously f2fs allocates its own bi_private data structure all the time even
though we don't use it. But, can we remove this bi_private allocation?

This patch removes such the additional bi_private allocation.

1. Retrieve f2fs_sb_info from its page->mapping->host->i_sb.
 - This removes the usecases of bi_private in end_io.

2. Use bi_private only when we really need it.
 - The bi_private is used only when the checkpoint procedure is conducted.
 - When conducting the checkpoint, f2fs submits a META_FLUSH bio to wait its bio
completion.
 - Since we have no dependancies to remove bi_private now, let's just use
 bi_private pointer as the completion pointer.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c | 43 ++++++++++++++++---------------------------
 fs/f2fs/segment.h |  7 -------
 2 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 0387863..0db4027 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -791,7 +791,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct bio_private *p = bio->bi_private;
+	struct f2fs_sb_info *sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);
 
 	do {
 		struct page *page = bvec->bv_page;
@@ -802,21 +802,21 @@ static void f2fs_end_io_write(struct bio *bio, int err)
 			SetPageError(page);
 			if (page->mapping)
 				set_bit(AS_EIO, &page->mapping->flags);
-			set_ckpt_flags(p->sbi->ckpt, CP_ERROR_FLAG);
-			p->sbi->sb->s_flags |= MS_RDONLY;
+
+			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
+			sbi->sb->s_flags |= MS_RDONLY;
 		}
 		end_page_writeback(page);
-		dec_page_count(p->sbi, F2FS_WRITEBACK);
+		dec_page_count(sbi, F2FS_WRITEBACK);
 	} while (bvec >= bio->bi_io_vec);
 
-	if (p->is_sync)
-		complete(p->wait);
+	if (bio->bi_private)
+		complete(bio->bi_private);
 
-	if (!get_pages(p->sbi, F2FS_WRITEBACK) &&
-			!list_empty(&p->sbi->cp_wait.task_list))
-		wake_up(&p->sbi->cp_wait);
+	if (!get_pages(sbi, F2FS_WRITEBACK) &&
+			!list_empty(&sbi->cp_wait.task_list))
+		wake_up(&sbi->cp_wait);
 
-	kfree(p);
 	bio_put(bio);
 }
 
@@ -838,7 +838,6 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 	int rw = sync ? WRITE_SYNC : WRITE;
 	enum page_type btype = PAGE_TYPE_OF_BIO(type);
 	struct f2fs_bio_info *io = &sbi->write_io[btype];
-	struct bio_private *p;
 
 	if (!io->bio)
 		return;
@@ -851,18 +850,16 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 
 	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
 
-	p = io->bio->bi_private;
-	p->sbi = sbi;
-	io->bio->bi_end_io = f2fs_end_io_write;
-
+	/*
+	 * META_FLUSH is only from the checkpoint procedure, and we should wait
+	 * this metadata bio for FS consistency.
+	 */
 	if (type == META_FLUSH) {
 		DECLARE_COMPLETION_ONSTACK(wait);
-		p->is_sync = true;
-		p->wait = &wait;
+		io->bio->bi_private = &wait;
 		submit_bio(rw, io->bio);
 		wait_for_completion(&wait);
 	} else {
-		p->is_sync = false;
 		submit_bio(rw, io->bio);
 	}
 	io->bio = NULL;
@@ -897,18 +894,10 @@ static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
 		do_submit_bio(sbi, type, false);
 alloc_new:
 	if (io->bio == NULL) {
-		struct bio_private *priv;
-retry:
-		priv = kmalloc(sizeof(struct bio_private), GFP_NOFS);
-		if (!priv) {
-			cond_resched();
-			goto retry;
-		}
-
 		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 		io->bio = f2fs_bio_alloc(bdev, bio_blocks);
 		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
-		io->bio->bi_private = priv;
+		io->bio->bi_end_io = f2fs_end_io_write;
 		/*
 		 * The end_io will be assigned at the sumbission phase.
 		 * Until then, let bio_add_page() merge consecutive IOs as much
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7fea2ee..26812fc 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -92,13 +92,6 @@
 #define MAX_BIO_BLOCKS(max_hw_blocks)					\
 	(min((int)max_hw_blocks, BIO_MAX_PAGES))
 
-/* during checkpoint, bio_private is used to synchronize the last bio */
-struct bio_private {
-	struct f2fs_sb_info *sbi;
-	bool is_sync;
-	struct completion *wait;
-};
-
 /*
  * indicate a block allocation direction: RIGHT and LEFT.
  * RIGHT means allocating new sections towards the end of volume.
-- 
1.8.4.474.g128a96c

