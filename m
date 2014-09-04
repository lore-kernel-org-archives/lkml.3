Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaIDKMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:12:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23591 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaIDKMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:12:33 -0400
X-AuditID: cbfee61b-f79f86d00000144c-61-54083b0c081d
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/2] f2fs: remove unneeded sit_i in macro
 SIT_BLOCK_OFFSET/START_SEGNO
Date: Thu, 04 Sep 2014 18:11:47 +0800
Message-id: <006901cfc828$bc513780$34f3a680$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/IFcJbsZ1fAB7FR02aZop3cLvCGw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t9jAV0ea44QgyVdehZP1s9itri0yN3i
	8q45bA7MHptWdbJ57F7wmcnj8ya5AOYoLpuU1JzMstQifbsEroxN2zcxF7wWqmj7w9/AuJe/
	i5GTQ0LAROLi888sELaYxIV769lAbCGBRYwSD2d6djFyAdk/GCWW3G9lBUmwCahILO/4zwRi
	iwDZhxZdZgexmQU8JBo7voPVCAskSUz5+54RxGYRUJVoe3AXrIZXwFLiwaPdULagxI/J91gg
	erUk1u88zgRhy0tsXvOWGeIgBYkdZ18zQuzSk5j/YAJUjbjExiO3WCYwCsxCMmoWklGzkIya
	haRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg4H0mvYNxVYPFIUYBDkYlHt6CF+wh
	QqyJZcWVuYcYJTiYlUR4F1pyhAjxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5Ykpqd
	mlqQWgSTZeLglGpgnL2w6/lSg2Q+/ws8T5zXnRbLVTCsVuVSaVh1V2vmQZ0mlQ0lIbxvWrbG
	374/z6Uq4rtZbmJqhajZlxc2jaXzj5dvdPbMeZkyf8kxl5RJRx1XGXXt8BO9wLPN1mb5ldaI
	BddLvruGNG/tnFA0e8WUyZLn3e+Z2Tuv3iYTeqfoLfehKyu9426wK7EUZyQaajEXFScCAN7z
	mVdaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sit_i in macro SIT_BLOCK_OFFSET/START_SEGNO is not used, remove it.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.c |  4 ++--
 fs/f2fs/segment.h | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 853c8f5..a6b90a5 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1403,7 +1403,7 @@ static struct page *get_current_sit_page(struct f2fs_sb_info *sbi,
 					unsigned int segno)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
-	unsigned int offset = SIT_BLOCK_OFFSET(sit_i, segno);
+	unsigned int offset = SIT_BLOCK_OFFSET(segno);
 	block_t blk_addr = sit_i->sit_base_addr + offset;
 
 	check_seg_range(sbi, segno);
@@ -1518,7 +1518,7 @@ to_sit_page:
 				page = NULL;
 			}
 
-			start = START_SEGNO(sit_i, segno);
+			start = START_SEGNO(segno);
 			end = start + SIT_ENTRY_PER_BLOCK - 1;
 
 			/* read sit block that will be updated */
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index d163fc8..2548bfd 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -77,10 +77,10 @@
 
 #define SIT_ENTRY_OFFSET(sit_i, segno)					\
 	(segno % sit_i->sents_per_block)
-#define SIT_BLOCK_OFFSET(sit_i, segno)					\
+#define SIT_BLOCK_OFFSET(segno)					\
 	(segno / SIT_ENTRY_PER_BLOCK)
-#define	START_SEGNO(sit_i, segno)		\
-	(SIT_BLOCK_OFFSET(sit_i, segno) * SIT_ENTRY_PER_BLOCK)
+#define	START_SEGNO(segno)		\
+	(SIT_BLOCK_OFFSET(segno) * SIT_ENTRY_PER_BLOCK)
 #define SIT_BLK_CNT(sbi)			\
 	((TOTAL_SEGS(sbi) + SIT_ENTRY_PER_BLOCK - 1) / SIT_ENTRY_PER_BLOCK)
 #define f2fs_bitmap_size(nr)			\
@@ -624,7 +624,7 @@ static inline pgoff_t current_sit_addr(struct f2fs_sb_info *sbi,
 						unsigned int start)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
-	unsigned int offset = SIT_BLOCK_OFFSET(sit_i, start);
+	unsigned int offset = SIT_BLOCK_OFFSET(start);
 	block_t blk_addr = sit_i->sit_base_addr + offset;
 
 	check_seg_range(sbi, start);
@@ -651,7 +651,7 @@ static inline pgoff_t next_sit_addr(struct f2fs_sb_info *sbi,
 
 static inline void set_to_next_sit(struct sit_info *sit_i, unsigned int start)
 {
-	unsigned int block_off = SIT_BLOCK_OFFSET(sit_i, start);
+	unsigned int block_off = SIT_BLOCK_OFFSET(start);
 
 	if (f2fs_test_bit(block_off, sit_i->sit_bitmap))
 		f2fs_clear_bit(block_off, sit_i->sit_bitmap);
-- 
2.0.1.474.g72c7794


