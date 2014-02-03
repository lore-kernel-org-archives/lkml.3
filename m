Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbaBCGF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:05:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:15685 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaBCGF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:05:57 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-11-52ef31c36e4c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: remove the ugly pointer conversion
Date: Mon, 03 Feb 2014 15:04:25 +0900
Message-id: <1391407465-8377-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA93Dhu+DDN4fE7S4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6Px5mfmgsNCFWd7
	PzI1MHbzdzFyckgImEi8mLCJHcIWk7hwbz0biC0ksIxRov9rKUxN28VVTF2MXEDx6YwSy970
	QjlNTBITz0wF6ubgYBPQlti83wCkQUSAWWLB1POMIDXMAhMYJf4ves8CkhAWsJT4+a+NFcRm
	EVCVeDO1BSzOK+AmMbtrH9QV2hLbnk8Ea5YQuM8mMWHzb6gGAYlvkw+xgCyTEJCV2HSAGaJe
	UuLgihssExgFFzAyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQICcHeHYy3D1gfYkwGGjeR
	WUo0OR8Ywnkl8YbGZkYWpiamxkbmlmakCSuJ8yY9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjE
	wSnVwFh3p6Gn1Ixl7T7Hyc93RFs7/6jMirNQ8dA1NJH6URh9U0Smeam/7GYvqaCHEgu9psux
	bBT+ZhgQox2zJz8itSLx+5ysfRNffLZdvuCv7+V5Bk7rGyqaOJK8GQuKFE/NW2egfJdjQVst
	w5q9LwynRFVVp1/9/sJj0hPNxVnay56n/d5wUaOAT4mlOCPRUIu5qDgRAEDUW3hXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd3Dhu+DDD5f5bW4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjGj8eZn5oLDQhVnez8yNTB283cxcnJICJhItF1cxQRhi0lcuLeerYuRi0NI
	YDqjxLI3vUwQThOTxMQzU9m7GDk42AS0JTbvNwBpEBFgllgw9TwjSA2zwARGif+L3rOAJIQF
	LCV+/mtjBbFZBFQl3kxtAYvzCrhJzO7axw6xTVti2/OJjBMYuRcwMqxiFE0tSC4oTkrPNdQr
	TswtLs1L10vOz93ECA7xZ1I7GFc2WBxiFOBgVOLh7dj7LkiINbGsuDL3EKMEB7OSCG+3wPsg
	Id6UxMqq1KL8+KLSnNTiQ4zJQNsnMkuJJucD4y+vJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaB
	QgLpiSWp2ampBalFMFuYODilGhgTNsbYvvn8h43fg3+ZUBqvf+MGTWuN8J/5Yetu72OUrFK+
	8WbNIVNjqSeXDTSfL2Wzrj9fuulFXXSfS8KxjoArN+q5DVKi4oy7wvf/E90jpH7V7FpCx8/P
	syZvmSOfqfGhf5GFa0LG7Hd5k+0NUv3OVuf/lvSX7P7xdLJZo7GAZoXN/CC+KCWW4oxEQy3m
	ouJEAEmaeAa1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the use of bi_private to remove pointer chasing for sbi.
Previously, we had a bi_private structure, but it needs memory allocation.
So this patch uses bi_private by the sbi pointer and adds a completion pointer
into the sbi.
This can achieve no memory allocation and nice use of the bi_private.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 11 +++++++----
 fs/f2fs/f2fs.h |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 20c3c64..d175ae3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -45,7 +45,7 @@ static void f2fs_read_end_io(struct bio *bio, int err)
 
 static void f2fs_write_end_io(struct bio *bio, int err)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(bio->bi_io_vec->bv_page->mapping->host->i_sb);
+	struct f2fs_sb_info *sbi = bio->bi_private;
 	struct bio_vec *bvec;
 	int i;
 
@@ -61,8 +61,10 @@ static void f2fs_write_end_io(struct bio *bio, int err)
 		dec_page_count(sbi, F2FS_WRITEBACK);
 	}
 
-	if (bio->bi_private)
-		complete(bio->bi_private);
+	if (sbi->wait_io) {
+		complete(sbi->wait_io);
+		sbi->wait_io = NULL;
+	}
 
 	if (!get_pages(sbi, F2FS_WRITEBACK) &&
 			!list_empty(&sbi->cp_wait.task_list))
@@ -85,6 +87,7 @@ static struct bio *__bio_alloc(struct f2fs_sb_info *sbi, block_t blk_addr,
 	bio->bi_bdev = sbi->sb->s_bdev;
 	bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
 	bio->bi_end_io = is_read ? f2fs_read_end_io : f2fs_write_end_io;
+	bio->bi_private = sbi;
 
 	return bio;
 }
@@ -112,7 +115,7 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 		 */
 		if (fio->type == META_FLUSH) {
 			DECLARE_COMPLETION_ONSTACK(wait);
-			io->bio->bi_private = &wait;
+			io->sbi->wait_io = &wait;
 			submit_bio(rw, io->bio);
 			wait_for_completion(&wait);
 		} else {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 55288d2..aeff132 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -398,6 +398,7 @@ struct f2fs_sb_info {
 	/* for bio operations */
 	struct f2fs_bio_info read_io;			/* for read bios */
 	struct f2fs_bio_info write_io[NR_PAGE_TYPE];	/* for write bios */
+	struct completion *wait_io;		/* for completion bios */
 
 	/* for checkpoint */
 	struct f2fs_checkpoint *ckpt;		/* raw checkpoint pointer */
-- 
1.8.4.474.g128a96c

