Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaH1TWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:22:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46698 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaH1TUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:20:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v7 tip/core/rcu 07/17] rcutorture: Add RCU-tasks test cases
Date: Thu, 28 Aug 2014 12:19:58 -0700
Message-Id: <1409253608-32538-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191929.GA31795@linux.vnet.ibm.com>
 <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-1542-0000-0000-0000045FD402
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds the TASKS01 and TASKS02 Kconfig fragments, along with
the corresponding TASKS01.boot and TASKS02.boot boot-parameter files
specifying that rcutorture test RCU-tasks instead of the default flavor.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/configs/rcu/TASKS01      |  9 +++++++++
 tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot |  1 +
 tools/testing/selftests/rcutorture/configs/rcu/TASKS02      |  5 +++++
 tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot |  1 +
 tools/testing/selftests/rcutorture/configs/rcu/TASKS03      | 13 +++++++++++++
 tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot |  1 +
 6 files changed, 30 insertions(+)
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS01
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS02
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS03
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot

diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS01 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01
new file mode 100644
index 000000000000..97f0a0b27ef7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01
@@ -0,0 +1,9 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=2
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_RCU=y
+CONFIG_TASKS_RCU=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot
new file mode 100644
index 000000000000..cd2a188eeb6d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=tasks
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS02 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02
new file mode 100644
index 000000000000..696d2ea74d13
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02
@@ -0,0 +1,5 @@
+CONFIG_SMP=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_TASKS_RCU=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot
new file mode 100644
index 000000000000..cd2a188eeb6d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=tasks
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS03 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03
new file mode 100644
index 000000000000..9c60da5b5d1d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03
@@ -0,0 +1,13 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=2
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_TASKS_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_ALL=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot
new file mode 100644
index 000000000000..cd2a188eeb6d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=tasks
-- 
1.8.1.5

