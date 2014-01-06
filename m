Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaAFLg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:36:26 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63522 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaAFLfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:35:03 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        preeti.lkml@gmail.com
Subject: [PATCH V2 5/8] sched: remove unused parameter in nohz_balancer_kick function
Date: Mon,  6 Jan 2014 12:34:42 +0100
Message-Id: <1389008085-9069-6-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu parameter is no longer needed in nohz_balancer_kick, let's remove
the parameter.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
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

