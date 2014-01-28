Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaA1F4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 00:56:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12920 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaA1Fzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 00:55:38 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-99-52e74656d7b5
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/4] f2fs: handle dirty segments inside refresh_sit_entry
Date: Tue, 28 Jan 2014 14:54:05 +0900
Message-id: <1390888447-5258-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1390888447-5258-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1390888447-5258-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zI90wt+dBBk//M1lc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFm/0+2gg/iFU1L
	VzM2MB4W6WLk5JAQMJF4P387K4QtJnHh3nq2LkYuDiGBZYwSq17OY4Mp6pz4iBkisYhR4vK1
	hUwQThOTxPG/C4HaOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4AkhAU8JRp3b2AG
	qWcRUJVov2wCEuYVcJP4u/gLC8QybYltzycygticAu4Slz/+ZAcpFwKqeT/REGSkhMBvNomP
	p3+BHcciICDxbfIhFpAaCQFZiU0HmCHGSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFhnrFibnF
	pXnpesn5uZsYIQHbu4Px9gHrQ4zJQOMmMkuJJucDAz6vJN7Q2MzIwtTE1NjI3NKMNGElcd6k
	h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiFoi0etra4TptWc+txarXSu7ka3848fCkT
	479x+8UDxYeXHtVWvPIq+v6nfaxdU2S8nsiqtco+T9/264Kiybr0U/K/9iwQ2JG2gSd7/tP7
	C4o6fz20NGjjuJdzyMGs4ZZH+dlXgq4Xjv8u3liSoiIpzhEYuqP3RWdxXcRZq58aucsTpzuf
	mNGoxFKckWioxVxUnAgA6qwF8m4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd1Qt+dBBh2vrC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4s/8nW8EH8YqmpasZGxgPi3QxcnJICJhIdE58xAxhi0lcuLeerYuRi0NI
	YBGjxOVrC5kgnCYmieN/F7J2MXJwsAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWcBSQgL
	eEo07t7ADFLPIqAq0X7ZBCTMK+Am8XfxFxaIZdoS255PZASxOQXcJS5//MkOUi4EVPN+ouEE
	Rt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj4ZnUDsaVDRaHGAU4GJV4eDs6nwUJ
	sSaWFVfmHmKU4GBWEuE9OwUoxJuSWFmVWpQfX1Sak1p8iDEZ6KaJzFKiyfnAWM0riTc0NjEz
	sjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsa0OUtVzr/h0diyUvhTcrDk
	7fe7w4QadneKL29+0K93scJ7b+qhdywzIrk/nj3E90XBUl42xyQtp2mjSr3ZhlVvV9VcDSuI
	3vziPrc4q1PKnbpzCm/tzRqizHRnL1+44knk5/Dp3sIs81q0b1t27pvwZOXCuP/FO8+kT5ww
	gXkC56GbD8Xf7GhSYinOSDTUYi4qTgQA9A88rcsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the refresh_sit_entry to handle locate_dirty_segments.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h    |  1 +
 fs/f2fs/segment.c | 19 ++++++++-----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 42903c3..6e9515d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1132,6 +1132,7 @@ void destroy_node_manager_caches(void);
 void f2fs_balance_fs(struct f2fs_sb_info *);
 void f2fs_balance_fs_bg(struct f2fs_sb_info *);
 void invalidate_blocks(struct f2fs_sb_info *, block_t);
+void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
 void clear_prefree_segments(struct f2fs_sb_info *);
 int npages_for_summary_flush(struct f2fs_sb_info *);
 void allocate_new_segments(struct f2fs_sb_info *);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 7caac5f..89aa503 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -434,12 +434,14 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 		get_sec_entry(sbi, segno)->valid_blocks += del;
 }
 
-static void refresh_sit_entry(struct f2fs_sb_info *sbi,
-			block_t old_blkaddr, block_t new_blkaddr)
+void refresh_sit_entry(struct f2fs_sb_info *sbi, block_t old, block_t new)
 {
-	update_sit_entry(sbi, new_blkaddr, 1);
-	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
-		update_sit_entry(sbi, old_blkaddr, -1);
+	update_sit_entry(sbi, new, 1);
+	if (GET_SEGNO(sbi, old) != NULL_SEGNO)
+		update_sit_entry(sbi, old, -1);
+
+	locate_dirty_segment(sbi, GET_SEGNO(sbi, old));
+	locate_dirty_segment(sbi, GET_SEGNO(sbi, new));
 }
 
 void invalidate_blocks(struct f2fs_sb_info *sbi, block_t addr)
@@ -886,12 +888,11 @@ void allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 	 * since SSR needs latest valid block information.
 	 */
 	refresh_sit_entry(sbi, old_blkaddr, *new_blkaddr);
+	locate_dirty_segment(sbi, old_cursegno);
 
 	if (!__has_curseg_space(sbi, type))
 		sit_i->s_ops->allocate_segment(sbi, type, false);
 
-	locate_dirty_segment(sbi, old_cursegno);
-	locate_dirty_segment(sbi, GET_SEGNO(sbi, old_blkaddr));
 	mutex_unlock(&sit_i->sentry_lock);
 
 	if (page && IS_NODESEG(type))
@@ -992,9 +993,7 @@ void recover_data_page(struct f2fs_sb_info *sbi,
 	__add_sum_entry(sbi, type, sum);
 
 	refresh_sit_entry(sbi, old_blkaddr, new_blkaddr);
-
 	locate_dirty_segment(sbi, old_cursegno);
-	locate_dirty_segment(sbi, GET_SEGNO(sbi, old_blkaddr));
 
 	mutex_unlock(&sit_i->sentry_lock);
 	mutex_unlock(&curseg->curseg_mutex);
@@ -1045,9 +1044,7 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 	f2fs_submit_page_mbio(sbi, page, new_blkaddr, &fio);
 	f2fs_submit_merged_bio(sbi, NODE, WRITE);
 	refresh_sit_entry(sbi, old_blkaddr, new_blkaddr);
-
 	locate_dirty_segment(sbi, old_cursegno);
-	locate_dirty_segment(sbi, GET_SEGNO(sbi, old_blkaddr));
 
 	mutex_unlock(&sit_i->sentry_lock);
 	mutex_unlock(&curseg->curseg_mutex);
-- 
1.8.4.474.g128a96c

