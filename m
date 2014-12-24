Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaLXJvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 04:51:53 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:10112 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751618AbaLXJvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 04:51:52 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="46357946"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?=E8=94=A1=E6=AD=A3=E9=BE=99?= <zhenglong.cai@cs2c.com.cn>,
        Bertrand Jacquin <beber@meleeweb.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Fabian Frederick <fabf@skynet.be>,
        Andy Lutomirski <luto@amacapital.net>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Peter Foley <pefoley2@pefoley.com>, Mel Gorman <mgorman@suse.de>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH] rcu: remove "select IRQ_WORK" from config TREE_RCU
Date: Wed, 24 Dec 2014 17:55:28 +0800
Message-ID: <1419414940-5082-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 48a7639ce80c ("rcu: Make callers awaken grace-period kthread")
removed the irq_work_queue(), so the TREE_RCU doesn't need
irq work any more.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 init/Kconfig      |    2 --
 kernel/rcu/tree.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9afb971..39b4313 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -470,7 +470,6 @@ choice
 config TREE_RCU
 	bool "Tree-based hierarchical RCU"
 	depends on !PREEMPT && SMP
-	select IRQ_WORK
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP system with hundreds or
@@ -480,7 +479,6 @@ config TREE_RCU
 config PREEMPT_RCU
 	bool "Preemptible tree-based hierarchical RCU"
 	depends on PREEMPT
-	select IRQ_WORK
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8e7b184..a47a13c 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -27,7 +27,6 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
-#include <linux/irq_work.h>
 
 /*
  * Define shape of hierarchy based on NR_CPUS, CONFIG_RCU_FANOUT, and
-- 
1.7.4.4

