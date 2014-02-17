Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaBQV2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:28:13 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44678 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaBQV1D (ORCPT
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
Subject: [PATCH tip/core/rcu 3/6] Documentation/memory-barriers.txt: Conditional must use prior load
Date: Mon, 17 Feb 2014 13:26:50 -0800
Message-Id: <1392672413-5114-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217212625.GA4083@linux.vnet.ibm.com>
 <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-0928-0000-0000-000006C2FE5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

A control dependency consists of a load, a conditional that depends on
that load, and a store.  This commit emphasizes this point in the
summary.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index ad6db1d48f1f..f2668c19807e 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -724,7 +724,8 @@ In summary:
       later loads, smp_mb().
 
   (*) Control dependencies require at least one run-time conditional
-      between the prior load and the subsequent store.  If the compiler
+      between the prior load and the subsequent store, and this
+      conditional must involve the prior load.  If the compiler
       is able to optimize the conditional away, it will have also
       optimized away the ordering.  Careful use of ACCESS_ONCE() can
       help to preserve the needed conditional.
-- 
1.8.1.5

