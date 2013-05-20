Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3ETO7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:59:12 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36165 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab3ETO7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:59:07 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/13] rcu: Remove TINY_PREEMPT_RCU tracing documentation
Date: Mon, 20 May 2013 07:58:18 -0700
Message-Id: <1369061900-546-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520145751.GA32218@linux.vnet.ibm.com>
 <1369061900-546-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5806-0000-0000-00002139A25D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because TINY_PREEMPT_RCU is no more, this commit removes its tracing
formats from the documentation.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/RCU/trace.txt | 100 ++------------------------------------------
 1 file changed, 4 insertions(+), 96 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index c776968..f3778f8 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -530,113 +530,21 @@ o	"nos" counts the number of times we balked for other
 	reasons, e.g., the grace period ended first.
 
 
-CONFIG_TINY_RCU and CONFIG_TINY_PREEMPT_RCU debugfs Files and Formats
+CONFIG_TINY_RCU debugfs Files and Formats
 
 These implementations of RCU provides a single debugfs file under the
 top-level directory RCU, namely rcu/rcudata, which displays fields in
-rcu_bh_ctrlblk, rcu_sched_ctrlblk and, for CONFIG_TINY_PREEMPT_RCU,
-rcu_preempt_ctrlblk.
+rcu_bh_ctrlblk and rcu_sched_ctrlblk.
 
 The output of "cat rcu/rcudata" is as follows:
 
-rcu_preempt: qlen=24 gp=1097669 g197/p197/c197 tasks=...
-             ttb=. btg=no ntb=184 neb=0 nnb=183 j=01f7 bt=0274
-             normal balk: nt=1097669 gt=0 bt=371 b=0 ny=25073378 nos=0
-             exp balk: bt=0 nos=0
 rcu_sched: qlen: 0
 rcu_bh: qlen: 0
 
-This is split into rcu_preempt, rcu_sched, and rcu_bh sections, with the
-rcu_preempt section appearing only in CONFIG_TINY_PREEMPT_RCU builds.
-The last three lines of the rcu_preempt section appear only in
-CONFIG_RCU_BOOST kernel builds.  The fields are as follows:
+This is split into rcu_sched and rcu_bh sections.  The field is as
+follows:
 
 o	"qlen" is the number of RCU callbacks currently waiting either
 	for an RCU grace period or waiting to be invoked.  This is the
 	only field present for rcu_sched and rcu_bh, due to the
 	short-circuiting of grace period in those two cases.
-
-o	"gp" is the number of grace periods that have completed.
-
-o	"g197/p197/c197" displays the grace-period state, with the
-	"g" number being the number of grace periods that have started
-	(mod 256), the "p" number being the number of grace periods
-	that the CPU has responded to (also mod 256), and the "c"
-	number being the number of grace periods that have completed
-	(once again mode 256).
-
-	Why have both "gp" and "g"?  Because the data flowing into
-	"gp" is only present in a CONFIG_RCU_TRACE kernel.
-
-o	"tasks" is a set of bits.  The first bit is "T" if there are
-	currently tasks that have recently blocked within an RCU
-	read-side critical section, the second bit is "N" if any of the
-	aforementioned tasks are blocking the current RCU grace period,
-	and the third bit is "E" if any of the aforementioned tasks are
-	blocking the current expedited grace period.  Each bit is "."
-	if the corresponding condition does not hold.
-
-o	"ttb" is a single bit.  It is "B" if any of the blocked tasks
-	need to be priority boosted and "." otherwise.
-
-o	"btg" indicates whether boosting has been carried out during
-	the current grace period, with "exp" indicating that boosting
-	is in progress for an expedited grace period, "no" indicating
-	that boosting has not yet started for a normal grace period,
-	"begun" indicating that boosting has bebug for a normal grace
-	period, and "done" indicating that boosting has completed for
-	a normal grace period.
-
-o	"ntb" is the total number of tasks subjected to RCU priority boosting
-	periods since boot.
-
-o	"neb" is the number of expedited grace periods that have had
-	to resort to RCU priority boosting since boot.
-
-o	"nnb" is the number of normal grace periods that have had
-	to resort to RCU priority boosting since boot.
-
-o	"j" is the low-order 16 bits of the jiffies counter in hexadecimal.
-
-o	"bt" is the low-order 16 bits of the value that the jiffies counter
-	will have at the next time that boosting is scheduled to begin.
-
-o	In the line beginning with "normal balk", the fields are as follows:
-
-	o	"nt" is the number of times that the system balked from
-		boosting because there were no blocked tasks to boost.
-		Note that the system will balk from boosting even if the
-		grace period is overdue when the currently running task
-		is looping within an RCU read-side critical section.
-		There is no point in boosting in this case, because
-		boosting a running task won't make it run any faster.
-
-	o	"gt" is the number of times that the system balked
-		from boosting because, although there were blocked tasks,
-		none of them were preventing the current grace period
-		from completing.
-
-	o	"bt" is the number of times that the system balked
-		from boosting because boosting was already in progress.
-
-	o	"b" is the number of times that the system balked from
-		boosting because boosting had already completed for
-		the grace period in question.
-
-	o	"ny" is the number of times that the system balked from
-		boosting because it was not yet time to start boosting
-		the grace period in question.
-
-	o	"nos" is the number of times that the system balked from
-		boosting for inexplicable ("not otherwise specified")
-		reasons.  This can actually happen due to races involving
-		increments of the jiffies counter.
-
-o	In the line beginning with "exp balk", the fields are as follows:
-
-	o	"bt" is the number of times that the system balked from
-		boosting because there were no blocked tasks to boost.
-
-	o	"nos" is the number of times that the system balked from
-		 boosting for inexplicable ("not otherwise specified")
-		 reasons.
-- 
1.8.1.5

