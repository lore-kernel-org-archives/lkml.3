Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbaD2A2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:28:05 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52609 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107AbaD2AZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 40/45] rcutorture: Run rcu_torture_writer at normal priority
Date: Mon, 28 Apr 2014 17:25:28 -0700
Message-Id: <1398731133-18925-40-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1344-0000-0000-00000134E8C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

There are usually lots of readers and only one writer, so if there has
to be a choice, we would want rcu_torture_writer to win.  This commit
therefore removes the set_user_nice() from rcu_torture_writer().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index a576583dd81e..b181b11c398e 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -757,7 +757,6 @@ rcu_torture_writer(void *arg)
 	int nsynctypes = 0;
 
 	VERBOSE_TOROUT_STRING("rcu_torture_writer task started");
-	set_user_nice(current, MAX_NICE);
 
 	/* Initialize synctype[] array.  If none set, take default. */
 	if (!gp_cond1 && !gp_exp1 && !gp_normal1 && !gp_sync)
-- 
1.8.1.5

