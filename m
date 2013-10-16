Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab3JPFfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 01:35:37 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55098 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3JPFfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 01:35:36 -0400
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingn@redhat.com
Subject: [PATCH TRIVIAL] sched/fair: simple cleanup in update_sg_lb_stats()
Date: Wed, 16 Oct 2013 11:05:27 +0530
Message-Id: <1381901727-3300-1-git-send-email-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101605-2674-0000-0000-00000B0FB934
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
index 4aa0b10889d0..c7ebad6c40af 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5465,7 +5465,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
 			int local_group, struct sg_lb_stats *sgs)
 {
-	unsigned long nr_running;
 	unsigned long load;
 	int i;
 
@@ -5474,8 +5473,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
-		nr_running = rq->nr_running;
-
 		/* Bias balancing toward cpus of our domain */
 		if (local_group)
 			load = target_load(i, load_idx);
@@ -5483,7 +5480,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = source_load(i, load_idx);
 
 		sgs->group_load += load;
-		sgs->sum_nr_running += nr_running;
+		sgs->sum_nr_running += rq->nr_running;
 #ifdef CONFIG_NUMA_BALANCING
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
-- 
1.8.4.474.g128a96c

