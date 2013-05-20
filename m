Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3ETO3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:29:14 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56955 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3ETO3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:29:09 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/6] rcu: Convert rcutree.c printk calls
Date: Mon, 20 May 2013 07:28:44 -0700
Message-Id: <1369060129-28173-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130520142819.GA27123@linux.vnet.ibm.com>
References: <20130520142819.GA27123@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-7408-0000-0000-00001061EA8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit converts printk() calls to the corresponding pr_*() calls.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 16ea679..302eadf 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -866,7 +866,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	 * See Documentation/RCU/stallwarn.txt for info on how to debug
 	 * RCU CPU stall warnings.
 	 */
-	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks:",
+	pr_err("INFO: %s detected stalls on CPUs/tasks:",
 	       rsp->name);
 	print_cpu_stall_info_begin();
 	rcu_for_each_leaf_node(rsp, rnp) {
@@ -899,7 +899,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
 	       rsp->gpnum, rsp->completed, totqlen);
 	if (ndetected == 0)
-		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
+		pr_err("INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
 		rcu_dump_cpu_stacks(rsp);
 
@@ -922,7 +922,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	 * See Documentation/RCU/stallwarn.txt for info on how to debug
 	 * RCU CPU stall warnings.
 	 */
-	printk(KERN_ERR "INFO: %s self-detected stall on CPU", rsp->name);
+	pr_err("INFO: %s self-detected stall on CPU", rsp->name);
 	print_cpu_stall_info_begin();
 	print_cpu_stall_info(rsp, smp_processor_id());
 	print_cpu_stall_info_end();
-- 
1.8.1.5

