Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab3CFOgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:36:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44263 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab3CFOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:36:37 -0500
Date: Wed, 6 Mar 2013 06:35:19 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-cc1f4b1f3faed9f2040eff2a75f510b424b3cf18@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5135A771.4070104@huawei.com>
References: <5135A771.4070104@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move SCHED_LOAD_SHIFT macros to kernel/
 sched/sched.h
Git-Commit-ID: cc1f4b1f3faed9f2040eff2a75f510b424b3cf18
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:35:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc1f4b1f3faed9f2040eff2a75f510b424b3cf18
Gitweb:     http://git.kernel.org/tip/cc1f4b1f3faed9f2040eff2a75f510b424b3cf18
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 16:06:09 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:24:30 +0100

sched: Move SCHED_LOAD_SHIFT macros to kernel/sched/sched.h

They are used internally only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5135A771.4070104@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
