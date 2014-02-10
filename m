Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaBJJGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:06:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:5686 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaBJJGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:06:03 -0500
X-IronPort-AV: E=Sophos;i="4.95,816,1384272000"; 
   d="scan'208";a="9497593"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: raistlin@linux.it, juri.lelli@gmail.com, clark.williams@gmail.com,
        peterz@infradead.org, mingo@redhat.com, namhyung@kernel.org,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] sched: Move the priority specific bits into a new header file.
Date: Mon, 10 Feb 2014 17:05:44 +0800
Message-Id: <6a9ea246c698b9591251c3aef716756e162615c7.1392022452.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1392022452.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1392022452.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/10 17:03:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/10 17:04:01,
	Serialize complete at 2014/02/10 17:04:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bits about priority are defined in linux/sched/rt.h, but
some of them are not only for rt scheduler, such as MAX_PRIO.

This patch move them all into a new header file, linux/sched/prio.h.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 include/linux/sched.h      |  1 +
 include/linux/sched/prio.h | 23 +++++++++++++++++++++++
 include/linux/sched/rt.h   | 19 +------------------
 3 files changed, 25 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/sched/prio.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..5aa0329 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -54,6 +54,7 @@ struct sched_param {
 #include <linux/llist.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
+#include <linux/sched/prio.h>
 
 #include <asm/processor.h>
 
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
index 34e4ebe..f7453d4 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -1,24 +1,7 @@
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
+#include <linux/sched/prio.h>
 
 static inline int rt_prio(int prio)
 {
-- 
1.8.2.1

