Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab3A0FQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 00:16:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53044 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3A0FQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 00:16:05 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: Allow TREE_PREEMPT_RCU on UP systems
Date: Sat, 26 Jan 2013 16:23:47 -0800
Message-Id: <1359246227-5770-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359246227-5770-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127002328.GA4847@linux.vnet.ibm.com>
 <1359246227-5770-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012705-7606-0000-0000-000007C905C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The TINY_PREEMPT_RCU is complex, does not provide that much memory
savings, and therefore TREE_PREEMPT_RCU should be used instead.  The
systems where the difference between TINY_PREEMPT_RCU and TREE_PREEMPT_RCU
are quite small compared to the memory footprint of CONFIG_PREEMPT.

This commit therefore takes a first step towards eliminating
TINY_PREEMPT_RCU by allowing TREE_PREEMPT_RCU to be configured on !SMP
systems.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index a5e90e1..fb19b46 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -453,7 +453,7 @@ config TREE_RCU
 
 config TREE_PREEMPT_RCU
 	bool "Preemptible tree-based hierarchical RCU"
-	depends on PREEMPT && SMP
+	depends on PREEMPT
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
@@ -461,6 +461,8 @@ config TREE_PREEMPT_RCU
 	  is also required.  It also scales down nicely to
 	  smaller systems.
 
+	  Select this option if you are unsure.
+
 config TINY_RCU
 	bool "UP-only small-memory-footprint RCU"
 	depends on !PREEMPT && !SMP
-- 
1.7.8

