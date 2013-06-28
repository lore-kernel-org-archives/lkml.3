Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3F1QKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:10:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44886 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3F1QKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:10:04 -0400
Date: Fri, 28 Jun 2013 09:09:50 -0700
From: tip-bot for Kamalesh Babulal <tipbot@zytor.com>
Message-ID: <tip-add332a1523a09cf6d429933f1e2fb4ccdfe6479@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20130627165005.GA15583@linux.vnet.ibm.com>
References: <20130627165005.GA15583@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/debug: Fix formatting of /proc/<PID>/sched
Git-Commit-ID: add332a1523a09cf6d429933f1e2fb4ccdfe6479
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 09:09:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  add332a1523a09cf6d429933f1e2fb4ccdfe6479
Gitweb:     http://git.kernel.org/tip/add332a1523a09cf6d429933f1e2fb4ccdfe6479
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Thu, 27 Jun 2013 22:20:05 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 28 Jun 2013 11:13:35 +0200

sched/debug: Fix formatting of /proc/<PID>/sched

This patch alters format string's width, to align all statistics
at par with the longest struct sched_statistic member name under
/proc/<PID>/sched.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/20130627165005.GA15583@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 62632098..1595614 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -493,15 +493,16 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid,
 						get_nr_threads(p));
 	SEQ_printf(m,
-		"---------------------------------------------------------\n");
+		"---------------------------------------------------------"
+		"----------\n");
 #define __P(F) \
-	SEQ_printf(m, "%-35s:%21Ld\n", #F, (long long)F)
+	SEQ_printf(m, "%-45s:%21Ld\n", #F, (long long)F)
 #define P(F) \
-	SEQ_printf(m, "%-35s:%21Ld\n", #F, (long long)p->F)
+	SEQ_printf(m, "%-45s:%21Ld\n", #F, (long long)p->F)
 #define __PN(F) \
-	SEQ_printf(m, "%-35s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)F))
+	SEQ_printf(m, "%-45s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)F))
 #define PN(F) \
-	SEQ_printf(m, "%-35s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)p->F))
+	SEQ_printf(m, "%-45s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)p->F))
 
 	PN(se.exec_start);
 	PN(se.vruntime);
@@ -560,9 +561,9 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	}
 #endif
 	__P(nr_switches);
-	SEQ_printf(m, "%-35s:%21Ld\n",
+	SEQ_printf(m, "%-45s:%21Ld\n",
 		   "nr_voluntary_switches", (long long)p->nvcsw);
-	SEQ_printf(m, "%-35s:%21Ld\n",
+	SEQ_printf(m, "%-45s:%21Ld\n",
 		   "nr_involuntary_switches", (long long)p->nivcsw);
 
 	P(se.load.weight);
@@ -585,7 +586,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 
 		t0 = cpu_clock(this_cpu);
 		t1 = cpu_clock(this_cpu);
-		SEQ_printf(m, "%-35s:%21Ld\n",
+		SEQ_printf(m, "%-45s:%21Ld\n",
 			   "clock-delta", (long long)(t1-t0));
 	}
 }
