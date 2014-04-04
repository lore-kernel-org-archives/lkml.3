Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaDDGlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:45 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:52532 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaDDGlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 19/36] hrtimer: rewrite remove_hrtimer() to remove extra indentation level
Date: Fri,  4 Apr 2014 12:06:02 +0530
Message-Id: <7ec75008ea6342e7dfac95c6a9cc8bf77b8ba153.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete bottom part of remove_hrtimer() is part of a 'if' block and so all code
present in that block has extra indentation level before it. Rewrite it to
remove this extra indentation level.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index fe13dcf..2ac423d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -913,31 +913,29 @@ static void __remove_hrtimer(struct hrtimer *timer,
 static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
-	if (hrtimer_is_queued(timer)) {
-		unsigned long state;
-		int reprogram;
+	unsigned long state;
 
-		/*
-		 * Remove the timer and force reprogramming when high
-		 * resolution mode is active and the timer is on the current
-		 * CPU. If we remove a timer on another CPU, reprogramming is
-		 * skipped. The interrupt event on this CPU is fired and
-		 * reprogramming happens in the interrupt handler. This is a
-		 * rare case and less expensive than a smp call.
-		 */
-		debug_deactivate(timer);
-		timer_stats_hrtimer_clear_start_info(timer);
-		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
-		/*
-		 * We must preserve the CALLBACK state flag here,
-		 * otherwise we could move the timer base in
-		 * switch_hrtimer_base.
-		 */
-		state = timer->state & HRTIMER_STATE_CALLBACK;
-		__remove_hrtimer(timer, base, state, reprogram);
-		return 1;
-	}
-	return 0;
+	if (!hrtimer_is_queued(timer))
+		return 0;
+
+	/*
+	 * Remove the timer and force reprogramming when high resolution mode is
+	 * active and the timer is on the current CPU. If we remove a timer on
+	 * another CPU, reprogramming is skipped. The interrupt event on this
+	 * CPU is fired and reprogramming happens in the interrupt handler. This
+	 * is a rare case and less expensive than a smp call.
+	 */
+	debug_deactivate(timer);
+	timer_stats_hrtimer_clear_start_info(timer);
+
+	/*
+	 * We must preserve the CALLBACK state flag here, otherwise we could
+	 * move the timer base in switch_hrtimer_base.
+	 */
+	state = timer->state & HRTIMER_STATE_CALLBACK;
+	__remove_hrtimer(timer, base, state,
+			 base->cpu_base == &__get_cpu_var(hrtimer_bases));
+	return 1;
 }
 
 int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
-- 
1.7.12.rc2.18.g61b472e

