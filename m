Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3EJPRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:17:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:13258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab3EJPRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:17:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="334911033"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [patch v6 2/8] sched: move few runnable tg variables into CONFIG_SMP
Date: Fri, 10 May 2013 23:17:23 +0800
Message-Id: <1368199049-2798-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following 2 variables only used under CONFIG_SMP, so better to move
their definiation into CONFIG_SMP too.

        atomic64_t load_avg;
        atomic_t runnable_avg;

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/sched.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9419764..c6634f1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -114,9 +114,11 @@ struct task_group {
 	unsigned long shares;
 
 	atomic_t load_weight;
+#ifdef	CONFIG_SMP
 	atomic64_t load_avg;
 	atomic_t runnable_avg;
 #endif
+#endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct sched_rt_entity **rt_se;
-- 
1.7.5.4

