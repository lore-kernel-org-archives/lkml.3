Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3BRFLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:11:45 -0500
Received: from mga14.intel.com ([143.182.124.37]:59504 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab3BRFHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:07:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="258209921"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com,
        morten.rasmussen@arm.com
Subject: [patch v5 01/15] sched: set initial value for runnable avg of sched entities.
Date: Mon, 18 Feb 2013 13:07:28 +0800
Message-Id: <1361164062-20111-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need initialize the se.avg.{decay_count, load_avg_contrib} to zero
after a new task forked.
Otherwise random values of above variables cause mess when do new task
enqueue:
    enqueue_task_fair
        enqueue_entity
            enqueue_entity_load_avg

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..1743746 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1559,6 +1559,8 @@ static void __sched_fork(struct task_struct *p)
 #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
+	p->se.avg.decay_count = 0;
+	p->se.avg.load_avg_contrib = 0;
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
-- 
1.7.12

