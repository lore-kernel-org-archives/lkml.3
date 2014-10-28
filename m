Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaJ1WgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:36:18 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60953 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbaJ1W1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:27:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, Stefan Hengelein <stefan.hengelein@fau.de>,
        Andreas Ruprecht <rupran@einserver.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/7] init/Kconfig: move RCU_NOCB_CPU dependencies to choice
Date: Tue, 28 Oct 2014 15:22:56 -0700
Message-Id: <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20141028222224.GA28263@linux.vnet.ibm.com>
References: <20141028222224.GA28263@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F50642
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Hengelein <stefan.hengelein@fau.de>

Every choice item of the "Build-forced no-CBs CPUs" choice had a
dependency to RCU_NOCB_CPU.  It's more comprehensible if the choice
itself has the dependency instead of every choice item.  The choice
itself doesn't need to be visible if there are no items selectable
(i.e.  on arch/frv) or RCU_NOCB_CPU is not defined.

Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 3ee28ae02cc8..0c9546ba56e8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -739,6 +739,7 @@ config RCU_NOCB_CPU
 choice
 	prompt "Build-forced no-CBs CPUs"
 	default RCU_NOCB_CPU_NONE
+	depends on RCU_NOCB_CPU
 	help
 	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
 	  from kthreads rather than from softirq context) to be specified
@@ -747,7 +748,6 @@ choice
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
@@ -761,7 +761,6 @@ config RCU_NOCB_CPU_NONE
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
-	depends on RCU_NOCB_CPU
 	help
 	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
 	  callbacks are invoked by a per-CPU kthread whose name begins
@@ -776,7 +775,6 @@ config RCU_NOCB_CPU_ZERO
 
 config RCU_NOCB_CPU_ALL
 	bool "All CPUs are build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU
 	help
 	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
 	  boot parameter will be ignored.  All CPUs' RCU callbacks will
-- 
1.8.1.5

