Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaC1Ln2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:43:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50866 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaC1LnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:43:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 13/16] hrtimer: rewrite remove_hrtimer() to remove extra indentation level
Date: Fri, 28 Mar 2014 17:11:32 +0530
Message-Id: <fccd30d06593b9a58f211c11d9e596b2e071ea71.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete bottom part of remove_hrtimer() is part of a 'if' block and so all code
present in that block has extra indentation level before it. Rewrite it to
remove this extra indentation level.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 30efa1c..0ae0fbf 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -896,32 +896,29 @@ static void __remove_hrtimer(struct hrtimer *timer, unsigned long newstate,
 /* remove hrtimer, called with base lock held */
 static inline int remove_hrtimer(struct hrtimer *timer)
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
-		reprogram =
-			timer->base->cpu_base == &__get_cpu_var(hrtimer_bases);
-		/*
-		 * We must preserve the CALLBACK state flag here,
-		 * otherwise we could move the timer base in
-		 * switch_hrtimer_base.
-		 */
-		state = timer->state & HRTIMER_STATE_CALLBACK;
-		__remove_hrtimer(timer, state, reprogram);
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
+	__remove_hrtimer(timer, state,
+			timer->base->cpu_base == &__get_cpu_var(hrtimer_bases));
+	return 1;
 }
 
 int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
-- 
1.7.12.rc2.18.g61b472e

