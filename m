Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3KSHLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:11:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38770 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3KSHLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:11:32 -0500
X-AuditID: cbfee691-b7f866d000001b8c-de-528b0f224701
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: introduce a bio array for per-page write bios
Date: Tue, 19 Nov 2013 16:10:37 +0900
Message-id: <1384845037-7872-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1384845037-7872-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1384845037-7872-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zfV0l/u4gg0edghbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZfy5cYSl4JJOxZSL
	/A2M/SpdjJwcEgImElP/vGKBsMUkLtxbz9bFyMUhJLCMUaL13DM2mKLGyd9YIRLTGSVePd4D
	5TQzSayccpG9i5GDg01AW2LzfgOQBhEBZokFU88zgtQwC0xglPi/6D3YCmEBD4nLk/vBbBYB
	VYnOc92MIDavgJvE+ZfbWCG2aUtsez4RLM4p4C5x6NIjZhBbCKjm2vuNTCBDJQS+s0ks2vyR
	DWKQgMS3yYdYQI6QEJCV2HSAGWKOpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtcmpeu
	l5yfu4kRErITdzDeP2B9iDEZaNxEZinR5HxgyOeVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClI
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6OHlu2E9MaGicX718Q4hd/f17308sV3R0/OcxaN
	r9mvxFnKwmuiteXheZdfNltv7fsT89Oh++PPf0/fKtzT4Jz7c/X51GABG9t7xhkNWwXuzV2q
	GLW4K+K8de2jhc1GRn8SflnsW7v+b0L0hO9fF20t4W+JKf7J3daqduxiw4U4kx+GfRnXpC4r
	sRRnJBpqMRcVJwIAoQHTe28CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQV0l/u4gg9m3eCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8z4c+MIS8ElnYopF/kbGPtVuhg5OSQETCQaJ39jhbDFJC7cW8/WxcjFISQw
	nVHi1eM9rBBOM5PEyikX2bsYOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4AkhAU8
	JC5P7gezWQRUJTrPdTOC2LwCbhLnX26D2qYtse35RLA4p4C7xKFLj5hBbCGgmmvvNzJNYORd
	wMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Ip5J72Bc1WBxiFGAg1GJh3eCe1eQEGti
	WXFl7iFGCQ5mJRFeyStAId6UxMqq1KL8+KLSnNTiQ4zJQFdNZJYSTc4HRmteSbyhsYmZkaWR
	mYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTC6TfhyrGXS8qCmG11fd73JVD4j
	nPHYZ/WsSfOEZGbczuaYkXX3rvZMPTk7u7YNHtEHTc7sOPC63Xl+pHXi1kID+dg/dQYXtVPd
	jj9zXOVRL/C/eI1eTJ0612KPN192tFxir+vY3e+jp8X4M34730+zma63fh4xlrl77jPfPu+i
	J1/0Fs+MWVOmxFKckWioxVxUnAgAwGN32MwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The f2fs has three bio types, NODE, DATA, and META, and manages some data
structures per each bio types.

The codes are a little bit messy, thus, this patch introduces a bio array
which groups individual data structures as follows.

struct f2fs_bio_info {
	struct bio *bio;		/* bios to merge */
	sector_t last_block_in_bio;	/* last block number */
	struct mutex io_mutex;		/* mutex for bio */
};

struct f2fs_sb_info {
	...
	struct f2fs_bio_info write_io[NR_PAGE_TYPE];	/* for write bios */
	...
};

The code changes from this new data structure are trivial.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h    | 12 +++++++++---
 fs/f2fs/segment.c | 44 ++++++++++++++++++++++----------------------
 fs/f2fs/super.c   |  2 +-
 3 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e9038bb..05f8fe1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -361,6 +361,12 @@ enum page_type {
 	META_FLUSH,
 };
 
+struct f2fs_bio_info {
+	struct bio *bio;		/* bios to merge */
+	sector_t last_block_in_bio;	/* last block number */
+	struct mutex io_mutex;		/* mutex for bio */
+};
+
 struct f2fs_sb_info {
 	struct super_block *sb;			/* pointer to VFS super block */
 	struct proc_dir_entry *s_proc;		/* proc entry */
@@ -374,9 +380,9 @@ struct f2fs_sb_info {
 
 	/* for segment-related operations */
 	struct f2fs_sm_info *sm_info;		/* segment manager */
-	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
-	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
-	struct mutex write_mutex[NR_PAGE_TYPE];	/* mutex for writing IOs */
+
+	/* for bio operations */
+	struct f2fs_bio_info write_io[NR_PAGE_TYPE];	/* for write bios */
 
 	/* for checkpoint */
 	struct f2fs_checkpoint *ckpt;		/* raw checkpoint pointer */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 119af0b..9607cc4 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -838,65 +838,65 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 {
 	int rw = sync ? WRITE_SYNC : WRITE;
 	enum page_type btype = PAGE_TYPE_OF_BIO(type);
-	struct bio *bio = sbi->bio[btype];
+	struct f2fs_bio_info *io = &sbi->write_io[btype];
 	struct bio_private *p;
 
-	if (!bio)
+	if (!io->bio)
 		return;
 
-	sbi->bio[btype] = NULL;
-
 	if (type >= META_FLUSH)
 		rw = WRITE_FLUSH_FUA;
 	if (btype == META)
 		rw |= REQ_META;
 
-	p = bio->bi_private;
+	p = io->bio->bi_private;
 	p->sbi = sbi;
-	bio->bi_end_io = f2fs_end_io_write;
+	io->bio->bi_end_io = f2fs_end_io_write;
 
-	trace_f2fs_do_submit_bio(sbi->sb, btype, sync, bio);
+	trace_f2fs_do_submit_bio(sbi->sb, btype, sync, io->bio);
 
 	if (type == META_FLUSH) {
 		DECLARE_COMPLETION_ONSTACK(wait);
 		p->is_sync = true;
 		p->wait = &wait;
-		submit_bio(rw, bio);
+		submit_bio(rw, io->bio);
 		wait_for_completion(&wait);
 	} else {
 		p->is_sync = false;
-		submit_bio(rw, bio);
+		submit_bio(rw, io->bio);
 	}
+	io->bio = NULL;
 }
 
 void f2fs_submit_bio(struct f2fs_sb_info *sbi, enum page_type type, bool sync)
 {
-	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+	struct f2fs_bio_info *io = &sbi->write_io[PAGE_TYPE_OF_BIO(type)];
 
-	if (!sbi->bio[btype])
+	if (!io->bio)
 		return;
 
-	mutex_lock(&sbi->write_mutex[btype]);
+	mutex_lock(&io->io_mutex);
 	do_submit_bio(sbi, type, sync);
-	mutex_unlock(&sbi->write_mutex[btype]);
+	mutex_unlock(&io->io_mutex);
 }
 
 static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
 				block_t blk_addr, enum page_type type)
 {
 	struct block_device *bdev = sbi->sb->s_bdev;
+	struct f2fs_bio_info *io = &sbi->write_io[type];
 	int bio_blocks;
 
 	verify_block_addr(sbi, blk_addr);
 
-	mutex_lock(&sbi->write_mutex[type]);
+	mutex_lock(&io->io_mutex);
 
 	inc_page_count(sbi, F2FS_WRITEBACK);
 
-	if (sbi->bio[type] && sbi->last_block_in_bio[type] != blk_addr - 1)
+	if (io->bio && io->last_block_in_bio != blk_addr - 1)
 		do_submit_bio(sbi, type, false);
 alloc_new:
-	if (sbi->bio[type] == NULL) {
+	if (io->bio == NULL) {
 		struct bio_private *priv;
 retry:
 		priv = kmalloc(sizeof(struct bio_private), GFP_NOFS);
@@ -906,9 +906,9 @@ retry:
 		}
 
 		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
-		sbi->bio[type] = f2fs_bio_alloc(bdev, bio_blocks);
-		sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
-		sbi->bio[type]->bi_private = priv;
+		io->bio = f2fs_bio_alloc(bdev, bio_blocks);
+		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+		io->bio->bi_private = priv;
 		/*
 		 * The end_io will be assigned at the sumbission phase.
 		 * Until then, let bio_add_page() merge consecutive IOs as much
@@ -916,15 +916,15 @@ retry:
 		 */
 	}
 
-	if (bio_add_page(sbi->bio[type], page, PAGE_CACHE_SIZE, 0) <
+	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
 							PAGE_CACHE_SIZE) {
 		do_submit_bio(sbi, type, false);
 		goto alloc_new;
 	}
 
-	sbi->last_block_in_bio[type] = blk_addr;
+	io->last_block_in_bio = blk_addr;
 
-	mutex_unlock(&sbi->write_mutex[type]);
+	mutex_unlock(&io->io_mutex);
 	trace_f2fs_submit_write_page(page, blk_addr, type);
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index e194578..8c677e9 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -879,7 +879,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	spin_lock_init(&sbi->stat_lock);
 
 	for (i = 0; i < NR_PAGE_TYPE; i++)
-		mutex_init(&sbi->write_mutex[i]);
+		mutex_init(&sbi->write_io[i].io_mutex);
 
 	init_rwsem(&sbi->cp_rwsem);
 	init_waitqueue_head(&sbi->cp_wait);
-- 
1.8.4.474.g128a96c

