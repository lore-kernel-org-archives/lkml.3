Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3KOJhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:37:15 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56921 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab3KOJhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:37:03 -0500
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH RESEND] sched/fair: simple cleanup in update_sg_lb_stats()
Date: Fri, 15 Nov 2013 15:06:52 +0530
Message-Id: <1384508212-25032-1-git-send-email-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111509-5140-0000-0000-0000042A4CE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rq->nr_running to sgs->sum_nr_running directly instead of
assigning it through an intermediate variable nr_running.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/fair.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e8b652ebe027..9d921e2e41eb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5500,7 +5500,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
 			int local_group, struct sg_lb_stats *sgs)
 {
-	unsigned long nr_running;
 	unsigned long load;
 	int i;
 
@@ -5509,8 +5508,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
-		nr_running = rq->nr_running;
-
 		/* Bias balancing toward cpus of our domain */
 		if (local_group)
 			load = target_load(i, load_idx);
@@ -5518,7 +5515,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = source_load(i, load_idx);
 
 		sgs->group_load += load;
-		sgs->sum_nr_running += nr_running;
+		sgs->sum_nr_running += rq->nr_running;
 #ifdef CONFIG_NUMA_BALANCING
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
-- 
1.8.4.474.g128a96c

