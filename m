Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab3K0OLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:11:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47803 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab3K0OLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:11:25 -0500
Date: Wed, 27 Nov 2013 06:10:49 -0800
From: tip-bot for Kamalesh Babulal <tipbot@zytor.com>
Message-ID: <tip-380c9077b38df2962a22f00f21f6cd0db62d3390@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1384508212-25032-1-git-send-email-kamalesh@linux.vnet.ibm.com>
References: <1384508212-25032-1-git-send-email-kamalesh@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Clean up update_sg_lb_stats() a bit
Git-Commit-ID: 380c9077b38df2962a22f00f21f6cd0db62d3390
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:10:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  380c9077b38df2962a22f00f21f6cd0db62d3390
Gitweb:     http://git.kernel.org/tip/380c9077b38df2962a22f00f21f6cd0db62d3390
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Fri, 15 Nov 2013 15:06:52 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 13:50:57 +0100

sched/fair: Clean up update_sg_lb_stats() a bit

Add rq->nr_running to sgs->sum_nr_running directly instead of
assigning it through an intermediate variable nr_running.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1384508212-25032-1-git-send-email-kamalesh@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6cb36c7..a566c07 100644
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
