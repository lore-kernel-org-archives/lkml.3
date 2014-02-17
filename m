Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaBQVg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:36:26 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52893 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaBQVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/12] rcu: Fix sparse warning for rcu_expedited from kernel/ksysfs.c
Date: Mon, 17 Feb 2014 13:35:59 -0800
Message-Id: <1392672959-6386-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-6688-0000-0000-000006AE6F08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

This commit fixes the follwoing warning:

kernel/ksysfs.c:143:5: warning: symbol 'rcu_expedited' was not declared. Should it be static?

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
[ paulmck: Moved the declaration to include/linux/rcupdate.h to avoid
	   including the RCU-internal rcu.h file outside of RCU. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 1 +
 kernel/ksysfs.c          | 2 ++
 kernel/rcu/rcu.h         | 2 --
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 32decf1a9c6c..f3706c6b2e21 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -46,6 +46,7 @@
 #include <linux/compiler.h>
 #include <asm/barrier.h>
 
+extern int rcu_expedited; /* for sysctl */
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index d945a949760f..e660964086e2 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -19,6 +19,8 @@
 #include <linux/sched.h>
 #include <linux/capability.h>
 
+#include <linux/rcupdate.h>	/* rcu_expedited */
+
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 1bd787fddcb2..af2e60a8425d 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -116,8 +116,6 @@ static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
 	}
 }
 
-extern int rcu_expedited;
-
 #ifdef CONFIG_RCU_STALL_COMMON
 
 extern int rcu_cpu_stall_suppress;
-- 
1.8.1.5

