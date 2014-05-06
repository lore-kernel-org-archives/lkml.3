Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709AbaEFJwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:52:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:6685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934527AbaEFJwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:52:11 -0400
X-IronPort-AV: E=Sophos;i="4.97,996,1389715200"; 
   d="scan'208";a="30132831"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] sched: Remove macro of NS_TO_JIFFIES in kernel/sched/sched.h.
Date: Tue, 6 May 2014 17:52:22 +0900
Message-ID: <79ab3616c1a9206d3d5c5cfcd1b63c94ab8bddfc.1399366240.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there is already a implementation in linux/jiffies.h to convert
a nsec to jiffies, so we can use it here rather than reimplement
it in sched.h.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/fair.c  | 2 +-
 kernel/sched/sched.h | 6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 43232b8..448ac443 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7636,7 +7636,7 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
+		rr_interval = nsecs_to_jiffies(sched_slice(cfs_rq_of(se), se));
 
 	return rr_interval;
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3563c81..bbc7e07 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -8,6 +8,7 @@
 #include <linux/stop_machine.h>
 #include <linux/tick.h>
 #include <linux/slab.h>
+#include <linux/jiffies.h>
 
 #include "cpupri.h"
 #include "cpudeadline.h"
@@ -24,11 +25,6 @@ extern long calc_load_fold_active(struct rq *this_rq);
 extern void update_cpu_load_active(struct rq *this_rq);
 
 /*
- * Helpers for converting nanosecond timing to jiffy resolution
- */
-#define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
-
-/*
  * Increase resolution of nice-level calculations for 64-bit architectures.
  * The extra resolution improves shares distribution and load balancing of
  * low-weight task groups (eg. nice +19 on an autogroup), deeper taskgroup
-- 
1.8.2.1

