Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaEFRRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:17:08 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:9672 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbaEFRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:17:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8UAKEYaVNbtAAq/2dsb2JhbABZgwarbQQBAQEBAQEFAZoHAgKBHxd0glMTHCMYgQIkE4hFAc42hVaIfIRGAQOPG4obAZJ7gzY7
Date: Tue, 6 May 2014 19:16:59 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/posix-timers.c: code clean-up
Message-Id: <20140506191659.f16b483f44bdc9ef291ffe02@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing some checkpatch warnings:
-Convert printk to pr_foo()
-Remove spaces between function and (
-Split lines > 80 characters

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/posix-timers.c | 57 +++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 424c2d4..40652b2 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -71,7 +71,7 @@ static DEFINE_SPINLOCK(hash_lock);
  * SIGEV values.  Here we put out an error if this assumption fails.
  */
 #if SIGEV_THREAD_ID != (SIGEV_THREAD_ID & \
-                       ~(SIGEV_SIGNAL | SIGEV_NONE | SIGEV_THREAD))
+		       ~(SIGEV_SIGNAL | SIGEV_NONE | SIGEV_THREAD))
 #error "SIGEV_THREAD_ID must not share bit with other SIGEV values!"
 #endif
 
@@ -252,7 +252,8 @@ static int posix_get_monotonic_coarse(clockid_t which_clock,
 	return 0;
 }
 
-static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
+static int posix_get_coarse_res(const clockid_t which_clock,
+				struct timespec *tp)
 {
 	*tp = ktime_to_timespec(KTIME_LOW_RES);
 	return 0;
@@ -333,14 +334,16 @@ static __init int init_posix_timers(void)
 	posix_timers_register_clock(CLOCK_REALTIME, &clock_realtime);
 	posix_timers_register_clock(CLOCK_MONOTONIC, &clock_monotonic);
 	posix_timers_register_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
-	posix_timers_register_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
-	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
+	posix_timers_register_clock(CLOCK_REALTIME_COARSE,
+				    &clock_realtime_coarse);
+	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE,
+				    &clock_monotonic_coarse);
 	posix_timers_register_clock(CLOCK_BOOTTIME, &clock_boottime);
 	posix_timers_register_clock(CLOCK_TAI, &clock_tai);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
-					sizeof (struct k_itimer), 0, SLAB_PANIC,
-					NULL);
+					       sizeof (struct k_itimer), 0,
+					       SLAB_PANIC, NULL);
 	return 0;
 }
 
@@ -494,11 +497,11 @@ static enum hrtimer_restart posix_timer_fn(struct hrtimer *timer)
 	return ret;
 }
 
-static struct pid *good_sigevent(sigevent_t * event)
+static struct pid *good_sigevent(sigevent_t *event)
 {
 	struct task_struct *rtn = current->group_leader;
 
-	if ((event->sigev_notify & SIGEV_THREAD_ID ) &&
+	if ((event->sigev_notify & SIGEV_THREAD_ID) &&
 		(!(rtn = find_task_by_vpid(event->sigev_notify_thread_id)) ||
 		 !same_thread_group(rtn, current) ||
 		 (event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_SIGNAL))
@@ -515,18 +518,18 @@ void posix_timers_register_clock(const clockid_t clock_id,
 				 struct k_clock *new_clock)
 {
 	if ((unsigned) clock_id >= MAX_CLOCKS) {
-		printk(KERN_WARNING "POSIX clock register failed for clock_id %d\n",
+		pr_warn("POSIX clock register failed for clock_id %d\n",
 		       clock_id);
 		return;
 	}
 
 	if (!new_clock->clock_get) {
-		printk(KERN_WARNING "POSIX clock id %d lacks clock_get()\n",
+		pr_warn("POSIX clock id %d lacks clock_get()\n",
 		       clock_id);
 		return;
 	}
 	if (!new_clock->clock_getres) {
-		printk(KERN_WARNING "POSIX clock id %d lacks clock_getres()\n",
+		pr_warn("POSIX clock id %d lacks clock_getres()\n",
 		       clock_id);
 		return;
 	}
@@ -535,7 +538,7 @@ void posix_timers_register_clock(const clockid_t clock_id,
 }
 EXPORT_SYMBOL_GPL(posix_timers_register_clock);
 
-static struct k_itimer * alloc_posix_timer(void)
+static struct k_itimer *alloc_posix_timer(void)
 {
 	struct k_itimer *tmr;
 	tmr = kmem_cache_zalloc(posix_timers_cache, GFP_KERNEL);
@@ -622,7 +625,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->it_overrun = -1;
 
 	if (timer_event_spec) {
-		if (copy_from_user(&event, timer_event_spec, sizeof (event))) {
+		if (copy_from_user(&event, timer_event_spec, sizeof(event))) {
 			error = -EFAULT;
 			goto out;
 		}
@@ -647,7 +650,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	if (copy_to_user(created_timer_id,
-			 &new_timer_id, sizeof (new_timer_id))) {
+			 &new_timer_id, sizeof(new_timer_id))) {
 		error = -EFAULT;
 		goto out;
 	}
@@ -748,7 +751,8 @@ common_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 	 */
 	if (iv.tv64 && (timr->it_requeue_pending & REQUEUE_PENDING ||
 	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE))
-		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now, iv);
+		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now,
+								   iv);
 
 	remaining = ktime_sub(hrtimer_get_expires(timer), now);
 	/* Return 0 only, when the timer is expired and not pending */
@@ -785,7 +789,7 @@ SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 
 	unlock_timer(timr, flags);
 
-	if (!ret && copy_to_user(setting, &cur_setting, sizeof (cur_setting)))
+	if (!ret && copy_to_user(setting, &cur_setting, sizeof(cur_setting)))
 		return -EFAULT;
 
 	return ret;
@@ -837,7 +841,7 @@ common_timer_set(struct k_itimer *timr, int flags,
 	if (hrtimer_try_to_cancel(timer) < 0)
 		return TIMER_RETRY;
 
-	timr->it_requeue_pending = (timr->it_requeue_pending + 2) & 
+	timr->it_requeue_pending = (timr->it_requeue_pending + 2) &
 		~REQUEUE_PENDING;
 	timr->it_overrun_last = 0;
 
@@ -857,9 +861,8 @@ common_timer_set(struct k_itimer *timr, int flags,
 	/* SIGEV_NONE timers are not queued ! See common_timer_get */
 	if (((timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE)) {
 		/* Setup correct expiry time for relative timers */
-		if (mode == HRTIMER_MODE_REL) {
+		if (mode == HRTIMER_MODE_REL)
 			hrtimer_add_expires(timer, timer->base->get_time());
-		}
 		return 0;
 	}
 
@@ -882,7 +885,7 @@ SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 	if (!new_setting)
 		return -EINVAL;
 
-	if (copy_from_user(&new_spec, new_setting, sizeof (new_spec)))
+	if (copy_from_user(&new_spec, new_setting, sizeof(new_spec)))
 		return -EFAULT;
 
 	if (!timespec_valid(&new_spec.it_interval) ||
@@ -901,12 +904,12 @@ retry:
 
 	unlock_timer(timr, flag);
 	if (error == TIMER_RETRY) {
-		rtn = NULL;	// We already got the old time...
+		rtn = NULL;	/* We already got the old time... */
 		goto retry;
 	}
 
 	if (old_setting && !error &&
-	    copy_to_user(old_setting, &old_spec, sizeof (old_spec)))
+	    copy_to_user(old_setting, &old_spec, sizeof(old_spec)))
 		error = -EFAULT;
 
 	return error;
@@ -1008,14 +1011,14 @@ SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 	if (!kc || !kc->clock_set)
 		return -EINVAL;
 
-	if (copy_from_user(&new_tp, tp, sizeof (*tp)))
+	if (copy_from_user(&new_tp, tp, sizeof(*tp)))
 		return -EFAULT;
 
 	return kc->clock_set(which_clock, &new_tp);
 }
 
 SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
-		struct timespec __user *,tp)
+		struct timespec __user *, tp)
 {
 	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec kernel_tp;
@@ -1026,7 +1029,7 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 
 	error = kc->clock_get(which_clock, &kernel_tp);
 
-	if (!error && copy_to_user(tp, &kernel_tp, sizeof (kernel_tp)))
+	if (!error && copy_to_user(tp, &kernel_tp, sizeof(kernel_tp)))
 		error = -EFAULT;
 
 	return error;
@@ -1067,7 +1070,7 @@ SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
 
 	error = kc->clock_getres(which_clock, &rtn_tp);
 
-	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof (rtn_tp)))
+	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof(rtn_tp)))
 		error = -EFAULT;
 
 	return error;
@@ -1096,7 +1099,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 	if (!kc->nsleep)
 		return -ENANOSLEEP_NOTSUP;
 
-	if (copy_from_user(&t, rqtp, sizeof (struct timespec)))
+	if (copy_from_user(&t, rqtp, sizeof(struct timespec)))
 		return -EFAULT;
 
 	if (!timespec_valid(&t))
-- 
1.8.4.5

