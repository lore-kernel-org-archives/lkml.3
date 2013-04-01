Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab3DAG5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:57:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45882 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab3DAG5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:57:03 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-a7-51592fb94d1a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 9/9] f2fs: fix the bitmap consistency of dirty segments
Date: Mon, 01 Apr 2013 15:56:00 +0900
Message-id: <1364799360-23145-9-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zfd2d+pGBBntv61tc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXH4bCtbwXOxikM/
	HzA1MG4Q6mLk4JAQMJHoby/qYuQEMsUkLtxbz9bFyMUhJLCMUeLol+ssEAkTibNvdrBCJBYx
	SuyevJAZwmljklhx4T47yCQ2AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3YJOEBdwldj5u
	ZQaxWQRUJV4fXM8OYvMCxc8vOwW1TVdi9f/nYHFOAQ+Jz20fweJCQDWn9q0GO09C4DubxM8b
	u9khBglIfJt8iAXiHVmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6
	yfm5mxghIdu/g/HuAetDjMlA4yYyS4km5wNDPq8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60Ah
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjNvs+U4cf5E6VeSzzz+thrY33F52XJ9upyZ0a3yP
	bflxYZ35al3fkFX3qxjmbvI8uEOAf/feK6lquxeds3y/y82v/tTxkjcd3Ye3TzlddI3DIqiN
	60f55CWTH0xby+r27dXGYuHTIb+/sCpnXPy4ablfXPVtj7nyjMk77vUwLbJJEK1e8/fqbCsl
	luKMREMt5qLiRAAV1gqjbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd2d+pGBBjPWa1tc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx+GwrW8FzsYpDPx8wNTBuEOpi5OSQEDCROPtmByuELSZx4d56ti5GLg4h
	gUWMErsnL2SGcNqYJFZcuM/excjBwSagLbF5vwFIg4gAs8SCqecZQWqYBSYwSvxf9J4FJCEs
	4C6x83ErM4jNIqAq8frgenYQmxcofn7ZKRaIbboSq/8/B4tzCnhIfG77CBYXAqo5tW812wRG
	3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPimfQOxlUNFocYBTgYlXh4Iy5EBAqx
	JpYVV+YeYpTgYFYS4fX5BhTiTUmsrEotyo8vKs1JLT7EmAx01URmKdHkfGC85pXEGxqbmBlZ
	GplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY3H0wm8zo3hDz1cu4V4ev918
	W1nm8SIz9/2reZ8/fZVVlp/zQHLyvMpVchqMN2+yZM9/0fDwLfN38RrWfYU7Wk/yzax/MOns
	9wPiB5/oRH36/rBtxo5DEoqH5pSV6xpOsxJrOfNGpOn55shrCdqzdmyL2l6kVMA87/393yqn
	Y3uUGXMquSTj3ZRYijMSDbWYi4oTARYMInXNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like below, there are 8 segment bitmaps for SSR victim candidates.

enum dirty_type {
	DIRTY_HOT_DATA,		/* dirty segments assigned as hot data logs */
	DIRTY_WARM_DATA,	/* dirty segments assigned as warm data logs */
	DIRTY_COLD_DATA,	/* dirty segments assigned as cold data logs */
	DIRTY_HOT_NODE,		/* dirty segments assigned as hot node logs */
	DIRTY_WARM_NODE,	/* dirty segments assigned as warm node logs */
	DIRTY_COLD_NODE,	/* dirty segments assigned as cold node logs */
	DIRTY,			/* to count # of dirty segments */
	PRE,			/* to count # of entirely obsolete segments */
	NR_DIRTY_TYPE
};

The upper 6 bitmaps indicates segments dirtied by active log areas respectively.
And, the DIRTY bitmap integrates all the 6 bitmaps.

For example,
 o DIRTY_HOT_DATA : 1010000
 o DIRTY_WARM_DATA: 0100000
 o DIRTY_COLD_DATA: 0001000
 o DIRTY_HOT_NODE : 0000010
 o DIRTY_WARM_NODE: 0000001
 o DIRTY_COLD_NODE: 0000000
In this case,
 o DIRTY          : 1111011,

 which means that we should guarantee the consistency between DIRTY and other
 bitmaps concreately.

However, the SSR mode selects victims freely from any log types, which can set
multiple bits across the various bitmap types.

So, this patch eliminates this inconsistency.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index fe520d3..7c67ec2 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -49,9 +49,20 @@ static void __locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
 
 	if (dirty_type == DIRTY) {
 		struct seg_entry *sentry = get_seg_entry(sbi, segno);
+		enum dirty_type t = DIRTY_HOT_DATA;
+
 		dirty_type = sentry->type;
+
 		if (!test_and_set_bit(segno, dirty_i->dirty_segmap[dirty_type]))
 			dirty_i->nr_dirty[dirty_type]++;
+
+		/* Only one bitmap should be set */
+		for (; t <= DIRTY_COLD_NODE; t++) {
+			if (t == dirty_type)
+				continue;
+			if (test_and_clear_bit(segno, dirty_i->dirty_segmap[t]))
+				dirty_i->nr_dirty[t]--;
+		}
 	}
 }
 
@@ -64,11 +75,13 @@ static void __remove_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
 		dirty_i->nr_dirty[dirty_type]--;
 
 	if (dirty_type == DIRTY) {
-		struct seg_entry *sentry = get_seg_entry(sbi, segno);
-		dirty_type = sentry->type;
-		if (test_and_clear_bit(segno,
-					dirty_i->dirty_segmap[dirty_type]))
-			dirty_i->nr_dirty[dirty_type]--;
+		enum dirty_type t = DIRTY_HOT_DATA;
+
+		/* clear all the bitmaps */
+		for (; t <= DIRTY_COLD_NODE; t++)
+			if (test_and_clear_bit(segno, dirty_i->dirty_segmap[t]))
+				dirty_i->nr_dirty[t]--;
+
 		if (get_valid_blocks(sbi, segno, sbi->segs_per_sec) == 0)
 			clear_bit(GET_SECNO(sbi, segno),
 						dirty_i->victim_secmap);
-- 
1.8.1.3.566.gaa39828

