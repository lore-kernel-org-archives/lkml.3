Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3KPAhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:37:17 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58293 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3KPAfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:54 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 23/28] rcutorture: Add tracing-enabled version of TREE08
Date: Fri, 15 Nov 2013 16:35:36 -0800
Message-Id: <1384562141-32446-23-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-6688-0000-0000-0000038DDF43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The TREE08 Kconfig fragment does not enable tracing, which is appropriate
for its test case.  However, this can be inconvenient in cases where
TREE08 locates RCU bugs.  This commit therefore adds a TREE08-T that
differs from TREE08 only in enabling CONFIG_RCU_TRACE.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 .../testing/selftests/rcutorture/configs/TREE08-T  | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE08-T

diff --git a/tools/testing/selftests/rcutorture/configs/TREE08-T b/tools/testing/selftests/rcutorture/configs/TREE08-T
new file mode 100644
index 000000000000..442c4e450ab3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE08-T
@@ -0,0 +1,26 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=16
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=3
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
-- 
1.8.1.5

