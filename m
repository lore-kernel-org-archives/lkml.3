Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaAFLfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:35:05 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:42758 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaAFLfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:35:00 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        preeti.lkml@gmail.com
Subject: [PATCH V2 4/8] sched: remove unused parameter for find_new_ilb
Date: Mon,  6 Jan 2014 12:34:41 +0100
Message-Id: <1389008085-9069-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'call_cpu' is never used in the function. Remove it.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 82dd145..1f7ed1a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6502,7 +6502,7 @@ static struct {
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
-static inline int find_new_ilb(int call_cpu)
+static inline int find_new_ilb(void)
 {
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
 
@@ -6523,7 +6523,7 @@ static void nohz_balancer_kick(int cpu)
 
 	nohz.next_balance++;
 
-	ilb_cpu = find_new_ilb(cpu);
+	ilb_cpu = find_new_ilb();
 
 	if (ilb_cpu >= nr_cpu_ids)
 		return;
-- 
1.7.9.5

