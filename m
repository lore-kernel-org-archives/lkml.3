Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaH1S1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:27:54 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39015 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaH1S0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 15/15] rcu: Add ACCESS_ONCE() for RCU_INIT_POINTER()
Date: Thu, 28 Aug 2014 11:26:34 -0700
Message-Id: <1409250394-25159-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-0928-0000-0000-0000047A3135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It is permissible to use RCU_INIT_POINTER() instead of rcu_assign_pointer()
in a couple of cases where readers might be concurrently accessing the
pointer being assigned to: (1) When assigning NULL and (2) When assigning
a pointer that is already visible to readers.  In these two cases, we
should really be using ACCESS_ONCE() to prevent compiler mischief.  This
commit therefore adds the ACCESS_ONCE().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 321ed0d4e675..7ba3f2470396 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -989,7 +989,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  */
 #define RCU_INIT_POINTER(p, v) \
 	do { \
-		p = RCU_INITIALIZER(v); \
+		ACCESS_ONCE(p) = (v); \
 	} while (0)
 
 /**
-- 
1.8.1.5

