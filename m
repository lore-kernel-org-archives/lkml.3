Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbaISPcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:32:51 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:38886 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694AbaISPcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:32:48 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/3] rcutorture: Enable RCU self test in configs
Date: Fri, 19 Sep 2014 11:32:31 -0400
Message-Id: <1411140752-27028-4-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411140752-27028-1-git-send-email-bobby.prani@gmail.com>
References: <1411140752-27028-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add config and boot parameters to enable the self tests in rcutorture testing.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
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
index f4feaee..36e41df 100644
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
index 0000000..0f08027
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
@@ -0,0 +1,2 @@
+rcupdate.rcu_self_test=1
+rcupdate.rcu_self_test_bh=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
index 3b42b8b..15b3e1a 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot
@@ -1 +1,2 @@
 rcutorture.torture_type=sched
+rcupdate.rcu_self_test_sched=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot
new file mode 100644
index 0000000..da9a03a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot
@@ -0,0 +1,3 @@
+rcupdate.rcu_self_test=1
+rcupdate.rcu_self_test_bh=1
+rcupdate.rcu_self_test_sched=1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
index 316aa6c..1a9303d 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
@@ -18,6 +18,8 @@ CONFIG_RCU_FANOUT_LEAF=2
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ALL=y
 CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
index 3b42b8b..2561daf 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08.boot
@@ -1 +1,3 @@
 rcutorture.torture_type=sched
+rcupdate.rcu_self_test=1
+rcupdate.rcu_self_test_sched=1
-- 
2.1.0

