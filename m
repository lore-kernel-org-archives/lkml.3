Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaBQWOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:14:37 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35271 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaBQWNW (ORCPT
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
Subject: [PATCH tip/core/rcu 40/55] rcutorture: Remove redundant module-alias directives
Date: Mon, 17 Feb 2014 14:12:44 -0800
Message-Id: <1392675179-11560-40-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3869
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because rcutorture.c has its old name back, there is no longer any need
for the MODULE_ALIAS() and MODULE_PARAM_PREFIX definitions.  This commit
therefore removes them.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 390189ecda05..81b8cc795a07 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -53,12 +53,6 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@freedesktop.org>");
 
-MODULE_ALIAS("rcutorture");
-#ifdef MODULE_PARAM_PREFIX
-#undef MODULE_PARAM_PREFIX
-#endif
-#define MODULE_PARAM_PREFIX "rcutorture."
-
 torture_parm(int, fqs_duration, 0, "Duration of fqs bursts (us), 0 to disable");
 torture_parm(int, fqs_holdoff, 0, "Holdoff time within fqs bursts (us)");
 torture_parm(int, fqs_stutter, 3, "Wait time between fqs bursts (s)");
-- 
1.8.1.5

