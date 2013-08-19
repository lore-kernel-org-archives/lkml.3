Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3HSQQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:16:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3HSQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:13:26 -0400
Message-Id: <20130819160425.527872672@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 18:01:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 07/10] sched, fair: Optimize find_busiest_queue()
References: <20130819160058.539049611@infradead.org>
Content-Disposition: inline; filename=peterz-more-bfg-cleanups-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_cpu_and() and thereby avoid computing the capacity for
CPUs we know we're not interested in.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4977,7 +4977,7 @@ static struct rq *find_busiest_queue(str
 	unsigned long busiest_load = 0, busiest_power = SCHED_POWER_SCALE;
 	int i;
 
-	for_each_cpu(i, sched_group_cpus(group)) {
+	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		unsigned long power = power_of(i);
 		unsigned long capacity = DIV_ROUND_CLOSEST(power,
 							   SCHED_POWER_SCALE);
@@ -4986,9 +4986,6 @@ static struct rq *find_busiest_queue(str
 		if (!capacity)
 			capacity = fix_small_capacity(env->sd, group);
 
-		if (!cpumask_test_cpu(i, env->cpus))
-			continue;
-
 		rq = cpu_rq(i);
 		wl = weighted_cpuload(i);
 


