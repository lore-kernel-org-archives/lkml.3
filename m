Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3CEIHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:07:42 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:63873 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3CEIHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:07:41 -0500
Message-ID: <5135A771.4070104@huawei.com>
Date: Tue, 5 Mar 2013 16:06:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/9] sched: Move SCHED_LOAD_SHIFT macros to kernel/sched/sched.h
References: <5135A736.8050104@huawei.com>
In-Reply-To: <5135A736.8050104@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are used internally only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/sched.h | 25 -------------------------
 kernel/sched/sched.h  | 26 +++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e880d7d..f8826d0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -756,31 +756,6 @@ enum cpu_idle_type {
 };
 
 /*
- * Increase resolution of nice-level calculations for 64-bit architectures.
- * The extra resolution improves shares distribution and load balancing of
- * low-weight task groups (eg. nice +19 on an autogroup), deeper taskgroup
- * hierarchies, especially on larger systems. This is not a user-visible change
- * and does not change the user-interface for setting shares/weights.
- *
- * We increase resolution only if we have enough bits to allow this increased
- * resolution (i.e. BITS_PER_LONG > 32). The costs for increasing resolution
- * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
- * increased costs.
- */
-#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage under light load  */
-# define SCHED_LOAD_RESOLUTION	10
-# define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
-# define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
-#else
-# define SCHED_LOAD_RESOLUTION	0
-# define scale_load(w)		(w)
-# define scale_load_down(w)	(w)
-#endif
-
-#define SCHED_LOAD_SHIFT	(10 + SCHED_LOAD_RESOLUTION)
-#define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
-
-/*
  * Increase resolution of cpu_power calculations
  */
 #define SCHED_POWER_SHIFT	10
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc03cfd..709a30c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -33,6 +33,31 @@ extern __read_mostly int scheduler_running;
  */
 #define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
 
+/*
+ * Increase resolution of nice-level calculations for 64-bit architectures.
+ * The extra resolution improves shares distribution and load balancing of
+ * low-weight task groups (eg. nice +19 on an autogroup), deeper taskgroup
+ * hierarchies, especially on larger systems. This is not a user-visible change
+ * and does not change the user-interface for setting shares/weights.
+ *
+ * We increase resolution only if we have enough bits to allow this increased
+ * resolution (i.e. BITS_PER_LONG > 32). The costs for increasing resolution
+ * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
+ * increased costs.
+ */
+#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage under light load  */
+# define SCHED_LOAD_RESOLUTION	10
+# define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
+# define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
+#else
+# define SCHED_LOAD_RESOLUTION	0
+# define scale_load(w)		(w)
+# define scale_load_down(w)	(w)
+#endif
+
+#define SCHED_LOAD_SHIFT	(10 + SCHED_LOAD_RESOLUTION)
+#define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
+
 #define NICE_0_LOAD		SCHED_LOAD_SCALE
 #define NICE_0_SHIFT		SCHED_LOAD_SHIFT
 
@@ -784,7 +809,6 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 }
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
-
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
-- 
1.8.0.2
