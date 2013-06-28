Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab3F1QL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:11:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3F1QL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:11:58 -0400
Date: Fri, 28 Jun 2013 09:09:59 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-333bb864f192015a53b5060b829089decd0220ef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1372417835-4698-1-git-send-email-alex.shi@intel.com>
References: <1372417835-4698-1-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/debug: Remove CONFIG_FAIR_GROUP_SCHED mask
Git-Commit-ID: 333bb864f192015a53b5060b829089decd0220ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 09:10:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  333bb864f192015a53b5060b829089decd0220ef
Gitweb:     http://git.kernel.org/tip/333bb864f192015a53b5060b829089decd0220ef
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Fri, 28 Jun 2013 19:10:35 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 28 Jun 2013 13:17:17 +0200

sched/debug: Remove CONFIG_FAIR_GROUP_SCHED mask

Now that we are using runnable load avg in sched balance, we don't
need to keep it under CONFIG_FAIR_GROUP_SCHED.

Also align the code style to #ifdef instead of #if defined() and
reorder the tg output info.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: pjt@google.com
Cc: kamalesh@linux.vnet.ibm.com
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1372417835-4698-1-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 1595614..e076bdd 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -209,22 +209,24 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->nr_spread_over);
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
-#ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
-			atomic_long_read(&cfs_rq->tg->load_avg));
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
 	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
 			cfs_rq->tg_runnable_contrib);
+	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+			atomic_long_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
 			atomic_read(&cfs_rq->tg->runnable_avg));
 #endif
+#endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
@@ -567,7 +569,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 		   "nr_involuntary_switches", (long long)p->nivcsw);
 
 	P(se.load.weight);
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 	P(se.avg.runnable_avg_sum);
 	P(se.avg.runnable_avg_period);
 	P(se.avg.load_avg_contrib);
