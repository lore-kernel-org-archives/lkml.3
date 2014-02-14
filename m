Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBNQ0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:26:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:43099 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaBNQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:26:14 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>,
        Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH RT] latency-hist: mostly checkpatch cleanup
Date: Fri, 14 Feb 2014 17:26:05 +0100
Message-Id: <1392395165-29948-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.0.rc3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Mc Guire <der.herr@hofr.at>

This checkpatch.pl cleanup.
What remains is "WARNING: quoted string split across lines" and I am not
going to extend pr_info() over 80 chars.

Most things are cosmetic. There is one spot where NR_CPUS got replaced
with cpu_possible()

Cc: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 latency-hist.patch | 100 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 48 deletions(-)

diff --git a/latency-hist.patch b/latency-hist.patch
index 46cbcdb..cf45c69 100644
--- a/latency-hist.patch
+++ b/latency-hist.patch
@@ -243,7 +243,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
  	struct memcg_batch_info {
 --- /dev/null
 +++ b/include/trace/events/hist.h
-@@ -0,0 +1,69 @@
+@@ -0,0 +1,72 @@
 +#undef TRACE_SYSTEM
 +#define TRACE_SYSTEM hist
 +
@@ -254,7 +254,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +#include <linux/tracepoint.h>
 +
 +#if !defined(CONFIG_PREEMPT_OFF_HIST) && !defined(CONFIG_INTERRUPT_OFF_HIST)
-+#define trace_preemptirqsoff_hist(a,b)
++#define trace_preemptirqsoff_hist(a, b)
 +#else
 +TRACE_EVENT(preemptirqsoff_hist,
 +
@@ -263,8 +263,8 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +	TP_ARGS(reason, starthist),
 +
 +	TP_STRUCT__entry(
-+		__field(int,	reason	)
-+		__field(int,	starthist	)
++		__field(int,	reason)
++		__field(int,	starthist)
 +	),
 +
 +	TP_fast_assign(
@@ -278,21 +278,22 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +#endif
 +
 +#ifndef CONFIG_MISSED_TIMER_OFFSETS_HIST
-+#define trace_hrtimer_interrupt(a,b,c,d)
++#define trace_hrtimer_interrupt(a, b, c, d)
 +#else
 +TRACE_EVENT(hrtimer_interrupt,
 +
-+	TP_PROTO(int cpu, long long offset, struct task_struct *curr, struct task_struct *task),
++	TP_PROTO(int cpu, long long offset, struct task_struct *curr,
++		struct task_struct *task),
 +
 +	TP_ARGS(cpu, offset, curr, task),
 +
 +	TP_STRUCT__entry(
-+		__field(int,		cpu	)
-+		__field(long long,	offset	)
++		__field(int,		cpu)
++		__field(long long,	offset)
 +		__array(char,		ccomm,	TASK_COMM_LEN)
-+		__field(int,		cprio	)
++		__field(int,		cprio)
 +		__array(char,		tcomm,	TASK_COMM_LEN)
-+		__field(int,		tprio	)
++		__field(int,		tprio)
 +	),
 +
 +	TP_fast_assign(
@@ -300,12 +301,14 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +		__entry->offset	= offset;
 +		memcpy(__entry->ccomm, curr->comm, TASK_COMM_LEN);
 +		__entry->cprio  = curr->prio;
-+		memcpy(__entry->tcomm, task != NULL ? task->comm : "<none>", task != NULL ? TASK_COMM_LEN : 7);
++		memcpy(__entry->tcomm, task != NULL ? task->comm : "<none>",
++			task != NULL ? TASK_COMM_LEN : 7);
 +		__entry->tprio  = task != NULL ? task->prio : -1;
 +	),
 +
 +	TP_printk("cpu=%d offset=%lld curr=%s[%d] thread=%s[%d]",
-+		__entry->cpu, __entry->offset, __entry->ccomm, __entry->cprio, __entry->tcomm, __entry->tprio)
++		__entry->cpu, __entry->offset, __entry->ccomm,
++		__entry->cprio, __entry->tcomm, __entry->tprio)
 +);
 +#endif
 +
@@ -340,8 +343,8 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +static inline char *getaction(int action)
 +{
 +	if (action >= 0 && action <= sizeof(actions)/sizeof(actions[0]))
-+		return(actions[action]);
-+	return("unknown");
++		return actions[action];
++	return "unknown";
 +}
 +
 +#endif /* _LATENCY_HIST_H */
@@ -540,7 +543,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
  obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 --- /dev/null
 +++ b/kernel/trace/latency_hist.c
-@@ -0,0 +1,1177 @@
+@@ -0,0 +1,1166 @@
 +/*
 + * kernel/trace/latency_hist.c
 + *
@@ -565,7 +568,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +#include <linux/sched.h>
 +#include <linux/sched/rt.h>
 +#include <linux/slab.h>
-+#include <asm/atomic.h>
++#include <linux/atomic.h>
 +#include <asm/div64.h>
 +
 +#include "trace.h"
@@ -638,7 +641,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +#endif
 +
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +struct maxlatproc_data {
 +	char comm[FIELD_SIZEOF(struct task_struct, comm)];
 +	char current_comm[FIELD_SIZEOF(struct task_struct, comm)];
@@ -658,11 +661,11 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +static char *wakeup_latency_hist_dir = "wakeup";
 +static char *wakeup_latency_hist_dir_sharedprio = "sharedprio";
 +static notrace void probe_wakeup_latency_hist_start(void *v,
-+    struct task_struct *p, int success);
++	struct task_struct *p, int success);
 +static notrace void probe_wakeup_latency_hist_stop(void *v,
-+    struct task_struct *prev, struct task_struct *next);
++	struct task_struct *prev, struct task_struct *next);
 +static notrace void probe_sched_migrate_task(void *,
-+    struct task_struct *task, int cpu);
++	struct task_struct *task, int cpu);
 +static struct enable_data wakeup_latency_enabled_data = {
 +	.latency_type = WAKEUP_LATENCY,
 +	.enabled = 0,
@@ -678,7 +681,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +static DEFINE_PER_CPU(struct hist_data, missed_timer_offsets);
 +static char *missed_timer_offsets_dir = "missed_timer_offsets";
 +static notrace void probe_hrtimer_interrupt(void *v, int cpu,
-+    long long offset, struct task_struct *curr, struct task_struct *task);
++	long long offset, struct task_struct *curr, struct task_struct *task);
 +static struct enable_data missed_timer_offsets_enabled_data = {
 +	.latency_type = MISSED_TIMER_OFFSETS,
 +	.enabled = 0,
@@ -688,7 +691,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +#endif
 +
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +static DEFINE_PER_CPU(struct hist_data, timerandwakeup_latency_hist);
 +static char *timerandwakeup_latency_hist_dir = "timerandwakeup";
 +static struct enable_data timerandwakeup_enabled_data = {
@@ -704,11 +707,11 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +{
 +	struct hist_data *my_hist;
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +	struct maxlatproc_data *mp = NULL;
 +#endif
 +
-+	if (cpu < 0 || cpu >= NR_CPUS || latency_type < 0 ||
++	if (!cpu_possible(cpu) || latency_type < 0 ||
 +	    latency_type >= MAX_LATENCY_TYPE)
 +		return;
 +
@@ -745,7 +748,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +		break;
 +#endif
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +	case TIMERANDWAKEUP_LATENCY:
 +		my_hist = &per_cpu(timerandwakeup_latency_hist, cpu);
 +		mp = &per_cpu(timerandwakeup_maxlatproc, cpu);
@@ -772,7 +775,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +	if (unlikely(latency > my_hist->max_lat ||
 +	    my_hist->min_lat == LONG_MAX)) {
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +		if (latency_type == WAKEUP_LATENCY ||
 +		    latency_type == WAKEUP_LATENCY_SHAREDPRIO ||
 +		    latency_type == MISSED_TIMER_OFFSETS ||
@@ -877,7 +880,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +	return 0;
 +}
 +
-+static struct seq_operations latency_hist_seq_op = {
++static const struct seq_operations latency_hist_seq_op = {
 +	.start = l_start,
 +	.next  = l_next,
 +	.stop  = l_stop,
@@ -896,7 +899,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +	return ret;
 +}
 +
-+static struct file_operations latency_hist_fops = {
++static const struct file_operations latency_hist_fops = {
 +	.open = latency_hist_open,
 +	.read = seq_read,
 +	.llseek = seq_lseek,
@@ -904,7 +907,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +};
 +
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +static void clear_maxlatprocdata(struct maxlatproc_data *mp)
 +{
 +	mp->comm[0] = mp->current_comm[0] = '\0';
@@ -936,7 +939,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +	int cpu;
 +	struct hist_data *hist = NULL;
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +	struct maxlatproc_data *mp = NULL;
 +#endif
 +	off_t latency_type = (off_t) file->private_data;
@@ -976,7 +979,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +			break;
 +#endif
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +		case TIMERANDWAKEUP_LATENCY:
 +			hist = &per_cpu(timerandwakeup_latency_hist, cpu);
 +			mp = &per_cpu(timerandwakeup_maxlatproc, cpu);
@@ -986,7 +989,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +
 +		hist_reset(hist);
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +		if (latency_type == WAKEUP_LATENCY ||
 +		    latency_type == WAKEUP_LATENCY_SHAREDPRIO ||
 +		    latency_type == MISSED_TIMER_OFFSETS ||
@@ -999,7 +1002,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +}
 +
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +static ssize_t
 +show_pid(struct file *file, char __user *ubuf, size_t cnt, loff_t *ppos)
 +{
@@ -1026,8 +1029,8 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +
 +	buf[cnt] = '\0';
 +
-+	if (strict_strtoul(buf, 10, &pid))
-+		return(-EINVAL);
++	if (kstrtoul(buf, 10, &pid))
++		return -EINVAL;
 +
 +	*this_pid = pid;
 +
@@ -1036,7 +1039,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +#endif
 +
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +static ssize_t
 +show_maxlatproc(struct file *file, char __user *ubuf, size_t cnt, loff_t *ppos)
 +{
@@ -1097,8 +1100,8 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +
 +	buf[cnt] = 0;
 +
-+	if (strict_strtol(buf, 10, &enable))
-+		return(-EINVAL);
++	if (kstrtoul(buf, 10, &enable))
++		return -EINVAL;
 +
 +	if ((enable && ed->enabled) || (!enable && !ed->enabled))
 +		return cnt;
@@ -1180,7 +1183,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +			break;
 +#endif
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +		case TIMERANDWAKEUP_LATENCY:
 +			if (!wakeup_latency_enabled_data.enabled ||
 +			    !missed_timer_offsets_enabled_data.enabled)
@@ -1269,7 +1272,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +};
 +
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +static const struct file_operations pid_fops = {
 +	.open = tracing_open_generic,
 +	.read = show_pid,
@@ -1284,7 +1287,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +
 +#if defined(CONFIG_INTERRUPT_OFF_HIST) || defined(CONFIG_PREEMPT_OFF_HIST)
 +static notrace void probe_preemptirqsoff_hist(void *v, int reason,
-+    int starthist)
++	int starthist)
 +{
 +	int cpu = raw_smp_processor_id();
 +	int time_set = 0;
@@ -1389,7 +1392,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +#ifdef CONFIG_WAKEUP_LATENCY_HIST
 +static DEFINE_RAW_SPINLOCK(wakeup_lock);
 +static notrace void probe_sched_migrate_task(void *v, struct task_struct *task,
-+    int cpu)
++	int cpu)
 +{
 +	int old_cpu = task_cpu(task);
 +
@@ -1412,7 +1415,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +}
 +
 +static notrace void probe_wakeup_latency_hist_start(void *v,
-+    struct task_struct *p, int success)
++	struct task_struct *p, int success)
 +{
 +	unsigned long flags;
 +	struct task_struct *curr = current;
@@ -1450,7 +1453,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +}
 +
 +static notrace void probe_wakeup_latency_hist_stop(void *v,
-+    struct task_struct *prev, struct task_struct *next)
++	struct task_struct *prev, struct task_struct *next)
 +{
 +	unsigned long flags;
 +	int cpu = task_cpu(next);
@@ -1519,7 +1522,8 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +
 +#ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
 +static notrace void probe_hrtimer_interrupt(void *v, int cpu,
-+    long long latency_ns, struct task_struct *curr, struct task_struct *task)
++	long long latency_ns, struct task_struct *curr,
++	struct task_struct *task)
 +{
 +	if (latency_ns <= 0 && task != NULL && rt_task(task) &&
 +	    (task->prio < curr->prio ||
@@ -1559,7 +1563,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +	char name[64];
 +	char *cpufmt = "CPU%d";
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +	char *cpufmt_maxlatproc = "max_latency-CPU%d";
 +	struct maxlatproc_data *mp = NULL;
 +#endif
@@ -1690,7 +1694,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +#endif
 +
 +#if defined(CONFIG_WAKEUP_LATENCY_HIST) && \
-+    defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
++	defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 +	dentry = debugfs_create_dir(timerandwakeup_latency_hist_dir,
 +	    latency_hist_root);
 +	for_each_possible_cpu(i) {
@@ -1717,7 +1721,7 @@ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 +	return 0;
 +}
 +
-+__initcall(latency_hist_init);
++device_initcall(latency_hist_init);
 --- a/kernel/trace/trace_irqsoff.c
 +++ b/kernel/trace/trace_irqsoff.c
 @@ -17,6 +17,7 @@
-- 
1.9.0.rc3

