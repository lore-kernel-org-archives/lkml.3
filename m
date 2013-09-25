Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3IYBbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:31:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33130 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3IYB3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:29:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/11] rcu: Convert local functions to static
Date: Tue, 24 Sep 2013 18:29:13 -0700
Message-Id: <1380072561-31134-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0928-0000-0000-000001DB94BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_cpu_stall_timeout kernel parameter, the rcu_dynticks per-CPU
variable, and the rcu_gp_fqs() function are used only locally.  This
commit therefore marks them as static.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c | 2 +-
 kernel/rcutree.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index b02a339..3260a10 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -298,7 +298,7 @@ EXPORT_SYMBOL_GPL(do_trace_rcu_torture_read);
 #endif
 
 int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
-int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
+static int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
 
 module_param(rcu_cpu_stall_suppress, int, 0644);
 module_param(rcu_cpu_stall_timeout, int, 0644);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e0fa192..2712b89 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -222,7 +222,7 @@ void rcu_note_context_switch(int cpu)
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
-DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
+static DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
@@ -1366,7 +1366,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 /*
  * Do one round of quiescent-state forcing.
  */
-int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
+static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 {
 	int fqs_state = fqs_state_in;
 	bool isidle = false;
-- 
1.8.1.5

