Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaD1X6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:58:13 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55913 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbaD1X4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Himangi Saraogi <himangi774@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/19] rcu: Replace NR_CPUS with nr_cpu_ids
Date: Mon, 28 Apr 2014 16:56:24 -0700
Message-Id: <1398729392-15087-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-7164-0000-0000-0000015FB4FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>

This patch replaces NR_CPUS with nr_cpu_ids as NR_CPUS should
consider cpumask_var_t.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c6fd0f15425c..6724bd98da7d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3461,8 +3461,8 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 			rnp->qsmaskinit = 0;
 			rnp->grplo = j * cpustride;
 			rnp->grphi = (j + 1) * cpustride - 1;
-			if (rnp->grphi >= NR_CPUS)
-				rnp->grphi = NR_CPUS - 1;
+			if (rnp->grphi >= nr_cpu_ids)
+				rnp->grphi = nr_cpu_ids - 1;
 			if (i == 0) {
 				rnp->grpnum = 0;
 				rnp->grpmask = 0;
-- 
1.8.1.5

