Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3AZBt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:49:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:39598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab3AZBtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:49:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,542,1355126400"; 
   d="scan'208";a="276820865"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [RFC patch v2 4/7] sched: update cpu load after task_tick.
Date: Sat, 26 Jan 2013 09:49:21 +0800
Message-Id: <1359164964-29052-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
References: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
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
index dbab4b3..4f4714e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2695,8 +2695,8 @@ void scheduler_tick(void)
 
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
-	update_cpu_load_active(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
+	update_cpu_load_active(rq);
 	raw_spin_unlock(&rq->lock);
 
 	perf_event_task_tick();
-- 
1.7.12

