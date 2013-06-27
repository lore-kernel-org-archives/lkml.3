Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3F0JGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:06:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46140 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3F0JFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:05:52 -0400
Date: Thu, 27 Jun 2013 02:03:17 -0700
From: tip-bot for Kamalesh Babulal <tipbot@zytor.com>
Message-ID: <tip-939fd731eb88a0cdd9058d0b0143563172a217d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130625080336.GA20175@linux.vnet.ibm.com>
References: <20130625080336.GA20175@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/debug:
  Add load-tracking statistics to task
Git-Commit-ID: 939fd731eb88a0cdd9058d0b0143563172a217d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:03:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  939fd731eb88a0cdd9058d0b0143563172a217d7
Gitweb:     http://git.kernel.org/tip/939fd731eb88a0cdd9058d0b0143563172a217d7
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Tue, 25 Jun 2013 13:33:36 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:46 +0200

sched/debug: Add load-tracking statistics to task

At present we print per-entity load-tracking statistics for
cfs_rq of cgroups/runqueues. Given that per task statistics
is maintained, it can be used to know the contribution made
by the task to its parenting cfs_rq level.

This patch adds per-task load-tracking statistics to /proc/<PID>/sched.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130625080336.GA20175@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index d803989..62632098 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -566,6 +566,12 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 		   "nr_involuntary_switches", (long long)p->nivcsw);
 
 	P(se.load.weight);
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+	P(se.avg.runnable_avg_sum);
+	P(se.avg.runnable_avg_period);
+	P(se.avg.load_avg_contrib);
+	P(se.avg.decay_count);
+#endif
 	P(policy);
 	P(prio);
 #undef PN
