Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935650Ab3BTPTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:19:38 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:48399 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935558Ab3BTPTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:19:36 -0500
From: Clark Williams <clark.williams@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <clark.williams@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] sched: move RR_TIMESLICE from sysctl.h to rt.h
Date: Wed, 20 Feb 2013 09:19:09 -0600
Message-Id: <1361373550-4011-2-git-send-email-clark.williams@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361373550-4011-1-git-send-email-clark.williams@gmail.com>
References: <1361373550-4011-1-git-send-email-clark.williams@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Clark Williams <clark.williams@gmail.com>
---
 include/linux/sched/rt.h     | 6 ++++++
 include/linux/sched/sysctl.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 94e19ea..440434d 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -55,4 +55,10 @@ static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 extern void normalize_rt_tasks(void);
 
 
+/*
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define RR_TIMESLICE		(100 * HZ / 1000)
+
 #endif /* _SCHED_RT_H */
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index d2bb0ae..bf8086b 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -91,12 +91,6 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 extern unsigned int sysctl_sched_autogroup_enabled;
 #endif
 
-/*
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
- */
-#define RR_TIMESLICE		(100 * HZ / 1000)
-
 extern int sched_rr_timeslice;
 
 extern int sched_rr_handler(struct ctl_table *table, int write,
-- 
1.8.1.2

