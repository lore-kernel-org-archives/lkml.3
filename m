Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3JDRgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:36:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3JDRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:36:53 -0400
Date: Fri, 4 Oct 2013 10:36:17 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-fb869b6e91a3ac235f237f73305ecf34cdc4969b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Clean up wait.h details a bit
Git-Commit-ID: fb869b6e91a3ac235f237f73305ecf34cdc4969b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:36:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb869b6e91a3ac235f237f73305ecf34cdc4969b
Gitweb:     http://git.kernel.org/tip/fb869b6e91a3ac235f237f73305ecf34cdc4969b
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 4 Oct 2013 10:24:49 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 13:57:19 +0200

sched/wait: Clean up wait.h details a bit

Since we are changing wait.h profoundly, use the opportunity to:

 - add a sentence to explain what this file is about
 - remove whitespace noise
 - prettify weird looking line break fixup attempts
 - standardize type definition and initialization sequences
 - use consistent style details

No code is changed.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-O8dIie5swnctqpupakatvqyq@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 124 +++++++++++++++++++++++++--------------------------
 1 file changed, 60 insertions(+), 64 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index bd4bd7b..a2726c7 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1,7 +1,8 @@
 #ifndef _LINUX_WAIT_H
 #define _LINUX_WAIT_H
-
-
+/*
+ * Linux wait queue related types and methods
+ */
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
@@ -13,27 +14,27 @@ typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, v
 int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
 
 struct __wait_queue {
-	unsigned int flags;
+	unsigned int		flags;
 #define WQ_FLAG_EXCLUSIVE	0x01
-	void *private;
-	wait_queue_func_t func;
-	struct list_head task_list;
+	void			*private;
+	wait_queue_func_t	func;
+	struct list_head	task_list;
 };
 
 struct wait_bit_key {
-	void *flags;
-	int bit_nr;
-#define WAIT_ATOMIC_T_BIT_NR -1
+	void			*flags;
+	int			bit_nr;
+#define WAIT_ATOMIC_T_BIT_NR	-1
 };
 
 struct wait_bit_queue {
-	struct wait_bit_key key;
-	wait_queue_t wait;
+	struct wait_bit_key	key;
+	wait_queue_t		wait;
 };
 
 struct __wait_queue_head {
-	spinlock_t lock;
-	struct list_head task_list;
+	spinlock_t		lock;
+	struct list_head	task_list;
 };
 typedef struct __wait_queue_head wait_queue_head_t;
 
@@ -84,17 +85,17 @@ extern void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct
 
 static inline void init_waitqueue_entry(wait_queue_t *q, struct task_struct *p)
 {
-	q->flags = 0;
-	q->private = p;
-	q->func = default_wake_function;
+	q->flags	= 0;
+	q->private	= p;
+	q->func		= default_wake_function;
 }
 
-static inline void init_waitqueue_func_entry(wait_queue_t *q,
-					wait_queue_func_t func)
+static inline void
+init_waitqueue_func_entry(wait_queue_t *q, wait_queue_func_t func)
 {
-	q->flags = 0;
-	q->private = NULL;
-	q->func = func;
+	q->flags	= 0;
+	q->private	= NULL;
+	q->func		= func;
 }
 
 static inline int waitqueue_active(wait_queue_head_t *q)
@@ -114,8 +115,8 @@ static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
 /*
  * Used for wake-one threads:
  */
-static inline void __add_wait_queue_exclusive(wait_queue_head_t *q,
-					      wait_queue_t *wait)
+static inline void
+__add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	__add_wait_queue(q, wait);
@@ -127,23 +128,22 @@ static inline void __add_wait_queue_tail(wait_queue_head_t *head,
 	list_add_tail(&new->task_list, &head->task_list);
 }
 
-static inline void __add_wait_queue_tail_exclusive(wait_queue_head_t *q,
-					      wait_queue_t *wait)
+static inline void
+__add_wait_queue_tail_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	__add_wait_queue_tail(q, wait);
 }
 
-static inline void __remove_wait_queue(wait_queue_head_t *head,
-							wait_queue_t *old)
+static inline void
+__remove_wait_queue(wait_queue_head_t *head, wait_queue_t *old)
 {
 	list_del(&old->task_list);
 }
 
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
-void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
-			void *key);
+void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
@@ -170,21 +170,21 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 /*
  * Wakeup macros to be used to report events to the targets.
  */
-#define wake_up_poll(x, m)				\
+#define wake_up_poll(x, m)						\
 	__wake_up(x, TASK_NORMAL, 1, (void *) (m))
-#define wake_up_locked_poll(x, m)				\
+#define wake_up_locked_poll(x, m)					\
 	__wake_up_locked_key((x), TASK_NORMAL, (void *) (m))
-#define wake_up_interruptible_poll(x, m)			\
+#define wake_up_interruptible_poll(x, m)				\
 	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
 #define ___wait_cond_timeout(condition)					\
 ({									\
- 	bool __cond = (condition);					\
- 	if (__cond && !__ret)						\
- 		__ret = 1;						\
- 	__cond || !__ret;						\
+	bool __cond = (condition);					\
+	if (__cond && !__ret)						\
+		__ret = 1;						\
+	__cond || !__ret;						\
 })
 
 #define ___wait_signal_pending(state)					\
@@ -209,8 +209,8 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 		if (___wait_signal_pending(state)) {			\
 			__ret = -ERESTARTSYS;				\
 			if (exclusive) {				\
-				abort_exclusive_wait(&wq, &__wait, 	\
-						     state, NULL); 	\
+				abort_exclusive_wait(&wq, &__wait,	\
+						     state, NULL);	\
 				goto __out;				\
 			}						\
 			break;						\
@@ -222,7 +222,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 __out:	__ret;								\
 })
 
-#define __wait_event(wq, condition) 					\
+#define __wait_event(wq, condition)					\
 	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
 			    schedule())
 
@@ -238,9 +238,9 @@ __out:	__ret;								\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  */
-#define wait_event(wq, condition) 					\
+#define wait_event(wq, condition)					\
 do {									\
-	if (condition)	 						\
+	if (condition)							\
 		break;							\
 	__wait_event(wq, condition);					\
 } while (0)
@@ -270,7 +270,7 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition)) 						\
+	if (!(condition))						\
 		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
@@ -329,7 +329,7 @@ do {									\
 ({									\
 	long __ret = timeout;						\
 	if (!(condition))						\
-		__ret = __wait_event_interruptible_timeout(wq, 		\
+		__ret = __wait_event_interruptible_timeout(wq,		\
 						condition, timeout);	\
 	__ret;								\
 })
@@ -569,7 +569,6 @@ do {									\
 	 ? 0 : __wait_event_interruptible_locked(wq, condition, 1, 1))
 
 
-
 #define __wait_event_killable(wq, condition)				\
 	___wait_event(wq, condition, TASK_KILLABLE, 0, 0, schedule())
 
@@ -663,7 +662,7 @@ do {									\
 
 
 #define __wait_event_interruptible_lock_irq(wq, condition, lock, cmd)	\
-	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,	   	\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
 		      spin_unlock_irq(&lock);				\
 		      cmd;						\
 		      schedule();					\
@@ -698,7 +697,7 @@ do {									\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__ret = __wait_event_interruptible_lock_irq(wq, 	\
+		__ret = __wait_event_interruptible_lock_irq(wq,		\
 						condition, lock, cmd);	\
 	__ret;								\
 })
@@ -734,18 +733,18 @@ do {									\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_lock_irq_timeout(wq, condition, 	\
-						    lock, timeout) 	\
+#define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
+						    lock, timeout)	\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
-		      TASK_INTERRUPTIBLE, 0, ret,	      		\
+		      TASK_INTERRUPTIBLE, 0, ret,			\
 		      spin_unlock_irq(&lock);				\
 		      __ret = schedule_timeout(__ret);			\
 		      spin_lock_irq(&lock));
 
 /**
- * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets true or a timeout elapses.
- *		The condition is checked under the lock. This is expected
- *		to be called with the lock taken.
+ * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets
+ *		true or a timeout elapses. The condition is checked under
+ *		the lock. This is expected to be called with the lock taken.
  * @wq: the waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @lock: a locked spinlock_t, which will be released before schedule()
@@ -783,11 +782,9 @@ do {									\
  * We plan to remove these interfaces.
  */
 extern void sleep_on(wait_queue_head_t *q);
-extern long sleep_on_timeout(wait_queue_head_t *q,
-				      signed long timeout);
+extern long sleep_on_timeout(wait_queue_head_t *q, signed long timeout);
 extern void interruptible_sleep_on(wait_queue_head_t *q);
-extern long interruptible_sleep_on_timeout(wait_queue_head_t *q,
-					   signed long timeout);
+extern long interruptible_sleep_on_timeout(wait_queue_head_t *q, signed long timeout);
 
 /*
  * Waitqueues which are removed from the waitqueue_head at wakeup time
@@ -795,8 +792,7 @@ extern long interruptible_sleep_on_timeout(wait_queue_head_t *q,
 void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
-void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
-			unsigned int mode, void *key);
+void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait, unsigned int mode, void *key);
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 
@@ -842,8 +838,8 @@ int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
  * One uses wait_on_bit() where one is waiting for the bit to clear,
  * but has no intention of setting it.
  */
-static inline int wait_on_bit(void *word, int bit,
-				int (*action)(void *), unsigned mode)
+static inline int
+wait_on_bit(void *word, int bit, int (*action)(void *), unsigned mode)
 {
 	if (!test_bit(bit, word))
 		return 0;
@@ -866,8 +862,8 @@ static inline int wait_on_bit(void *word, int bit,
  * One uses wait_on_bit_lock() where one is waiting for the bit to
  * clear with the intention of setting it, and when done, clearing it.
  */
-static inline int wait_on_bit_lock(void *word, int bit,
-				int (*action)(void *), unsigned mode)
+static inline int
+wait_on_bit_lock(void *word, int bit, int (*action)(void *), unsigned mode)
 {
 	if (!test_and_set_bit(bit, word))
 		return 0;
@@ -891,5 +887,5 @@ int wait_on_atomic_t(atomic_t *val, int (*action)(atomic_t *), unsigned mode)
 		return 0;
 	return out_of_line_wait_on_atomic_t(val, action, mode);
 }
-	
-#endif
+
+#endif /* _LINUX_WAIT_H */
