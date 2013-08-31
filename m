Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3HaFSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:18:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab3HaFRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:17:06 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=OmlLZOFk1d4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GeqvIrjxLIMA:10 a=JfrnYn6hAAAA:8 a=S2UAOUZmtTlZo-vYbisA:9 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130831051703.390216483@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 31 Aug 2013 01:11:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 18/18 v2] ftrace/sched: Mark functions that are RCU unsafe
References: <20130831051117.884125230@goodmis.org>
Content-Disposition: inline; filename=0018-ftrace-sched-Mark-functions-that-are-RCU-unsafe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Some callbacks of the function tracer use rcu_read_lock(). This means that
there's places that can not be traced because RCU is not tracking the CPU
for various reasons (like NO_HZ_FULL and coming back from userspace).

Thes functions need to be marked so that callbacks that use RCU do not
trace them.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7c32cb..9bd2aea 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1440,6 +1440,7 @@ void scheduler_ipi(void)
 	}
 	irq_exit();
 }
+FTRACE_UNSAFE_RCU(scheduler_ipi);
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
@@ -3222,6 +3223,7 @@ int idle_cpu(int cpu)
 
 	return 1;
 }
+FTRACE_UNSAFE_RCU(idle_cpu);
 
 /**
  * idle_task - return the idle task for a given cpu.
-- 
1.7.10.4


