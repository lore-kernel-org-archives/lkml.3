Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaA0JSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:18:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:46967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaA0JSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:18:02 -0500
X-IronPort-AV: E=Sophos;i="4.95,728,1384272000"; 
   d="scan'208";a="9457822"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: raistlin@linux.it, juri.lelli@gmail.com, clark.williams@gmail.com,
        mingo@redhat.com, rostedt@goodmis.org,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] sched: Expose some macros related with priority.
Date: Mon, 27 Jan 2014 17:15:38 -0500
Message-Id: <2b022810905b52d13238466807f4b2a691577180.1390859827.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 17:16:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 17:16:27,
	Serialize complete at 2014/01/27 17:16:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some macros in kernel/sched/sched.h about priority are
private to kernel/sched. But they are useful to other
parts of the core kernel.

This patch move these macros from kernel/sched/sched.h to
include/linux/sched/prio.h so that they are available to
other subsystems.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
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
-- 
1.8.2.1

