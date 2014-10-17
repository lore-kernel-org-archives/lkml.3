Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaJQHaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:30:19 -0400
Received: from shelob.surriel.com ([74.92.59.67]:35974 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaJQHaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:30:06 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.org, mingo@redhat.com,
        mgorman@suse.de
Subject: [PATCH 1/6] sched,numa: export info needed for NUMA balancing on complex topologies
Date: Fri, 17 Oct 2014 03:29:49 -0400
Message-Id: <1413530994-9732-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413530994-9732-1-git-send-email-riel@redhat.com>
References: <1413530994-9732-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Export some information that is necessary to do placement of
tasks on systems with multi-level NUMA topologies.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/core.c  | 4 +++-
 kernel/sched/sched.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5a4ad05..ed427f9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6076,6 +6076,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 #ifdef CONFIG_NUMA
 static int sched_domains_numa_levels;
 static int *sched_domains_numa_distance;
+int sched_max_numa_distance;
 static struct cpumask ***sched_domains_numa_masks;
 static int sched_domains_curr_level;
 #endif
@@ -6247,7 +6248,7 @@ static void sched_numa_warn(const char *str)
 	printk(KERN_WARNING "\n");
 }
 
-static bool find_numa_distance(int distance)
+bool find_numa_distance(int distance)
 {
 	int i;
 
@@ -6394,6 +6395,7 @@ static void sched_init_numa(void)
 	sched_domain_topology = tl;
 
 	sched_domains_numa_levels = level;
+	sched_max_numa_distance = sched_domains_numa_distance[level - 1];
 }
 
 static void sched_domains_numa_masks_set(int cpu)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6130251..515402e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -680,6 +680,8 @@ static inline u64 rq_clock_task(struct rq *rq)
 
 #ifdef CONFIG_NUMA_BALANCING
 extern void sched_setnuma(struct task_struct *p, int node);
+extern int sched_max_numa_distance;
+extern bool find_numa_distance(int distance);
 extern int migrate_task_to(struct task_struct *p, int cpu);
 extern int migrate_swap(struct task_struct *, struct task_struct *);
 #endif /* CONFIG_NUMA_BALANCING */
-- 
1.9.3

