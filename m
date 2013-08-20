Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3HTVdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab3HTVds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:48 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 12/12] pid: mark struct task const in helper functions
Date: Tue, 20 Aug 2013 17:32:04 -0400
Message-Id: <1fba7bd41a8af292fd36daf6f0e502c8a4dac676.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
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
 include/linux/sched.h |   44 ++++++++++++++++++++++----------------------
 kernel/pid.c          |    4 ++--
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 46e739d..a585b51 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1423,12 +1423,12 @@ static inline void set_numabalancing_state(bool enabled)
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
@@ -1438,12 +1438,12 @@ static inline struct pid *task_tgid(struct task_struct *task)
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
@@ -1468,50 +1468,50 @@ struct pid_namespace;
  *
  * see also pid_nr() etc in include/linux/pid.h
  */
-pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
+pid_t __task_pid_nr_ns(const struct task_struct *task, enum pid_type type,
 			struct pid_namespace *ns);
 
-static inline pid_t task_pid_nr(struct task_struct *tsk)
+static inline pid_t task_pid_nr(const struct task_struct *tsk)
 {
 	return pid_nr(task_pid(tsk));
 }
 
-static inline pid_t task_pid_nr_ns(struct task_struct *tsk,
+static inline pid_t task_pid_nr_ns(const struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
 	return __task_pid_nr_ns(tsk, PIDTYPE_PID, ns);
 }
 
-static inline pid_t task_pid_nr_init_ns(struct task_struct *tsk)
+static inline pid_t task_pid_nr_init_ns(const struct task_struct *tsk)
 {
 	return task_pid_nr_ns(tsk, &init_pid_ns);
 }
 
-static inline pid_t task_pid_vnr(struct task_struct *tsk)
+static inline pid_t task_pid_vnr(const struct task_struct *tsk)
 {
 	return __task_pid_nr_ns(tsk, PIDTYPE_PID, NULL);
 }
 
 
-static inline pid_t task_tgid_nr(struct task_struct *tsk)
+static inline pid_t task_tgid_nr(const struct task_struct *tsk)
 {
 	return pid_nr(task_tgid(tsk));
 }
 
-pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
+pid_t task_tgid_nr_ns(const struct task_struct *tsk, struct pid_namespace *ns);
 
-static inline pid_t task_tgid_nr_init_ns(struct task_struct *tsk)
+static inline pid_t task_tgid_nr_init_ns(const struct task_struct *tsk)
 {
 	return task_tgid_nr_ns(tsk, &init_pid_ns);
 }
 
-static inline pid_t task_tgid_vnr(struct task_struct *tsk)
+static inline pid_t task_tgid_vnr(const struct task_struct *tsk)
 {
 	return pid_vnr(task_tgid(tsk));
 }
 
 
-static inline pid_t task_ppid_nr_ns(struct task_struct *tsk,
+static inline pid_t task_ppid_nr_ns(const struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
 	pid_t pid;
@@ -1523,37 +1523,37 @@ static inline pid_t task_ppid_nr_ns(struct task_struct *tsk,
 	return pid;
 }
 
-static inline pid_t task_ppid_nr_init_ns(struct task_struct *tsk)
+static inline pid_t task_ppid_nr_init_ns(const struct task_struct *tsk)
 {
 	return task_ppid_nr_ns(tsk, &init_pid_ns);
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
@@ -1566,7 +1566,7 @@ static inline pid_t task_pgrp_nr(struct task_struct *tsk)
  * If pid_alive fails, then pointers within the task structure
  * can be stale and must not be dereferenced.
  */
-static inline int pid_alive(struct task_struct *p)
+static inline int pid_alive(const struct task_struct *p)
 {
 	return p->pids[PIDTYPE_PID].pid != NULL;
 }
@@ -1577,7 +1577,7 @@ static inline int pid_alive(struct task_struct *p)
  *
  * Check if a task structure is the first user space task the kernel created.
  */
-static inline int is_global_init(struct task_struct *tsk)
+static inline int is_global_init(const struct task_struct *tsk)
 {
 	return task_pid_nr(tsk) == 1;
 }
diff --git a/kernel/pid.c b/kernel/pid.c
index 66505c1..17755ae 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -506,7 +506,7 @@ pid_t pid_vnr(struct pid *pid)
 }
 EXPORT_SYMBOL_GPL(pid_vnr);
 
-pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
+pid_t __task_pid_nr_ns(const struct task_struct *task, enum pid_type type,
 			struct pid_namespace *ns)
 {
 	pid_t nr = 0;
@@ -525,7 +525,7 @@ pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
 }
 EXPORT_SYMBOL(__task_pid_nr_ns);
 
-pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+pid_t task_tgid_nr_ns(const struct task_struct *tsk, struct pid_namespace *ns)
 {
 	return pid_nr_ns(task_tgid(tsk), ns);
 }
-- 
1.7.1

