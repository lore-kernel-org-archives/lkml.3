Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3LJB3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:29:06 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36210 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3LJB2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:28:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v5 tip/core/locking 2/7] Documentation/memory-barriers.txt: Add long atomic examples to memory-barriers.txt
Date: Mon,  9 Dec 2013 17:27:58 -0800
Message-Id: <1386638883-25379-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131210012738.GA24317@linux.vnet.ibm.com>
 <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121001-7164-0000-0000-00000414BBE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although the atomic_long_t functions are quite useful, they are a bit
obscure.  This commit therefore adds the common ones alongside their
atomic_t counterparts in Documentation/memory-barriers.txt.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/memory-barriers.txt | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 1d067235b0bc..2d22da095a60 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1728,21 +1728,23 @@ explicit lock operations, described later).  These include:
 
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

