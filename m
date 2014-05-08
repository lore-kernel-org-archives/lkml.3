Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaEHKrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:47:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33437 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbaEHKre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:47:34 -0400
Date: Thu, 8 May 2014 03:47:04 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6yurip2tfix2f4bfc5agu2s0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle: Remove TS_POLLING support
Git-Commit-ID: 69dd0f848879328ae6c6f54c2ec80e49eef042d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69dd0f848879328ae6c6f54c2ec80e49eef042d8
Gitweb:     http://git.kernel.org/tip/69dd0f848879328ae6c6f54c2ec80e49eef042d8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 9 Apr 2014 14:30:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 8 May 2014 09:16:57 +0200

sched/idle: Remove TS_POLLING support

Now that there are no architectures left using it, kill the support
for TS_POLLING.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/n/tip-6yurip2tfix2f4bfc5agu2s0@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 46 ++--------------------------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index accb66b..725eef1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2775,51 +2775,9 @@ static inline int spin_needbreak(spinlock_t *lock)
 
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
