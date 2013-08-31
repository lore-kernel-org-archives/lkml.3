Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3HaFTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:19:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab3HaFRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:17:05 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Gxg810s-2EQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ESKT_2k1mnEA:10 a=VnNF1IyMAAAA:8 a=ADIRIkwvCkhWOhZfK5QA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130831051701.767976027@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 31 Aug 2013 01:11:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 08/18 v2] ftrace/rcu: Do not trace debug_lockdep_rcu_enabled()
References: <20130831051117.884125230@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-rcu-Do-not-trace-debug_lockdep_rcu_enabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The function debug_lockdep_rcu_enabled() is part of the RCU lockdep
debugging, and is called very frequently. I found that if I enable
a lot of debugging and run the function graph tracer, this
function can cause a live lock of the system.

We don't usually trace lockdep infrastructure, no need to trace
this either.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcupdate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index cce6ba8..4f20c6c 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -122,7 +122,7 @@ struct lockdep_map rcu_sched_lock_map =
 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
 EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 
-int debug_lockdep_rcu_enabled(void)
+int notrace debug_lockdep_rcu_enabled(void)
 {
 	return rcu_scheduler_active && debug_locks &&
 	       current->lockdep_recursion == 0;
-- 
1.7.10.4


