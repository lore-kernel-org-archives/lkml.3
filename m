Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaDNQYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:24:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32994 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbaDNQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:24:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 03/38] tick: rearrange members of 'struct tick_sched'
Date: Mon, 14 Apr 2014 21:53:25 +0530
Message-Id: <d657f04837cbb19e08fd6661ecd3364977ef6bb2.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange members of 'struct tick_sched' to make it more readable. i.e. By
keeping all ktime_t members together, similarly 'unsigned long' and 'int' as
well. I couldn't figure out breaking any logical blocks here which we wanted to
keep together.

This is the change in footprints after this change.
For x86: size of this structure changed from 240 to 232 bytes
For ARM: didn't see a difference, was 160 bytes

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 8cc804c..edabc7d 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -35,19 +35,17 @@ enum tick_nohz_mode {
  * struct tick_sched - sched tick emulation and no idle tick control/stats
  * @sched_timer:	hrtimer to schedule the periodic tick in high
  *			resolution mode
- * @check_clocks:	tracks if clockevent device is recently changed
  * @nohz_mode:		Current NOHZ mode
+ * @check_clocks:	tracks if clockevent device is recently changed
+ * @idle_jiffies:	jiffies at the entry to idle for idle time accounting
+ * @idle_calls:		Total number of idle calls
+ * @idle_sleeps:	Number of idle calls, where the sched tick was stopped
+ * @last_jiffies:	Last updated value of jiffies
+ * @next_jiffies:	Next jiffie for which timer is requested
  * @last_tick:		Store the last tick expiry time when the tick
  *			timer is modified for nohz sleeps. This is necessary
  *			to resume the tick timer operation in the timeline
  *			when the CPU returns from nohz sleep.
- * @inidle:		CPU is currently executing from within the idle loop
- * @tick_stopped:	Indicator that the idle tick has been stopped
- * @idle_jiffies:	jiffies at the entry to idle for idle time accounting
- * @idle_calls:		Total number of idle calls
- * @idle_sleeps:	Number of idle calls, where the sched tick was stopped
- * @idle_active:	similar to inidle, but is reset when we get an interrupt
- *			while being in idle
  * @idle_entrytime:	Time when the idle call was entered
  * @idle_waketime:	Time when the idle was interrupted
  * @idle_exittime:	Time when the idle state was left
@@ -55,31 +53,33 @@ enum tick_nohz_mode {
  * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped,
  *			with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
- * @last_jiffies:	Last updated value of jiffies
- * @next_jiffies:	Next jiffie for which timer is requested
  * @idle_expires:	Time when we should come out of idle or next timer event
+ * @inidle:		CPU is currently executing from within the idle loop
+ * @idle_active:	similar to inidle, but is reset when we get an interrupt
+ *			while being in idle
+ * @tick_stopped:	Indicator that the idle tick has been stopped
  * @do_timer_last:	CPU was the last one doing do_timer before going idle
  */
 struct tick_sched {
 	struct hrtimer			sched_timer;
-	unsigned long			check_clocks;
 	enum tick_nohz_mode		nohz_mode;
-	ktime_t				last_tick;
-	int				inidle;
-	int				tick_stopped;
+	unsigned long			check_clocks;
 	unsigned long			idle_jiffies;
 	unsigned long			idle_calls;
 	unsigned long			idle_sleeps;
-	int				idle_active;
+	unsigned long			last_jiffies;
+	unsigned long			next_jiffies;
+	ktime_t				last_tick;
 	ktime_t				idle_entrytime;
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				iowait_sleeptime;
 	ktime_t				sleep_length;
-	unsigned long			last_jiffies;
-	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
+	int				inidle;
+	int				idle_active;
+	int				tick_stopped;
 	int				do_timer_last;
 };
 
-- 
1.7.12.rc2.18.g61b472e

