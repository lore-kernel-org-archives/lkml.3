Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3F0Qua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:50:30 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50274 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3F0Qu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:50:28 -0400
Date: Thu, 27 Jun 2013 22:20:05 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, kamalesh@linux.vnet.ibm.com
Subject: [PATCH TRIVIAL] sched/debug: Fix formatting of /proc/<PID>/sched
Message-ID: <20130627165005.GA15583@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062716-9264-0000-0000-0000040613B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch alters format string's width, to align all statistics at par
with the longest struct sched_statistic member name under /proc/<PID>/sched.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
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
--
1.7.11.6

