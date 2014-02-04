Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaBDEsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 23:48:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43804 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaBDEsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 23:48:16 -0500
X-AuditID: cbfee68e-b7f566d000002344-34-52f0710eace8
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: clean up with a macro
Date: Tue, 04 Feb 2014 13:46:44 +0900
Message-id: <1391489204-19695-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1391489204-19695-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1391489204-19695-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zA12+wg9BBvsPy1tc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH2ZCtjwRaJim+N
	S5gbGNeIdDFyckgImEjM+NHFBGGLSVy4t54NxBYSWMYocWlGEkzNgnPPmLsYuYDiixgljn6Z
	wgJR1MQk8bG3oouRg4NNQFti834DkLCIALPEgqnnGUHqmQUmMEr8X/QerF5YwEBi5tYedhCb
	RUBV4uuluewgvbwC7hIPzlhD7NKW2PZ8IiOIzSngIfFr30smiFXuEs/eX2EHmSkh8JtN4son
	mDkCEt8mH2IBmSMhICux6QAzxBxJiYMrbrBMYBRewMiwilE0tSC5oDgpvchIrzgxt7g0L10v
	OT93EyMkXPt2MN48YH2IMRlo3ERmKdHkfGC455XEGxqbGVmYmpgaG5lbmpEmrCTOu+hhUpCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGRkuRAIlcmbs78x8kdRlYdU3d0xAtrhDQ6bu1/7/u
	/ZMLTmv+k+dd8u+h69R0h14/rRv/imU/Tbs0jYnn0oGDRq/TFT2ffonUnNqsM2vSzcM7nflr
	paRWr6qZJtHmvuIvq1NOw272Xf/PTnPmWH5Q5bvFqXv2q+omRsY6spv/uCqdVT795Z/5dkos
	xRmJhlrMRcWJAF80EehtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAV2+wg9BBqceSVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix9mQrY8EWiYpvjUuYGxjXiHQxcnJICJhILDj3jBnCFpO4cG89WxcjF4eQ
	wCJGiaNfprCAJIQEmpgkPvZWdDFycLAJaEts3m8AEhYRYJZYMPU8I0g9s8AERon/i96D1QsL
	GEjM3NrDDmKzCKhKfL00lx2kl1fAXeLBGWuIXdoS255PZASxOQU8JH7te8kEscpd4tn7K+wT
	GHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOh2dSOxhXNlgcYhTgYFTi4VVQ+RAk
	xJpYVlyZe4hRgoNZSYT3oAVQiDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OBsZpXEm9obGJm
	ZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYz7Or8GTLV3/dTCcvb4nYuR
	XXLCaZtVkudvat30S+lGk5Pm5ffPV8mL/JjTtnf/fpHW10vs9IVnX3gdK2hZsWxHyCqG2wcY
	fta7TLP2DNrS/ONguf82tbJ/1s0Bd387F9i1zuu8mitkKnHpjMSHzEKeEz5PksuFooMSD80z
	W3pB8MFlXcmw+G1KLMUZiYZazEXFiQCyxq0oywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds GET_BLKOFF_FROM_SEG0 to clean up some codes.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c |  3 +--
 fs/f2fs/segment.c  | 11 ++++-------
 fs/f2fs/segment.h  |  3 +++
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index f1b0b89..bda04a0 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -218,8 +218,7 @@ static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 {
 	struct seg_entry *sentry;
 	unsigned int segno = GET_SEGNO(sbi, blkaddr);
-	unsigned short blkoff = GET_SEGOFF_FROM_SEG0(sbi, blkaddr) &
-					(sbi->blocks_per_seg - 1);
+	unsigned short blkoff = GET_BLKOFF_FROM_SEG0(sbi, blkaddr);
 	struct f2fs_summary sum;
 	nid_t ino, nid;
 	void *kaddr;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index fba510b..e87946a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -405,7 +405,7 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 
 	se = get_seg_entry(sbi, segno);
 	new_vblocks = se->valid_blocks + del;
-	offset = GET_SEGOFF_FROM_SEG0(sbi, blkaddr) & (sbi->blocks_per_seg - 1);
+	offset = GET_BLKOFF_FROM_SEG0(sbi, blkaddr);
 
 	f2fs_bug_on((new_vblocks >> (sizeof(unsigned short) << 3) ||
 				(new_vblocks > sbi->blocks_per_seg)));
@@ -987,8 +987,7 @@ void recover_data_page(struct f2fs_sb_info *sbi,
 		change_curseg(sbi, type, true);
 	}
 
-	curseg->next_blkoff = GET_SEGOFF_FROM_SEG0(sbi, new_blkaddr) &
-					(sbi->blocks_per_seg - 1);
+	curseg->next_blkoff = GET_BLKOFF_FROM_SEG0(sbi, new_blkaddr);
 	__add_sum_entry(sbi, type, sum);
 
 	refresh_sit_entry(sbi, old_blkaddr, new_blkaddr);
@@ -1026,8 +1025,7 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 		curseg->next_segno = segno;
 		change_curseg(sbi, type, true);
 	}
-	curseg->next_blkoff = GET_SEGOFF_FROM_SEG0(sbi, new_blkaddr) &
-					(sbi->blocks_per_seg - 1);
+	curseg->next_blkoff = GET_BLKOFF_FROM_SEG0(sbi, new_blkaddr);
 	__add_sum_entry(sbi, type, sum);
 
 	/* change the current log to the next block addr in advance */
@@ -1035,8 +1033,7 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 		curseg->next_segno = next_segno;
 		change_curseg(sbi, type, true);
 	}
-	curseg->next_blkoff = GET_SEGOFF_FROM_SEG0(sbi, next_blkaddr) &
-					(sbi->blocks_per_seg - 1);
+	curseg->next_blkoff = GET_BLKOFF_FROM_SEG0(sbi, next_blkaddr);
 
 	/* rewrite node page */
 	set_page_writeback(page);
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 5731682..4024546 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -57,6 +57,9 @@
 	((blk_addr) - SM_I(sbi)->seg0_blkaddr)
 #define GET_SEGNO_FROM_SEG0(sbi, blk_addr)				\
 	(GET_SEGOFF_FROM_SEG0(sbi, blk_addr) >> sbi->log_blocks_per_seg)
+#define GET_BLKOFF_FROM_SEG0(sbi, blk_addr)				\
+	(GET_SEGOFF_FROM_SEG0(sbi, blk_addr) & (sbi->blocks_per_seg - 1))
+
 #define GET_SEGNO(sbi, blk_addr)					\
 	(((blk_addr == NULL_ADDR) || (blk_addr == NEW_ADDR)) ?		\
 	NULL_SEGNO : GET_L2R_SEGNO(FREE_I(sbi),			\
-- 
1.8.4.474.g128a96c

