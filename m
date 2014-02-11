Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaBKMQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:16:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46469 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaBKMQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:16:20 -0500
Date: Tue, 11 Feb 2014 04:15:38 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-b4f2ab43615e5b36c48fffa99f26aca381839ac6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove 'cpu' parameter from idle_balance(
 )
Git-Commit-ID: b4f2ab43615e5b36c48fffa99f26aca381839ac6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:15:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4f2ab43615e5b36c48fffa99f26aca381839ac6
Gitweb:     http://git.kernel.org/tip/b4f2ab43615e5b36c48fffa99f26aca381839ac6
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Fri, 17 Jan 2014 10:04:01 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Feb 2014 16:17:01 +0100

sched: Remove 'cpu' parameter from idle_balance()

The cpu parameter passed to idle_balance() is not needed as it could
be retrieved from 'struct rq.'

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: alex.shi@linaro.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 2 +-
 kernel/sched/fair.c  | 3 ++-
 kernel/sched/sched.h | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 104c816..74dd565 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2705,7 +2705,7 @@ need_resched:
 	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
+		idle_balance(rq);
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4caa803..428bc9d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6531,12 +6531,13 @@ out:
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
index b44720d..82c0e02 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1158,7 +1158,7 @@ extern const struct sched_class idle_sched_class;
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern void idle_balance(int this_cpu, struct rq *this_rq);
+extern void idle_balance(struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
