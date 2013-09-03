Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab3ICG2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:28:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10409 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548Ab3ICG2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:28:10 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-31-522581720bd4
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: avoid an overflow during utilization calculation
Date: Tue, 03 Sep 2013 15:27:53 +0900
Message-id: <1378189673-32656-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
In-reply-to: <1378189673-32656-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1378189673-32656-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zI92iRtUgg/M3lC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgypiy/w5LwW22ii1n
	HrA0MJ5m7WLk5JAQMJH4Mu8JI4QtJnHh3nq2LkYuDiGBZYwSGw+1scMUzd/5lB0isYhRon/n
	byaQhJBAG5PE11m5XYwcHGwC2hKb9xuAhEUEmCUWTD3PCFLPLDCBUeL/ovcsIDXCAt4SXRsT
	QGpYBFQlHsw/DjaGV8Bdonv3KqgjdCUWnTgIdhyngIfEqostzBCr3CV6Vz9nBpkpIfCbTaJ7
	13cWiEECEt8mHwKbLyEgK7HpADPEHEmJgytusExgFF7AyLCKUTS1ILmgOCm9yESvODG3uDQv
	XS85P3cTIyRgJ+xgvHfA+hBjMtC4icxSosn5wIDPK4k3NDYzsjA1MTU2Mrc0I01YSZxXvcU6
	UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj9J1trJMMBBvjOPMTnq+8fTtC7x+HGOuR0qoX
	Earet6b9KV0sqPXmCLPeXSP7Ga/drNn4Q7O3HCrfJXs5zL7IfllhZPf+uEX+HQ3S5p37NVO2
	9kssz2+0YTD+srRwX+PSe5eYbN7/v8w5Yb95l237PfFPEaX7WtwaFub5NJdtVPdZuGHVnXwl
	luKMREMt5qLiRAAYB5O6bgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd2iRtUgg7t7FSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yYsv8OS8FttootZx6wNDCeZu1i5OSQEDCRmL/zKTuELSZx4d56ti5GLg4h
	gUWMEv07fzOBJIQE2pgkvs7K7WLk4GAT0JbYvN8AJCwiwCyxYOp5RpB6ZoEJjBL/F71nAakR
	FvCW6NqYAFLDIqAq8WD+cbAxvALuEt27VzFC7NKVWHTiINgNnAIeEqsutjBDrHKX6F39nHkC
	I+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHx8ExqB+PKBotDjAIcjEo8vBx7VYKE
	WBPLiitzDzFKcDArifAKfQMK8aYkVlalFuXHF5XmpBYfYkwGumois5Rocj4wVvNK4g2NTcyM
	LI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgbF35i51xzs7G1J5jl167j+X
	/84//bh1hhalB94Z3dqVfX7nqaZViXyrZRrbrvkw6Hx5/M/n5ZnnkzJa1KOa5ll9rHllWJh9
	45S6ft7aC+vNfj7f6PI6448hU8knDua+ktSvRgUv5Jv/rc1ne8x3sUxB54Jdpei9B3JXn7Du
	KE9r0uWx6Jz4c4kSS3FGoqEWc1FxIgDBojqxywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current f2fs uses all the block counts with 32 bit numbers, which is able to
cover about 15TB volume.

But in calculation of utilization, f2fs multiplies the count by 100 which can
induce overflow.
This patch fixes this.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index cd9bd93..e0d6d3a 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -471,7 +471,7 @@ static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi, int freed)
 
 static inline int utilization(struct f2fs_sb_info *sbi)
 {
-	return div_u64(valid_user_blocks(sbi) * 100, sbi->user_block_count);
+	return div_u64((u64)valid_user_blocks(sbi) * 100, sbi->user_block_count);
 }
 
 /*
-- 
1.8.3.1.437.g0dbd812

