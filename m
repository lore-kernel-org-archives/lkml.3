Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016Ab3E1NEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:04:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3E1NEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:04:49 -0400
Date: Tue, 28 May 2013 06:04:19 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-0c1061733aa0303e6536c0bc7f86d68f5eb55446@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, williams@redhat.com, rostedt@goodmis.org,
        tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        williams@redhat.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1368608650-7935-1-git-send-email-juri.lelli@gmail.com>
References: <1368608650-7935-1-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rtmutex: Document rt_mutex_adjust_prio_chain()
Git-Commit-ID: 0c1061733aa0303e6536c0bc7f86d68f5eb55446
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

Commit-ID:  0c1061733aa0303e6536c0bc7f86d68f5eb55446
Gitweb:     http://git.kernel.org/tip/0c1061733aa0303e6536c0bc7f86d68f5eb55446
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Wed, 15 May 2013 11:04:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:23:52 +0200

rtmutex: Document rt_mutex_adjust_prio_chain()

Parameters and usage of rt_mutex_adjust_prio_chain() are already
documented in Documentation/rt-mutex-design.txt. However, since this
function is called from several paths with different semantics (related
to the arguments), it is handy to have a quick reference directly in
the code.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1368608650-7935-1-git-send-email-juri.lelli@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/rtmutex.c | 13 +++++++++++++
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
