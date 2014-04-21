Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaDUJ4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:56:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62008 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaDUJzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:55:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 04/19] tick: move declaration of 'tick_cpu_device' to tick.h
Date: Mon, 21 Apr 2014 15:25:00 +0530
Message-Id: <a09cbeb8e209f2beae2f8efb515bbba704525a72.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'tick_cpu_device' isn't local to kernel/time/ directory as it is declared in
hrtimer.h as well. Move its declaration to tick.h.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/hrtimer.h     | 3 ---
 include/linux/tick.h        | 2 ++
 kernel/time/tick-internal.h | 1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index e7a8d3f..a31f83e 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -332,9 +332,6 @@ extern ktime_t ktime_get_clocktai(void);
 extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 					 ktime_t *offs_tai);
 
-DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
-
-
 /* Exported timer functions: */
 
 /* Initialize timers: */
diff --git a/include/linux/tick.h b/include/linux/tick.h
index edabc7d..1a9908a 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -85,6 +85,8 @@ struct tick_sched {
 
 extern void __init tick_init(void);
 extern int tick_is_oneshot_available(void);
+
+DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern struct tick_device *tick_get_device(int cpu);
 
 # ifdef CONFIG_HIGH_RES_TIMERS
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 855c513..57c1a76 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -13,7 +13,6 @@ extern seqlock_t jiffies_lock;
 #define TICK_DO_TIMER_NONE	-1
 #define TICK_DO_TIMER_BOOT	-2
 
-DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern ktime_t tick_next_period;
 extern ktime_t tick_period;
 extern int tick_do_timer_cpu __read_mostly;
-- 
1.7.12.rc2.18.g61b472e

