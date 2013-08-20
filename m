Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab3HTCva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:51:30 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49405 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3HTCv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:51:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/5] rcu: Remove unused variable from rcu_torture_writer()
Date: Mon, 19 Aug 2013 19:51:13 -0700
Message-Id: <1376967074-32530-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-0320-0000-0000-000000BBA490
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The oldbatch variable in rcu_torture_writer() is stored to, but never
loaded from.  This commit therefore removes it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutorture.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 949a8f2..869dac2 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -797,7 +797,6 @@ rcu_torture_writer(void *arg)
 {
 	bool exp;
 	int i;
-	long oldbatch = rcu_batches_completed();
 	struct rcu_torture *rp;
 	struct rcu_torture *rp1;
 	struct rcu_torture *old_rp;
@@ -851,7 +850,6 @@ rcu_torture_writer(void *arg)
 			}
 		}
 		rcutorture_record_progress(++rcu_torture_current_version);
-		oldbatch = cur_ops->completed();
 		rcu_stutter_wait("rcu_torture_writer");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
-- 
1.8.1.5

