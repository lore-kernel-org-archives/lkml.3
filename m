Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaJ0Bl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:41:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:12393 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbaJ0Bls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:41:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="scan'208";a="621089539"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 5/6] sched/dl: reschedule if successfully pull earlier deadline task
Date: Mon, 27 Oct 2014 09:41:06 +0800
Message-Id: <1414374067-7209-5-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reschedule if successfully pull earlier deadline task.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 97141e2..21de865 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1583,8 +1583,8 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 * this is the right place to try to pull some other one
 	 * from an overloaded cpu, if any.
 	 */
-	if (!rq->dl.dl_nr_running)
-		pull_dl_task(rq);
+	if (!rq->dl.dl_nr_running && pull_dl_task(rq))
+			resched_curr(rq);
 #endif
 }
 
-- 
1.9.1

