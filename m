Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaBQWUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:20:20 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35224 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaBQWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:20 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 49/55] locktorture: Add vestigial locktorture configuration
Date: Mon, 17 Feb 2014 14:12:53 -0800
Message-Id: <1392675179-11560-49-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3850
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a trivial set of configuration files for lock
torturing.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh      |  2 +-
 .../selftests/rcutorture/configs/lock/BUSTED       |  6 +++
 .../selftests/rcutorture/configs/lock/BUSTED.boot  |  1 +
 .../selftests/rcutorture/configs/lock/CFLIST       |  1 +
 .../selftests/rcutorture/configs/lock/CFcommon     |  2 +
 .../selftests/rcutorture/configs/lock/LOCK01       |  6 +++
 .../rcutorture/configs/lock/ver_functions.sh       | 43 ++++++++++++++++++++++
 7 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/BUSTED
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/CFcommon
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK01
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index c24092ce981c..8d3a6e916811 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -159,7 +159,7 @@ do
 		shift
 		;;
 	--torture)
-		checkarg --torture "(suite name)" "$#" "$2" '^rcu$' '^--'
+		checkarg --torture "(suite name)" "$#" "$2" '^\(lock\|rcu\)$' '^--'
 		TORTURE_SUITE=$2
 		shift
 		;;
diff --git a/tools/testing/selftests/rcutorture/configs/lock/BUSTED b/tools/testing/selftests/rcutorture/configs/lock/BUSTED
new file mode 100644
index 000000000000..1d1da1477fc3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/BUSTED
@@ -0,0 +1,6 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot b/tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot
new file mode 100644
index 000000000000..6386c15e9770
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot
@@ -0,0 +1 @@
+locktorture.torture_type=lock_busted
diff --git a/tools/testing/selftests/rcutorture/configs/lock/CFLIST b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
new file mode 100644
index 000000000000..a061b22d1892
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
@@ -0,0 +1 @@
+LOCK01
diff --git a/tools/testing/selftests/rcutorture/configs/lock/CFcommon b/tools/testing/selftests/rcutorture/configs/lock/CFcommon
new file mode 100644
index 000000000000..e372dc269254
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/CFcommon
@@ -0,0 +1,2 @@
+CONFIG_LOCK_TORTURE_TEST=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK01 b/tools/testing/selftests/rcutorture/configs/lock/LOCK01
new file mode 100644
index 000000000000..a9625e3d6cd9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK01
@@ -0,0 +1,6 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
new file mode 100644
index 000000000000..9746ea1cd6c7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
@@ -0,0 +1,43 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2014
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# locktorture_param_onoff bootparam-string config-file
+#
+# Adds onoff locktorture module parameters to kernels having it.
+locktorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding locktorture onoff. 1>&2
+		echo locktorture.onoff_interval=3 locktorture.onoff_holdoff=30
+	fi
+}
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `locktorture_param_onoff "$1" "$2"` \
+		locktorture.stat_interval=15 \
+		locktorture.shutdown_secs=$3 \
+		locktorture.locktorture_runnable=1 \
+		locktorture.verbose=1
+}
-- 
1.8.1.5

