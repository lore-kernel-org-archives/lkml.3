Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaA0JSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:18:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:5122 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbaA0JSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:18:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,728,1384272000"; 
   d="scan'208";a="9457824"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: raistlin@linux.it, juri.lelli@gmail.com, clark.williams@gmail.com,
        mingo@redhat.com, rostedt@goodmis.org,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] sched: Move the priority specific bits into a new header file.
Date: Mon, 27 Jan 2014 17:15:37 -0500
Message-Id: <f7549508a1588da2c613d601748ca9de30fa5dcf.1390859827.git.yangds.fnst@cn.fujitsu.com>
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

Some bits about priority are defined in linux/sched/rt.h, but
some of them are not only for rt scheduler, such as MAX_PRIO.

This patch move them all into a new header file, linux/sched/prio.h.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 include/linux/sched.h      |  4 ++++
 include/linux/sched/prio.h | 23 +++++++++++++++++++++++
 include/linux/sched/rt.h   | 21 +++------------------
 3 files changed, 30 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/sched/prio.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 68a0e84..ba1b732 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -3,6 +3,10 @@
 
 #include <uapi/linux/sched.h>
 
+#ifndef _SCHED_PRIO_H
+#include <linux/sched/prio.h>
+#endif /* #ifndef _SCHED_PRIO_H */
+
 
 struct sched_param {
 	int sched_priority;
diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
new file mode 100644
index 0000000..9382ba8
--- /dev/null
+++ b/include/linux/sched/prio.h
@@ -0,0 +1,23 @@
+#ifndef _SCHED_PRIO_H
+#define _SCHED_PRIO_H
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
+#endif /* _SCHED_PRIO_H */
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 34e4ebe..50409a3 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -1,24 +1,9 @@
 #ifndef _SCHED_RT_H
 #define _SCHED_RT_H
 
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
+#ifndef _SCHED_PRIO_H
+#include <linux/sched/prio.h>
+#endif /* ifndef _SCHED_PRIO_H */
 
 static inline int rt_prio(int prio)
 {
-- 
1.8.2.1

