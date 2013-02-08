Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab3BHOJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:09:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3BHOJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:09:30 -0500
Date: Fri, 8 Feb 2013 06:09:02 -0800
From: tip-bot for Clark Williams <williams@redhat.com>
Message-ID: <tip-8bd75c77b7c6a3954140dd2e20346aef3efe4a35@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, williams@redhat.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        williams@redhat.com, rostedt@goodmis.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20130207094707.7b9f825f@riff.lan>
References: <20130207094707.7b9f825f@riff.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Move rt specific bits into new header file
Git-Commit-ID: 8bd75c77b7c6a3954140dd2e20346aef3efe4a35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 08 Feb 2013 06:09:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bd75c77b7c6a3954140dd2e20346aef3efe4a35
Gitweb:     http://git.kernel.org/tip/8bd75c77b7c6a3954140dd2e20346aef3efe4a35
Author:     Clark Williams <williams@redhat.com>
AuthorDate: Thu, 7 Feb 2013 09:47:07 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 7 Feb 2013 20:51:08 +0100

sched/rt: Move rt specific bits into new header file

Move rt scheduler definitions out of include/linux/sched.h into
new file include/linux/sched/rt.h

Signed-off-by: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20130207094707.7b9f825f@riff.lan
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/spi/spi.c                 |  2 +-
 drivers/staging/csr/bh.c          |  2 +-
 drivers/staging/csr/unifi_sme.c   |  2 +-
 drivers/tty/sysrq.c               |  1 +
 fs/select.c                       |  1 +
 include/linux/sched.h             | 55 ++-----------------------------------
 include/linux/sched/rt.h          | 58 +++++++++++++++++++++++++++++++++++++++
 init/init_task.c                  |  1 +
 kernel/futex.c                    |  1 +
 kernel/hrtimer.c                  |  1 +
 kernel/irq/manage.c               |  1 +
 kernel/mutex.c                    |  1 +
 kernel/rtmutex-debug.c            |  1 +
 kernel/rtmutex-tester.c           |  1 +
 kernel/rtmutex.c                  |  1 +
 kernel/sched/cpupri.c             |  2 ++
 kernel/sched/sched.h              |  1 +
 kernel/trace/trace.c              |  1 +
 kernel/trace/trace_sched_wakeup.c |  2 +-
 kernel/watchdog.c                 |  1 +
 mm/page-writeback.c               |  1 +
 mm/page_alloc.c                   |  1 +
 22 files changed, 81 insertions(+), 57 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 19ee901..3a6083b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -33,7 +33,7 @@
 #include <linux/of_gpio.h>
 #include <linux/pm_runtime.h>
 #include <linux/export.h>
-#include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/ioport.h>
diff --git a/drivers/staging/csr/bh.c b/drivers/staging/csr/bh.c
index 1a1f5c7..7b13359 100644
--- a/drivers/staging/csr/bh.c
+++ b/drivers/staging/csr/bh.c
@@ -15,7 +15,7 @@
  */
 #include "csr_wifi_hip_unifi.h"
 #include "unifi_priv.h"
-
+#include <linux/sched/rt.h>
 
 /*
  * ---------------------------------------------------------------------------
diff --git a/drivers/staging/csr/unifi_sme.c b/drivers/staging/csr/unifi_sme.c
index 7c6c413..49395da 100644
--- a/drivers/staging/csr/unifi_sme.c
+++ b/drivers/staging/csr/unifi_sme.c
@@ -15,7 +15,7 @@
 #include "unifi_priv.h"
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_conversions.h"
-
+#include <linux/sched/rt.h>
 
 
 
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index b3c4a25..40e5b39 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -15,6 +15,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
diff --git a/fs/select.c b/fs/select.c
index 2ef72d9..8c1c96c 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/rcupdate.h>
 #include <linux/hrtimer.h>
+#include <linux/sched/rt.h>
 
 #include <asm/uaccess.h>
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8fc9b27..33cc421 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1164,6 +1164,7 @@ struct sched_entity {
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
 #endif
+
 /*
  * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
  * removed when useful for applications beyond shares distribution (e.g.
@@ -1191,6 +1192,7 @@ struct sched_rt_entity {
 #endif
 };
 
+
 struct rcu_node;
 
 enum perf_event_task_context {
@@ -1596,37 +1598,6 @@ static inline void set_numabalancing_state(bool enabled)
 }
 #endif
 
-/*
- * Priority of a process goes from 0..MAX_PRIO-1, valid RT
- * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
- * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
- * values are inverted: lower p->prio value means higher priority.
- *
- * The MAX_USER_RT_PRIO value allows the actual maximum
- * RT priority to be separate from the value exported to
- * user-space.  This allows kernel threads to set their
- * priority to a value higher than any user task. Note:
- * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
- */
-
-#define MAX_USER_RT_PRIO	100
-#define MAX_RT_PRIO		MAX_USER_RT_PRIO
-
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
-
-static inline int rt_prio(int prio)
-{
-	if (unlikely(prio < MAX_RT_PRIO))
-		return 1;
-	return 0;
-}
-
-static inline int rt_task(struct task_struct *p)
-{
-	return rt_prio(p->prio);
-}
-
 static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
@@ -2054,26 +2025,6 @@ static inline void sched_autogroup_fork(struct signal_struct *sig) { }
 static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 #endif
 
-#ifdef CONFIG_RT_MUTEXES
-extern int rt_mutex_getprio(struct task_struct *p);
-extern void rt_mutex_setprio(struct task_struct *p, int prio);
-extern void rt_mutex_adjust_pi(struct task_struct *p);
-static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
-{
-	return tsk->pi_blocked_on != NULL;
-}
-#else
-static inline int rt_mutex_getprio(struct task_struct *p)
-{
-	return p->normal_prio;
-}
-# define rt_mutex_adjust_pi(p)		do { } while (0)
-static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
-{
-	return false;
-}
-#endif
-
 extern bool yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
@@ -2703,8 +2654,6 @@ static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
 extern long sched_setaffinity(pid_t pid, const struct cpumask *new_mask);
 extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 
-extern void normalize_rt_tasks(void);
-
 #ifdef CONFIG_CGROUP_SCHED
 
 extern struct task_group root_task_group;
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
new file mode 100644
index 0000000..94e19ea
--- /dev/null
+++ b/include/linux/sched/rt.h
@@ -0,0 +1,58 @@
+#ifndef _SCHED_RT_H
+#define _SCHED_RT_H
+
+/*
+ * Priority of a process goes from 0..MAX_PRIO-1, valid RT
+ * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
+ * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
+ * values are inverted: lower p->prio value means higher priority.
+ *
+ * The MAX_USER_RT_PRIO value allows the actual maximum
+ * RT priority to be separate from the value exported to
+ * user-space.  This allows kernel threads to set their
+ * priority to a value higher than any user task. Note:
+ * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
+ */
+
+#define MAX_USER_RT_PRIO	100
+#define MAX_RT_PRIO		MAX_USER_RT_PRIO
+
+#define MAX_PRIO		(MAX_RT_PRIO + 40)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+
+static inline int rt_prio(int prio)
+{
+	if (unlikely(prio < MAX_RT_PRIO))
+		return 1;
+	return 0;
+}
+
+static inline int rt_task(struct task_struct *p)
+{
+	return rt_prio(p->prio);
+}
+
+#ifdef CONFIG_RT_MUTEXES
+extern int rt_mutex_getprio(struct task_struct *p);
+extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern void rt_mutex_adjust_pi(struct task_struct *p);
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return tsk->pi_blocked_on != NULL;
+}
+#else
+static inline int rt_mutex_getprio(struct task_struct *p)
+{
+	return p->normal_prio;
+}
+# define rt_mutex_adjust_pi(p)		do { } while (0)
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return false;
+}
+#endif
+
+extern void normalize_rt_tasks(void);
+
+
+#endif /* _SCHED_RT_H */
diff --git a/init/init_task.c b/init/init_task.c
index a031ad1..ba0a7f36 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -3,6 +3,7 @@
 #include <linux/mqueue.h>
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/rt.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
diff --git a/kernel/futex.c b/kernel/futex.c
index 19eb089..9618b6e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -60,6 +60,7 @@
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
 #include <linux/ptrace.h>
+#include <linux/sched/rt.h>
 
 #include <asm/futex.h>
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 8a9aa59..c5dde98 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -45,6 +45,7 @@
 #include <linux/debugobjects.h>
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/rt.h>
 #include <linux/timer.h>
 
 #include <asm/uaccess.h>
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e49a288..02115d9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/task_work.h>
 
 #include "internals.h"
diff --git a/kernel/mutex.c b/kernel/mutex.c
index a307cc9..52f2301 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -19,6 +19,7 @@
  */
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
diff --git a/kernel/rtmutex-debug.c b/kernel/rtmutex-debug.c
index 16502d3..13b243a 100644
--- a/kernel/rtmutex-debug.c
+++ b/kernel/rtmutex-debug.c
@@ -17,6 +17,7 @@
  * See rt.c in preempt-rt for proper credits and further information
  */
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index 98ec494..7890b10 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -10,6 +10,7 @@
 #include <linux/kthread.h>
 #include <linux/export.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/freezer.h>
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index a242e69..1e09308 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/export.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/timer.h>
 
 #include "rtmutex_common.h"
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 23aa789..1095e87 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -28,6 +28,8 @@
  */
 
 #include <linux/gfp.h>
+#include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include "cpupri.h"
 
 /* Convert between a 140 based task->prio, and our 102 based cpupri */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ed8de30..cc03cfd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1,6 +1,7 @@
 
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/rt.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3c13e46..4d2e4af 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -39,6 +39,7 @@
 #include <linux/poll.h>
 #include <linux/nmi.h>
 #include <linux/fs.h>
+#include <linux/sched/rt.h>
 
 #include "trace.h"
 #include "trace_output.h"
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 9fe45fc..75aa97f 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -15,8 +15,8 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
+#include <linux/sched/rt.h>
 #include <trace/events/sched.h>
-
 #include "trace.h"
 
 static struct trace_array	*wakeup_trace;
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3..2768942 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/smpboot.h>
+#include <linux/sched/rt.h>
 
 #include <asm/irq_regs.h>
 #include <linux/kvm_para.h>
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0713bfb..66a0024 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -35,6 +35,7 @@
 #include <linux/buffer_head.h> /* __set_page_dirty_buffers */
 #include <linux/pagevec.h>
 #include <linux/timer.h>
+#include <linux/sched/rt.h>
 #include <trace/events/writeback.h>
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index df2022f..42d18e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -58,6 +58,7 @@
 #include <linux/prefetch.h>
 #include <linux/migrate.h>
 #include <linux/page-debug-flags.h>
+#include <linux/sched/rt.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
