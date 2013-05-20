Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab3ETO3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:29:06 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42005 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab3ETO3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:29:03 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/6] rcu: Merge adjacent identical ifdefs
Date: Mon, 20 May 2013 07:28:48 -0700
Message-Id: <1369060129-28173-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060129-28173-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520142819.GA27123@linux.vnet.ibm.com>
 <1369060129-28173-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-7182-0000-0000-000006CA4C45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Two ifdefs in kernel/rcupdate.c now have identical conditions with
nothing between them, so the commit merges them into a single ifdef.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
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

