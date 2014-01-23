Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaAWTeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:34:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbaAWTec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:34:32 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        akpm@linux-foundation.org, peterz@infradead.org, oleg@redhat.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 6/7] pid: mark struct task const in helper functions
Date: Thu, 23 Jan 2014 14:32:39 -0500
Message-Id: <b2bfe83dccd589489230fc4b2a407863c44a27e8.1390495874.git.rgb@redhat.com>
In-Reply-To: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
References: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
In-Reply-To: <cover.1390495874.git.rgb@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make any sense to recallers to pass in a non-const struct
task so update the function signatures to only require a const struct
task.

(informed by ebiederman's c76b2526)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/sched.h |   36 ++++++++++++++++++------------------
 kernel/pid.c          |    4 ++--
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f60de19..2016d92 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1488,12 +1488,12 @@ static inline void task_numa_free(struct task_struct *p)
 }
 #endif
 
-static inline struct pid *task_pid(struct task_struct *task)
+static inline struct pid *task_pid(const struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
 }
 
-static inline struct pid *task_tgid(struct task_struct *task)
+static inline struct pid *task_tgid(const struct task_struct *task)
 {
 	return task->group_leader->pids[PIDTYPE_PID].pid;
 }
@@ -1503,12 +1503,12 @@ static inline struct pid *task_tgid(struct task_struct *task)
  * the result of task_pgrp/task_session even if task == current,
  * we can race with another thread doing sys_setsid/sys_setpgid.
  */
-static inline struct pid *task_pgrp(struct task_struct *task)
+static inline struct pid *task_pgrp(const struct task_struct *task)
 {
 	return task->group_leader->pids[PIDTYPE_PGID].pid;
 }
 
-static inline struct pid *task_session(struct task_struct *task)
+static inline struct pid *task_session(const struct task_struct *task)
 {
 	return task->group_leader->pids[PIDTYPE_SID].pid;
 }
@@ -1528,64 +1528,64 @@ struct pid_namespace;
  *
  * see also pid_nr() etc in include/linux/pid.h
  */
-pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
+pid_t __task_pid_nr_ns(const struct task_struct *task, enum pid_type type,
 			struct pid_namespace *ns);
 
-static inline pid_t task_pid_nr(struct task_struct *tsk)
+static inline pid_t task_pid_nr(const struct task_struct *tsk)
 {
 	return tsk->pid;
 }
 
-static inline pid_t task_pid_nr_ns(struct task_struct *tsk,
+static inline pid_t task_pid_nr_ns(const struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
 	return __task_pid_nr_ns(tsk, PIDTYPE_PID, ns);
 }
 
-static inline pid_t task_pid_vnr(struct task_struct *tsk)
+static inline pid_t task_pid_vnr(const struct task_struct *tsk)
 {
 	return __task_pid_nr_ns(tsk, PIDTYPE_PID, NULL);
 }
 
 
-static inline pid_t task_tgid_nr(struct task_struct *tsk)
+static inline pid_t task_tgid_nr(const const struct task_struct *tsk)
 {
 	return pid_nr(task_tgid(tsk));
 }
 
-pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
+pid_t task_tgid_nr_ns(const struct task_struct *tsk, struct pid_namespace *ns);
 
-static inline pid_t task_tgid_vnr(struct task_struct *tsk)
+static inline pid_t task_tgid_vnr(const struct task_struct *tsk)
 {
 	return pid_vnr(task_tgid(tsk));
 }
 
 
-static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
+static inline pid_t task_pgrp_nr_ns(const struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
 	return __task_pid_nr_ns(tsk, PIDTYPE_PGID, ns);
 }
 
-static inline pid_t task_pgrp_vnr(struct task_struct *tsk)
+static inline pid_t task_pgrp_vnr(const struct task_struct *tsk)
 {
 	return __task_pid_nr_ns(tsk, PIDTYPE_PGID, NULL);
 }
 
 
-static inline pid_t task_session_nr_ns(struct task_struct *tsk,
+static inline pid_t task_session_nr_ns(const struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
 	return __task_pid_nr_ns(tsk, PIDTYPE_SID, ns);
 }
 
-static inline pid_t task_session_vnr(struct task_struct *tsk)
+static inline pid_t task_session_vnr(const struct task_struct *tsk)
 {
 	return __task_pid_nr_ns(tsk, PIDTYPE_SID, NULL);
 }
 
 /* obsolete, do not use */
-static inline pid_t task_pgrp_nr(struct task_struct *tsk)
+static inline pid_t task_pgrp_nr(const struct task_struct *tsk)
 {
 	return task_pgrp_nr_ns(tsk, &init_pid_ns);
 }
@@ -1600,7 +1600,7 @@ static inline pid_t task_pgrp_nr(struct task_struct *tsk)
  *
  * Return: 1 if the process is alive. 0 otherwise.
  */
-static inline int pid_alive(struct task_struct *p)
+static inline int pid_alive(const struct task_struct *p)
 {
 	return p->pids[PIDTYPE_PID].pid != NULL;
 }
@@ -1613,7 +1613,7 @@ static inline int pid_alive(struct task_struct *p)
  *
  * Return: 1 if the task structure is init. 0 otherwise.
  */
-static inline int is_global_init(struct task_struct *tsk)
+static inline int is_global_init(const struct task_struct *tsk)
 {
 	return task_pid_nr(tsk) == 1;
 }
diff --git a/kernel/pid.c b/kernel/pid.c
index 9b9a266..468b35c 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -512,7 +512,7 @@ pid_t pid_vnr(struct pid *pid)
 }
 EXPORT_SYMBOL_GPL(pid_vnr);
 
-pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
+pid_t __task_pid_nr_ns(const struct task_struct *task, enum pid_type type,
 			struct pid_namespace *ns)
 {
 	pid_t nr = 0;
@@ -531,7 +531,7 @@ pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
 }
 EXPORT_SYMBOL(__task_pid_nr_ns);
 
-pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+pid_t task_tgid_nr_ns(const struct task_struct *tsk, struct pid_namespace *ns)
 {
 	return pid_nr_ns(task_tgid(tsk), ns);
 }
-- 
1.7.1

