Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaBQWO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:14:27 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44750 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaBQWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 44/55] rcutorture: Create config files for scripted test-the-test testing
Date: Mon, 17 Feb 2014 14:12:48 -0800
Message-Id: <1392675179-11560-44-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-0928-0000-0000-000006C34F24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a pair of files in the configs directory to allow
test-the-test runs of rcutorture via a "--configs BUSTED" argument to
the kvm.sh script.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/configs/BUSTED      | 8 ++++++++
 tools/testing/selftests/rcutorture/configs/BUSTED.boot | 1 +
 2 files changed, 9 insertions(+)
 create mode 100644 tools/testing/selftests/rcutorture/configs/BUSTED
 create mode 100644 tools/testing/selftests/rcutorture/configs/BUSTED.boot

diff --git a/tools/testing/selftests/rcutorture/configs/BUSTED b/tools/testing/selftests/rcutorture/configs/BUSTED
new file mode 100644
index 000000000000..46fb6cf30cc2
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/BUSTED
@@ -0,0 +1,8 @@
+CONFIG_RCU_TRACE=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/BUSTED.boot b/tools/testing/selftests/rcutorture/configs/BUSTED.boot
new file mode 100644
index 000000000000..6804f9dcfc1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/BUSTED.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=rcu_busted
-- 
1.8.1.5

