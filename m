Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaBVSEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:04:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41395 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaBVSEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:04:31 -0500
Date: Sat, 22 Feb 2014 10:03:57 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-75e45d512f257beedae0d8a67d053cde5537bd4c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <bd80780f19b4f9b4a765acc353c8dbc130274dd6.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <bd80780f19b4f9b4a765acc353c8dbc130274dd6.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE
Git-Commit-ID: 75e45d512f257beedae0d8a67d053cde5537bd4c
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

Commit-ID:  75e45d512f257beedae0d8a67d053cde5537bd4c
Gitweb:     http://git.kernel.org/tip/75e45d512f257beedae0d8a67d053cde5537bd4c
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:50 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 22 Feb 2014 18:15:54 +0100

sched: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/bd80780f19b4f9b4a765acc353c8dbc130274dd6.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index cc4965e..a8a73b8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2993,7 +2993,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	unsigned long flags;
 	struct rq *rq;
 
-	if (task_nice(p) == nice || nice < -20 || nice > 19)
+	if (task_nice(p) == nice || nice < MIN_NICE || nice > MAX_NICE)
 		return;
 	/*
 	 * We have to be careful, if called from sys_setpriority(),
@@ -3072,10 +3072,10 @@ SYSCALL_DEFINE1(nice, int, increment)
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
@@ -3623,7 +3623,7 @@ static int sched_copy_attr(struct sched_attr __user *uattr,
 	 * XXX: do we want to be lenient like existing syscalls; or do we want
 	 * to be strict and return an error on out-of-bounds values?
 	 */
-	attr->sched_nice = clamp(attr->sched_nice, -20, 19);
+	attr->sched_nice = clamp(attr->sched_nice, MIN_NICE, MAX_NICE);
 
 out:
 	return ret;
