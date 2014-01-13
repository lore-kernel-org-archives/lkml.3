Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaAMP4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:56:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60855 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaAMP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:56:08 -0500
Date: Mon, 13 Jan 2014 07:55:29 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-7caff66f361c44d0fbc74ed1cfa60a357fc84cf2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1389008085-9069-2-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-2-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Reduce trigger_load_balance() parameters
Git-Commit-ID: 7caff66f361c44d0fbc74ed1cfa60a357fc84cf2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:55:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7caff66f361c44d0fbc74ed1cfa60a357fc84cf2
Gitweb:     http://git.kernel.org/tip/7caff66f361c44d0fbc74ed1cfa60a357fc84cf2
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 6 Jan 2014 12:34:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:26 +0100

sched: Reduce trigger_load_balance() parameters

The cpu information is already stored in the struct rq, so no need to pass it
as parameter to the trigger_load_balance function.

Cc: linaro-kernel@lists.linaro.org
Cc: preeti.lkml@gmail.com
Cc: mingo@redhat.com
Cc: peterz@infradead.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389008085-9069-2-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 2 +-
 kernel/sched/fair.c  | 4 +++-
 kernel/sched/sched.h | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a549d9a..392c6f8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2436,7 +2436,7 @@ void scheduler_tick(void)
 
 #ifdef CONFIG_SMP
 	rq->idle_balance = idle_cpu(cpu);
-	trigger_load_balance(rq, cpu);
+	trigger_load_balance(rq);
 #endif
 	rq_last_tick_reset(rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b73f4ba..b35d322 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6876,8 +6876,10 @@ static inline int on_null_domain(int cpu)
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  */
-void trigger_load_balance(struct rq *rq, int cpu)
+void trigger_load_balance(struct rq *rq)
 {
+	int cpu = rq->cpu;
+
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(cpu)))
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 890339099..c2119fd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1175,7 +1175,7 @@ extern const struct sched_class idle_sched_class;
 
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
-extern void trigger_load_balance(struct rq *rq, int cpu);
+extern void trigger_load_balance(struct rq *rq);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
