Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab3EOJFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:05:25 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63748 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab3EOJFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:05:11 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: mingo@kernel.org, williams@redhat.com
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] rtmutex: document rt_mutex_adjust_prio_chain()
Date: Wed, 15 May 2013 11:04:10 +0200
Message-Id: <1368608650-7935-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parameters and usage of rt_mutex_adjust_prio_chain() are already
documented in Documentation/rt-mutex-design.txt. However, since this
function is called from several paths with different semantics (related
to the arguments), it is handy to have a quick reference directly in
the code.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/rtmutex.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 1e09308..0dd6aec 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -145,6 +145,19 @@ int max_lock_depth = 1024;
 /*
  * Adjust the priority chain. Also used for deadlock detection.
  * Decreases task's usage by one - may thus free the task.
+ *
+ * @task: the task owning the mutex (owner) for which a chain walk is probably
+ *	  needed
+ * @deadlock_detect: do we have to carry out deadlock detection?
+ * @orig_lock: the mutex (can be NULL if we are walking the chain to recheck
+ * 	       things for a task that has just got its priority adjusted, and
+ *	       is waiting on a mutex)
+ * @orig_waiter: rt_mutex_waiter struct for the task that has just donated
+ *		 its priority to the mutex owner (can be NULL in the case
+ *		 depicted above or if the top waiter is gone away and we are
+ *		 actually deboosting the owner)
+ * @top_task: the current top waiter
+ *
  * Returns 0 or -EDEADLK.
  */
 static int rt_mutex_adjust_prio_chain(struct task_struct *task,
-- 
1.7.9.5

