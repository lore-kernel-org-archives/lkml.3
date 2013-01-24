Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3AXDaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:30:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:14248 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab3AXDaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="247742534"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [PATCH 1/4] sched: update cpu load after task_tick.
Date: Thu, 24 Jan 2013 11:30:40 +0800
Message-Id: <1358998243-23176-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358998243-23176-1-git-send-email-alex.shi@intel.com>
References: <1358998243-23176-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get the latest runnable info, we need do this cpuload update after
task_tick.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.0.1

