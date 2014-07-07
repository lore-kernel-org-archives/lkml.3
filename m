Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaGGWig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:38:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56173 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaGGWib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/17] rcu: remove redundant ACCESS_ONCE() from tick_do_timer_cpu
Date: Mon,  7 Jul 2014 15:38:09 -0700
Message-Id: <1404772701-8804-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-0928-0000-0000-000003305D84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

In kernels built with CONFIG_NO_HZ_FULL, tick_do_timer_cpu is constant
once boot completes.  Thus, there is no need to wrap it in ACCESS_ONCE()
in code that is built only when CONFIG_NO_HZ_FULL.  This commit therefore
removes the redundant ACCESS_ONCE().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 02ac0fb186b8..5da9f9b3abc9 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2844,7 +2844,7 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
 static void rcu_bind_gp_kthread(void)
 {
 #ifdef CONFIG_NO_HZ_FULL
-	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
+	int cpu = tick_do_timer_cpu;
 
 	if (cpu < 0 || cpu >= nr_cpu_ids)
 		return;
-- 
1.8.1.5

