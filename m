Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbaD2Ad6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:33:58 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37405 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007AbaD2AZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 16/45] rcutorture: Mark function as static in kernel/rcu/torture.c
Date: Mon, 28 Apr 2014 17:25:04 -0700
Message-Id: <1398731133-18925-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-7164-0000-0000-0000015FD2EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rashika Kheria <rashika.kheria@gmail.com>

Mark functions as static in kernel/rcu/torture.c because they are not
used outside this file.

This eliminates the following warning in kernel/rcu/torture.c:
kernel/rcu/torture.c:902:6: warning: no previous prototype for ‘rcutorture_trace_dump’ [-Wmissing-prototypes]
kernel/rcu/torture.c:1572:6: warning: no previous prototype for ‘rcu_torture_barrier_cbf’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 1110db210318..3845ea99ccd4 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -806,7 +806,7 @@ rcu_torture_fakewriter(void *arg)
 	return 0;
 }
 
-void rcutorture_trace_dump(void)
+static void rcutorture_trace_dump(void)
 {
 	static atomic_t beenhere = ATOMIC_INIT(0);
 
@@ -1183,7 +1183,7 @@ static int __init rcu_torture_stall_init(void)
 }
 
 /* Callback function for RCU barrier testing. */
-void rcu_torture_barrier_cbf(struct rcu_head *rcu)
+static void rcu_torture_barrier_cbf(struct rcu_head *rcu)
 {
 	atomic_inc(&barrier_cbs_invoked);
 }
-- 
1.8.1.5

