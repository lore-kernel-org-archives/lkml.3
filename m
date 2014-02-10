Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaBJNiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:38:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaBJNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:31:17 -0500
Date: Mon, 10 Feb 2014 05:30:17 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-6b6350f155afdfdf888e18c7bf26950a6d10b0c2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <2b022810905b52d13238466807f4b2a691577180.1390859827.git.yangds.fnst@cn.fujitsu.com>
References: <2b022810905b52d13238466807f4b2a691577180.1390859827.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Expose some macros related to priority
Git-Commit-ID: 6b6350f155afdfdf888e18c7bf26950a6d10b0c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:30:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b6350f155afdfdf888e18c7bf26950a6d10b0c2
Gitweb:     http://git.kernel.org/tip/6b6350f155afdfdf888e18c7bf26950a6d10b0c2
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 27 Jan 2014 17:15:38 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:31:51 +0100

sched: Expose some macros related to priority

Some macros in kernel/sched/sched.h about priority are
private to kernel/sched. But they are useful to other
parts of the core kernel.

This patch moves these macros from kernel/sched/sched.h to
include/linux/sched/prio.h so that they are available to
other subsystems.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: raistlin@linux.it
Cc: juri.lelli@gmail.com
Cc: clark.williams@gmail.com
Cc: rostedt@goodmis.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/2b022810905b52d13238466807f4b2a691577180.1390859827.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/prio.h | 18 ++++++++++++++++++
 kernel/sched/sched.h       | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index 9382ba8..13216f1 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -20,4 +20,22 @@
 #define MAX_PRIO		(MAX_RT_PRIO + 40)
 #define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
 
+/*
+ * Convert user-nice values [ -20 ... 0 ... 19 ]
+ * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
+ * and back.
+ */
+#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
+#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
+#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
+
+/*
+ * 'User priority' is the nice value converted to something we
+ * can work with better when scaling various scheduler parameters,
+ * it's a [ 0 ... 39 ] range.
+ */
+#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
+#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
+#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
+
 #endif /* _SCHED_PRIO_H */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c2119fd..b44720d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -24,24 +24,6 @@ extern long calc_load_fold_active(struct rq *this_rq);
 extern void update_cpu_load_active(struct rq *this_rq);
 
 /*
- * Convert user-nice values [ -20 ... 0 ... 19 ]
- * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
- * and back.
- */
-#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
-#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
-#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
-
-/*
- * 'User priority' is the nice value converted to something we
- * can work with better when scaling various scheduler parameters,
- * it's a [ 0 ... 39 ] range.
- */
-#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
-#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
-#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
-
-/*
  * Helpers for converting nanosecond timing to jiffy resolution
  */
 #define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
