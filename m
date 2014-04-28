Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaD2ACw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:02:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50945 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaD1X4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/19] rcu: Document RCU_INIT_POINTER()'s lack of ordering guarantees
Date: Mon, 28 Apr 2014 16:56:27 -0700
Message-Id: <1398729392-15087-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-0928-0000-0000-0000018CF5B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although rcu_assign_pointer() provides ordering guarantees,
RCU_INIT_POINTER() does not.  This commit makes that explicit
in the docbook comment header.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index fdc422f3d61d..3c5ef02ea580 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -949,6 +949,9 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * pointers, but you must use rcu_assign_pointer() to initialize the
  * external-to-structure pointer -after- you have completely initialized
  * the reader-accessible portions of the linked structure.
+ *
+ * Note that unlike rcu_assign_pointer(), RCU_INIT_POINTER() provides no
+ * ordering guarantees for either the CPU or the compiler.
  */
 #define RCU_INIT_POINTER(p, v) \
 	do { \
-- 
1.8.1.5

