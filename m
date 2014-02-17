Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaBQV1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:27:09 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41617 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaBQV1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:27:03 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/6] Documentation/memory-barriers.txt: ACCESS_ONCE() provides cache coherence
Date: Mon, 17 Feb 2014 13:26:49 -0800
Message-Id: <1392672413-5114-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217212625.GA4083@linux.vnet.ibm.com>
 <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-7164-0000-0000-000006266562
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The ACCESS_ONCE() primitive provides cache coherence, but the
documentation does not clearly state this.  This commit therefore upgrades
the documentation.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 102dc19c4119..ad6db1d48f1f 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1249,6 +1249,23 @@ The ACCESS_ONCE() function can prevent any number of optimizations that,
 while perfectly safe in single-threaded code, can be fatal in concurrent
 code.  Here are some examples of these sorts of optimizations:
 
+ (*) The compiler is within its rights to reorder loads and stores
+     to the same variable, and in some cases, the CPU is within its
+     rights to reorder loads to the same variable.  This means that
+     the following code:
+
+	a[0] = x;
+	a[1] = x;
+
+     Might result in an older value of x stored in a[1] than in a[0].
+     Prevent both the compiler and the CPU from doing this as follows:
+
+	a[0] = ACCESS_ONCE(x);
+	a[1] = ACCESS_ONCE(x);
+
+     In short, ACCESS_ONCE() provides "cache coherence" for accesses from
+     multiple CPUs to a single variable.
+
  (*) The compiler is within its rights to merge successive loads from
      the same variable.  Such merging can cause the compiler to "optimize"
      the following code:
-- 
1.8.1.5

