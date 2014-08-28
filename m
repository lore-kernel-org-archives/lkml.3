Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaH1TNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:13:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60240 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaH1TMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:12:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/11] rcutorture: Test partial nohz_full= configuration
Date: Thu, 28 Aug 2014 12:12:17 -0700
Message-Id: <1409253143-31466-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253143-31466-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191203.GA26955@linux.vnet.ibm.com>
 <1409253143-31466-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-0928-0000-0000-0000047AA2EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current set of tests covers only cases where either all possible CPUs
are nohz_full= CPUs or none of them are.  Because there have been some
recent bug escapes in cases where only some of the CPUs are nohz_full=
CPUs, this commit add a configuration where only half of the CPUs are
nohz_full= CPUs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/configs/rcu/TREE07      | 2 +-
 tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot

diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE07 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
index ab6225506909..715ee5e0d59d 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE07
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
@@ -7,7 +7,7 @@ CONFIG_PREEMPT=n
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=n
 CONFIG_NO_HZ_FULL=y
-CONFIG_NO_HZ_FULL_ALL=y
+CONFIG_NO_HZ_FULL_ALL=n
 CONFIG_NO_HZ_FULL_SYSIDLE=y
 CONFIG_RCU_FAST_NO_HZ=n
 CONFIG_RCU_TRACE=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot
new file mode 100644
index 000000000000..d44609937503
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot
@@ -0,0 +1 @@
+nohz_full=2-9
-- 
1.8.1.5

