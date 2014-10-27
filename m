Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaJ0Bls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:41:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:12393 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaJ0Blp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:41:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="scan'208";a="621089530"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 4/6] sched/dl: push task away if the deadline is equal to curr during wakeup
Date: Mon, 27 Oct 2014 09:41:05 +0800
Message-Id: <1414374067-7209-4-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch pushes task away if the dealine of the task is equal 
to current during wake up. The same behavior as rt class.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index aa7c27f..97141e2 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1492,7 +1492,7 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
 	    p->nr_cpus_allowed > 1 &&
 	    dl_task(rq->curr) &&
 	    (rq->curr->nr_cpus_allowed < 2 ||
-	     dl_entity_preempt(&rq->curr->dl, &p->dl))) {
+	     !dl_entity_preempt(&p->dl, &rq->curr->dl))) {
 		push_dl_tasks(rq);
 	}
 }
-- 
1.9.1

