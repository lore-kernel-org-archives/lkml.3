Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3H3NYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:24:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab3H3NYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:24:11 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=dqa1JRUP-gUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Xw3bRzdRQRMA:10 a=ZEzuP4Ro0e6AgQVfVH8A:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130830132405.020985353@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 30 Aug 2013 09:02:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Dave Jones <davej@redhat.com>
Subject: [RFC][PATCH 8/8] rcu/ftrace: Add FTRACE_UNSAFE_RCU() to unsafe RCU functions
References: <20130830130205.504335754@goodmis.org>
Content-Disposition: inline; filename=0008-rcu-ftrace-Add-FTRACE_UNSAFE_RCU-to-unsafe-RCU-funct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 068de3a..9abf305 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -53,6 +53,7 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 #include <linux/random.h>
+#include <linux/ftrace.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -373,6 +374,7 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
 			   "Illegal idle entry in RCU-sched read-side critical section.");
 }
+FTRACE_UNSAFE_RCU(rcu_eqs_enter_common);
 
 /*
  * Enter an RCU extended quiescent state, which can be either the
@@ -392,6 +394,7 @@ static void rcu_eqs_enter(bool user)
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
 	rcu_eqs_enter_common(rdtp, oldval, user);
 }
+FTRACE_UNSAFE_RCU(rcu_eqs_enter);
 
 /**
  * rcu_idle_enter - inform RCU that current CPU is entering idle
@@ -565,6 +568,7 @@ void rcu_user_exit(void)
 {
 	rcu_eqs_exit(1);
 }
+FTRACE_UNSAFE_RCU(rcu_user_exit);
 
 /**
  * rcu_user_exit_after_irq - inform RCU that we won't resume to userspace
-- 
1.7.10.4


