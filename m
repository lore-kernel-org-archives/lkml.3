Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3LKXJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:09:41 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:59537 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3LKXI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:08:56 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 tip/core/rcu 3/4] rcu: Make rcu_assign_pointer's assignment volatile and type-safe
Date: Wed, 11 Dec 2013 15:08:47 -0800
Message-Id: <1386803328-13272-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386803328-13272-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131211230823.GA12448@linux.vnet.ibm.com>
 <1386803328-13272-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121123-3532-0000-0000-000003C5085A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

The rcu_assign_pointer() primitive needs to use ACCESS_ONCE to make
the assignment to the destination pointer volatile, to protect against
compilers too clever for their own good.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00ad28168ef0..97853cd2d7b4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -551,7 +551,7 @@ static inline void rcu_preempt_sleep_check(void)
 #define __rcu_assign_pointer(p, v, space) \
 	do { \
 		smp_wmb(); \
-		(p) = (typeof(*v) __force space *)(v); \
+		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \
 	} while (0)
 
 
-- 
1.8.1.5

