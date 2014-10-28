Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaJ1WOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:14:01 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54087 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbaJ1WN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:13:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/9] rcu: Add sparse check for RCU_INIT_POINTER()
Date: Tue, 28 Oct 2014 15:09:58 -0700
Message-Id: <1414534202-27312-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0033-0000-0000-0000028046B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Add a sparse check when RCU_INIT_POINTER() is used to assign a non __rcu
annotated pointer.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a4a819ffb2d1..a033d8b55773 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1047,6 +1047,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  */
 #define RCU_INIT_POINTER(p, v) \
 	do { \
+		rcu_dereference_sparse(p, __rcu); \
 		p = RCU_INITIALIZER(v); \
 	} while (0)
 
-- 
1.8.1.5

