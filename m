Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3HOLOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:14:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50431 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3HOLOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:14:44 -0400
Date: Thu, 15 Aug 2013 13:14:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 3/3] sched: clean-up struct sd_lb_stat
Message-ID: <20130815111428.GP24092@twins.programming.kicks-ass.net>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com>
 <20130815110905.GO24092@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815110905.GO24092@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another little diff.


--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4647,8 +4647,10 @@ static inline void update_sd_lb_stats(st
 		int local_group;
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
-		if (local_group)
+		if (local_group) {
+			sds->this = sg;
 			sgs = &sds->this_stat;
+		}
 
 		memset(sgs, 0, sizeof(*sgs));
 		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
@@ -4671,9 +4673,7 @@ static inline void update_sd_lb_stats(st
 		sds->total_load += sgs->group_load;
 		sds->total_pwr += sg->sgp->power;
 
-		if (local_group)
-			sds->this = sg;
-		else if (update_sd_pick_busiest(env, sds, sg, sgs)) {
+		if (!local_group && update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
 			sds->busiest_stat = *sgs;
 		}
