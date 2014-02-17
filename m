Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaBQWOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:14:42 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35268 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaBQWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Paul Bolle <pebolle@tiscali.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 52/55] rcutorture: Rename TREE_RCU-Kconfig.txt
Date: Mon, 17 Feb 2014 14:12:56 -0800
Message-Id: <1392675179-11560-52-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F386E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

It used to be that:

    git ls-files "*Kconfig*"

would find all Kconfig files and would only find Kconfig files. This
commit renames TREE_RCU-Kconfig.txt to TREE_RCU-kconfig.txt so that this
is once again true.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/doc/TREE_RCU-Kconfig.txt  | 95 ----------------------
 .../selftests/rcutorture/doc/TREE_RCU-kconfig.txt  | 95 ++++++++++++++++++++++
 2 files changed, 95 insertions(+), 95 deletions(-)
 delete mode 100644 tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt
 create mode 100644 tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt

diff --git a/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt b/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt
deleted file mode 100644
index adbb76cffb49..000000000000
--- a/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt
+++ /dev/null
@@ -1,95 +0,0 @@
-This document gives a brief rationale for the TREE_RCU-related test
-cases, a group that includes TREE_PREEMPT_RCU.
-
-
-Kconfig Parameters:
-
-CONFIG_DEBUG_LOCK_ALLOC -- Do three, covering CONFIG_PROVE_LOCKING & not.
-CONFIG_DEBUG_OBJECTS_RCU_HEAD -- Do one.
-CONFIG_HOTPLUG_CPU -- Do half.  (Every second.)
-CONFIG_HZ_PERIODIC -- Do one.
-CONFIG_NO_HZ_IDLE -- Do those not otherwise specified. (Groups of two.)
-CONFIG_NO_HZ_FULL -- Do two, one with CONFIG_NO_HZ_FULL_SYSIDLE.
-CONFIG_NO_HZ_FULL_SYSIDLE -- Do one.
-CONFIG_PREEMPT -- Do half.  (First three and #8.)
-CONFIG_PROVE_LOCKING -- Do all but two, covering CONFIG_PROVE_RCU and not.
-CONFIG_PROVE_RCU -- Do all but one under CONFIG_PROVE_LOCKING.
-CONFIG_PROVE_RCU_DELAY -- Do one.
-CONFIG_RCU_BOOST -- one of TREE_PREEMPT_RCU.
-CONFIG_RCU_BOOST_PRIO -- set to 2 for _BOOST testing.
-CONFIG_RCU_CPU_STALL_INFO -- do one with and without _VERBOSE.
-CONFIG_RCU_CPU_STALL_VERBOSE -- do one with and without _INFO.
-CONFIG_RCU_FANOUT -- Cover hierarchy as currently, but overlap with others.
-CONFIG_RCU_FANOUT_EXACT -- Do one.
-CONFIG_RCU_FANOUT_LEAF -- Do one non-default.
-CONFIG_RCU_FAST_NO_HZ -- Do one, but not with CONFIG_RCU_NOCB_CPU_ALL.
-CONFIG_RCU_NOCB_CPU -- Do three, see below.
-CONFIG_RCU_NOCB_CPU_ALL -- Do one.
-CONFIG_RCU_NOCB_CPU_NONE -- Do one.
-CONFIG_RCU_NOCB_CPU_ZERO -- Do one.
-CONFIG_RCU_TRACE -- Do half.
-CONFIG_SMP -- Need one !SMP for TREE_PREEMPT_RCU.
-RCU-bh: Do one with PREEMPT and one with !PREEMPT.
-RCU-sched: Do one with PREEMPT but not BOOST.
-
-
-Hierarchy:
-
-TREE01.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=8, CONFIG_RCU_FANOUT_EXACT=n.
-TREE02.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=3, CONFIG_RCU_FANOUT_EXACT=n,
-	CONFIG_RCU_FANOUT_LEAF=3.
-TREE03.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=4, CONFIG_RCU_FANOUT_EXACT=n,
-	CONFIG_RCU_FANOUT_LEAF=4.
-TREE04.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=2, CONFIG_RCU_FANOUT_EXACT=n,
-	CONFIG_RCU_FANOUT_LEAF=2.
-TREE05.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=6, CONFIG_RCU_FANOUT_EXACT=n
-	CONFIG_RCU_FANOUT_LEAF=6.
-TREE06.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=6, CONFIG_RCU_FANOUT_EXACT=y
-	CONFIG_RCU_FANOUT_LEAF=6.
-TREE07.	CONFIG_NR_CPUS=16, CONFIG_RCU_FANOUT=2, CONFIG_RCU_FANOUT_EXACT=n,
-	CONFIG_RCU_FANOUT_LEAF=2.
-TREE08.	CONFIG_NR_CPUS=16, CONFIG_RCU_FANOUT=3, CONFIG_RCU_FANOUT_EXACT=y,
-	CONFIG_RCU_FANOUT_LEAF=2.
-TREE09.	CONFIG_NR_CPUS=1.
-
-
-Kconfig Parameters Ignored:
-
-CONFIG_64BIT
-
-	Used only to check CONFIG_RCU_FANOUT value, inspection suffices.
-
-CONFIG_NO_HZ_FULL_SYSIDLE_SMALL
-
-	Defer until Frederic uses this.
-
-CONFIG_PREEMPT_COUNT
-CONFIG_PREEMPT_RCU
-
-	Redundant with CONFIG_PREEMPT, ignore.
-
-CONFIG_RCU_BOOST_DELAY
-
-	Inspection suffices, ignore.
-
-CONFIG_RCU_CPU_STALL_TIMEOUT
-
-	Inspection suffices, ignore.
-
-CONFIG_RCU_STALL_COMMON
-
-	Implied by TREE_RCU and TREE_PREEMPT_RCU.
-
-CONFIG_RCU_TORTURE_TEST
-CONFIG_RCU_TORTURE_TEST_RUNNABLE
-
-	Always used in KVM testing.
-
-CONFIG_RCU_USER_QS
-
-	Redundant with CONFIG_NO_HZ_FULL.
-
-CONFIG_TREE_PREEMPT_RCU
-CONFIG_TREE_RCU
-
-	These are controlled by CONFIG_PREEMPT.
diff --git a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
new file mode 100644
index 000000000000..adbb76cffb49
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
@@ -0,0 +1,95 @@
+This document gives a brief rationale for the TREE_RCU-related test
+cases, a group that includes TREE_PREEMPT_RCU.
+
+
+Kconfig Parameters:
+
+CONFIG_DEBUG_LOCK_ALLOC -- Do three, covering CONFIG_PROVE_LOCKING & not.
+CONFIG_DEBUG_OBJECTS_RCU_HEAD -- Do one.
+CONFIG_HOTPLUG_CPU -- Do half.  (Every second.)
+CONFIG_HZ_PERIODIC -- Do one.
+CONFIG_NO_HZ_IDLE -- Do those not otherwise specified. (Groups of two.)
+CONFIG_NO_HZ_FULL -- Do two, one with CONFIG_NO_HZ_FULL_SYSIDLE.
+CONFIG_NO_HZ_FULL_SYSIDLE -- Do one.
+CONFIG_PREEMPT -- Do half.  (First three and #8.)
+CONFIG_PROVE_LOCKING -- Do all but two, covering CONFIG_PROVE_RCU and not.
+CONFIG_PROVE_RCU -- Do all but one under CONFIG_PROVE_LOCKING.
+CONFIG_PROVE_RCU_DELAY -- Do one.
+CONFIG_RCU_BOOST -- one of TREE_PREEMPT_RCU.
+CONFIG_RCU_BOOST_PRIO -- set to 2 for _BOOST testing.
+CONFIG_RCU_CPU_STALL_INFO -- do one with and without _VERBOSE.
+CONFIG_RCU_CPU_STALL_VERBOSE -- do one with and without _INFO.
+CONFIG_RCU_FANOUT -- Cover hierarchy as currently, but overlap with others.
+CONFIG_RCU_FANOUT_EXACT -- Do one.
+CONFIG_RCU_FANOUT_LEAF -- Do one non-default.
+CONFIG_RCU_FAST_NO_HZ -- Do one, but not with CONFIG_RCU_NOCB_CPU_ALL.
+CONFIG_RCU_NOCB_CPU -- Do three, see below.
+CONFIG_RCU_NOCB_CPU_ALL -- Do one.
+CONFIG_RCU_NOCB_CPU_NONE -- Do one.
+CONFIG_RCU_NOCB_CPU_ZERO -- Do one.
+CONFIG_RCU_TRACE -- Do half.
+CONFIG_SMP -- Need one !SMP for TREE_PREEMPT_RCU.
+RCU-bh: Do one with PREEMPT and one with !PREEMPT.
+RCU-sched: Do one with PREEMPT but not BOOST.
+
+
+Hierarchy:
+
+TREE01.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=8, CONFIG_RCU_FANOUT_EXACT=n.
+TREE02.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=3, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=3.
+TREE03.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=4, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=4.
+TREE04.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=2, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=2.
+TREE05.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=6, CONFIG_RCU_FANOUT_EXACT=n
+	CONFIG_RCU_FANOUT_LEAF=6.
+TREE06.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=6, CONFIG_RCU_FANOUT_EXACT=y
+	CONFIG_RCU_FANOUT_LEAF=6.
+TREE07.	CONFIG_NR_CPUS=16, CONFIG_RCU_FANOUT=2, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=2.
+TREE08.	CONFIG_NR_CPUS=16, CONFIG_RCU_FANOUT=3, CONFIG_RCU_FANOUT_EXACT=y,
+	CONFIG_RCU_FANOUT_LEAF=2.
+TREE09.	CONFIG_NR_CPUS=1.
+
+
+Kconfig Parameters Ignored:
+
+CONFIG_64BIT
+
+	Used only to check CONFIG_RCU_FANOUT value, inspection suffices.
+
+CONFIG_NO_HZ_FULL_SYSIDLE_SMALL
+
+	Defer until Frederic uses this.
+
+CONFIG_PREEMPT_COUNT
+CONFIG_PREEMPT_RCU
+
+	Redundant with CONFIG_PREEMPT, ignore.
+
+CONFIG_RCU_BOOST_DELAY
+
+	Inspection suffices, ignore.
+
+CONFIG_RCU_CPU_STALL_TIMEOUT
+
+	Inspection suffices, ignore.
+
+CONFIG_RCU_STALL_COMMON
+
+	Implied by TREE_RCU and TREE_PREEMPT_RCU.
+
+CONFIG_RCU_TORTURE_TEST
+CONFIG_RCU_TORTURE_TEST_RUNNABLE
+
+	Always used in KVM testing.
+
+CONFIG_RCU_USER_QS
+
+	Redundant with CONFIG_NO_HZ_FULL.
+
+CONFIG_TREE_PREEMPT_RCU
+CONFIG_TREE_RCU
+
+	These are controlled by CONFIG_PREEMPT.
-- 
1.8.1.5

