Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3LHGP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 01:15:59 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:56825 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3LHGPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 01:15:10 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 03/12] sched/numa: drop sysctl_numa_balancing_settle_count sysctl
Date: Sun,  8 Dec 2013 14:14:44 +0800
Message-Id: <1386483293-15354-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120806-2000-0000-0000-00000ED52151
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 887c290e (sched/numa: Decide whether to favour task or group weights
based on swap candidate relationships) drop the check against
sysctl_numa_balancing_settle_count, this patch remove the sysctl.

Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 include/linux/sched/sysctl.h |    1 -
 kernel/sched/fair.c          |    9 ---------
 kernel/sysctl.c              |    7 -------
 3 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 41467f8..31e0193 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -48,7 +48,6 @@ extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
 extern unsigned int sysctl_numa_balancing_scan_size;
-extern unsigned int sysctl_numa_balancing_settle_count;
 
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ea3fd1e..56bcc0c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -886,15 +886,6 @@ static unsigned int task_scan_max(struct task_struct *p)
 	return max(smin, smax);
 }
 
-/*
- * Once a preferred node is selected the scheduler balancer will prefer moving
- * a task to that node for sysctl_numa_balancing_settle_count number of PTE
- * scans. This will give the process the chance to accumulate more faults on
- * the preferred node but still allow the scheduler to move the task again if
- * the nodes CPUs are overloaded.
- */
-unsigned int sysctl_numa_balancing_settle_count __read_mostly = 4;
-
 static void account_numa_enqueue(struct rq *rq, struct task_struct *p)
 {
 	rq->nr_numa_running += (p->numa_preferred_nid != -1);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34a6047..c8da99f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -385,13 +385,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname       = "numa_balancing_settle_count",
-		.data           = &sysctl_numa_balancing_settle_count,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec,
-	},
-	{
 		.procname       = "numa_balancing_migrate_deferred",
 		.data           = &sysctl_numa_balancing_migrate_deferred,
 		.maxlen         = sizeof(unsigned int),
-- 
1.7.5.4

