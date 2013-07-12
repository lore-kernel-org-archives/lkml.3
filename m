Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965282Ab3GLSqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:46:23 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:47751 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247Ab3GLSqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:46:21 -0400
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yacine.belkadi.1@gmail.com
Subject: [PATCH] sched: fix some kernel-doc warnings
Date: Fri, 12 Jul 2013 20:45:47 +0200
Message-Id: <1373654747-2389-1-git-send-email-yacine.belkadi.1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building the htmldocs (in verbose mode), scripts/kernel-doc reports the
follwing type of warnings:

Warning(kernel/sched/core.c:936): No description found for return value of
'task_curr'

Fix those by:
- adding the missing descriptions
- using "Return" sections for the descriptions

Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
---

Applied to d2b4a646717153a1a180b64d4a8464054dbd700e

 include/linux/sched.h |    6 ++++
 kernel/sched/core.c   |   82 ++++++++++++++++++++++++++++++++++++-------------
 kernel/sched/cpupri.c |    4 +--
 kernel/sched/fair.c   |    9 ++++--
 4 files changed, 76 insertions(+), 25 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cdd5407..96720dd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1537,6 +1537,8 @@ static inline pid_t task_pgrp_nr(struct task_struct *tsk)
  * Test if a process is not yet dead (at most zombie state)
  * If pid_alive fails, then pointers within the task structure
  * can be stale and must not be dereferenced.
+ *
+ * Return: 1 if the process is alive. 0 otherwise.
  */
 static inline int pid_alive(struct task_struct *p)
 {
@@ -1548,6 +1550,8 @@ static inline int pid_alive(struct task_struct *p)
  * @tsk: Task structure to be checked.
  *
  * Check if a task structure is the first user space task the kernel created.
+ *
+ * Return: 1 if the task structure is init. 0 otherwise.
  */
 static inline int is_global_init(struct task_struct *tsk)
 {
@@ -1898,6 +1902,8 @@ extern struct task_struct *idle_task(int cpu);
 /**
  * is_idle_task - is the specified task an idle task?
  * @p: the task in question.
+ *
+ * Return: 1 if @p is an idle task. 0 otherwise.
  */
 static inline bool is_idle_task(const struct task_struct *p)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9b1f2e5..cbbf574 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -931,6 +931,8 @@ static int effective_prio(struct task_struct *p)
 /**
  * task_curr - is this task currently executing on a CPU?
  * @p: the task in question.
+ *
+ * Return: 1 if the task is currently executing. 0 otherwise.
  */
 inline int task_curr(const struct task_struct *p)
 {
@@ -1480,7 +1482,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
  * the simpler "current->state = TASK_RUNNING" to mark yourself
  * runnable without the overhead of this.
  *
- * Returns %true if @p was woken up, %false if it was already running
+ * Return: %true if @p was woken up, %false if it was already running.
  * or @state didn't match @p's state.
  */
 static int
@@ -1575,8 +1577,9 @@ out:
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
@@ -2189,6 +2192,8 @@ void scheduler_tick(void)
  * This makes sure that uptime, CFS vruntime, load
  * balancing, etc... continue to move forward, even
  * with a very low granularity.
+ *
+ * Return: Maximum deferment in nanoseconds.
  */
 u64 scheduler_tick_max_deferment(void)
 {
@@ -2794,8 +2799,8 @@ EXPORT_SYMBOL(wait_for_completion);
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
@@ -2827,8 +2832,8 @@ EXPORT_SYMBOL(wait_for_completion_io);
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
@@ -2844,7 +2849,7 @@ EXPORT_SYMBOL(wait_for_completion_io_timeout);
  * This waits for completion of a specific task to be signaled. It is
  * interruptible.
  *
- * The return value is -ERESTARTSYS if interrupted, 0 if completed.
+ * Return: -ERESTARTSYS if interrupted, 0 if completed.
  */
 int __sched wait_for_completion_interruptible(struct completion *x)
 {
@@ -2863,8 +2868,8 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
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
@@ -2881,7 +2886,7 @@ EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
  * This waits to be signaled for completion of a specific task. It can be
  * interrupted by a kill signal.
  *
- * The return value is -ERESTARTSYS if interrupted, 0 if completed.
+ * Return: -ERESTARTSYS if interrupted, 0 if completed.
  */
 int __sched wait_for_completion_killable(struct completion *x)
 {
@@ -2901,8 +2906,8 @@ EXPORT_SYMBOL(wait_for_completion_killable);
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
@@ -2916,7 +2921,7 @@ EXPORT_SYMBOL(wait_for_completion_killable_timeout);
  *	try_wait_for_completion - try to decrement a completion without blocking
  *	@x:	completion structure
  *
- *	Returns: 0 if a decrement cannot be done without blocking
+ *	Return: 0 if a decrement cannot be done without blocking
  *		 1 if a decrement succeeded.
  *
  *	If a completion is being used as a counting completion,
@@ -2943,7 +2948,7 @@ EXPORT_SYMBOL(try_wait_for_completion);
  *	completion_done - Test to see if a completion has any waiters
  *	@x:	completion structure
  *
- *	Returns: 0 if there are waiters (wait_for_completion() in progress)
+ *	Return: 0 if there are waiters (wait_for_completion() in progress)
  *		 1 if there are no waiters.
  *
  */
@@ -3180,7 +3185,7 @@ SYSCALL_DEFINE1(nice, int, increment)
  * task_prio - return the priority value of a given task.
  * @p: the task in question.
  *
- * This is the priority value as seen by users in /proc.
+ * Return: The priority value as seen by users in /proc.
  * RT tasks are offset by -200. Normal tasks are centered
  * around 0, value goes from -16 to +15.
  */
@@ -3192,6 +3197,8 @@ int task_prio(const struct task_struct *p)
 /**
  * task_nice - return the nice value of a given task.
  * @p: the task in question.
+ *
+ * Return: The nice value [ -20 ... 0 ... 19 ].
  */
 int task_nice(const struct task_struct *p)
 {
@@ -3202,6 +3209,8 @@ EXPORT_SYMBOL(task_nice);
 /**
  * idle_cpu - is a given cpu idle currently?
  * @cpu: the processor in question.
+ *
+ * Return: 1 if the CPU is currently idle. 0 otherwise.
  */
 int idle_cpu(int cpu)
 {
@@ -3224,6 +3233,8 @@ int idle_cpu(int cpu)
 /**
  * idle_task - return the idle task for a given cpu.
  * @cpu: the processor in question.
+ *
+ * Return: The idle task for the cpu @cpu.
  */
 struct task_struct *idle_task(int cpu)
 {
@@ -3233,6 +3244,8 @@ struct task_struct *idle_task(int cpu)
 /**
  * find_process_by_pid - find a process with a matching PID value.
  * @pid: the pid in question.
+ *
+ * The task of @pid, if found. %NULL otherwise.
  */
 static struct task_struct *find_process_by_pid(pid_t pid)
 {
@@ -3430,6 +3443,8 @@ recheck:
  * @policy: new policy.
  * @param: structure containing the new RT priority.
  *
+ * Return: 0 on success. An error code otherwise.
+ *
  * NOTE that the task may be already dead.
  */
 int sched_setscheduler(struct task_struct *p, int policy,
@@ -3449,6 +3464,8 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
  * current context has permission.  For example, this is needed in
  * stop_machine(): we create temporary high priority worker threads,
  * but our caller might not have that capability.
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       const struct sched_param *param)
@@ -3483,6 +3500,8 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
  * @pid: the pid in question.
  * @policy: new policy.
  * @param: structure containing the new RT priority.
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
 		struct sched_param __user *, param)
@@ -3498,6 +3517,8 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 {
@@ -3507,6 +3528,9 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 /**
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
+ *
+ * Return: On success, the policy of the thread. Otherwise, a negative error
+ * code.
  */
 SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 {
@@ -3533,6 +3557,9 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
  * sys_sched_getparam - get the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the RT priority.
+ *
+ * Return: On success, 0 and the RT priority is in @param. Otherwise, an error
+ * code.
  */
 SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 {
@@ -3657,6 +3684,8 @@ static int get_user_cpu_mask(unsigned long __user *user_mask_ptr, unsigned len,
  * @pid: pid of the process
  * @len: length in bytes of the bitmask pointed to by user_mask_ptr
  * @user_mask_ptr: user-space pointer to the new cpu mask
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 SYSCALL_DEFINE3(sched_setaffinity, pid_t, pid, unsigned int, len,
 		unsigned long __user *, user_mask_ptr)
@@ -3708,6 +3737,8 @@ out_unlock:
  * @pid: pid of the process
  * @len: length in bytes of the bitmask pointed to by user_mask_ptr
  * @user_mask_ptr: user-space pointer to hold the current cpu mask
+ *
+ * Return: 0 on success. An error code otherwise.
  */
 SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 		unsigned long __user *, user_mask_ptr)
@@ -3742,6 +3773,8 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
  *
  * This function yields the current CPU to other tasks. If there are no
  * other threads running on this CPU then this function will return.
+ *
+ * Return: 0.
  */
 SYSCALL_DEFINE0(sched_yield)
 {
@@ -3867,7 +3900,7 @@ EXPORT_SYMBOL(yield);
  * It's the caller's job to ensure that the target task struct
  * can't go away on us before we can do any checks.
  *
- * Returns:
+ * Return:
  *	true (>0) if we indeed boosted the target task.
  *	false (0) if we failed to boost the target.
  *	-ESRCH if there's no task to yield to.
@@ -3970,8 +4003,9 @@ long __sched io_schedule_timeout(long timeout)
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
@@ -3995,8 +4029,9 @@ SYSCALL_DEFINE1(sched_get_priority_max, int, policy)
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
@@ -4022,6 +4057,9 @@ SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
  *
  * this syscall writes the default timeslice value of a given process
  * into the user-space timespec buffer. A value of '0' means infinity.
+ *
+ * Return: On success, 0 and the timeslice is in @interval. Otherwise,
+ * an error code.
  */
 SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 		struct timespec __user *, interval)
@@ -6630,6 +6668,8 @@ void normalize_rt_tasks(void)
  * @cpu: the processor in question.
  *
  * ONLY VALID WHEN THE WHOLE SYSTEM IS STOPPED!
+ *
+ * Return: The current task for @cpu.
  */
 struct task_struct *curr_task(int cpu)
 {
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 1095e87..abe64af 100644
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
+ * Return: -ENOMEM if memory fails.
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
-- 
1.7.10.4

