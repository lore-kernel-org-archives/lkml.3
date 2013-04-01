Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab3DAG5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:57:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45882 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab3DAG5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:57:04 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-c7-51592fb95908
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 6/9] f2fs: check completion of foreground GC
Date: Mon, 01 Apr 2013 15:55:57 +0900
Message-id: <1364799360-23145-6-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zA92d+pGBBm9fylhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfFuq1nBe5GKTX9z
	GxjnC3QxcnJICJhIfDu/hgXCFpO4cG89WxcjF4eQwDJGiZ2XD7PAFN05dwHMFhJYxCjx6AoP
	RFEbk8SKC/fZuxg5ONgEtCU27zcAqRERYJZYMPU8I0gNs8AERon/i96DNQsL2Eh8+fWYFcRm
	EVCVOPxmKyOIzSvgLjH/YisrxDJdidX/n7OD2JwCHhKf2z5CLXaXOLVvNdh1EgLf2SQ+3PnB
	BjFIQOLb5EMsIEdICMhKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y1StOzC0uzUvX
	S87P3cQICdeJOxjvH7A+xJgMNG4is5Rocj4w3PNK4g2NzYwsTE1MjY3MLc1IE1YS51VvsQ4U
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBgnemxbkZjuh7ROIYGwS4deBrpuvVikVivemLoo
	PMvge6mT21YvlobVRe85l+jflUtKtPtQq6djFvD3FP+kKRG70rw17x88/utidsXzibqScvdn
	aPO++hcdsOzW+a3e/mqlnt+aZt7wk3DOiA3dF+7yPJfF2Ujwad2L9hcnpDbbXTzbZesYocRS
	nJFoqMVcVJwIAM5KeQltAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAd2d+pGBBod2Slhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jxbqtZwXuRik1/cxsY5wt0MXJySAiYSNw5d4EFwhaTuHBvPRuILSSwiFHi
	0RWeLkYuILuNSWLFhfvsXYwcHGwC2hKb9xuA1IgIMEssmHqeEaSGWWACo8T/Re/BBgkL2Eh8
	+fWYFcRmEVCVOPxmKyOIzSvgLjH/YisrxDJdidX/n7OD2JwCHhKf2z6yQCx2lzi1bzXbBEbe
	BYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo+GZ9A7GVQ0WhxgFOBiVeHgjLkQECrEm
	lhVX5h5ilOBgVhLh9fkGFOJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YKTmlcQbGpuYGVka
	mVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOje1Zcl/D5kkgXn83+DlWTCx8Y
	H2op2Dwrrv7NfTlVK7F3+j9m/vixulttzQ3VF9+ynvx86RP16vIT7YQjReJ3k4sTJa/P1ZrZ
	+y82tWj578pf5r4h/g5t5ma8Wx9az19pcC7g36LF9V2KyoFtu287LD33a6l44tXdBT/5OuYd
	f/A7VVh8/5KZSizFGYmGWsxFxYkA3N357MoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The foreground GCs are triggered under not enough free sections.
So, we should not skip moving valid blocks in the victim segments.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/gc.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 01a1d60..54aceb2 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -131,7 +131,7 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 
-	if (p->alloc_mode) {
+	if (p->alloc_mode == SSR) {
 		p->gc_mode = GC_GREEDY;
 		p->dirty_segmap = dirty_i->dirty_segmap[type];
 		p->ofs_unit = 1;
@@ -403,8 +403,14 @@ next_step:
 			continue;
 
 		/* set page dirty and write it */
-		if (!PageWriteback(node_page))
+		if (gc_type == FG_GC) {
+			f2fs_submit_bio(sbi, NODE, true);
+			wait_on_page_writeback(node_page);
 			set_page_dirty(node_page);
+		} else {
+			if (!PageWriteback(node_page))
+				set_page_dirty(node_page);
+		}
 		f2fs_put_page(node_page, 1);
 		stat_inc_node_blk_count(sbi, 1);
 	}
@@ -420,6 +426,13 @@ next_step:
 			.for_reclaim = 0,
 		};
 		sync_node_pages(sbi, 0, &wbc);
+
+		/*
+		 * In the case of FG_GC, it'd be better to reclaim this victim
+		 * completely.
+		 */
+		if (get_valid_blocks(sbi, segno, 1) != 0)
+			goto next_step;
 	}
 }
 
@@ -483,20 +496,19 @@ static int check_dnode(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 
 static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 {
-	if (page->mapping != inode->i_mapping)
-		goto out;
-
-	if (inode != page->mapping->host)
-		goto out;
-
-	if (PageWriteback(page))
-		goto out;
-
 	if (gc_type == BG_GC) {
+		if (PageWriteback(page))
+			goto out;
 		set_page_dirty(page);
 		set_cold_data(page);
 	} else {
 		struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+
+		if (PageWriteback(page)) {
+			f2fs_submit_bio(sbi, DATA, true);
+			wait_on_page_writeback(page);
+		}
+
 		mutex_lock_op(sbi, DATA_WRITE);
 		if (clear_page_dirty_for_io(page) &&
 			S_ISDIR(inode->i_mode)) {
@@ -593,8 +605,18 @@ next_iput:
 	if (++phase < 4)
 		goto next_step;
 
-	if (gc_type == FG_GC)
+	if (gc_type == FG_GC) {
 		f2fs_submit_bio(sbi, DATA, true);
+
+		/*
+		 * In the case of FG_GC, it'd be better to reclaim this victim
+		 * completely.
+		 */
+		if (get_valid_blocks(sbi, segno, 1) != 0) {
+			phase = 2;
+			goto next_step;
+		}
+	}
 }
 
 static int __get_victim(struct f2fs_sb_info *sbi, unsigned int *victim,
-- 
1.8.1.3.566.gaa39828

