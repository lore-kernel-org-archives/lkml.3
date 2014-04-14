Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaDNQYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:24:22 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:32906 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbaDNQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:24:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 01/38] tick: align to Coding Guidelines
Date: Mon, 14 Apr 2014 21:53:23 +0530
Message-Id: <ce2b4fe3fa2e5be273017834412a197d653518e3.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does some trivial fixups:
- breaking lines longer than 80 columns
- merging few lines together
- don't break print messages even if they cross 80 columns
- remove few whitespaces
- remove few extra blank lines

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h         |  3 ++-
 kernel/time/tick-broadcast.c | 16 ++++++----------
 kernel/time/tick-internal.h  |  5 ++++-
 kernel/time/tick-oneshot.c   |  3 +--
 kernel/time/tick-sched.c     | 29 ++++++++++++++++-------------
 5 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..8c865fb 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -47,7 +47,8 @@ enum tick_nohz_mode {
  * @idle_waketime:	Time when the idle was interrupted
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
- * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
+ * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped,
+ *			with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
  * @do_timer_lst:	CPU was the last one doing do_timer before going idle
  */
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 64c5990..c4c50ba 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -132,7 +132,6 @@ int tick_broadcast_update_freq(struct clock_event_device *dev, u32 freq)
 	return ret;
 }
 
-
 static void err_broadcast(const struct cpumask *mask)
 {
 	pr_crit_once("Failed to broadcast timer tick. Some CPUs may be unresponsive.\n");
@@ -358,8 +357,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		cpumask_set_cpu(cpu, tick_broadcast_on);
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_mask)) {
-			if (tick_broadcast_device.mode ==
-			    TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
 		}
 		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
@@ -372,8 +370,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 		if (!tick_device_is_functional(dev))
 			break;
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
-			if (tick_broadcast_device.mode ==
-			    TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
 		}
 		break;
@@ -399,8 +396,8 @@ out:
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
 	if (!cpumask_test_cpu(*oncpu, cpu_online_mask))
-		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
-		       "offline CPU #%d\n", *oncpu);
+		printk(KERN_ERR "tick-broadcast: ignoring broadcast for offline CPU #%d\n",
+		       *oncpu);
 	else
 		tick_do_broadcast_on_off(&reason);
 }
@@ -484,7 +481,6 @@ int tick_resume_broadcast(void)
 	return broadcast;
 }
 
-
 #ifdef CONFIG_TICK_ONESHOT
 
 static cpumask_var_t tick_broadcast_oneshot_mask;
@@ -727,7 +723,8 @@ int tick_broadcast_oneshot_control(unsigned long reason)
 			 */
 			if (!cpumask_test_cpu(cpu, tick_broadcast_force_mask) &&
 			    dev->next_event.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
+				tick_broadcast_set_event(bc, cpu,
+							 dev->next_event, 1);
 		}
 		/*
 		 * If the current CPU owns the hrtimer broadcast
@@ -894,7 +891,6 @@ void tick_broadcast_switch_to_oneshot(void)
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
-
 /*
  * Remove a dead CPU from broadcasting
  */
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 7ab92b1..855c513 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -87,7 +87,10 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
-static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
+static inline int tick_broadcast_oneshot_control(unsigned long reason)
+{
+	return 0;
+}
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 8241090..e04d5a0 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -65,8 +65,7 @@ int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
 		    !tick_device_is_functional(dev)) {
 
-		printk(KERN_INFO "Clockevents: "
-		       "could not switch to one-shot mode:");
+		printk(KERN_INFO "Clockevents: could not switch to one-shot mode:");
 		if (!dev) {
 			printk(" no tick device\n");
 		} else {
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9f8af69..d48d648 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -105,7 +105,6 @@ static ktime_t tick_init_jiffy_update(void)
 	return period;
 }
 
-
 static void tick_sched_do_timer(ktime_t now)
 {
 	int cpu = smp_processor_id();
@@ -245,8 +244,8 @@ void tick_nohz_full_kick_all(void)
 		return;
 
 	preempt_disable();
-	smp_call_function_many(tick_nohz_full_mask,
-			       nohz_full_kick_ipi, NULL, false);
+	smp_call_function_many(tick_nohz_full_mask, nohz_full_kick_ipi, NULL,
+			       false);
 	tick_nohz_full_kick();
 	preempt_enable();
 }
@@ -285,7 +284,8 @@ static int __init tick_nohz_full_setup(char *str)
 
 	cpu = smp_processor_id();
 	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
-		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
+		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n",
+			   cpu);
 		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
 	}
 	tick_nohz_full_running = true;
@@ -295,8 +295,7 @@ static int __init tick_nohz_full_setup(char *str)
 __setup("nohz_full=", tick_nohz_full_setup);
 
 static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
-						 unsigned long action,
-						 void *hcpu)
+				       unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
@@ -350,7 +349,8 @@ void __init tick_nohz_init(void)
 		context_tracking_cpu_set(cpu);
 
 	cpu_notifier(tick_nohz_cpu_down_callback, 0);
-	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), tick_nohz_full_mask);
+	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf),
+			  tick_nohz_full_mask);
 	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
 }
 #endif
@@ -362,8 +362,8 @@ void __init tick_nohz_init(void)
 /*
  * NO HZ enabled ?
  */
-static int tick_nohz_enabled __read_mostly  = 1;
-int tick_nohz_active  __read_mostly;
+static int tick_nohz_enabled __read_mostly = 1;
+int tick_nohz_active __read_mostly;
 /*
  * Enable / Disable tickless mode
  */
@@ -407,16 +407,19 @@ static void tick_nohz_update_jiffies(ktime_t now)
  * Updates the per cpu time idle statistics counters
  */
 static void
-update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_update_time)
+update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now,
+		     u64 *last_update_time)
 {
 	ktime_t delta;
 
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		if (nr_iowait_cpu(cpu) > 0)
-			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime,
+							 delta);
 		else
-			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime,
+						       delta);
 		ts->idle_entrytime = now;
 	}
 
@@ -873,7 +876,7 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	/*
 	 * Cancel the scheduled timer and restore the tick
 	 */
-	ts->tick_stopped  = 0;
+	ts->tick_stopped = 0;
 	ts->idle_exittime = now;
 
 	tick_nohz_restart(ts, now);
-- 
1.7.12.rc2.18.g61b472e

