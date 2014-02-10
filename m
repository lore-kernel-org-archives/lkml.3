Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaBJNaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:30:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaBJNar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:30:47 -0500
Date: Mon, 10 Feb 2014 05:30:06 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-5c228079ce8a9bb043a423069a6674dfb9268037@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <f7549508a1588da2c613d601748ca9de30fa5dcf.1390859827.git.yangds.fnst@cn.fujitsu.com>
References: <f7549508a1588da2c613d601748ca9de30fa5dcf.1390859827.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Move the priority specific bits into a new header file
Git-Commit-ID: 5c228079ce8a9bb043a423069a6674dfb9268037
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:30:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c228079ce8a9bb043a423069a6674dfb9268037
Gitweb:     http://git.kernel.org/tip/5c228079ce8a9bb043a423069a6674dfb9268037
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 27 Jan 2014 17:15:37 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:31:49 +0100

sched: Move the priority specific bits into a new header file

Some bits about priority are defined in linux/sched/rt.h, but
some of them are not only for rt scheduler, such as MAX_PRIO.

This patch move them all into a new header file, linux/sched/prio.h.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: clark.williams@gmail.com
Cc: rostedt@goodmis.org
Cc: raistlin@linux.it
Cc: juri.lelli@gmail.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/f7549508a1588da2c613d601748ca9de30fa5dcf.1390859827.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h      |  2 ++
 include/linux/sched/prio.h | 23 +++++++++++++++++++++++
 include/linux/sched/rt.h   | 19 +------------------
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ed86779..d97d0a8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -3,6 +3,8 @@
 
 #include <uapi/linux/sched.h>
 
+#include <linux/sched/prio.h>
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
