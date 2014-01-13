Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaAMP4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:56:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60874 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaAMP40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:56:26 -0500
Date: Mon, 13 Jan 2014 07:55:49 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-63f609b160151c9e86b26b935c9671a23afe299f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1389008085-9069-4-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-4-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Pass 'struct rq' to on_null_domain()
Git-Commit-ID: 63f609b160151c9e86b26b935c9671a23afe299f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:55:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63f609b160151c9e86b26b935c9671a23afe299f
Gitweb:     http://git.kernel.org/tip/63f609b160151c9e86b26b935c9671a23afe299f
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 6 Jan 2014 12:34:40 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:28 +0100

sched: Pass 'struct rq' to on_null_domain()

The on_null_domain() function is getting the cpu to retrieve the struct rq
associated with it.

Pass 'struct rq' directly to the function as the caller already has the info.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389008085-9069-4-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c47b1ce..fc0afc5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6868,9 +6868,9 @@ static void run_rebalance_domains(struct softirq_action *h)
 	nohz_idle_balance(this_cpu, idle);
 }
 
-static inline int on_null_domain(int cpu)
+static inline int on_null_domain(struct rq *rq)
 {
-	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
+	return !rcu_dereference_sched(rq->sd);
 }
 
 /*
@@ -6882,10 +6882,10 @@ void trigger_load_balance(struct rq *rq)
 
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
-	    likely(!on_null_domain(cpu)))
+	    likely(!on_null_domain(rq)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ_COMMON
-	if (nohz_kick_needed(rq) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq) && likely(!on_null_domain(rq)))
 		nohz_balancer_kick(cpu);
 #endif
 }
