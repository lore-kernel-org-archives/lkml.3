Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3EFBqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 21:46:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:64038 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab3EFBqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 21:46:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,618,1363158000"; 
   d="scan'208";a="308658603"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH v5 2/7] sched: remove SMP cover for runnable variables in cfs_rq
Date: Mon,  6 May 2013 09:45:06 +0800
Message-Id: <1367804711-30308-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following variables were covered under CONFIG_SMP in struct cfs_rq.
but similar runnable variables work for UP in struct rq and task_group.
like rq->avg, task_group->load_avg.
So move them out, they also can work with UP.

         u64 runnable_load_avg, blocked_load_avg;
         atomic64_t decay_counter, removed_load;
         u64 last_decay;

         u32 tg_runnable_contrib;
         u64 tg_load_contrib;

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7f36024f..1a02b90 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -226,7 +226,6 @@ struct cfs_rq {
 	unsigned int nr_spread_over;
 #endif
 
-#ifdef CONFIG_SMP
 	/*
 	 * CFS Load tracking
 	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
@@ -242,6 +241,7 @@ struct cfs_rq {
 	u64 tg_load_contrib;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_SMP
 	/*
 	 *   h_load = weight * f(tg)
 	 *
-- 
1.7.12

