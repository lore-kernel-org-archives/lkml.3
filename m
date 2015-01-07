Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbbAGRw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:52:59 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52648 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbbAGRw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:57 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/10] rcu: Set default to RCU_CPU_STALL_INFO=y
Date: Wed,  7 Jan 2015 09:52:39 -0800
Message-Id: <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20150107175225.GA4237@linux.vnet.ibm.com>
References: <20150107175225.GA4237@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0009-0000-0000-000007C65C45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The RCU_CPU_STALL_INFO code has been in for quite some time, and has
proven reliable.  This commit therefore enables it by default.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5f2ce616c046..b47d9e474cbc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1257,7 +1257,7 @@ config RCU_CPU_STALL_TIMEOUT
 config RCU_CPU_STALL_INFO
 	bool "Print additional diagnostics on RCU CPU stall"
 	depends on (TREE_RCU || PREEMPT_RCU) && DEBUG_KERNEL
-	default n
+	default y
 	help
 	  For each stalled CPU that is aware of the current RCU grace
 	  period, print out additional per-CPU diagnostic information
-- 
1.8.1.5

