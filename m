Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaC1LnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:43:20 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:64102 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaC1LnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:43:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 12/16] hrtimer: rewrite switch_hrtimer_base() to remove extra indentation level
Date: Fri, 28 Mar 2014 17:11:31 +0530
Message-Id: <b56d3fcdc21abee9d394b8045413ed032d85abf2.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete bottom part of switch_hrtimer_base() is part of a 'if' block and so all
code present in that block has extra indentation level before it. Rewrite it to
remove this extra indentation level.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 04f8e44..30efa1c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -203,33 +203,33 @@ again:
 	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
 	new_base = &new_cpu_base->clock_base[base->index];
 
-	if (base != new_base) {
-		/*
-		 * We are trying to move timer to new_base.
-		 * However we can't change timer's base while it is running,
-		 * so we keep it on the same CPU. No hassle vs. reprogramming
-		 * the event source in the high resolution case. The softirq
-		 * code will take care of this when the timer function has
-		 * completed. There is no conflict as we hold the lock until
-		 * the timer is enqueued.
-		 */
-		if (unlikely(hrtimer_callback_running(timer)))
-			return;
+	if (base == new_base)
+		return;
 
-		/* See the comment in lock_timer_base() */
-		timer->base = NULL;
-		raw_spin_unlock(&base->cpu_base->lock);
-		raw_spin_lock(&new_base->cpu_base->lock);
+	/*
+	 * We are trying to move timer to new_base. However we can't change
+	 * timer's base while it is running, so we keep it on the same CPU. No
+	 * hassle vs. reprogramming the event source in the high resolution
+	 * case. The softirq code will take care of this when the timer function
+	 * has completed. There is no conflict as we hold the lock until the
+	 * timer is enqueued.
+	 */
+	if (unlikely(hrtimer_callback_running(timer)))
+		return;
 
-		if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
-			cpu = this_cpu;
-			raw_spin_unlock(&new_base->cpu_base->lock);
-			raw_spin_lock(&base->cpu_base->lock);
-			timer->base = base;
-			goto again;
-		}
-		timer->base = new_base;
+	/* See the comment in lock_timer_base() */
+	timer->base = NULL;
+	raw_spin_unlock(&base->cpu_base->lock);
+	raw_spin_lock(&new_base->cpu_base->lock);
+
+	if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
+		cpu = this_cpu;
+		raw_spin_unlock(&new_base->cpu_base->lock);
+		raw_spin_lock(&base->cpu_base->lock);
+		timer->base = base;
+		goto again;
 	}
+	timer->base = new_base;
 }
 
 #else /* CONFIG_SMP */
-- 
1.7.12.rc2.18.g61b472e

