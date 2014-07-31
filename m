Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaGaAlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:41:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50592 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbaGaAjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:39:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 tip/core/rcu 06/10] rcutorture: Add RCU-tasks test cases
Date: Wed, 30 Jul 2014 17:39:38 -0700
Message-Id: <1406767182-4356-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073100-0928-0000-0000-000003C7075F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds the TASKS01 and TASKS02 Kconfig fragments, along with
the corresponding TASKS01.boot and TASKS02.boot boot-parameter files
specifying that rcutorture test RCU-tasks instead of the default flavor.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/configs/rcu/TASKS01      | 7 +++++++
 tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot | 1 +
 tools/testing/selftests/rcutorture/configs/rcu/TASKS02      | 6 ++++++
 tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot | 1 +
 4 files changed, 15 insertions(+)
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS01
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS02
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot

diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS01 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01
new file mode 100644
index 000000000000..263a20f01fae
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01
@@ -0,0 +1,7 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=2
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
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
index 000000000000..17b669c8833c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02
@@ -0,0 +1,6 @@
+CONFIG_SMP=n
+CONFIG_HOTPLUG_CPU=y
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
-- 
1.8.1.5

