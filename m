Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbaJ1WEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:04:39 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53192 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbaJ1WEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:04:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/5] documentation: memory-barriers.txt: Correct example for reorderings
Date: Tue, 28 Oct 2014 15:00:17 -0700
Message-Id: <1414533617-25933-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533617-25933-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215937.GA25095@linux.vnet.ibm.com>
 <1414533617-25933-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F4F2C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Correct the example of memory orderings in memory-barriers.txt

Commit 615cc2c9cf95 "Documentation/memory-barriers.txt: fix important typo re
memory barriers" changed the assignment to x and y. Change the rest of the
example to match this change.

Reported-by: Ganesh Rapolu <ganesh.rapolu@hotmail.com>
Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 8ebb66128cc8..3d5f49b9f82b 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -121,22 +121,22 @@ For example, consider the following sequence of events:
 The set of accesses as seen by the memory system in the middle can be arranged
 in 24 different combinations:
 
-	STORE A=3,	STORE B=4,	x=LOAD A->3,	y=LOAD B->4
-	STORE A=3,	STORE B=4,	y=LOAD B->4,	x=LOAD A->3
-	STORE A=3,	x=LOAD A->3,	STORE B=4,	y=LOAD B->4
-	STORE A=3,	x=LOAD A->3,	y=LOAD B->2,	STORE B=4
-	STORE A=3,	y=LOAD B->2,	STORE B=4,	x=LOAD A->3
-	STORE A=3,	y=LOAD B->2,	x=LOAD A->3,	STORE B=4
-	STORE B=4,	STORE A=3,	x=LOAD A->3,	y=LOAD B->4
+	STORE A=3,	STORE B=4,	y=LOAD A->3,	x=LOAD B->4
+	STORE A=3,	STORE B=4,	x=LOAD B->4,	y=LOAD A->3
+	STORE A=3,	y=LOAD A->3,	STORE B=4,	x=LOAD B->4
+	STORE A=3,	y=LOAD A->3,	x=LOAD B->2,	STORE B=4
+	STORE A=3,	x=LOAD B->2,	STORE B=4,	y=LOAD A->3
+	STORE A=3,	x=LOAD B->2,	y=LOAD A->3,	STORE B=4
+	STORE B=4,	STORE A=3,	y=LOAD A->3,	x=LOAD B->4
 	STORE B=4, ...
 	...
 
 and can thus result in four different combinations of values:
 
-	x == 1, y == 2
-	x == 1, y == 4
-	x == 3, y == 2
-	x == 3, y == 4
+	x == 2, y == 1
+	x == 2, y == 3
+	x == 4, y == 1
+	x == 4, y == 3
 
 
 Furthermore, the stores committed by a CPU to the memory system may not be
-- 
1.8.1.5

