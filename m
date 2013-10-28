Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3J1FHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:07:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34303 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3J1FHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:07:39 -0400
X-AuditID: cbfee691-b7f866d000001b8c-49-526df1135fd3
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: [PATCH] f2fs: remove unnecessary segment bitmap updates
Date: Mon, 28 Oct 2013 14:06:47 +0900
Message-id: <1382936807-4778-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t8zA13hj7lBBmdXylpc29fIZHF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxvVLjewF
	fQIV+04fZ2pg7OXtYuTkkBAwkXh68zsrhC0mceHeerYuRi4OIYFljBINy5+xwRR9Xv8DrEhI
	YDqjxPO74hBFzUwSt+Z/Zexi5OBgE9CW2LzfAKRGRIBZYsHU84wgNcwCOxglOromgdUICzhI
	HHucDlLDIqAq8f/RGbD5vAJuEv+/LWeB2KUtse35RLBeCYHnbBL/dq9nhmgQkPg2+RALyBwJ
	AVmJTQeYIeolJQ6uuMEygVFwASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQUJy4g/H+
	AetDjMlA4yYyS4km5wNDOa8k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXx
	RaU5qcWHGJk4OKUaGNOjj+VPWOnz3VcuXvjLmmfSyxZ0z1SL/bH++iLeJbVS2q6qbnsfzsst
	5nOTqWs1KvSqv/jt9h95i/ilOlefbtyTaWL/T3YLJ++6t7UJe6cKKJ7KjvGZ7fJHv+I3B3Ox
	s+qEhtfSf2/WTnWxOfvmniTbxtx1F48dFzH35Dxe2PXk7yXO03FfPyixFGckGmoxFxUnAgA5
	gxrcWwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQV3hj7lBBje2SFhc29fIZHF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8b1S43sBX0CFftOH2dqYOzl7WLk5JAQMJH4vP4HK4QtJnHh3no2
	EFtIYDqjxPO74l2MXEB2M5PErflfGbsYOTjYBLQlNu83AKkREWCWWDD1PCNIDbPADkaJjq5J
	YDXCAg4Sxx6ng9SwCKhK/H90Bmwmr4CbxP9vy1kgdmlLbHs+kXECI/cCRoZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMGB/kx6B+OqBotDjAIcjEo8vBvW5gYJsSaWFVfmHmKU4GBWEuHt
	uwUU4k1JrKxKLcqPLyrNSS0+xJgMtH0is5Rocj4wCvNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Y
	ah0oJJCeWJKanZpakFoEs4WJg1OqgVHyv6/pHxGpqWqH5b81LpdjtJeV1boev1dL8eLpxffX
	P1iwOJtD+gLPgd+f9z5ycFc6ofVXqbXkftob/uLM+VGC4XOmhn931/kx57qdoM2eQAa7AG7+
	sA9tQZ4nJv9yKrlZwbXs8eyMtScvZxx+8X6dZs6pQ9W+3pYCeZuFg18Xz9zI4hedJqbEUpyR
	aKjFXFScCABiQMZkuAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changman Lee <cm224.lee@samsung.com>

From: Changman Lee <cm224.lee@samsung.com>

Only one dirty type is set in __locate_dirty_segment and we can know
dirty type of segment. So we don't need to check other dirty types.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 487af61..8f92c18 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -58,20 +58,10 @@ static void __locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
 
 	if (dirty_type == DIRTY) {
 		struct seg_entry *sentry = get_seg_entry(sbi, segno);
-		enum dirty_type t = DIRTY_HOT_DATA;
+		enum dirty_type t = sentry->type;
 
-		dirty_type = sentry->type;
-
-		if (!test_and_set_bit(segno, dirty_i->dirty_segmap[dirty_type]))
-			dirty_i->nr_dirty[dirty_type]++;
-
-		/* Only one bitmap should be set */
-		for (; t <= DIRTY_COLD_NODE; t++) {
-			if (t == dirty_type)
-				continue;
-			if (test_and_clear_bit(segno, dirty_i->dirty_segmap[t]))
-				dirty_i->nr_dirty[t]--;
-		}
+		if (!test_and_set_bit(segno, dirty_i->dirty_segmap[t]))
+			dirty_i->nr_dirty[t]++;
 	}
 }
 
@@ -84,16 +74,11 @@ static void __remove_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
 		dirty_i->nr_dirty[dirty_type]--;
 
 	if (dirty_type == DIRTY) {
-		enum dirty_type t = DIRTY_HOT_DATA;
-
-		/* clear its dirty bitmap */
-		for (; t <= DIRTY_COLD_NODE; t++) {
-			if (test_and_clear_bit(segno,
-						dirty_i->dirty_segmap[t])) {
-				dirty_i->nr_dirty[t]--;
-				break;
-			}
-		}
+		struct seg_entry *sentry = get_seg_entry(sbi, segno);
+		enum dirty_type t = sentry->type;
+
+		if (test_and_clear_bit(segno, dirty_i->dirty_segmap[t]))
+			dirty_i->nr_dirty[t]--;
 
 		if (get_valid_blocks(sbi, segno, sbi->segs_per_sec) == 0)
 			clear_bit(GET_SECNO(sbi, segno),
-- 
1.8.4.474.g128a96c

