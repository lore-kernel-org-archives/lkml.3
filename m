Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3KELho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:37:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16730 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3KELhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:37:40 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-2a-5278d882b04d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 03/11] skd: fix error messages in skd_init()
Date: Tue, 05 Nov 2013 12:37:01 +0100
Message-id: <1383651429-4322-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoG7zjYogg4uv2Cx6e06yW6y+289m
	sXHGelaLs7+uslicbXrDbnF51xw2BzaPy2dLPd7vu8rm0bdlFaPHnXMfmDw+b5ILYI3isklJ
	zcksSy3St0vgyti9sI2tYLFoxbsl9Q2M/wS6GDk5JARMJK7sb2KHsMUkLtxbz9bFyMUhJDCd
	UaJ//gN2CKeLSeLX/o1sIFVsAlYSE9tXMYLYIgLCEvs7WllAipgFFjBKTN4xB2yUsIC9RN/H
	ZmYQm0VAVeLyijWsIDavgLvEnNdzmSDWyUs8vd8HNpRTwEPiyqU3YL1CQDXbPu5lncDIu4CR
	YRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCg9k97BuKrB4hCjAAejEg/vxdCKICHWxLLi
	ytxDjBIczEoivG1HgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFk
	mTg4pRoYs8JmzJ3Xbto9Mfw4u2PCsboA1fZLIUe87wgkqwb3nE7OCnlQkRw2I3jhMemL1ZU3
	TxzZ8OuKWcfxn7vO8cQq5djVhAf82X+Dt5nvRN5Mzl/KvR9PXrb7/0aLkS24JG2W3H0hhaVb
	1039vkcvd4L0NeXXUR2V0V0Z/j+fzr8XPLefX37LEV51JZbijERDLeai4kQAJloKqCECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* change priority level from KERN_INFO to KERN_ERR
* add "skd: " prefix
* do minor CodingStyle fixes

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 8c96d18..99d5d12 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5406,47 +5406,44 @@ static int __init skd_init(void)
 	case SKD_IRQ_MSIX:
 		break;
 	default:
-		pr_info("skd_isr_type %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_isr_type %d invalid, re-set to %d\n",
 		       skd_isr_type, SKD_IRQ_DEFAULT);
 		skd_isr_type = SKD_IRQ_DEFAULT;
 	}
 
-	if (skd_max_queue_depth < 1
-	    || skd_max_queue_depth > SKD_MAX_QUEUE_DEPTH) {
-		pr_info(
-		       "skd_max_queue_depth %d invalid, re-set to %d\n",
+	if (skd_max_queue_depth < 1 ||
+	    skd_max_queue_depth > SKD_MAX_QUEUE_DEPTH) {
+		pr_err(PFX "skd_max_queue_depth %d invalid, re-set to %d\n",
 		       skd_max_queue_depth, SKD_MAX_QUEUE_DEPTH_DEFAULT);
 		skd_max_queue_depth = SKD_MAX_QUEUE_DEPTH_DEFAULT;
 	}
 
 	if (skd_max_req_per_msg < 1 || skd_max_req_per_msg > 14) {
-		pr_info(
-		       "skd_max_req_per_msg %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_max_req_per_msg %d invalid, re-set to %d\n",
 		       skd_max_req_per_msg, SKD_MAX_REQ_PER_MSG_DEFAULT);
 		skd_max_req_per_msg = SKD_MAX_REQ_PER_MSG_DEFAULT;
 	}
 
 	if (skd_sgs_per_request < 1 || skd_sgs_per_request > 4096) {
-		pr_info(
-		       "skd_sg_per_request %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_sg_per_request %d invalid, re-set to %d\n",
 		       skd_sgs_per_request, SKD_N_SG_PER_REQ_DEFAULT);
 		skd_sgs_per_request = SKD_N_SG_PER_REQ_DEFAULT;
 	}
 
 	if (skd_dbg_level < 0 || skd_dbg_level > 2) {
-		pr_info("skd_dbg_level %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_dbg_level %d invalid, re-set to %d\n",
 		       skd_dbg_level, 0);
 		skd_dbg_level = 0;
 	}
 
 	if (skd_isr_comp_limit < 0) {
-		pr_info("skd_isr_comp_limit %d invalid, set to %d\n",
+		pr_err(PFX "skd_isr_comp_limit %d invalid, set to %d\n",
 		       skd_isr_comp_limit, 0);
 		skd_isr_comp_limit = 0;
 	}
 
 	if (skd_max_pass_thru < 1 || skd_max_pass_thru > 50) {
-		pr_info("skd_max_pass_thru %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_max_pass_thru %d invalid, re-set to %d\n",
 		       skd_max_pass_thru, SKD_N_SPECIAL_CONTEXT);
 		skd_max_pass_thru = SKD_N_SPECIAL_CONTEXT;
 	}
-- 
1.8.2.3

