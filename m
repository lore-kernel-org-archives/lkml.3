Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaHWGKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 02:10:44 -0400
Received: from blu004-omc4s33.hotmail.com ([65.55.111.172]:49665 "EHLO
	BLU004-OMC4S33.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbaHWGKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 02:10:42 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Aug 2014 02:10:42 EDT
X-TMN: [B8an5Ah4CUEQTEQW5J+pvbMOr97XnCKk]
X-Originating-Email: [ganesh.rapolu@hotmail.com]
Message-ID: <BLU436-SMTP214DCCF4135E3E81A493210E2D10@phx.gbl>
From: Ganesh Rapolu <ganesh.rapolu@hotmail.com>
To: rdunlap@infradead.org
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ganesh Rapolu <ganesh.rapolu@hotmail.com>
Subject: [PATCH] DOCUMENTATION: Fixed typo in an example in memory-barriers.txt
Date: Fri, 22 Aug 2014 23:05:08 -0700
X-Mailer: git-send-email 2.1.0
X-OriginalArrivalTime: 23 Aug 2014 06:05:34.0638 (UTC) FILETIME=[40AC64E0:01CFBE98]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the first example in the memory-barriers.txt file, CPU 2 is assigned to
run (x = B; y = A;). However, the rest of the example proceeds as if CPU 2 had been
running (x = A; y = B;) as shown by the descriptions of the possible executions:

	STORE A=3,	STORE B=4,	x=LOAD A->3,	y=LOAD B->4
	STORE A=3,	STORE B=4,	y=LOAD B->4,	x=LOAD A->3
	STORE A=3,	x=LOAD A->3,	STORE B=4,	y=LOAD B->4
	STORE A=3,	x=LOAD A->3,	y=LOAD B->2,	STORE B=4
	STORE A=3,	y=LOAD B->2,	STORE B=4,	x=LOAD A->3
	STORE A=3,	y=LOAD B->2,	x=LOAD A->3,	STORE B=4
	STORE B=4,	STORE A=3,	x=LOAD A->3,	y=LOAD B->4
	STORE B=4, ...
	...

The change was merely to make the inital evironment consistent with what happens in the
rest of the example.

Signed-off-by: Ganesh Rapolu <ganesh.rapolu@hotmail.com>
---
 Documentation/memory-barriers.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a4de88f..9a46bbe 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -115,8 +115,8 @@ For example, consider the following sequence of events:
 	CPU 1		CPU 2
 	===============	===============
 	{ A == 1; B == 2 }
-	A = 3;		x = B;
-	B = 4;		y = A;
+	A = 3;		x = A;
+	B = 4;		y = B;
 
 The set of accesses as seen by the memory system in the middle can be arranged
 in 24 different combinations:
-- 
2.0.4

