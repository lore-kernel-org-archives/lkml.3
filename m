Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3KPAg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:36:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38157 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3KPAfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 03/28] rcutorture: Add kernel-version argument
Date: Fri, 15 Nov 2013 16:35:16 -0800
Message-Id: <1384562141-32446-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-0928-0000-0000-0000037AA9D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 .../selftests/rcutorture/bin/kvm-test-1-rcu.sh     |  1 +
 tools/testing/selftests/rcutorture/bin/kvm.sh      |  9 ++++++-
 .../rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP    | 19 +++++++++++++++
 .../rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp    | 20 ++++++++++++++++
 .../rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp    | 22 +++++++++++++++++
 .../rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP    | 18 ++++++++++++++
 .../rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp    | 22 +++++++++++++++++
 .../selftests/rcutorture/configs/v0.0/NT1-nh       | 23 ++++++++++++++++++
 .../selftests/rcutorture/configs/v0.0/NT3-NH       | 20 ++++++++++++++++
 .../rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP    | 20 ++++++++++++++++
 .../rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp    | 20 ++++++++++++++++
 .../rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp    | 20 ++++++++++++++++
 .../rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP    | 22 +++++++++++++++++
 .../rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp    | 28 ++++++++++++++++++++++
 .../selftests/rcutorture/configs/v0.0/PT1-nh       | 23 ++++++++++++++++++
 .../selftests/rcutorture/configs/v0.0/PT2-NH       | 22 +++++++++++++++++
 .../rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP    | 19 +++++++++++++++
 .../rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp    | 20 ++++++++++++++++
 .../rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp    | 22 +++++++++++++++++
 .../rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP    | 18 ++++++++++++++
 .../rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp    | 22 +++++++++++++++++
 .../selftests/rcutorture/configs/v3.3/NT1-nh       | 23 ++++++++++++++++++
 .../selftests/rcutorture/configs/v3.3/NT3-NH       | 20 ++++++++++++++++
 .../rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP    | 20 ++++++++++++++++
 .../rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp    | 20 ++++++++++++++++
 .../rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp    | 20 ++++++++++++++++
 .../rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP    | 22 +++++++++++++++++
 .../rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp    | 28 ++++++++++++++++++++++
 .../selftests/rcutorture/configs/v3.3/PT1-nh       | 23 ++++++++++++++++++
 .../selftests/rcutorture/configs/v3.3/PT2-NH       | 22 +++++++++++++++++
 .../rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP    | 19 +++++++++++++++
 .../rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp    | 20 ++++++++++++++++
 .../rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp    | 22 +++++++++++++++++
 .../rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP    | 18 ++++++++++++++
 .../rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp    | 22 +++++++++++++++++
 .../selftests/rcutorture/configs/v3.5/NT1-nh       | 23 ++++++++++++++++++
 .../selftests/rcutorture/configs/v3.5/NT3-NH       | 20 ++++++++++++++++
 .../rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP    | 20 ++++++++++++++++
 .../rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp    | 20 ++++++++++++++++
 .../rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp    | 20 ++++++++++++++++
 .../rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP    | 22 +++++++++++++++++
 .../rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp    | 28 ++++++++++++++++++++++
 .../selftests/rcutorture/configs/v3.5/PT1-nh       | 23 ++++++++++++++++++
 .../selftests/rcutorture/configs/v3.5/PT2-NH       | 22 +++++++++++++++++
 44 files changed, 906 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index ae5c2ff4c0ce..3b53078c5ff2 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -61,6 +61,7 @@ then
 fi
 cp $config_template $resdir/ConfigFragment
 echo ' ---' `date`: Starting build
+echo ' ---' Kconfig fragment at: $config_template
 cat << '___EOF___' >> $T
 CONFIG_RCU_TORTURE_TEST=y
 ___EOF___
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 9fcceed81079..7deb7b44d647 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -51,6 +51,7 @@ configs=" sysidleY.2013.06.19a \
 	  NT1-nh \
 	  NT3-NH"
 ds=`date +%Y.%m.%d-%H:%M:%S`
+kversion=""
 
 usage () {
 	echo "Usage: $scriptname optional arguments:"
@@ -58,6 +59,7 @@ usage () {
 	echo "       --configs \"config-file list\""
 	echo "       --datestamp string"
 	echo "       --duration minutes"
+	echo "       --kversion vN.NN"
 	echo "       --rcu-kvm absolute-pathname"
 	echo "       --results absolute-pathname"
 	echo "       --relbuilddir relative-pathname"
@@ -110,6 +112,11 @@ do
 		dur=$2
 		shift
 		;;
+	--kversion)
+		checkarg --kversion "(kernel version)" $# "$2" '^v[0-9.]*$' error
+		kversion=$2
+		shift
+		;;
 	--rcu-kvm)
 		checkarg --rcu-kvm "(absolute pathname)" "$#" "$2" '^/' error
 		KVM=$2; export KVM
@@ -174,6 +181,6 @@ do
 	rd=$resdir/$ds/$CF
 	mkdir $rd || :
 	echo Results directory: $rd
-	kvm-test-1-rcu.sh $CONFIGFRAG/$CF $builddir $rd $dur "-nographic" "rcutorture.test_no_idle_hz=1 rcutorture.n_barrier_cbs=4 rcutorture.verbose=1"
+	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic" "rcutorture.test_no_idle_hz=1 rcutorture.n_barrier_cbs=4 rcutorture.verbose=1"
 done
 # Tracing: trace_event=rcu:rcu_nocb_grace_period,rcu:rcu_grace_period,rcu:rcu_grace_period_init,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_torture_read,rcu:rcu_invoke_callback,rcu:rcu_fqs,rcu:rcu_dyntick,rcu:rcu_unlock_preempted_task
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..d81e11d280aa
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..02e418572b1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b3100f69c8cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..c56b44530725
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..90d924fea9e9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh b/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
new file mode 100644
index 000000000000..023f312a931c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH b/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
new file mode 100644
index 000000000000..6fd0235dae73
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..9647c44cf4b7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..0f3b667d2a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b035e141bf2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..3ccf6a9447f5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..ef624ce73d8e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh b/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
new file mode 100644
index 000000000000..e3361c3894a1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh
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
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH b/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
new file mode 100644
index 000000000000..64abfc3b4d94
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..d81e11d280aa
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..02e418572b1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b3100f69c8cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..c56b44530725
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..90d924fea9e9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh b/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
new file mode 100644
index 000000000000..023f312a931c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH b/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
new file mode 100644
index 000000000000..6fd0235dae73
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..9647c44cf4b7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..0f3b667d2a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b035e141bf2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..3ccf6a9447f5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..ef624ce73d8e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh b/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
new file mode 100644
index 000000000000..e3361c3894a1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH b/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
new file mode 100644
index 000000000000..64abfc3b4d94
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..d81e11d280aa
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..02e418572b1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b3100f69c8cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..c56b44530725
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..90d924fea9e9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh b/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
new file mode 100644
index 000000000000..023f312a931c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH b/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
new file mode 100644
index 000000000000..6fd0235dae73
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..9647c44cf4b7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..0f3b667d2a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b035e141bf2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..3ccf6a9447f5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..ef624ce73d8e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh b/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
new file mode 100644
index 000000000000..e3361c3894a1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh
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
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH b/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH
new file mode 100644
index 000000000000..64abfc3b4d94
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH
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

