Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359AbaDKN7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:59:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39767 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbaDKNzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:55:52 -0400
Message-Id: <20140411135218.416914708@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Apr 2014 15:42:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 5/8] sched,idle: Remove TS_POLLING support
References: <20140411134243.160989490@infradead.org>
Content-Disposition: inline; filename=peterz-ts_polling-kill.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there are no architectures left using it, kill the support
for TS_POLLING.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h |   46 ++--------------------------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2695,51 +2695,9 @@ static inline int spin_needbreak(spinloc
 
 /*
  * Idle thread specific functions to determine the need_resched
- * polling state. We have two versions, one based on TS_POLLING in
- * thread_info.status and one based on TIF_POLLING_NRFLAG in
- * thread_info.flags
+ * polling state.
  */
-#ifdef TS_POLLING
-static inline int tsk_is_polling(struct task_struct *p)
-{
-	return task_thread_info(p)->status & TS_POLLING;
-}
-static inline void __current_set_polling(void)
-{
-	current_thread_info()->status |= TS_POLLING;
-}
-
-static inline bool __must_check current_set_polling_and_test(void)
-{
-	__current_set_polling();
-
-	/*
-	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
-	 */
-	smp_mb();
-
-	return unlikely(tif_need_resched());
-}
-
-static inline void __current_clr_polling(void)
-{
-	current_thread_info()->status &= ~TS_POLLING;
-}
-
-static inline bool __must_check current_clr_polling_and_test(void)
-{
-	__current_clr_polling();
-
-	/*
-	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
-	 */
-	smp_mb();
-
-	return unlikely(tif_need_resched());
-}
-#elif defined(TIF_POLLING_NRFLAG)
+#ifdef TIF_POLLING_NRFLAG
 static inline int tsk_is_polling(struct task_struct *p)
 {
 	return test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);


