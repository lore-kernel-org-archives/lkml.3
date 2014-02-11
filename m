Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaBKHgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:36:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaBKHfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:35:07 -0500
X-IronPort-AV: E=Sophos;i="4.95,824,1384272000"; 
   d="scan'208";a="9505338"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6/9] sched: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
Date: Tue, 11 Feb 2014 15:34:50 +0800
Message-Id: <bd80780f19b4f9b4a765acc353c8dbc130274dd6.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:05,
	Serialize complete at 2014/02/11 15:33:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Ingo Molnar <mingo@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>
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
index 104c816..46cf585 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3000,7 +3000,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	unsigned long flags;
 	struct rq *rq;
 
-	if (task_nice(p) == nice || nice < -20 || nice > 19)
+	if (task_nice(p) == nice || nice < MIN_NICE || nice > MAX_NICE)
 		return;
 	/*
 	 * We have to be careful, if called from sys_setpriority(),
@@ -3079,10 +3079,10 @@ SYSCALL_DEFINE1(nice, int, increment)
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
@@ -3605,7 +3605,7 @@ static int sched_copy_attr(struct sched_attr __user *uattr,
 	 * XXX: do we want to be lenient like existing syscalls; or do we want
 	 * to be strict and return an error on out-of-bounds values?
 	 */
-	attr->sched_nice = clamp(attr->sched_nice, -20, 19);
+	attr->sched_nice = clamp(attr->sched_nice, MIN_NICE, MAX_NICE);
 
 out:
 	return ret;
-- 
1.8.2.1

