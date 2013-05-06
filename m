Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3EFBqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 21:46:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:64038 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab3EFBqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 21:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,618,1363158000"; 
   d="scan'208";a="308658625"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH v5 4/7] sched: update cpu load after task_tick.
Date: Mon,  6 May 2013 09:45:08 +0800
Message-Id: <1367804711-30308-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get the latest runnable info, we need do this cpuload update after
task_tick.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ecec7f1..33bcebf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2692,8 +2692,8 @@ void scheduler_tick(void)
 
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
-	update_cpu_load_active(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
+	update_cpu_load_active(rq);
 	raw_spin_unlock(&rq->lock);
 
 	perf_event_task_tick();
-- 
1.7.12

