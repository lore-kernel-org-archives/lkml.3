Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbaHHN55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:57:57 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37734 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaHHN5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:57:55 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] timer: Move kerneldoc where it belongs
Date: Fri,  8 Aug 2014 15:57:50 +0200
Message-Id: <1407506270-7637-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Commit 8a49731416d9 ("timer: provide an api for deferrable timeout")
only partially updates the kerneldoc comment for __schedule_timeout()
which causes DocBook generation to complain about the missing
description for the flag argument. The __schedule_timeout() function is
locally scoped and therefore kerneldoc isn't very useful. The original
schedule_timeout() function is a public and exported function, however,
and therefore should have proper kerneldoc, so move the comment back to
it instead.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 kernel/time/timer.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index e81a30181e41..72ea2401bd37 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1431,32 +1431,6 @@ static void process_timeout(unsigned long __data)
 	wake_up_process((struct task_struct *)__data);
 }
 
-/**
- * __schedule_timeout - sleep until timeout
- * @timeout: timeout value in jiffies
- *
- * Make the current task sleep until @timeout jiffies have
- * elapsed. The routine will return immediately unless
- * the current task state has been set (see set_current_state()).
- *
- * You can set the task state as follows -
- *
- * %TASK_UNINTERRUPTIBLE - at least @timeout jiffies are guaranteed to
- * pass before the routine returns. The routine will return 0
- *
- * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
- * delivered to the current task. In this case the remaining time
- * in jiffies will be returned, or 0 if the timer expired in time
- *
- * The current task state is guaranteed to be TASK_RUNNING when this
- * routine returns.
- *
- * Specifying a @timeout value of %MAX_SCHEDULE_TIMEOUT will schedule
- * the CPU away without a bound on the timeout. In this case the return
- * value will be %MAX_SCHEDULE_TIMEOUT.
- *
- * In all cases the return value is guaranteed to be non-negative.
- */
 static signed long
 __sched __schedule_timeout(signed long timeout, unsigned long flag)
 {
@@ -1514,6 +1488,32 @@ __sched __schedule_timeout(signed long timeout, unsigned long flag)
 	return timeout < 0 ? 0 : timeout;
 }
 
+/**
+ * schedule_timeout - sleep until timeout
+ * @timeout: timeout value in jiffies
+ *
+ * Make the current task sleep until @timeout jiffies have
+ * elapsed. The routine will return immediately unless
+ * the current task state has been set (see set_current_state()).
+ *
+ * You can set the task state as follows -
+ *
+ * %TASK_UNINTERRUPTIBLE - at least @timeout jiffies are guaranteed to
+ * pass before the routine returns. The routine will return 0
+ *
+ * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
+ * delivered to the current task. In this case the remaining time
+ * in jiffies will be returned, or 0 if the timer expired in time
+ *
+ * The current task state is guaranteed to be TASK_RUNNING when this
+ * routine returns.
+ *
+ * Specifying a @timeout value of %MAX_SCHEDULE_TIMEOUT will schedule
+ * the CPU away without a bound on the timeout. In this case the return
+ * value will be %MAX_SCHEDULE_TIMEOUT.
+ *
+ * In all cases the return value is guaranteed to be non-negative.
+ */
 signed long __sched schedule_timeout(signed long timeout)
 {
 	return __schedule_timeout(timeout, 0);
-- 
2.0.4

