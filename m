Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaHYNJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:09:41 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:50324 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaHYNJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:09:40 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] doc: memory-barriers.txt: Correct example for reorderings
Date: Mon, 25 Aug 2014 09:08:58 -0400
Message-Id: <1408972138-12246-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
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
index a4de88f..cf31875 100644
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
+	STORE A=3,	STORE B=4,	x=LOAD B->4,	y=LOAD A->3
+	STORE A=3,	STORE B=4,	y=LOAD A->3,	x=LOAD B->4
+	STORE B=4,	x=LOAD B->4,	STORE A=3,	y=LOAD A->3
+	STORE A=3,	x=LOAD B->2,	y=LOAD A->3,	STORE B=4
+	STORE B=4,	y=LOAD A->1,	STORE A=3,	x=LOAD B->4
+	STORE B=4,	y=LOAD A->1,	x=LOAD B->4,	STORE A=3
+	STORE B=4,	STORE A=3,	x=LOAD B->4,	y=LOAD A->3
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
1.9.1

