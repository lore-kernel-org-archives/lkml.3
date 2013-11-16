Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3KPAkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:40:12 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49411 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3KPAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:53 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 07/28] rcutorture: Add SRCU Kconfig-fragment files
Date: Fri, 15 Nov 2013 16:35:20 -0800
Message-Id: <1384562141-32446-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1344-0000-0000-0000034C987F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Use .boot facility to ease inclusion of SRCU into automated testing.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/configs/SRCU-N      | 8 ++++++++
 tools/testing/selftests/rcutorture/configs/SRCU-N.boot | 1 +
 tools/testing/selftests/rcutorture/configs/SRCU-P      | 8 ++++++++
 tools/testing/selftests/rcutorture/configs/SRCU-P.boot | 1 +
 4 files changed, 18 insertions(+)
 create mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-N
 create mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-N.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-P
 create mode 100644 tools/testing/selftests/rcutorture/configs/SRCU-P.boot

diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N b/tools/testing/selftests/rcutorture/configs/SRCU-N
new file mode 100644
index 000000000000..10a0e27f4c75
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-N
@@ -0,0 +1,8 @@
+CONFIG_RCU_TRACE=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N.boot b/tools/testing/selftests/rcutorture/configs/SRCU-N.boot
new file mode 100644
index 000000000000..238bfe3bd0cc
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-N.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=srcu
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-P b/tools/testing/selftests/rcutorture/configs/SRCU-P
new file mode 100644
index 000000000000..6650e00c6d91
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-P
@@ -0,0 +1,8 @@
+CONFIG_RCU_TRACE=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-P.boot b/tools/testing/selftests/rcutorture/configs/SRCU-P.boot
new file mode 100644
index 000000000000..238bfe3bd0cc
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-P.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=srcu
-- 
1.8.1.5

