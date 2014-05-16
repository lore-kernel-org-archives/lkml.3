Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaEPEMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 00:12:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:7290 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751106AbaEPEMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 00:12:30 -0400
X-IronPort-AV: E=Sophos;i="4.97,1064,1389715200"; 
   d="scan'208";a="30601454"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] sched/fair: cleanup, clamp values with macros clamp() and max().
Date: Fri, 16 May 2014 12:12:34 +0900
Message-ID: <1400209954-6264-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than use "if" to check and clamp values to allowed minmum or maxmum,
this patch use macros clamp() and max() to clean it up.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/fair.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..939a7ab 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2041,10 +2041,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 	if (tg_weight)
 		shares /= tg_weight;
 
-	if (shares < MIN_SHARES)
-		shares = MIN_SHARES;
-	if (shares > tg->shares)
-		shares = tg->shares;
+	shares = clamp(shares, MIN_SHARES, tg->shares);
 
 	return shares;
 }
@@ -4133,8 +4130,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		 * those are clipped to [MIN_SHARES, ...) do so now. See
 		 * calc_cfs_shares().
 		 */
-		if (wl < MIN_SHARES)
-			wl = MIN_SHARES;
+		wl = max(wl, MIN_SHARES);
 
 		/*
 		 * wl = dw_i = S * (s'_i - s_i); see (3)
-- 
1.8.2.1

