Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3FYID7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:03:59 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59000 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FYIDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:03:54 -0400
Date: Tue, 25 Jun 2013 13:33:36 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, pjt@google.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com
Subject: [PATCH] sched/debug: Add load-tracking statistics to task
Message-ID: <20130625080336.GA20175@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062507-5816-0000-0000-0000089DA165
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present we print per-entity load-tracking statistics for
cfs_rq of cgroups/runqueues. Given that per task statistics
is maintained, it can be used to know the contribution made
by the task to its parenting cfs_rq level.

This patch adds per-task load-tracking statistics to
/proc/<PID>/sched.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index d1c0c81..375225b 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -567,6 +567,12 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
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
--
1.7.11.6

