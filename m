Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3HTCh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:37:58 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39216 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3HTCh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:37:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] doc: Fix memory-barrier control-dependency example
Date: Mon, 19 Aug 2013 19:37:47 -0700
Message-Id: <1376966267-29949-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966267-29949-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820023717.GA29357@linux.vnet.ibm.com>
 <1376966267-29949-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-4834-0000-0000-00000A50EFAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Each control-dependency example needs its barriers between the "if"
condition and the body of the "if" because a control dependency is
a dependency induced by a branch.  This commit makes the needed
adjustment.

Reported-by: Yongming Shen <symingz@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/memory-barriers.txt | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index fa5d8a9..c8c42e6 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -531,9 +531,10 @@ dependency barrier to make it work correctly.  Consider the following bit of
 code:
 
 	q = &a;
-	if (p)
+	if (p) {
+		<data dependency barrier>
 		q = &b;
-	<data dependency barrier>
+	}
 	x = *q;
 
 This will not have the desired effect because there is no actual data
@@ -542,9 +543,10 @@ attempting to predict the outcome in advance.  In such a case what's actually
 required is:
 
 	q = &a;
-	if (p)
+	if (p) {
+		<read barrier>
 		q = &b;
-	<read barrier>
+	}
 	x = *q;
 
 
-- 
1.8.1.5

