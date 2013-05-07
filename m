Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab3EGOM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:12:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56030 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865Ab3EGOMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:12:22 -0400
Date: Tue, 7 May 2013 07:12:03 -0700
From: tip-bot for Paul Gortmaker <tipbot@zytor.com>
Message-ID: <tip-8527632dc95472adb571701e852479531c0567a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        paul.gortmaker@windriver.com
In-Reply-To: <1366398650-31599-3-git-send-email-paul.gortmaker@windriver.com>
References: <1366398650-31599-3-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Move update_load_*()
  methods from sched.h to fair.c
Git-Commit-ID: 8527632dc95472adb571701e852479531c0567a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8527632dc95472adb571701e852479531c0567a2
Gitweb:     http://git.kernel.org/tip/8527632dc95472adb571701e852479531c0567a2
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Fri, 19 Apr 2013 15:10:50 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 7 May 2013 13:14:51 +0200

sched: Move update_load_*() methods from sched.h to fair.c

These inlines are only used by kernel/sched/fair.c so they do
not need to be present in the main kernel/sched/sched.h file.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1366398650-31599-3-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c  | 18 ++++++++++++++++++
 kernel/sched/sched.h | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..08a554d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -113,6 +113,24 @@ unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
 unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
 #endif
 
+static inline void update_load_add(struct load_weight *lw, unsigned long inc)
+{
+	lw->weight += inc;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
+{
+	lw->weight -= dec;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_set(struct load_weight *lw, unsigned long w)
+{
+	lw->weight = w;
+	lw->inv_weight = 0;
+}
+
 /*
  * Increase the granularity value when there are more CPUs,
  * because with more CPUs the 'effective latency' as visible
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a38ee0a..f1f6256 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -892,24 +892,6 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 #define WF_FORK		0x02		/* child wakeup after fork */
 #define WF_MIGRATED	0x4		/* internal use, task got migrated */
 
-static inline void update_load_add(struct load_weight *lw, unsigned long inc)
-{
-	lw->weight += inc;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
-{
-	lw->weight -= dec;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_set(struct load_weight *lw, unsigned long w)
-{
-	lw->weight = w;
-	lw->inv_weight = 0;
-}
-
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
  * of tasks with abnormal "nice" values across CPUs the contribution that
