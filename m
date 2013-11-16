Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3KPAiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:38:25 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38251 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3KPAgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:36:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 06/28] rcutorture: Add v3.12 version, which adds sysidle testing
Date: Fri, 15 Nov 2013 16:35:19 -0800
Message-Id: <1384562141-32446-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-0928-0000-0000-0000037AAA25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The v3.12 version of the kernel added the CONFIG_NO_HZ_FULL_SYSIDLE
Kconfig parameter, so this commit adds a version transition at that
point.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 .../selftests/rcutorture/configs/v3.12/CFLIST      | 17 ++++++++++++
 .../rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP   | 19 ++++++++++++++
 .../rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp   | 20 +++++++++++++++
 .../rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp   | 22 ++++++++++++++++
 .../rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP   | 18 +++++++++++++
 .../rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp   | 22 ++++++++++++++++
 .../rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp   | 19 ++++++++++++++
 .../rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP   | 26 +++++++++++++++++++
 .../rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP   | 22 ++++++++++++++++
 .../selftests/rcutorture/configs/v3.12/NT1-nh      | 23 +++++++++++++++++
 .../selftests/rcutorture/configs/v3.12/NT3-NH      | 20 +++++++++++++++
 .../rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP   | 20 +++++++++++++++
 .../rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp   | 20 +++++++++++++++
 .../rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp   | 20 +++++++++++++++
 .../rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP   | 22 ++++++++++++++++
 .../rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp   | 28 ++++++++++++++++++++
 .../rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp   | 18 +++++++++++++
 .../rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP   | 30 ++++++++++++++++++++++
 .../configs/v3.12/P7-4-T-NH-SD-SMP-HP-all          | 30 ++++++++++++++++++++++
 .../configs/v3.12/P7-4-T-NH-SD-SMP-HP-none         | 30 ++++++++++++++++++++++
 .../rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp   | 30 ++++++++++++++++++++++
 .../selftests/rcutorture/configs/v3.12/PT1-nh      | 23 +++++++++++++++++
 .../selftests/rcutorture/configs/v3.12/PT2-NH      | 22 ++++++++++++++++
 23 files changed, 521 insertions(+)
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH

diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST b/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
new file mode 100644
index 000000000000..da4cbc668f2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST
@@ -0,0 +1,17 @@
+sysidleY.2013.06.19a
+sysidleN.2013.06.19a
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+P6---t-nh-SD-smp-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..d81e11d280aa
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..02e418572b1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b3100f69c8cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..c56b44530725
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..90d924fea9e9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
new file mode 100644
index 000000000000..0ccc36d72738
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=1
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..3f640cf84973
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP
@@ -0,0 +1,26 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..285da2dd8ac3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=14
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh b/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
new file mode 100644
index 000000000000..023f312a931c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH b/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
new file mode 100644
index 000000000000..6fd0235dae73
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..9647c44cf4b7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..0f3b667d2a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b035e141bf2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..3ccf6a9447f5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..ef624ce73d8e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
new file mode 100644
index 000000000000..f4c9175828bf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=n
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..77a8c5b75763
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=n
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
new file mode 100644
index 000000000000..0eecebc6e95f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
new file mode 100644
index 000000000000..0eecebc6e95f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
new file mode 100644
index 000000000000..588bc70420cd
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=n
+CONFIG_RCU_NOCB_CPU_ZERO=y
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh b/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
new file mode 100644
index 000000000000..e3361c3894a1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH b/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH
new file mode 100644
index 000000000000..64abfc3b4d94
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
-- 
1.8.1.5

