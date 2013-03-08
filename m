Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab3CHCKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:10:18 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63398 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3CHCKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:10:17 -0500
Date: Thu, 7 Mar 2013 18:10:13 -0800
From: Michel Lespinasse <walken@google.com>
To: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: make sched_group_{get,set}_rt_{runtime,period}
 functions static
Message-ID: <20130308021013.GA11284@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a tiny cleanup I did while I was looking through scheduler code
doing a tasklist_lock change. Please consider applying if you find it
appropriate.

------------------------------8<-----------------------------------------
sched: make sched_group_{get,set}_rt_{runtime,period} functions static

These functions, as well as sched_rt_can_attach(), used to be public so
that kernel/user.c could use them; however this use has now disappeared
so that these functions can be made static again.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/sched.h |  9 ---------
 kernel/sched/core.c   | 11 ++++++-----
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6ddbfb..ac8dbca5ea15 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2694,15 +2694,6 @@ extern void sched_move_task(struct task_struct *tsk);
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 extern unsigned long sched_group_shares(struct task_group *tg);
 #endif
-#ifdef CONFIG_RT_GROUP_SCHED
-extern int sched_group_set_rt_runtime(struct task_group *tg,
-				      long rt_runtime_us);
-extern long sched_group_rt_runtime(struct task_group *tg);
-extern int sched_group_set_rt_period(struct task_group *tg,
-				      long rt_period_us);
-extern long sched_group_rt_period(struct task_group *tg);
-extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
-#endif
 #endif /* CONFIG_CGROUP_SCHED */
 
 extern int task_can_switch_user(struct user_struct *up,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624a393c..4c0b8c333034 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7455,7 +7455,8 @@ unlock:
 	return err;
 }
 
-int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
+static int
+sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 {
 	u64 rt_runtime, rt_period;
 
@@ -7467,7 +7468,7 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
-long sched_group_rt_runtime(struct task_group *tg)
+static long sched_group_rt_runtime(struct task_group *tg)
 {
 	u64 rt_runtime_us;
 
@@ -7479,7 +7480,7 @@ long sched_group_rt_runtime(struct task_group *tg)
 	return rt_runtime_us;
 }
 
-int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
+static int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 {
 	u64 rt_runtime, rt_period;
 
@@ -7492,7 +7493,7 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
-long sched_group_rt_period(struct task_group *tg)
+static long sched_group_rt_period(struct task_group *tg)
 {
 	u64 rt_period_us;
 
@@ -7527,7 +7528,7 @@ static int sched_rt_global_constraints(void)
 	return ret;
 }
 
-int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
+static int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 {
 	/* Don't accept realtime tasks when there is no way for them to run */
 	if (rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
