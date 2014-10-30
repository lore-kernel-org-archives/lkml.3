Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161451AbaJ3Wjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:39:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:46204 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161393AbaJ3Wjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:39:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,289,1413270000"; 
   d="scan'208";a="623777824"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v3 4/6] sched/deadline: push task away if the deadline is equal to curr during wakeup
Date: Fri, 31 Oct 2014 06:39:34 +0800
Message-Id: <1414708776-124078-4-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com>
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
index 4c5fdf5..1c09751 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1511,7 +1511,7 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
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

