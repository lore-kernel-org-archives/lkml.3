Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaDNQ0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:26:49 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52268 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbaDNQ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:26:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 24/38] tick-sched: don't check tick_nohz_full_cpu() in __tick_nohz_task_switch()
Date: Mon, 14 Apr 2014 21:53:46 +0530
Message-Id: <ec2173fa3a7e754e45fb9409e44f77fa051610b7.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__tick_nohz_task_switch() calls tick_nohz_full_kick(), which is already checking
tick_nohz_full_cpu() and so we don't need to repeat the same check here.

Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 256f4a3..5a99859 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -261,13 +261,9 @@ void __tick_nohz_task_switch(struct task_struct *tsk)
 
 	local_irq_save(flags);
 
-	if (!tick_nohz_full_cpu(smp_processor_id()))
-		goto out;
-
 	if (tick_nohz_tick_stopped() && !can_stop_full_tick())
 		tick_nohz_full_kick();
 
-out:
 	local_irq_restore(flags);
 }
 
-- 
1.7.12.rc2.18.g61b472e

