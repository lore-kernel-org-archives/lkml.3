Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3KRJNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:13:10 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36873 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3KRJM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:12:58 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-cd-5289da176c8e
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: use sbi->wr_mutex for write bios
Date: Mon, 18 Nov 2013 18:12:02 +0900
Message-id: <1384765922-24028-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zQ13xW51BBisnKlhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfFuB3vBRcmKe9P/
	sTcwThftYuTkkBAwkXj59isbhC0mceHeeiCbi0NIYBmjxJSZn1lgir6su84OkVjEKNFx8A1Y
	QkigmUniWFt2FyMHB5uAtsTm/QYgYREBZokFU88zgtQzC0xglPi/6D0LSI2wgLVEd18eSA2L
	gKrE8S3bWEFsXgF3iTszz0EdoS2x7flERhCbU8BD4kvvGqhV7hJ/735iBZkpIfCdTeLhrVvM
	EIMEJL5NPgQ2X0JAVmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5y
	fu4mRki4TtjBeO+A9SHGZKBxE5mlRJPzgeGeVxJvaGxmZGFqYmpsZG5pRpqwkjiv2qOkICGB
	9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mva7mVfx7vj25aXLBaWbzPYXS/Pg9H+fcS7a8X+45
	ccmOxt4X5twyV9N0SwV3LhH56PPe6/dEOU2pPzz/NxZzHnrckVkyQ//ziwfflgim7p3Boiik
	N3PxrtIXiVqZPJuvr9RKqrtdNusyw/UzfhtPsb1/IyjzwqXL9uLmBUYdteV9ylUnfiWmKLEU
	ZyQaajEXFScCAAuVVNJtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV3xW51BBrObZSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x4t4O94KJkxb3p/9gbGKeLdjFyckgImEh8WXedHcIWk7hwbz1bFyMXh5DA
	IkaJjoNvWEASQgLNTBLH2rK7GDk42AS0JTbvNwAJiwgwSyyYep4RpJ5ZYAKjxP9F71lAaoQF
	rCW6+/JAalgEVCWOb9nGCmLzCrhL3Jl5jg1il7bEtucTGUFsTgEPiS+9a6BWuUv8vfuJdQIj
	7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwdHwTGoH48oGi0OMAhyMSjy8GmGdQUKs
	iWXFlbmHGCU4mJVEeFfcAArxpiRWVqUW5ccXleakFh9iTAa6aiKzlGhyPjBS80riDY1NzIws
	jcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBkb/v/oZM/a8mPNt3/G2WXS85
	L/fkZoffK+9FZ32+WPDj59slDx7ovOJ+nvcy0V/vQ5eSdOJ+q3e/wqfuk7Ss/dfHxmzmtmQq
	w2s/Xv20F4e/sRfPO5v4qnDdiqZlJ+7ZNLa9quXQft3PotZ5L+rK78l5eduqJUWt/UTv7LX6
	9jOea1uZZVrMMyWW4oxEQy3mouJEALSxHOvKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an unnecessary semaphore (i.e., sbi->bio_sem).
There is no reason to use the semaphore when f2fs submits read and write IOs.
Instead, let's use a write mutex and cover the sbi->bio[] by the lock.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c    |  4 ----
 fs/f2fs/f2fs.h    |  2 +-
 fs/f2fs/segment.c | 13 +++++++++----
 fs/f2fs/super.c   |  2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 84867dc..7550026 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -390,8 +390,6 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 
 	trace_f2fs_readpage(page, blk_addr, type);
 
-	down_read(&sbi->bio_sem);
-
 	/* Allocate a new bio */
 	bio = f2fs_bio_alloc(bdev, 1);
 
@@ -401,13 +399,11 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 
 	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
 		bio_put(bio);
-		up_read(&sbi->bio_sem);
 		f2fs_put_page(page, 1);
 		return -EFAULT;
 	}
 
 	submit_bio(type, bio);
-	up_read(&sbi->bio_sem);
 	return 0;
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1c783fd..76f5586 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -375,7 +375,7 @@ struct f2fs_sb_info {
 	struct f2fs_sm_info *sm_info;		/* segment manager */
 	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
 	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
-	struct rw_semaphore bio_sem;		/* IO semaphore */
+	struct mutex write_mutex;		/* mutex for writing IOs */
 
 	/* for checkpoint */
 	struct f2fs_checkpoint *ckpt;		/* raw checkpoint pointer */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index dad5f1a..893d489 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -871,9 +871,14 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 
 void f2fs_submit_bio(struct f2fs_sb_info *sbi, enum page_type type, bool sync)
 {
-	down_write(&sbi->bio_sem);
+	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+
+	if (!sbi->bio[btype])
+		return;
+
+	mutex_lock(&sbi->write_mutex);
 	do_submit_bio(sbi, type, sync);
-	up_write(&sbi->bio_sem);
+	mutex_unlock(&sbi->write_mutex);
 }
 
 static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
@@ -884,7 +889,7 @@ static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
 
 	verify_block_addr(sbi, blk_addr);
 
-	down_write(&sbi->bio_sem);
+	mutex_lock(&sbi->write_mutex);
 
 	inc_page_count(sbi, F2FS_WRITEBACK);
 
@@ -919,7 +924,7 @@ retry:
 
 	sbi->last_block_in_bio[type] = blk_addr;
 
-	up_write(&sbi->bio_sem);
+	mutex_unlock(&sbi->write_mutex);
 	trace_f2fs_submit_write_page(page, blk_addr, type);
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2c52527..c7b6300 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -882,7 +882,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	mutex_init(&sbi->node_write);
 	sbi->por_doing = false;
 	spin_lock_init(&sbi->stat_lock);
-	init_rwsem(&sbi->bio_sem);
+	mutex_init(&sbi->write_mutex);
 	init_rwsem(&sbi->cp_rwsem);
 	init_waitqueue_head(&sbi->cp_wait);
 	init_sb_info(sbi);
-- 
1.8.4.474.g128a96c

