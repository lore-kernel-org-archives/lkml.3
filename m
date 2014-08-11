Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaHKWwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:52:09 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:62606 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaHKWvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:51:18 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Masanari Iida <standby24x7@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] doc: memory-barriers.txt: Add barrier() to provide ordering
Date: Mon, 11 Aug 2014 18:51:40 -0400
Message-Id: <1407797503-24727-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
References: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the provably false case, add barrier() in both the legs of the if() condition
to provide ordering.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/memory-barriers.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 41a6c9c..0f2903f 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -689,9 +689,11 @@ should do something like the following:
 	q = ACCESS_ONCE(a);
 	BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
 	if (q % MAX) {
+		barrier();
 		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
+		barrier();
 		ACCESS_ONCE(b) = p;
 		do_something_else();
 	}
-- 
1.9.1

