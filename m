Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaDUJ5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:57:11 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:46702 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaDUJ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:57:04 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 17/19] tick-sched: remove local variable 'now' from tick_setup_sched_timer()
Date: Mon, 21 Apr 2014 15:25:13 +0530
Message-Id: <854b0c5813797f9f146dc4a9d94c8e21d47c1e64.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local variable 'now' is used at only one place and so can be replaced by
ktime_get() instead.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2360e7a..4a94412 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1120,7 +1120,6 @@ early_param("skew_tick", skew_tick);
 void tick_setup_sched_timer(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
-	ktime_t now = ktime_get();
 
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
@@ -1140,13 +1139,12 @@ void tick_setup_sched_timer(void)
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

