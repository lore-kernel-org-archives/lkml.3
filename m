Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3BVMol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:44:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3BVMoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:44:39 -0500
Date: Fri, 22 Feb 2013 04:43:20 -0800
From: tip-bot for Clark Williams <tipbot@zytor.com>
Message-ID: <tip-45ebd3945b2a3cf4eb89d5fb0090a3cb71af7973@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tony.luck@gmail.com, clark.williams@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, clark.williams@gmail.com, tony.luck@gmail.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1361373550-4011-2-git-send-email-clark.williams@gmail.com>
References: <1361373550-4011-2-git-send-email-clark.williams@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Move RR_TIMESLICE from sysctl.h to rt.h
Git-Commit-ID: 45ebd3945b2a3cf4eb89d5fb0090a3cb71af7973
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 22 Feb 2013 04:43:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45ebd3945b2a3cf4eb89d5fb0090a3cb71af7973
Gitweb:     http://git.kernel.org/tip/45ebd3945b2a3cf4eb89d5fb0090a3cb71af7973
Author:     Clark Williams <clark.williams@gmail.com>
AuthorDate: Wed, 20 Feb 2013 09:19:09 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 22 Feb 2013 10:44:46 +0100

sched: Move RR_TIMESLICE from sysctl.h to rt.h

This fixes an ia64 build bug reported by Tony Luck.

Reported-by: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Clark Williams <clark.williams@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1361373550-4011-2-git-send-email-clark.williams@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
