Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3DLXT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:19:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53862 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3DLXTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:19:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/7] rcu: Remove "Experimental" flags
Date: Fri, 12 Apr 2013 16:19:12 -0700
Message-Id: <1365808754-20762-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-5406-0000-0000-0000076916F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

After a release or two, features are no longer experimental.  Therefore,
this commit removes the "Experimental" tag from them.

Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig            |  2 +-
 kernel/rcutree_plugin.h | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index a3a2304..bac0483 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -658,7 +658,7 @@ config RCU_BOOST_DELAY
 	  Accept the default if unsure.
 
 config RCU_NOCB_CPU
-	bool "Offload RCU callback processing from boot-selected CPUs (EXPERIMENTAL"
+	bool "Offload RCU callback processing from boot-selected CPUs"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default n
 	help
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 44b0998..dcab269 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -80,7 +80,7 @@ static void __init rcu_bootup_announce_oddness(void)
 	pr_info("\tFour-level hierarchy is enabled.\n");
 #endif
 	if (rcu_fanout_leaf != CONFIG_RCU_FANOUT_LEAF)
-		pr_info("\tExperimental boot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
+		pr_info("\tBoot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
 	if (nr_cpu_ids != NR_CPUS)
 		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_NOCB_CPU
@@ -90,19 +90,19 @@ static void __init rcu_bootup_announce_oddness(void)
 		have_rcu_nocb_mask = true;
 	}
 #ifdef CONFIG_RCU_NOCB_CPU_ZERO
-	pr_info("\tExperimental no-CBs CPU 0\n");
+	pr_info("\tOffload RCU callbacks from CPU 0\n");
 	cpumask_set_cpu(0, rcu_nocb_mask);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
 #ifdef CONFIG_RCU_NOCB_CPU_ALL
-	pr_info("\tExperimental no-CBs for all CPUs\n");
+	pr_info("\tOffload RCU callbacks from all CPUs\n");
 	cpumask_setall(rcu_nocb_mask);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
 	if (have_rcu_nocb_mask) {
 		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
-		pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
+		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
 		if (rcu_nocb_poll)
-			pr_info("\tExperimental polled no-CBs CPUs.\n");
+			pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
 	}
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 }
-- 
1.8.1.5

