Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaJVGIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:08:06 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35886 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaJVGH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:07:57 -0400
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
Subject: [PATCH RFC 3/7] sched: fair: add usage_util_of helper
Date: Tue, 21 Oct 2014 23:07:27 -0700
Message-Id: <1413958051-7103-4-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 kernel/sched/fair.c  | 6 ++++++
 kernel/sched/sched.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 15f5638..0930ad8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2057,6 +2057,7 @@ static inline void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 
 #ifdef CONFIG_SMP
 unsigned long capacity_of(int cpu);
+unsigned long usage_util_of(int cpu);
 #endif /* CONFIG_SMP */
 
 static void
@@ -4140,6 +4141,11 @@ unsigned long capacity_of(int cpu)
 	return cpu_rq(cpu)->cpu_capacity;
 }
 
+unsigned long usage_util_of(int cpu)
+{
+	return cpu_rq(cpu)->cfs.usage_util_avg;
+}
+
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9a28d38..c34cbfc 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -310,6 +310,7 @@ struct cfs_bandwidth { };
 #endif	/* CONFIG_CGROUP_SCHED */
 
 extern unsigned long capacity_of(int cpu);
+extern unsigned long usage_util_of(int cpu);
 
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
-- 
1.8.3.2

