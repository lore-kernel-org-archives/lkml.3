Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808Ab3GRSMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:12:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35567 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3GRSMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:12:09 -0400
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yacine.belkadi.1@gmail.com
Subject: [PATCH] hrtimer, timer: fix some scripts/kernel-doc warnings
Date: Thu, 18 Jul 2013 20:11:42 +0200
Message-Id: <1374171102-2048-1-git-send-email-yacine.belkadi.1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building the htmldocs (in verbose mode), scripts/kernel-doc reports the
following type of warnings:

Warning(kernel/timer.c:230): No description found for return value of
'round_jiffies'

Fix them by:
- Using "Return:" sections to introduce the descriptions of return values.
- Adding missing descriptions.

Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
---

Applied to d2b4a646717153a1a180b64d4a8464054dbd700e

 kernel/hrtimer.c |   27 +++++++++++++++++----------
 kernel/timer.c   |   40 ++++++++++++++++++++++++++++++----------
 2 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f0f4fe2..89696c9 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -277,7 +277,7 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
  * @kt:		addend
  * @nsec:	the scalar nsec value to add
  *
- * Returns the sum of kt and nsec in ktime_t format
+ * Return: The sum of @kt and @nsec in ktime_t format.
  */
 ktime_t ktime_add_ns(const ktime_t kt, u64 nsec)
 {
@@ -305,7 +305,7 @@ EXPORT_SYMBOL_GPL(ktime_add_ns);
  * @kt:		minuend
  * @nsec:	the scalar nsec value to subtract
  *
- * Returns the subtraction of @nsec from @kt in ktime_t format
+ * Return: The subtraction of @nsec from @kt in ktime_t format.
  */
 ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
 {
@@ -836,7 +836,8 @@ void unlock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
  * @interval:	the interval to forward
  *
  * Forward the timer expiry so it will expire in the future.
- * Returns the number of overruns.
+ *
+ * Return: The number of overruns.
  */
 u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
 {
@@ -1038,7 +1039,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
  * @mode:	expiry mode: absolute (HRTIMER_MODE_ABS) or
  *		relative (HRTIMER_MODE_REL)
  *
- * Returns:
+ * Return:
  *  0 on success
  *  1 when the timer was active
  */
@@ -1056,7 +1057,7 @@ EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
  * @mode:	expiry mode: absolute (HRTIMER_MODE_ABS) or
  *		relative (HRTIMER_MODE_REL)
  *
- * Returns:
+ * Return:
  *  0 on success
  *  1 when the timer was active
  */
@@ -1072,7 +1073,7 @@ EXPORT_SYMBOL_GPL(hrtimer_start);
  * hrtimer_try_to_cancel - try to deactivate a timer
  * @timer:	hrtimer to stop
  *
- * Returns:
+ * Return:
  *  0 when the timer was not active
  *  1 when the timer was active
  * -1 when the timer is currently excuting the callback function and
@@ -1100,7 +1101,7 @@ EXPORT_SYMBOL_GPL(hrtimer_try_to_cancel);
  * hrtimer_cancel - cancel a timer and wait for the handler to finish.
  * @timer:	the timer to be cancelled
  *
- * Returns:
+ * Return:
  *  0 when the timer was not active
  *  1 when the timer was active
  */
@@ -1119,6 +1120,8 @@ EXPORT_SYMBOL_GPL(hrtimer_cancel);
 /**
  * hrtimer_get_remaining - get remaining time for the timer
  * @timer:	the timer to read
+ *
+ * Return: The remaining time for @timer.
  */
 ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 {
@@ -1137,7 +1140,7 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 /**
  * hrtimer_get_next_event - get the time until next expiry event
  *
- * Returns the delta to the next expiry event or KTIME_MAX if no timer
+ * Return: The delta to the next expiry event or KTIME_MAX if no timer
  * is pending.
  */
 ktime_t hrtimer_get_next_event(void)
@@ -1220,6 +1223,8 @@ EXPORT_SYMBOL_GPL(hrtimer_init);
  *
  * Store the resolution of the clock selected by @which_clock in the
  * variable pointed to by @tp.
+ *
+ * Return: 0
  */
 int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 {
@@ -1793,6 +1798,8 @@ void __init hrtimers_init(void)
  * @delta:	slack in expires timeout (ktime_t)
  * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
  * @clock:	timer clock, CLOCK_MONOTONIC or CLOCK_REALTIME
+ *
+ * Return: 0 when the timer has expired. Otherwise -EINTR.
  */
 int __sched
 schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
@@ -1864,7 +1871,7 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
  * The current task state is guaranteed to be TASK_RUNNING when this
  * routine returns.
  *
- * Returns 0 when the timer has expired otherwise -EINTR
+ * Return: 0 when the timer has expired. Otherwise -EINTR.
  */
 int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 				     const enum hrtimer_mode mode)
@@ -1894,7 +1901,7 @@ EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
  * The current task state is guaranteed to be TASK_RUNNING when this
  * routine returns.
  *
- * Returns 0 when the timer has expired otherwise -EINTR
+ * Return: 0 when the timer has expired. Otherwise -EINTR.
  */
 int __sched schedule_hrtimeout(ktime_t *expires,
 			       const enum hrtimer_mode mode)
diff --git a/kernel/timer.c b/kernel/timer.c
index 15bc1b4..3fe6ab0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -174,7 +174,7 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
  * processors firing at the exact same time, which could lead
  * to lock contention or spurious cache line bouncing.
  *
- * The return value is the rounded version of the @j parameter.
+ * Return: The rounded version of the @j parameter.
  */
 unsigned long __round_jiffies(unsigned long j, int cpu)
 {
@@ -200,7 +200,7 @@ EXPORT_SYMBOL_GPL(__round_jiffies);
  * processors firing at the exact same time, which could lead
  * to lock contention or spurious cache line bouncing.
  *
- * The return value is the rounded version of the @j parameter.
+ * Return: The rounded version of the @j parameter.
  */
 unsigned long __round_jiffies_relative(unsigned long j, int cpu)
 {
@@ -224,7 +224,7 @@ EXPORT_SYMBOL_GPL(__round_jiffies_relative);
  * at the same time, rather than at various times spread out. The goal
  * of this is to have the CPU wake up less, which saves power.
  *
- * The return value is the rounded version of the @j parameter.
+ * Return: The rounded version of the @j parameter.
  */
 unsigned long round_jiffies(unsigned long j)
 {
@@ -245,7 +245,7 @@ EXPORT_SYMBOL_GPL(round_jiffies);
  * at the same time, rather than at various times spread out. The goal
  * of this is to have the CPU wake up less, which saves power.
  *
- * The return value is the rounded version of the @j parameter.
+ * Return: The rounded version of the @j parameter.
  */
 unsigned long round_jiffies_relative(unsigned long j)
 {
@@ -262,6 +262,8 @@ EXPORT_SYMBOL_GPL(round_jiffies_relative);
  * round down.  This is useful for timeouts for which the exact time
  * of firing does not matter too much, as long as they don't fire too
  * early.
+ *
+ * Return: The rounded version of the @j parameter.
  */
 unsigned long __round_jiffies_up(unsigned long j, int cpu)
 {
@@ -278,6 +280,8 @@ EXPORT_SYMBOL_GPL(__round_jiffies_up);
  * round down.  This is useful for timeouts for which the exact time
  * of firing does not matter too much, as long as they don't fire too
  * early.
+ *
+ * Return: The rounded version of the @j parameter.
  */
 unsigned long __round_jiffies_up_relative(unsigned long j, int cpu)
 {
@@ -296,6 +300,8 @@ EXPORT_SYMBOL_GPL(__round_jiffies_up_relative);
  * round down.  This is useful for timeouts for which the exact time
  * of firing does not matter too much, as long as they don't fire too
  * early.
+ *
+ * Return: The rounded version of the @j parameter.
  */
 unsigned long round_jiffies_up(unsigned long j)
 {
@@ -311,6 +317,8 @@ EXPORT_SYMBOL_GPL(round_jiffies_up);
  * round down.  This is useful for timeouts for which the exact time
  * of firing does not matter too much, as long as they don't fire too
  * early.
+ *
+ * Return: The rounded version of the @j parameter.
  */
 unsigned long round_jiffies_up_relative(unsigned long j)
 {
@@ -783,6 +791,8 @@ out_unlock:
  * but will not re-activate and modify already deleted timers.
  *
  * It is useful for unserialized use of timers.
+ *
+ * Return: 1 if the timer was modified. 0 otherwise.
  */
 int mod_timer_pending(struct timer_list *timer, unsigned long expires)
 {
@@ -845,8 +855,8 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
  * same timer, then mod_timer() is the only safe way to modify the timeout,
  * since add_timer() cannot modify an already running timer.
  *
- * The function returns whether it has modified a pending timer or not.
- * (ie. mod_timer() of an inactive timer returns 0, mod_timer() of an
+ * Return: The function returns whether it has modified a pending timer or
+ * not. (ie. mod_timer() of an inactive timer returns 0, mod_timer() of an
  * active timer returns 1.)
  */
 int mod_timer(struct timer_list *timer, unsigned long expires)
@@ -874,6 +884,8 @@ EXPORT_SYMBOL(mod_timer);
  * active timer (if the timer is inactive it will be activated)
  * and to ensure that the timer is scheduled on the current CPU.
  *
+ * Return: 1 if the timer was modified. 0 otherwise.
+ *
  * Note that this does not prevent the timer from being migrated
  * when the current CPU goes offline.  If this is a problem for
  * you, use CPU-hotplug notifiers to handle it correctly, for
@@ -952,9 +964,9 @@ EXPORT_SYMBOL_GPL(add_timer_on);
  * del_timer() deactivates a timer - this works on both active and inactive
  * timers.
  *
- * The function returns whether it has deactivated a pending timer or not.
- * (ie. del_timer() of an inactive timer returns 0, del_timer() of an
- * active timer returns 1.)
+ * Return: The function returns whether it has deactivated a pending timer
+ * or not. (ie. del_timer() of an inactive timer returns 0, del_timer() of
+ * an active timer returns 1.)
  */
 int del_timer(struct timer_list *timer)
 {
@@ -981,6 +993,8 @@ EXPORT_SYMBOL(del_timer);
  *
  * This function tries to deactivate a timer. Upon successful (ret >= 0)
  * exit the timer is not queued and the handler is not running on any CPU.
+ *
+ * Return: >= 0 on success.
  */
 int try_to_del_timer_sync(struct timer_list *timer)
 {
@@ -1037,7 +1051,8 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  * The interrupt on the other CPU is waiting to grab somelock but
  * it has interrupted the softirq that CPU0 is waiting to finish.
  *
- * The function returns whether it has deactivated a pending timer or not.
+ * Return: The function returns whether it has deactivated a pending timer
+ * or not.
  */
 int del_timer_sync(struct timer_list *timer)
 {
@@ -1314,6 +1329,8 @@ static unsigned long cmp_next_hrtimer_event(unsigned long now,
 /**
  * get_next_timer_interrupt - return the jiffy of the next pending timer
  * @now: current time (in jiffies)
+ *
+ * Return: The jiffy of the next pending timer.
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
@@ -1673,6 +1690,9 @@ EXPORT_SYMBOL(msleep);
 /**
  * msleep_interruptible - sleep waiting for signals
  * @msecs: Time in milliseconds to sleep for
+ *
+ * Return: 0 if the sleep was not interrupted by a signal. Otherwise,
+ * the remaining time in jiffies.
  */
 unsigned long msleep_interruptible(unsigned int msecs)
 {
-- 
1.7.10.4

