Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaD2Aaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:30:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59723 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091AbaD2AZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 42/45] locktorture: Remove reference to nonexistent Kconfig parameter
Date: Mon, 28 Apr 2014 17:25:30 -0700
Message-Id: <1398731133-18925-42-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-0000018D138F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The locktorture module references CONFIG_LOCK_TORTURE_TEST_RUNNABLE,
which does not exist.  Which is a good thing, because otherwise
randconfig testing could enable both rcutorture and locktorture
concurrently, which the torture tests are not set up for.  This
commit therefore removes the reference, so that test is runnable
immediately only when inserted as a module.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/locking/locktorture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index b0d3e3c50672..1952466c7db5 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -82,14 +82,14 @@ struct lock_writer_stress_stats {
 };
 static struct lock_writer_stress_stats *lwsa;
 
-#if defined(MODULE) || defined(CONFIG_LOCK_TORTURE_TEST_RUNNABLE)
+#if defined(MODULE)
 #define LOCKTORTURE_RUNNABLE_INIT 1
 #else
 #define LOCKTORTURE_RUNNABLE_INIT 0
 #endif
 int locktorture_runnable = LOCKTORTURE_RUNNABLE_INIT;
 module_param(locktorture_runnable, int, 0444);
-MODULE_PARM_DESC(locktorture_runnable, "Start locktorture at boot");
+MODULE_PARM_DESC(locktorture_runnable, "Start locktorture at module init");
 
 /* Forward reference. */
 static void lock_torture_cleanup(void);
-- 
1.8.1.5

