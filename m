Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3DLXTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:19:41 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57619 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3DLXT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:19:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 7/7] rcu: Merge adjacent identical ifdefs
Date: Fri, 12 Apr 2013 16:19:14 -0700
Message-Id: <1365808754-20762-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-3620-0000-0000-000002038540
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Two ifdefs in kernel/rcupdate.c now have identical conditions with
nothing between them, so the commit merges them into a single ifdef.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 48ab703..faeea98 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -145,9 +145,6 @@ static struct lock_class_key rcu_sched_lock_key;
 struct lockdep_map rcu_sched_lock_map =
 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
 EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
-#endif
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 int debug_lockdep_rcu_enabled(void)
 {
-- 
1.8.1.5

