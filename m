Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3KURs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:48:58 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36205 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3KURsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:48:54 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 2/3] documentation: Add long atomic examples to memory-barriers.txt
Date: Thu, 21 Nov 2013 09:48:46 -0800
Message-Id: <1385056127-6980-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1385056127-6980-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131121174824.GA6611@linux.vnet.ibm.com>
 <1385056127-6980-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112117-7164-0000-0000-00000386FF95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although the atomic_long_t functions are quite useful, they are a bit
obscure.  This commit therefore adds the common ones alongside their
atomic_t counterparts in Documentation/memory-barriers.txt.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
---
 Documentation/memory-barriers.txt | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index eccc83a40ce1..d49fb6b48c86 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1726,21 +1726,23 @@ explicit lock operations, described later).  These include:
 
 	xchg();
 	cmpxchg();
-	atomic_xchg();
-	atomic_cmpxchg();
-	atomic_inc_return();
-	atomic_dec_return();
-	atomic_add_return();
-	atomic_sub_return();
-	atomic_inc_and_test();
-	atomic_dec_and_test();
-	atomic_sub_and_test();
-	atomic_add_negative();
-	atomic_add_unless();	/* when succeeds (returns 1) */
+	atomic_xchg();			atomic_long_xchg();
+	atomic_cmpxchg();		atomic_long_cmpxchg();
+	atomic_inc_return();		atomic_long_inc_return();
+	atomic_dec_return();		atomic_long_dec_return();
+	atomic_add_return();		atomic_long_add_return();
+	atomic_sub_return();		atomic_long_sub_return();
+	atomic_inc_and_test();		atomic_long_inc_and_test();
+	atomic_dec_and_test();		atomic_long_dec_and_test();
+	atomic_sub_and_test();		atomic_long_sub_and_test();
+	atomic_add_negative();		atomic_long_add_negative();
 	test_and_set_bit();
 	test_and_clear_bit();
 	test_and_change_bit();
 
+	/* when succeeds (returns 1) */
+	atomic_add_unless();		atomic_long_add_unless();
+
 These are used for such things as implementing LOCK-class and UNLOCK-class
 operations and adjusting reference counters towards object destruction, and as
 such the implicit memory barrier effects are necessary.
-- 
1.8.1.5

