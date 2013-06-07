Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3FGHYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:24:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:10416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab3FGHV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:21:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,820,1363158000"; 
   d="scan'208";a="251855699"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: [patch v8 2/9] sched: move few runnable tg variables into CONFIG_SMP
Date: Fri,  7 Jun 2013 15:20:45 +0800
Message-Id: <1370589652-24549-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following 2 variables only used under CONFIG_SMP, so better to move
their definiation into CONFIG_SMP too.

        atomic64_t load_avg;
        atomic_t runnable_avg;

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/sched.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d892a9f..24b1503 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -149,9 +149,11 @@ struct task_group {
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
1.7.12

