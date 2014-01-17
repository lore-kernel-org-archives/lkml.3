Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaAQJEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:04:20 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44225 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaAQJEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:04:08 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        alex.shi@linaro.org
Subject: [PATCH 1/4] sched: Remove 'cpu' parameter for idle_balance()
Date: Fri, 17 Jan 2014 10:04:01 +0100
Message-Id: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu parameter passed to idle_balance is not needed as it could
be retrieved from the struct rq.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/core.c  |    2 +-
 kernel/sched/fair.c  |    3 ++-
 kernel/sched/sched.h |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 36c951b..cf51601 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2680,7 +2680,7 @@ need_resched:
 	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
+		idle_balance(rq);
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b24b6cf..d601df3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6359,12 +6359,13 @@ out:
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
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c2119fd..b0be4c6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1176,7 +1176,7 @@ extern const struct sched_class idle_sched_class;
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern void idle_balance(int this_cpu, struct rq *this_rq);
+extern void idle_balance(struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
-- 
1.7.9.5

