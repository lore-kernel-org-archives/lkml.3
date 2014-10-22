Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbaJVGIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:08:04 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45007 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaJVGHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:07:55 -0400
From: Mike Turquette <mturquette@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, riel@redhat.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 2/7] sched: cfs: declare capacity_of in sched.h
Date: Tue, 21 Oct 2014 23:07:26 -0700
Message-Id: <1413958051-7103-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

capacity_of is useful for cpu frequency scaling policies. Share it via
sched.h so that selectable cpu frequency scaling policies can make use
of it.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 kernel/sched/fair.c  | 7 +++++--
 kernel/sched/sched.h | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 90b36cc..15f5638 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1018,7 +1018,6 @@ bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 static unsigned long weighted_cpuload(const int cpu);
 static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
-static unsigned long capacity_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
 
 /* Cached statistics for all CPUs within a node */
@@ -2056,6 +2055,10 @@ static inline void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
+#ifdef CONFIG_SMP
+unsigned long capacity_of(int cpu);
+#endif /* CONFIG_SMP */
+
 static void
 account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -4132,7 +4135,7 @@ static unsigned long target_load(int cpu, int type)
 	return max(rq->cpu_load[type-1], total);
 }
 
-static unsigned long capacity_of(int cpu)
+unsigned long capacity_of(int cpu)
 {
 	return cpu_rq(cpu)->cpu_capacity;
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 04940f8..9a28d38 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -309,6 +309,8 @@ struct cfs_bandwidth { };
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
+extern unsigned long capacity_of(int cpu);
+
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-- 
1.8.3.2

