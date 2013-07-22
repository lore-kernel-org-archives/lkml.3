Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab3GVSq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:46:58 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44221 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866Ab3GVSqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:46:54 -0400
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yacine.belkadi.1@gmail.com
Subject: [PATCH] workqueue: fix some scripts/kernel-doc warnings
Date: Mon, 22 Jul 2013 20:46:34 +0200
Message-Id: <1374518794-1982-1-git-send-email-yacine.belkadi.1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building the htmldocs (in verbose mode), scripts/kernel-doc reports the
following type of warnings:

Warning(kernel/workqueue.c:653): No description found for return value of
'get_work_pool'

Fix them by:
- Using "Return:" sections to introduce descriptions of return values
- Adding some missing descriptions

Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
---

 Applied to 61f98b0fca802d7e0191072606519e2230a6226d

 kernel/workqueue.c |  107 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 41 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f02c4a4..08e2e97 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -540,6 +540,8 @@ static int worker_pool_assign_id(struct worker_pool *pool)
  * This must be called either with pwq_lock held or sched RCU read locked.
  * If the pwq needs to be used beyond the locking in effect, the caller is
  * responsible for guaranteeing that the pwq stays online.
+ *
+ * Return: The unbound pool_workqueue for @node.
  */
 static struct pool_workqueue *unbound_pwq_by_node(struct workqueue_struct *wq,
 						  int node)
@@ -638,8 +640,6 @@ static struct pool_workqueue *get_work_pwq(struct work_struct *work)
  * get_work_pool - return the worker_pool a given work was associated with
  * @work: the work item of interest
  *
- * Return the worker_pool @work was last associated with.  %NULL if none.
- *
  * Pools are created and destroyed under wq_pool_mutex, and allows read
  * access under sched-RCU read lock.  As such, this function should be
  * called under wq_pool_mutex or with preemption disabled.
@@ -648,6 +648,8 @@ static struct pool_workqueue *get_work_pwq(struct work_struct *work)
  * mentioned locking is in effect.  If the returned pool needs to be used
  * beyond the critical section, the caller is responsible for ensuring the
  * returned pool is and stays online.
+ *
+ * Return: The worker_pool @work was last associated with.  %NULL if none.
  */
 static struct worker_pool *get_work_pool(struct work_struct *work)
 {
@@ -671,7 +673,7 @@ static struct worker_pool *get_work_pool(struct work_struct *work)
  * get_work_pool_id - return the worker pool ID a given work is associated with
  * @work: the work item of interest
  *
- * Return the worker_pool ID @work was last associated with.
+ * Return: The worker_pool ID @work was last associated with.
  * %WORK_OFFQ_POOL_NONE if none.
  */
 static int get_work_pool_id(struct work_struct *work)
@@ -830,7 +832,7 @@ void wq_worker_waking_up(struct task_struct *task, int cpu)
  * CONTEXT:
  * spin_lock_irq(rq->lock)
  *
- * RETURNS:
+ * Return:
  * Worker task on @cpu to wake up, %NULL if none.
  */
 struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
@@ -965,8 +967,8 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
  * CONTEXT:
  * spin_lock_irq(pool->lock).
  *
- * RETURNS:
- * Pointer to worker which is executing @work if found, NULL
+ * Return:
+ * Pointer to worker which is executing @work if found, %NULL
  * otherwise.
  */
 static struct worker *find_worker_executing_work(struct worker_pool *pool,
@@ -1154,14 +1156,16 @@ out_put:
  * @flags: place to store irq state
  *
  * Try to grab PENDING bit of @work.  This function can handle @work in any
- * stable state - idle, on timer or on worklist.  Return values are
+ * stable state - idle, on timer or on worklist.
  *
+ * Return:
  *  1		if @work was pending and we successfully stole PENDING
  *  0		if @work was idle and we claimed PENDING
  *  -EAGAIN	if PENDING couldn't be grabbed at the moment, safe to busy-retry
  *  -ENOENT	if someone else is canceling @work, this state may persist
  *		for arbitrarily long
  *
+ * Note:
  * On >= 0 return, the caller owns @work's PENDING bit.  To avoid getting
  * interrupted while holding PENDING and @work off queue, irq must be
  * disabled on entry.  This, combined with delayed_work->timer being
@@ -1403,10 +1407,10 @@ retry:
  * @wq: workqueue to use
  * @work: work to queue
  *
- * Returns %false if @work was already on a queue, %true otherwise.
- *
  * We queue the work to a specific CPU, the caller must ensure it
  * can't go away.
+ *
+ * Return: %false if @work was already on a queue, %true otherwise.
  */
 bool queue_work_on(int cpu, struct workqueue_struct *wq,
 		   struct work_struct *work)
@@ -1476,7 +1480,7 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
  * @dwork: work to queue
  * @delay: number of jiffies to wait before queueing
  *
- * Returns %false if @work was already on a queue, %true otherwise.  If
+ * Return: %false if @work was already on a queue, %true otherwise.  If
  * @delay is zero and @dwork is idle, it will be scheduled for immediate
  * execution.
  */
@@ -1512,7 +1516,7 @@ EXPORT_SYMBOL(queue_delayed_work_on);
  * zero, @work is guaranteed to be scheduled immediately regardless of its
  * current state.
  *
- * Returns %false if @dwork was idle and queued, %true if @dwork was
+ * Return: %false if @dwork was idle and queued, %true if @dwork was
  * pending and its timer was modified.
  *
  * This function is safe to call from any context including IRQ handler.
@@ -1627,7 +1631,7 @@ static void worker_leave_idle(struct worker *worker)
  * Might sleep.  Called without any lock but returns with pool->lock
  * held.
  *
- * RETURNS:
+ * Return:
  * %true if the associated pool is online (@worker is successfully
  * bound), %false if offline.
  */
@@ -1688,7 +1692,7 @@ static struct worker *alloc_worker(void)
  * CONTEXT:
  * Might sleep.  Does GFP_KERNEL allocations.
  *
- * RETURNS:
+ * Return:
  * Pointer to the newly created worker.
  */
 static struct worker *create_worker(struct worker_pool *pool)
@@ -1788,6 +1792,8 @@ static void start_worker(struct worker *worker)
  * @pool: the target pool
  *
  * Grab the managership of @pool and create and start a new worker for it.
+ *
+ * Return: 0 on success. A negative error code otherwise.
  */
 static int create_and_start_worker(struct worker_pool *pool)
 {
@@ -1932,7 +1938,7 @@ static void pool_mayday_timeout(unsigned long __pool)
  * multiple times.  Does GFP_KERNEL allocations.  Called only from
  * manager.
  *
- * RETURNS:
+ * Return:
  * %false if no action was taken and pool->lock stayed locked, %true
  * otherwise.
  */
@@ -1989,7 +1995,7 @@ restart:
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Called only from manager.
  *
- * RETURNS:
+ * Return:
  * %false if no action was taken and pool->lock stayed locked, %true
  * otherwise.
  */
@@ -2032,7 +2038,7 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.
  *
- * RETURNS:
+ * Return:
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.
  */
@@ -2246,6 +2252,8 @@ static void process_scheduled_works(struct worker *worker)
  * work items regardless of their specific target workqueue.  The only
  * exception is work items which belong to workqueues with a rescuer which
  * will be explained in rescuer_thread().
+ *
+ * Return: 0
  */
 static int worker_thread(void *__worker)
 {
@@ -2344,6 +2352,8 @@ sleep:
  * those works so that forward progress can be guaranteed.
  *
  * This should happen rarely.
+ *
+ * Return: 0
  */
 static int rescuer_thread(void *__rescuer)
 {
@@ -2516,7 +2526,7 @@ static void insert_wq_barrier(struct pool_workqueue *pwq,
  * CONTEXT:
  * mutex_lock(wq->mutex).
  *
- * RETURNS:
+ * Return:
  * %true if @flush_color >= 0 and there's something to flush.  %false
  * otherwise.
  */
@@ -2824,7 +2834,7 @@ already_gone:
  * Wait until @work has finished execution.  @work is guaranteed to be idle
  * on return if it hasn't been requeued since flush started.
  *
- * RETURNS:
+ * Return:
  * %true if flush_work() waited for the work to finish execution,
  * %false if it was already idle.
  */
@@ -2884,7 +2894,7 @@ static bool __cancel_work_timer(struct work_struct *work, bool is_dwork)
  * The caller must ensure that the workqueue on which @work was last
  * queued can't be destroyed before this function returns.
  *
- * RETURNS:
+ * Return:
  * %true if @work was pending, %false otherwise.
  */
 bool cancel_work_sync(struct work_struct *work)
@@ -2901,7 +2911,7 @@ EXPORT_SYMBOL_GPL(cancel_work_sync);
  * immediate execution.  Like flush_work(), this function only
  * considers the last queueing instance of @dwork.
  *
- * RETURNS:
+ * Return:
  * %true if flush_work() waited for the work to finish execution,
  * %false if it was already idle.
  */
@@ -2919,11 +2929,15 @@ EXPORT_SYMBOL(flush_delayed_work);
  * cancel_delayed_work - cancel a delayed work
  * @dwork: delayed_work to cancel
  *
- * Kill off a pending delayed_work.  Returns %true if @dwork was pending
- * and canceled; %false if wasn't pending.  Note that the work callback
- * function may still be running on return, unless it returns %true and the
- * work doesn't re-arm itself.  Explicitly flush or use
- * cancel_delayed_work_sync() to wait on it.
+ * Kill off a pending delayed_work.
+ *
+ * Return: %true if @dwork was pending and canceled; %false if it wasn't
+ * pending.
+ *
+ * Note:
+ * The work callback function may still be running on return, unless
+ * it returns %true and the work doesn't re-arm itself.  Explicitly flush or
+ * use cancel_delayed_work_sync() to wait on it.
  *
  * This function is safe to call from any context including IRQ handler.
  */
@@ -2952,7 +2966,7 @@ EXPORT_SYMBOL(cancel_delayed_work);
  *
  * This is cancel_work_sync() for delayed works.
  *
- * RETURNS:
+ * Return:
  * %true if @dwork was pending, %false otherwise.
  */
 bool cancel_delayed_work_sync(struct delayed_work *dwork)
@@ -2969,7 +2983,7 @@ EXPORT_SYMBOL(cancel_delayed_work_sync);
  * system workqueue and blocks until all CPUs have completed.
  * schedule_on_each_cpu() is very slow.
  *
- * RETURNS:
+ * Return:
  * 0 on success, -errno on failure.
  */
 int schedule_on_each_cpu(work_func_t func)
@@ -3037,7 +3051,7 @@ EXPORT_SYMBOL(flush_scheduled_work);
  * Executes the function immediately if process context is available,
  * otherwise schedules the function for delayed execution.
  *
- * Returns:	0 - function was executed
+ * Return:	0 - function was executed
  *		1 - function was scheduled for execution
  */
 int execute_in_process_context(work_func_t fn, struct execute_work *ew)
@@ -3294,7 +3308,7 @@ static void wq_device_release(struct device *dev)
  * apply_workqueue_attrs() may race against userland updating the
  * attributes.
  *
- * Returns 0 on success, -errno on failure.
+ * Return: 0 on success, -errno on failure.
  */
 int workqueue_sysfs_register(struct workqueue_struct *wq)
 {
@@ -3387,7 +3401,9 @@ void free_workqueue_attrs(struct workqueue_attrs *attrs)
  * @gfp_mask: allocation mask to use
  *
  * Allocate a new workqueue_attrs, initialize with default settings and
- * return it.  Returns NULL on failure.
+ * return it.
+ *
+ * Return: The allocated new workqueue_attr on success. %NULL on failure.
  */
 struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask)
 {
@@ -3440,7 +3456,8 @@ static bool wqattrs_equal(const struct workqueue_attrs *a,
  * @pool: worker_pool to initialize
  *
  * Initiailize a newly zalloc'd @pool.  It also allocates @pool->attrs.
- * Returns 0 on success, -errno on failure.  Even on failure, all fields
+ *
+ * Return: 0 on success, -errno on failure.  Even on failure, all fields
  * inside @pool proper are initialized and put_unbound_pool() can be called
  * on @pool safely to release it.
  */
@@ -3547,9 +3564,12 @@ static void put_unbound_pool(struct worker_pool *pool)
  * Obtain a worker_pool which has the same attributes as @attrs, bump the
  * reference count and return it.  If there already is a matching
  * worker_pool, it will be used; otherwise, this function attempts to
- * create a new one.  On failure, returns NULL.
+ * create a new one.
  *
  * Should be called with wq_pool_mutex held.
+ *
+ * Return: On success, a worker_pool with the same attributes as @attrs.
+ * On failure, %NULL.
  */
 static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 {
@@ -3779,9 +3799,7 @@ static void free_unbound_pwq(struct pool_workqueue *pwq)
  *
  * Calculate the cpumask a workqueue with @attrs should use on @node.  If
  * @cpu_going_down is >= 0, that cpu is considered offline during
- * calculation.  The result is stored in @cpumask.  This function returns
- * %true if the resulting @cpumask is different from @attrs->cpumask,
- * %false if equal.
+ * calculation.  The result is stored in @cpumask.
  *
  * If NUMA affinity is not enabled, @attrs->cpumask is always used.  If
  * enabled and @node has online CPUs requested by @attrs, the returned
@@ -3790,6 +3808,9 @@ static void free_unbound_pwq(struct pool_workqueue *pwq)
  *
  * The caller is responsible for ensuring that the cpumask of @node stays
  * stable.
+ *
+ * Return: %true if the resulting @cpumask is different from @attrs->cpumask,
+ * %false if equal.
  */
 static bool wq_calc_node_cpumask(const struct workqueue_attrs *attrs, int node,
 				 int cpu_going_down, cpumask_t *cpumask)
@@ -3843,8 +3864,9 @@ static struct pool_workqueue *numa_pwq_tbl_install(struct workqueue_struct *wq,
  * items finish.  Note that a work item which repeatedly requeues itself
  * back-to-back will stay on its current pwq.
  *
- * Performs GFP_KERNEL allocations.  Returns 0 on success and -errno on
- * failure.
+ * Performs GFP_KERNEL allocations.
+ *
+ * Return: 0 on success and -errno on failure.
  */
 int apply_workqueue_attrs(struct workqueue_struct *wq,
 			  const struct workqueue_attrs *attrs)
@@ -4312,6 +4334,8 @@ EXPORT_SYMBOL_GPL(workqueue_set_max_active);
  *
  * Determine whether %current is a workqueue rescuer.  Can be used from
  * work functions to determine whether it's being run off the rescuer task.
+ *
+ * Return: %true if %current is a workqueue rescuer. %false otherwise.
  */
 bool current_is_workqueue_rescuer(void)
 {
@@ -4335,7 +4359,7 @@ bool current_is_workqueue_rescuer(void)
  * workqueue being congested on one CPU doesn't mean the workqueue is also
  * contested on other CPUs / NUMA nodes.
  *
- * RETURNS:
+ * Return:
  * %true if congested, %false otherwise.
  */
 bool workqueue_congested(int cpu, struct workqueue_struct *wq)
@@ -4368,7 +4392,7 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  * synchronization around this function and the test result is
  * unreliable and only useful as advisory hints or for debugging.
  *
- * RETURNS:
+ * Return:
  * OR'd bitmask of WORK_BUSY_* bits.
  */
 unsigned int work_busy(struct work_struct *work)
@@ -4746,9 +4770,10 @@ static void work_for_cpu_fn(struct work_struct *work)
  * @fn: the function to run
  * @arg: the function arg
  *
- * This will return the value @fn returns.
  * It is up to the caller to ensure that the cpu doesn't go offline.
  * The caller must not hold any locks which would prevent @fn from completing.
+ *
+ * Return: The value @fn returns.
  */
 long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 {
@@ -4813,7 +4838,7 @@ void freeze_workqueues_begin(void)
  * CONTEXT:
  * Grabs and releases wq_pool_mutex.
  *
- * RETURNS:
+ * Return:
  * %true if some freezable workqueues are still busy.  %false if freezing
  * is complete.
  */
-- 
1.7.10.4

