Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3L3Nrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:47:42 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:53288 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab3L3NpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:45:01 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 4/7] sched: remove unused parameter in nohz_balancer_kick function
Date: Mon, 30 Dec 2013 14:44:50 +0100
Message-Id: <1388411093-3413-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu parameter is no longer needed in nohz_balancer_kick, let's remove
the parameter.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/fair.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1f7ed1a..c647c45 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6517,7 +6517,7 @@ static inline int find_new_ilb(void)
  * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
  * CPU (if there is one).
  */
-static void nohz_balancer_kick(int cpu)
+static void nohz_balancer_kick(void)
 {
 	int ilb_cpu;
 
@@ -6871,15 +6871,13 @@ static inline int on_null_domain(struct rq *rq)
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
 
-- 
1.7.9.5

