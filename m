Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaICDee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:34:34 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:55804 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaICDed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:34:33 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH v2] doc: memory-barriers.txt: Correct example for reorderings
Date: Tue,  2 Sep 2014 23:34:29 -0400
Message-Id: <1409715269-17390-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the example of memory orderings in memory-barriers.txt

Commit 615cc2c9cf95 "Documentation/memory-barriers.txt: fix important typo re
memory barriers" changed the assignment to x and y. Change the rest of the
example to match this change.

Reported-by: Ganesh Rapolu <ganesh.rapolu@hotmail.com>
Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/memory-barriers.txt | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a4de88f..02f5de8 100644
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
2.1.0

