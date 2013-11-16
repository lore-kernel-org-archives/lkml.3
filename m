Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3KPAjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:39:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38194 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3KPAfx (ORCPT
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
Subject: [PATCH tip/core/rcu 09/28] rcutorture: Refactor TINY_RCU test cases
Date: Fri, 15 Nov 2013 16:35:22 -0800
Message-Id: <1384562141-32446-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-0928-0000-0000-0000037AA9DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The TINY_RCU test cases were first put in place many years ago, and have
been incrementally modified rather than being reworked.  This commit
therefore completes a long-overdue reworking of the TINY_RCU test cases.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/configs/CFLIST  |  4 +--
 tools/testing/selftests/rcutorture/configs/NT1-nh  | 23 -------------
 tools/testing/selftests/rcutorture/configs/NT3-NH  | 20 -----------
 tools/testing/selftests/rcutorture/configs/PT1-nh  | 23 -------------
 tools/testing/selftests/rcutorture/configs/PT2-NH  | 22 ------------
 tools/testing/selftests/rcutorture/configs/TINY01  | 13 +++++++
 tools/testing/selftests/rcutorture/configs/TINY02  | 13 +++++++
 .../testing/selftests/rcutorture/doc/TINY_RCU.txt  | 40 ++++++++++++++++++++++
 8 files changed, 68 insertions(+), 90 deletions(-)
 delete mode 100644 tools/testing/selftests/rcutorture/configs/NT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/NT3-NH
 delete mode 100644 tools/testing/selftests/rcutorture/configs/PT1-nh
 delete mode 100644 tools/testing/selftests/rcutorture/configs/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/TINY01
 create mode 100644 tools/testing/selftests/rcutorture/configs/TINY02
 create mode 100644 tools/testing/selftests/rcutorture/doc/TINY_RCU.txt

diff --git a/tools/testing/selftests/rcutorture/configs/CFLIST b/tools/testing/selftests/rcutorture/configs/CFLIST
index 884491b25c19..cd3d29cb0a47 100644
--- a/tools/testing/selftests/rcutorture/configs/CFLIST
+++ b/tools/testing/selftests/rcutorture/configs/CFLIST
@@ -9,5 +9,5 @@ TREE08
 TREE09
 SRCU-N
 SRCU-P
-NT1-nh
-NT3-NH
+TINY01
+TINY02
diff --git a/tools/testing/selftests/rcutorture/configs/NT1-nh b/tools/testing/selftests/rcutorture/configs/NT1-nh
deleted file mode 100644
index 023f312a931c..000000000000
--- a/tools/testing/selftests/rcutorture/configs/NT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/NT3-NH b/tools/testing/selftests/rcutorture/configs/NT3-NH
deleted file mode 100644
index 6fd0235dae73..000000000000
--- a/tools/testing/selftests/rcutorture/configs/NT3-NH
+++ /dev/null
@@ -1,20 +0,0 @@
-#CHECK#CONFIG_TINY_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/PT1-nh b/tools/testing/selftests/rcutorture/configs/PT1-nh
deleted file mode 100644
index e3361c3894a1..000000000000
--- a/tools/testing/selftests/rcutorture/configs/PT1-nh
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=n
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/PT2-NH b/tools/testing/selftests/rcutorture/configs/PT2-NH
deleted file mode 100644
index 64abfc3b4d94..000000000000
--- a/tools/testing/selftests/rcutorture/configs/PT2-NH
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_TINY_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-#
-CONFIG_SMP=n
-#
-CONFIG_HOTPLUG_CPU=n
-#
-CONFIG_NO_HZ=y
-#
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/TINY01 b/tools/testing/selftests/rcutorture/configs/TINY01
new file mode 100644
index 000000000000..0c2823f21712
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TINY01
@@ -0,0 +1,13 @@
+CONFIG_SMP=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PREEMPT_COUNT=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TINY02 b/tools/testing/selftests/rcutorture/configs/TINY02
new file mode 100644
index 000000000000..e5072d7528b6
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TINY02
@@ -0,0 +1,13 @@
+CONFIG_SMP=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_HZ_PERIODIC=y
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PREEMPT_COUNT=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
new file mode 100644
index 000000000000..28db67b54e55
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
@@ -0,0 +1,40 @@
+This document gives a brief rationale for the TINY_RCU test cases.
+
+
+Kconfig Parameters:
+
+CONFIG_DEBUG_LOCK_ALLOC -- Do all three and none of the three.
+CONFIG_PREEMPT_COUNT
+CONFIG_RCU_TRACE
+
+The theory here is that randconfig testing will hit the other six possible
+combinations of these parameters.
+
+
+Kconfig Parameters Ignored:
+
+CONFIG_DEBUG_OBJECTS_RCU_HEAD
+CONFIG_PROVE_RCU
+
+	In common code tested by TREE_RCU test cases.
+
+CONFIG_NO_HZ_FULL_SYSIDLE
+CONFIG_RCU_NOCB_CPU
+CONFIG_RCU_USER_QS
+
+	Meaningless for TINY_RCU.
+
+CONFIG_RCU_STALL_COMMON
+CONFIG_RCU_TORTURE_TEST
+
+	Redundant with CONFIG_RCU_TRACE.
+
+CONFIG_HOTPLUG_CPU
+CONFIG_PREEMPT
+CONFIG_PREEMPT_RCU
+CONFIG_SMP
+CONFIG_TINY_RCU
+CONFIG_TREE_PREEMPT_RCU
+CONFIG_TREE_RCU
+
+	All forced by CONFIG_TINY_RCU.
-- 
1.8.1.5

