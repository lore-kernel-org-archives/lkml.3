Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab3KVMb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:31:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3KVMby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:31:54 -0500
Date: Fri, 22 Nov 2013 04:31:17 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-e0edc78f25c020dea66742c05a7fbcb2ff3df629@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] Documentation/memory-barriers.txt:
  Fix a typo in the data dependency description
Git-Commit-ID: e0edc78f25c020dea66742c05a7fbcb2ff3df629
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 22 Nov 2013 04:31:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0edc78f25c020dea66742c05a7fbcb2ff3df629
Gitweb:     http://git.kernel.org/tip/e0edc78f25c020dea66742c05a7fbcb2ff3df629
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 22 Nov 2013 11:24:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 22 Nov 2013 11:46:12 +0100

Documentation/memory-barriers.txt: Fix a typo in the data dependency description

This typo has been there forever, it is 7.5 years old, looks like this
section of our memory ordering documentation is a place where most eyes
are glazed over already ;-)

[ Also fix some stray spaces and stray tabs while at it, shrinking the
  file by 49 bytes. Visual output unchanged. ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-gncea9cb8igosblizfqMXrie@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/memory-barriers.txt | 42 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index c8c42e6..020cccd 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -500,7 +500,7 @@ odd-numbered bank is idle, one can see the new value of the pointer P (&B),
 but the old value of the variable B (2).
 
 
-Another example of where data dependency barriers might by required is where a
+Another example of where data dependency barriers might be required is where a
 number is read from memory and then used to calculate the index for an array
 access:
 
@@ -882,12 +882,12 @@ cache it for later use.
 
 Consider:
 
-	CPU 1	   		CPU 2
+	CPU 1			CPU 2
 	=======================	=======================
-	 	   		LOAD B
-	 	   		DIVIDE		} Divide instructions generally
-	 	   		DIVIDE		} take a long time to perform
-	 	   		LOAD A
+				LOAD B
+				DIVIDE		} Divide instructions generally
+				DIVIDE		} take a long time to perform
+				LOAD A
 
 Which might appear as this:
 
@@ -910,13 +910,13 @@ Which might appear as this:
 Placing a read barrier or a data dependency barrier just before the second
 load:
 
-	CPU 1	   		CPU 2
+	CPU 1			CPU 2
 	=======================	=======================
-	 	   		LOAD B
-	 	   		DIVIDE
-	 	   		DIVIDE
+				LOAD B
+				DIVIDE
+				DIVIDE
 				<read barrier>
-	 	   		LOAD A
+				LOAD A
 
 will force any value speculatively obtained to be reconsidered to an extent
 dependent on the type of barrier used.  If there was no change made to the
@@ -1887,8 +1887,8 @@ functions:
      space should suffice for PCI.
 
      [*] NOTE! attempting to load from the same location as was written to may
-     	 cause a malfunction - consider the 16550 Rx/Tx serial registers for
-     	 example.
+	 cause a malfunction - consider the 16550 Rx/Tx serial registers for
+	 example.
 
      Used with prefetchable I/O memory, an mmiowb() barrier may be required to
      force stores to be ordered.
@@ -1955,19 +1955,19 @@ barriers for the most part act at the interface between the CPU and its cache
 	                          :
 	+--------+    +--------+  :   +--------+    +-----------+
 	|        |    |        |  :   |        |    |           |    +--------+
-	|  CPU   |    | Memory |  :   | CPU    |    |           |    |	      |
-	|  Core  |--->| Access |----->| Cache  |<-->|           |    |	      |
+	|  CPU   |    | Memory |  :   | CPU    |    |           |    |        |
+	|  Core  |--->| Access |----->| Cache  |<-->|           |    |        |
 	|        |    | Queue  |  :   |        |    |           |--->| Memory |
-	|        |    |        |  :   |        |    |           |    |	      |
-	+--------+    +--------+  :   +--------+    |           |    | 	      |
+	|        |    |        |  :   |        |    |           |    |        |
+	+--------+    +--------+  :   +--------+    |           |    |        |
 	                          :                 | Cache     |    +--------+
 	                          :                 | Coherency |
 	                          :                 | Mechanism |    +--------+
 	+--------+    +--------+  :   +--------+    |           |    |	      |
 	|        |    |        |  :   |        |    |           |    |        |
 	|  CPU   |    | Memory |  :   | CPU    |    |           |--->| Device |
-	|  Core  |--->| Access |----->| Cache  |<-->|           |    | 	      |
-	|        |    | Queue  |  :   |        |    |           |    | 	      |
+	|  Core  |--->| Access |----->| Cache  |<-->|           |    |        |
+	|        |    | Queue  |  :   |        |    |           |    |        |
 	|        |    |        |  :   |        |    |           |    +--------+
 	+--------+    +--------+  :   +--------+    +-----------+
 	                          :
@@ -2090,7 +2090,7 @@ CPU's caches by some other cache event:
 	p = &v;		q = p;
 			<D:request p>
 	<B:modify p=&v>	<D:commit p=&v>
-		  	<D:read p>
+			<D:read p>
 			x = *q;
 			<C:read *q>	Reads from v before v updated in cache
 			<C:unbusy>
@@ -2115,7 +2115,7 @@ queue before processing any further requests:
 	p = &v;		q = p;
 			<D:request p>
 	<B:modify p=&v>	<D:commit p=&v>
-		  	<D:read p>
+			<D:read p>
 			smp_read_barrier_depends()
 			<C:unbusy>
 			<C:commit v=2>
