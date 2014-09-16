Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaIPEUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 00:20:45 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48035 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaIPEUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 00:20:43 -0400
From: Martin Kelly <martin@martingkelly.com>
To: x86@kernel.org
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Martin Kelly <martin@martingkelly.com>,
        Martin Kelly <martkell@amazon.com>
Subject: [PATCH] context_tracking: Fix checkpatch warnings
Date: Mon, 15 Sep 2014 21:20:32 -0700
Message-Id: <1410841232-24591-1-git-send-email-martin@martingkelly.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch emits several warnings for context_tracking.c, which are
fixed in this patch:

- No space after "("
- Lines longer than 80 characters

Signed-off-by: Martin Kelly <martkell@amazon.com>
---
 kernel/context_tracking.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 5664985..bf29065 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -54,8 +54,8 @@ void context_tracking_user_enter(void)
 	/*
 	 * Repeat the user_enter() check here because some archs may be calling
 	 * this from asm and if no CPU needs context tracking, they shouldn't
-	 * go further. Repeat the check here until they support the inline static
-	 * key check.
+	 * go further. Repeat the check here until they support the inline
+	 * static key check.
 	 */
 	if (!context_tracking_is_enabled())
 		return;
@@ -75,31 +75,33 @@ void context_tracking_user_enter(void)
 	WARN_ON_ONCE(!current->mm);
 
 	local_irq_save(flags);
-	if ( __this_cpu_read(context_tracking.state) != IN_USER) {
+	if (__this_cpu_read(context_tracking.state) != IN_USER) {
 		if (__this_cpu_read(context_tracking.active)) {
 			trace_user_enter(0);
 			/*
-			 * At this stage, only low level arch entry code remains and
-			 * then we'll run in userspace. We can assume there won't be
-			 * any RCU read-side critical section until the next call to
-			 * user_exit() or rcu_irq_enter(). Let's remove RCU's dependency
-			 * on the tick.
+			 * At this stage, only low level arch entry code
+			 * remains and then we'll run in userspace. We can
+			 * assume there won't be any RCU read-side critical
+			 * section until the next call to user_exit() or
+			 * rcu_irq_enter(). Let's remove RCU's dependency on
+			 * the tick.
 			 */
 			vtime_user_enter(current);
 			rcu_user_enter();
 		}
 		/*
-		 * Even if context tracking is disabled on this CPU, because it's outside
-		 * the full dynticks mask for example, we still have to keep track of the
-		 * context transitions and states to prevent inconsistency on those of
-		 * other CPUs.
-		 * If a task triggers an exception in userspace, sleep on the exception
-		 * handler and then migrate to another CPU, that new CPU must know where
-		 * the exception returns by the time we call exception_exit().
-		 * This information can only be provided by the previous CPU when it called
-		 * exception_enter().
-		 * OTOH we can spare the calls to vtime and RCU when context_tracking.active
-		 * is false because we know that CPU is not tickless.
+		 * Even if context tracking is disabled on this CPU, because
+		 * it's outside the full dynticks mask for example, we still
+		 * have to keep track of the context transitions and states to
+		 * prevent inconsistency on those of other CPUs.  If a task
+		 * triggers an exception in userspace, sleep on the exception
+		 * handler and then migrate to another CPU, that new CPU must
+		 * know where the exception returns by the time we call
+		 * exception_exit().  This information can only be provided by
+		 * the previous CPU when it called exception_enter().  OTOH we
+		 * can spare the calls to vtime and RCU when
+		 * context_tracking.active is false because we know that CPU is
+		 * not tickless.
 		 */
 		__this_cpu_write(context_tracking.state, IN_USER);
 	}
-- 
2.1.0

