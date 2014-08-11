Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaHKWvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:51:20 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:56967 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaHKWvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:51:16 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Masanari Iida <standby24x7@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] doc: memory-barriers.txt: Minor correction in Control dependencies
Date: Mon, 11 Aug 2014 18:51:39 -0400
Message-Id: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor corrections in memory-barriers.txt document.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/memory-barriers.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index abec3f9..41a6c9c 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -627,7 +627,7 @@ proving the value of 'a', and the pair of barrier() invocations are
 required to prevent the compiler from pulling the two identical stores
 to 'b' out from the legs of the "if" statement.
 
-It is important to note that control dependencies absolutely require a
+It is important to note that control dependencies absolutely require
 a conditional.  For example, the following "optimized" version of
 the above example breaks ordering, which is why the barrier() invocations
 are absolutely required if you have identical stores in both legs of
@@ -652,7 +652,7 @@ for example, as follows:
 		do_something();
 	} else {
 		barrier();
-		ACCESS_ONCE(b) = q / 3;
+		ACCESS_ONCE(b) = q / 2;
 		do_something_else();
 	}
 
@@ -710,7 +710,7 @@ x and y both being zero:
 
 The above two-CPU example will never trigger the assert().  However,
 if control dependencies guaranteed transitivity (which they do not),
-then adding the following two CPUs would guarantee a related assertion:
+then adding the following CPU would guarantee a related assertion:
 
 	CPU 2
 	=====================
@@ -719,8 +719,8 @@ then adding the following two CPUs would guarantee a related assertion:
 	assert(!(r1 == 2 && r2 == 1 && x == 2)); /* FAILS!!! */
 
 But because control dependencies do -not- provide transitivity, the
-above assertion can fail after the combined four-CPU example completes.
-If you need the four-CPU example to provide ordering, you will need
+above assertion can fail after the combined three-CPU example completes.
+If you need the three-CPU example to provide ordering, you will need
 smp_mb() between the loads and stores in the CPU 0 and CPU 1 code fragments,
 that is, just before or just after the "if" statements.
 
-- 
1.9.1

