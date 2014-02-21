Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbaBUVee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:34:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbaBUVea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:34:30 -0500
Date: Fri, 21 Feb 2014 13:33:53 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-82abc86e6bcd0ab6b2efad1d8201abb463422034@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <bd80780f19b4f9b4a765acc353c8dbc130274dd6.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <bd80780f19b4f9b4a765acc353c8dbc130274dd6.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
Git-Commit-ID: 82abc86e6bcd0ab6b2efad1d8201abb463422034
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

Commit-ID:  82abc86e6bcd0ab6b2efad1d8201abb463422034
Gitweb:     http://git.kernel.org/tip/82abc86e6bcd0ab6b2efad1d8201abb463422034
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:50 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:20 +0100

sched: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/bd80780f19b4f9b4a765acc353c8dbc130274dd6.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/auto_group.c |  2 +-
 kernel/sched/core.c       | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 4a07353..e73efba 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -203,7 +203,7 @@ int proc_sched_autogroup_set_nice(struct task_struct *p, int nice)
 	struct autogroup *ag;
 	int err;
 
-	if (nice < -20 || nice > 19)
+	if (nice < MIN_NICE || nice > MAX_NICE)
 		return -EINVAL;
 
 	err = security_task_setnice(current, nice);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 67a24fa..67fcadb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3001,7 +3001,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	unsigned long flags;
 	struct rq *rq;
 
-	if (task_nice(p) == nice || nice < -20 || nice > 19)
+	if (task_nice(p) == nice || nice < MIN_NICE || nice > MAX_NICE)
 		return;
 	/*
 	 * We have to be careful, if called from sys_setpriority(),
@@ -3080,10 +3080,10 @@ SYSCALL_DEFINE1(nice, int, increment)
 		increment = 40;
 
 	nice = task_nice(current) + increment;
-	if (nice < -20)
-		nice = -20;
-	if (nice > 19)
-		nice = 19;
+	if (nice < MIN_NICE)
+		nice = MIN_NICE;
+	if (nice > MAX_NICE)
+		nice = MAX_NICE;
 
 	if (increment < 0 && !can_nice(current, nice))
 		return -EPERM;
@@ -3631,7 +3631,7 @@ static int sched_copy_attr(struct sched_attr __user *uattr,
 	 * XXX: do we want to be lenient like existing syscalls; or do we want
 	 * to be strict and return an error on out-of-bounds values?
 	 */
-	attr->sched_nice = clamp(attr->sched_nice, -20, 19);
+	attr->sched_nice = clamp(attr->sched_nice, MIN_NICE, MAX_NICE);
 
 out:
 	return ret;
