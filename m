Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaAUL3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:29:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51884 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbaAUL31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:29:27 -0500
Message-Id: <20140121112258.274565098@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 21 Jan 2014 12:17:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/9] sched: Remove cpu parameter for idle_balance()
References: <20140121111754.580142558@infradead.org>
Content-Disposition: inline; filename=daniel_lezcano-1_sched-remove__cpu__parameter_for_idle_balance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

The cpu parameter passed to idle_balance is not needed as it could
be retrieved from the struct rq.

Cc: alex.shi@linaro.org
Cc: peterz@infradead.org
Cc: mingo@kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org
---
 kernel/sched/core.c  |    2 +-
 kernel/sched/fair.c  |    3 ++-
 kernel/sched/sched.h |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2680,7 +2680,7 @@ static void __sched __schedule(void)
 	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
+		idle_balance(rq);
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6359,12 +6359,13 @@ static int load_balance(int this_cpu, st
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-void idle_balance(int this_cpu, struct rq *this_rq)
+void idle_balance(struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 	u64 curr_cost = 0;
+	int this_cpu = this_rq->cpu;
 
 	this_rq->idle_stamp = rq_clock(this_rq);
 
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1176,7 +1176,7 @@ extern const struct sched_class idle_sch
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern void idle_balance(int this_cpu, struct rq *this_rq);
+extern void idle_balance(struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);


