Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaAMP4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:56:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaAMP4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:56:40 -0500
Date: Mon, 13 Jan 2014 07:56:08 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-0aeeeebac8d8304501680f12862784341f4bee7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
In-Reply-To: <1389008085-9069-6-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-6-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Remove unused parameter from nohz_balancer_kick()
Git-Commit-ID: 0aeeeebac8d8304501680f12862784341f4bee7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:56:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0aeeeebac8d8304501680f12862784341f4bee7b
Gitweb:     http://git.kernel.org/tip/0aeeeebac8d8304501680f12862784341f4bee7b
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 6 Jan 2014 12:34:42 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:30 +0100

sched: Remove unused parameter from nohz_balancer_kick()

The cpu parameter is no longer needed in nohz_balancer_kick, let's remove
the parameter.

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389008085-9069-6-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5fda3c4..b91cd93 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6524,7 +6524,7 @@ static inline int find_new_ilb(void)
  * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
  * CPU (if there is one).
  */
-static void nohz_balancer_kick(int cpu)
+static void nohz_balancer_kick(void)
 {
 	int ilb_cpu;
 
@@ -6878,15 +6878,13 @@ static inline int on_null_domain(struct rq *rq)
  */
 void trigger_load_balance(struct rq *rq)
 {
-	int cpu = rq->cpu;
-
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(rq)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ_COMMON
 	if (nohz_kick_needed(rq) && likely(!on_null_domain(rq)))
-		nohz_balancer_kick(cpu);
+		nohz_balancer_kick();
 #endif
 }
 
