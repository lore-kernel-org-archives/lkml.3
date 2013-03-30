Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3C3OgB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:36:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726Ab3C3Ofl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:35:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568187"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 03/21] sched: only count runnable avg on cfs_rq's nr_running
Date: Sat, 30 Mar 2013 22:34:50 +0800
Message-Id: <1364654108-16307-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old function count the runnable avg on rq's nr_running even there is
only rt task in rq. That is incorrect, so correct it to cfs_rq's
nr_running.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2881d42..026e959 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2829,7 +2829,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	}
 
 	if (!se) {
-		update_rq_runnable_avg(rq, rq->nr_running);
+		update_rq_runnable_avg(rq, rq->cfs.nr_running);
 		inc_nr_running(rq);
 	}
 	hrtick_update(rq);
-- 
1.7.12

