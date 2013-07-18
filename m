Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3GRKoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:44:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3GRKoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:44:09 -0400
Date: Thu, 18 Jul 2013 03:43:17 -0700
From: tip-bot for Yacine Belkadi <tipbot@zytor.com>
Message-ID: <tip-e69f61862ab833e9b8d3c15b6ce07fd69f3bfecc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, yacine.belkadi.1@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yacine.belkadi.1@gmail.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1373654747-2389-1-git-send-email-yacine.belkadi.1@gmail.com>
References: <1373654747-2389-1-git-send-email-yacine.belkadi.1@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix some kernel-doc warnings
Git-Commit-ID: e69f61862ab833e9b8d3c15b6ce07fd69f3bfecc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 18 Jul 2013 03:43:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e69f61862ab833e9b8d3c15b6ce07fd69f3bfecc
Gitweb:     http://git.kernel.org/tip/e69f61862ab833e9b8d3c15b6ce07fd69f3bfecc
Author:     Yacine Belkadi <yacine.belkadi.1@gmail.com>
AuthorDate: Fri, 12 Jul 2013 20:45:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 18 Jul 2013 09:58:21 +0200

sched: Fix some kernel-doc warnings

When building the htmldocs (in verbose mode), scripts/kernel-doc
reports the follwing type of warnings:

  Warning(kernel/sched/core.c:936): No description found for return value of 'task_curr'
  ...

Fix those by:

 - adding the missing descriptions
 - using "Return" sections for the descriptions

Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1373654747-2389-1-git-send-email-yacine.belkadi.1@gmail.com
[ While at it, fix the cpupri_set() explanation. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  6 ++++
 kernel/sched/core.c   | 82 ++++++++++++++++++++++++++++++++++++++-------------
 kernel/sched/cpupri.c |  4 +--
 kernel/sched/fair.c   |  9 ++++--
 4 files changed, 76 insertions(+), 25 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 50d04b9..8230024 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1532,6 +1532,8 @@ static inline pid_t task_pgrp_nr(struct task_struct *tsk)
  * Test if a process is not yet dead (at most zombie state)
  * If pid_alive fails, then pointers within the task structure
  * can be stale and must not be dereferenced.
+ *
+ * Return: 1 if the process is alive. 0 otherwise.
  */
 static inline int pid_alive(struct task_struct *p)
 {
@@ -1543,6 +1545,8 @@ static inline int pid_alive(struct task_struct *p)
  * @tsk: Task structure to be checked.
  *
  * Check if a task structure is the first user space task the kernel created.
+ *
+ * Return: 1 if the task structure is init. 0 otherwise.
  */
 static inline int is_global_init(struct task_struct *tsk)
 {
@@ -1893,6 +1897,8 @@ extern struct task_struct *idle_task(int cpu);
 /**
  * is_idle_task - is the specified task an idle task?
  * @p: the task in question.
+ *
+ * Return: 1 if @p is an idle task. 0 otherwise.
  */
 static inline bool is_idle_task(const struct task_struct *p)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0d8eb45..4c3967f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -933,6 +933,8 @@ static int effective_prio(struct task_struct *p)
 /**
  * task_curr - is this task currently executing on a CPU?
  * @p: the task in question.
+ *
+ * Return: 1 if the task is currently executing. 0 otherwise.
  */
 inline int task_curr(const struct task_struct *p)
 {
@@ -1482,7 +1484,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
  * the simpler "current->state = TASK_RUNNING" to mark yourself
  * runnable without the overhead of this.
  *
- * Returns %true if @p was woken up, %false if it was already running
+ * Return: %true if @p was woken up, %false if it was already running.
  * or @state didn't match @p's state.
  */
 static int
@@ -1577,8 +1579,9 @@ out:
  * @p: The process to be woken up.
  *
  * Attempt to wake up the nominated process and move it to the set of runnable
- * processes.  Returns 1 if the process was woken up, 0 if it was already
- * running.
+ * processes.
+ *
+ * Return: 1 if the process was woken up, 0 if it was already running.
  *
  * It may be assumed that this function implies a write memory barrier before
  * changing the task state if and only if any tasks are woken up.
@@ -2191,6 +2194,8 @@ void scheduler_tick(void)
  * This makes sure that uptime, CFS vruntime, load
  * balancing, etc... continue to move forward, even
  * with a very low granularity.
+ *
+ * Return: Maximum deferment in nanoseconds.
  */
 u64 scheduler_tick_max_deferment(void)
 {
@@ -2796,8 +2801,8 @@ EXPORT_SYMBOL(wait_for_completion);
  * specified timeout to expire. The timeout is in jiffies. It is not
  * interruptible.
  *
- * The return value is 0 if timed out, and positive (at least 1, or number of
- * jiffies left till timeout) if completed.
+ * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
+ * till timeout) if completed.
  */
 unsigned long __sched
 wait_for_completion_timeout(struct completion *x, unsigned long timeout)
@@ -2829,8 +2834,8 @@ EXPORT_SYMBOL(wait_for_completion_io);
  * specified timeout to expire. The timeout is in jiffies. It is not
  * interruptible. The caller is accounted as waiting for IO.
  *
- * The return value is 0 if timed out, and positive (at least 1, or number of
- * jiffies left till timeout) if completed.
+ * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
+ * till timeout) if completed.
  */
 unsigned long __sched
 wait_for_completion_io_timeout(struct completion *x, unsigned long timeout)
@@ -2846,7 +2851,7 @@ EXPORT_SYMBOL(wait_for_completion_io_timeout);
  * This waits for completion of a specific task to be signaled. It is
  * interruptible.
  *
- * The return value is -ERESTARTSYS if interrupted, 0 if completed.
+ * Return: -ERESTARTSYS if interrupted, 0 if completed.
  */
 int __sched wait_for_completion_interruptible(struct completion *x)
 {
@@ -2865,8 +2870,8 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. It is interruptible. The timeout is in jiffies.
  *
- * The return value is -ERESTARTSYS if interrupted, 0 if timed out,
- * positive (at least 1, or number of jiffies left till timeout) if completed.
+ * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
+ * or number of jiffies left till timeout) if completed.
  */
 long __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
@@ -2883,7 +2888,7 @@ EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
  * This waits to be signaled for completion of a specific task. It can be
  * interrupted by a kill signal.
  *
- * The return value is -ERESTARTSYS if interrupted, 0 if completed.
+ * Return: -ERESTARTSYS if interrupted, 0 if completed.
  */
 int __sched wait_for_completion_killable(struct completion *x)
 {
@@ -2903,8 +2908,8 @@ EXPORT_SYMBOL(wait_for_completion_killable);
  * signaled or for a specified timeout to expire. It can be
  * interrupted by a kill signal. The timeout is in jiffies.
  *
- * The return value is -ERESTARTSYS if interrupted, 0 if timed out,
- * positive (at least 1, or number of jiffies left till timeout) if completed.
+ * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
+ * or number of jiffies left till timeout) if completed.
  */
 long __sched
 wait_for_completion_killable_timeout(struct completion *x,
@@ -2918,7 +2923,7 @@ EXPORT_SYMBOL(wait_for_completion_killable_timeout);
  *	try_wait_for_completion - try to decrement a completion without blocking
  *	@x:	completion structure
  *
- *	Returns: 0 if a decrement cannot be done without blocking
+ *	Return: 0 if a decrement cannot be done without blocking
  *		 1 if a decrement succeeded.
  *
  *	If a completion is being used as a counting completion,
@@ -2945,7 +2950,7 @@ EXPORT_SYMBOL(try_wait_for_completion);
  *	completion_done - Test to see if a completion has any waiters
  *	@x:	completion structure
  *
- *	Returns: 0 if there are waiters (wait_for_completion() in progress)
+ *	Return: 0 if there are waiters (wait_for_completion() in progress)
  *		 1 if there are no waiters.
  *
  */
@@ -3182,7 +3187,7 @@ SYSCALL_DEFINE1(nice, int, increment)
  * task_prio - return the priority value of a given task.
  * @p: the task in question.
  *
- * This is the priority value as seen by users in /proc.
+ * Return: The priority value as seen by users in /proc.
  * RT tasks are offset by -200. Normal tasks are centered
  * around 0, value goes from -16 to +15.
  */
@@ -3194,6 +3199,8 @@ int task_prio(const struct task_struct *p)
 /**
  * task_nice - return the nice value of a given task.
  * @p: the task in question.
+ *
+ * Return: The nice value [ -20 ... 0 ... 19 ].
  */
 int task_nice(const struct task_struct *p)
 {
@@ -3204,6 +3211,8 @@ EXPORT_SYMBOL(task_nice);
 /**
  * idle_cpu - is a given cpu idle currently?
  * @cpu: the processor in question.
+ *
+ * Return: 1 if the CPU is currently idle. 0 otherwise.
  */
 int idle_cpu(int cpu)
 {
@@ -3226,6 +3235,8 @@ int idle_cpu(int cpu)
 /**
  * idle_task - return the idle task for a given cpu.
  * @cpu: the processor in question.
+ *
+ * Return: The idle task for the cpu @cpu.
  */
 struct task_struct *idle_task(int cpu)
 {
@@ -3235,6 +3246,8 @@ struct task_struct *idle_task(int cpu)
 /**
  * find_process_by_pid - find a process with a matching PID value.
  * @pid: the pid in question.
+ *
+ * The task of @pid, if found. %NULL otherwise.
  */
 static struct task_struct *find_process_by_pid(pid_t pid)
 {
@@ -3432,6 +3445,8 @@ recheck:
  * @policy: new policy.
  * @param: structure containing the new RT priority.
  *
+ * Return: 0 on success. An error code otherwise.
+ *
  * NOTE that the task may be already dead.
  */
 int sched_setscheduler(struct task_struct *p, int policy,
@@ -3451,6 +3466,8 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
  * current context has permission.  For example, this is needed in
  * stop_machine(): we create temporary high priority worker threads,
  * but our caller might not have that capability.
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       const struct sched_param *param)
@@ -3485,6 +3502,8 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
  * @pid: the pid in question.
  * @policy: new policy.
  * @param: structure containing the new RT priority.
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
 		struct sched_param __user *, param)
@@ -3500,6 +3519,8 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 {
@@ -3509,6 +3530,9 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 /**
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
+ *
+ * Return: On success, the policy of the thread. Otherwise, a negative error
+ * code.
  */
 SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 {
@@ -3535,6 +3559,9 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
  * sys_sched_getparam - get the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the RT priority.
+ *
+ * Return: On success, 0 and the RT priority is in @param. Otherwise, an error
+ * code.
  */
 SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 {
@@ -3659,6 +3686,8 @@ static int get_user_cpu_mask(unsigned long __user *user_mask_ptr, unsigned len,
  * @pid: pid of the process
  * @len: length in bytes of the bitmask pointed to by user_mask_ptr
  * @user_mask_ptr: user-space pointer to the new cpu mask
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 SYSCALL_DEFINE3(sched_setaffinity, pid_t, pid, unsigned int, len,
 		unsigned long __user *, user_mask_ptr)
@@ -3710,6 +3739,8 @@ out_unlock:
  * @pid: pid of the process
  * @len: length in bytes of the bitmask pointed to by user_mask_ptr
  * @user_mask_ptr: user-space pointer to hold the current cpu mask
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 		unsigned long __user *, user_mask_ptr)
@@ -3744,6 +3775,8 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
  *
  * This function yields the current CPU to other tasks. If there are no
  * other threads running on this CPU then this function will return.
+ *
+ * Return: 0.
  */
 SYSCALL_DEFINE0(sched_yield)
 {
@@ -3869,7 +3902,7 @@ EXPORT_SYMBOL(yield);
  * It's the caller's job to ensure that the target task struct
  * can't go away on us before we can do any checks.
  *
- * Returns:
+ * Return:
  *	true (>0) if we indeed boosted the target task.
  *	false (0) if we failed to boost the target.
  *	-ESRCH if there's no task to yield to.
@@ -3972,8 +4005,9 @@ long __sched io_schedule_timeout(long timeout)
  * sys_sched_get_priority_max - return maximum RT priority.
  * @policy: scheduling class.
  *
- * this syscall returns the maximum rt_priority that can be used
- * by a given scheduling class.
+ * Return: On success, this syscall returns the maximum
+ * rt_priority that can be used by a given scheduling class.
+ * On failure, a negative error code is returned.
  */
 SYSCALL_DEFINE1(sched_get_priority_max, int, policy)
 {
@@ -3997,8 +4031,9 @@ SYSCALL_DEFINE1(sched_get_priority_max, int, policy)
  * sys_sched_get_priority_min - return minimum RT priority.
  * @policy: scheduling class.
  *
- * this syscall returns the minimum rt_priority that can be used
- * by a given scheduling class.
+ * Return: On success, this syscall returns the minimum
+ * rt_priority that can be used by a given scheduling class.
+ * On failure, a negative error code is returned.
  */
 SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
 {
@@ -4024,6 +4059,9 @@ SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
  *
  * this syscall writes the default timeslice value of a given process
  * into the user-space timespec buffer. A value of '0' means infinity.
+ *
+ * Return: On success, 0 and the timeslice is in @interval. Otherwise,
+ * an error code.
  */
 SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 		struct timespec __user *, interval)
@@ -6632,6 +6670,8 @@ void normalize_rt_tasks(void)
  * @cpu: the processor in question.
  *
  * ONLY VALID WHEN THE WHOLE SYSTEM IS STOPPED!
+ *
+ * Return: The current task for @cpu.
  */
 struct task_struct *curr_task(int cpu)
 {
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 1095e87..8b836b3 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -62,7 +62,7 @@ static int convert_prio(int prio)
  * any discrepancies created by racing against the uncertainty of the current
  * priority configuration.
  *
- * Returns: (int)bool - CPUs were found
+ * Return: (int)bool - CPUs were found
  */
 int cpupri_find(struct cpupri *cp, struct task_struct *p,
 		struct cpumask *lowest_mask)
@@ -203,7 +203,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  * cpupri_init - initialize the cpupri structure
  * @cp: The cpupri context
  *
- * Returns: -ENOMEM if memory fails.
+ * Return: -ENOMEM on memory allocation failure.
  */
 int cpupri_init(struct cpupri *cp)
 {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f77f9c5..98d1355 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4280,6 +4280,8 @@ struct sg_lb_stats {
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
  * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
+ *
+ * Return: The load index.
  */
 static inline int get_sd_load_idx(struct sched_domain *sd,
 					enum cpu_idle_type idle)
@@ -4574,6 +4576,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
  *
  * Determine if @sg is a busier group than the previously selected
  * busiest group.
+ *
+ * Return: %true if @sg is a busier group than the previously selected
+ * busiest group. %false otherwise.
  */
 static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sd_lb_stats *sds,
@@ -4691,7 +4696,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
  * assuming lower CPU number will be equivalent to lower a SMT thread
  * number.
  *
- * Returns 1 when packing is required and a task should be moved to
+ * Return: 1 when packing is required and a task should be moved to
  * this CPU.  The amount of the imbalance is returned in *imbalance.
  *
  * @env: The load balancing environment.
@@ -4869,7 +4874,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
  * @balance: Pointer to a variable indicating if this_cpu
  *	is the appropriate cpu to perform load balancing at this_level.
  *
- * Returns:	- the busiest group if imbalance exists.
+ * Return:	- The busiest group if imbalance exists.
  *		- If no imbalance and user has opted for power-savings balance,
  *		   return the least loaded group whose CPUs can be
  *		   put to idle by rebalancing its tasks onto our group.
