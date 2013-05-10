Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3EJPSC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:18:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:13258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab3EJPR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:17:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="334911124"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [patch v6 5/8] sched: update cpu load after task_tick.
Date: Fri, 10 May 2013 23:17:26 +0800
Message-Id: <1368199049-2798-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
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
index 866c05a..f1f9641 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2684,8 +2684,8 @@ void scheduler_tick(void)
 
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
-	update_cpu_load_active(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
+	update_cpu_load_active(rq);
 	raw_spin_unlock(&rq->lock);
 
 	perf_event_task_tick();
-- 
1.7.5.4

