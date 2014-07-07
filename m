Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaGGWZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:25:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51038 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaGGWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:24:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] documentation: Add acquire/release barriers to pairing rules
Date: Mon,  7 Jul 2014 15:24:21 -0700
Message-Id: <1404771862-6904-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707222345.GA6320@linux.vnet.ibm.com>
 <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-1542-0000-0000-0000031A1E95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It is possible to pair acquire and release barriers with other barriers,
so this commit adds them to the list in the SMP barrier pairing section.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 Documentation/memory-barriers.txt | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a6ca533a73fc..2a7c3c4fb53f 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -757,10 +757,12 @@ SMP BARRIER PAIRING
 When dealing with CPU-CPU interactions, certain types of memory barrier should
 always be paired.  A lack of appropriate pairing is almost certainly an error.
 
-A write barrier should always be paired with a data dependency barrier or read
-barrier, though a general barrier would also be viable.  Similarly a read
-barrier or a data dependency barrier should always be paired with at least an
-write barrier, though, again, a general barrier is viable:
+A write barrier should always be paired with a data dependency barrier,
+acquire barrier, release barrier, or read barrier, though a general
+barrier would also be viable.  Similarly a read barrier or a data
+dependency barrier should always be paired with at least a write barrier,
+an acquire barrier, or a release barrier, though, again, a general
+barrier is viable:
 
 	CPU 1		      CPU 2
 	===============	      ===============
-- 
1.8.1.5

