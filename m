Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaDNQ2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:28:02 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54339 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDNQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:59 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 34/38] tick-sched: remove local variable 'now' from tick_setup_sched_timer()
Date: Mon, 14 Apr 2014 21:53:56 +0530
Message-Id: <486aa1d8c01ac6ef4ab3e5d8110b9931016151b2.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local variable 'now' is used at only one place and so can be easily replaced by
ktime_get() instead.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a0a6705..78751b3 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1116,7 +1116,6 @@ early_param("skew_tick", skew_tick);
 void tick_setup_sched_timer(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
-	ktime_t now = ktime_get();
 
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
@@ -1136,13 +1135,12 @@ void tick_setup_sched_timer(void)
 	}
 
 	for (;;) {
-		hrtimer_forward(&ts->sched_timer, now, tick_period);
+		hrtimer_forward(&ts->sched_timer, ktime_get(), tick_period);
 		hrtimer_start_expires(&ts->sched_timer,
 				      HRTIMER_MODE_ABS_PINNED);
 		/* Check, if the timer was already in the past */
 		if (hrtimer_active(&ts->sched_timer))
 			break;
-		now = ktime_get();
 	}
 
 #ifdef CONFIG_NO_HZ_COMMON
-- 
1.7.12.rc2.18.g61b472e

