Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3IYB34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:29:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46373 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab3IYB3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:29:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/11] rcu: Silence unused-variable warnings
Date: Tue, 24 Sep 2013 18:29:17 -0700
Message-Id: <1380072561-31134-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-3532-0000-0000-000001ADC70A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The "idle" variable in both rcu_eqs_enter_common() and
rcu_eqs_exit_common() is only used in a WARN_ON_ONCE().  If the kernel
is built disabling WARN_ON_ONCE(), the compiler will complain (rightly)
that "idle" is unused.  This commit therefore adds a __maybe_unused to
the declaration of both variables.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8eb9cfd..e6f2e8f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -371,7 +371,8 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 {
 	trace_rcu_dyntick(TPS("Start"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
+		struct task_struct *idle __maybe_unused =
+			idle_task(smp_processor_id());
 
 		trace_rcu_dyntick(TPS("Error on entry: not idle task"), oldval, 0);
 		ftrace_dump(DUMP_ORIG);
@@ -508,7 +509,8 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick(TPS("End"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
+		struct task_struct *idle __maybe_unused =
+			idle_task(smp_processor_id());
 
 		trace_rcu_dyntick(TPS("Error on exit: not idle task"),
 				  oldval, rdtp->dynticks_nesting);
-- 
1.8.1.5

