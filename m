Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbaJ1WeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:34:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35021 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357AbaJ1WeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:34:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/6] rcutorture: Enable RCU self test in configs
Date: Tue, 28 Oct 2014 15:30:02 -0700
Message-Id: <1414535405-30228-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028222929.GA29476@linux.vnet.ibm.com>
 <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F50B48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Add config and boot parameters to enable the self tests in rcutorture testing.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/configs/rcu/TINY02      | 2 ++
 tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot | 2 ++
 tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot | 1 +
 tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot | 3 +++
 tools/testing/selftests/rcutorture/configs/rcu/TREE08      | 2 ++
 tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot | 2 ++
 6 files changed, 12 insertions(+)
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot

diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TINY02 b/tools/testing/selftests/rcutorture/configs/rcu/TINY02
index f4feaee40776..36e41df3d27a 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TINY02
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TINY02
@@ -7,6 +7,8 @@ CONFIG_HZ_PERIODIC=y
 CONFIG_NO_HZ_IDLE=n
 CONFIG_NO_HZ_FULL=n
 CONFIG_RCU_TRACE=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
 CONFIG_PREEMPT_COUNT=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot b/tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
new file mode 100644
index 000000000000..0f0802730014
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
@@ -0,0 +1,2 @@
+rcupdate.rcu_self_test=1
+rcupdate.rcu_self_test_bh=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
index 3b42b8b033cd..15b3e1a86f74 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
@@ -1 +1,2 @@
 rcutorture.torture_type=sched
+rcupdate.rcu_self_test_sched=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot
new file mode 100644
index 000000000000..da9a03a398db
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot
@@ -0,0 +1,3 @@
+rcupdate.rcu_self_test=1
+rcupdate.rcu_self_test_bh=1
+rcupdate.rcu_self_test_sched=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
index 69a2e255bf98..80f79d465009 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
@@ -18,6 +18,8 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ALL=y
 CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
index 3b42b8b033cd..2561daf605ad 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
@@ -1 +1,3 @@
 rcutorture.torture_type=sched
+rcupdate.rcu_self_test=1
+rcupdate.rcu_self_test_sched=1
-- 
1.8.1.5

