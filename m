Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaFEUoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:44:16 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61280 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaFEUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:44:13 -0400
Date: Thu, 5 Jun 2014 23:44:11 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: [PATCH] doc: fix important typo re memory barriers
Message-ID: <20140605204410.GA26217@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Examples introducing neccesity of RMB+WMP pair reads as

	A=3	READ B
	www	rrrrrr
	B=4	READ A

Note the opposite order of reads vs writes.

But the first example without barriers reads as

	A=3	READ A
	B=4	READ B

There are 4 outcomes in the first example.
But if someone new to the concept tries to insert barriers like this:

	A=3	READ A
	www	rrrrrr
	B=4	READ B

he will still get all 4 possible outcomes, because "READ A" is first.

All this can be utterly confusing because barrier pair seems to be
superfluous. In short, fixup first example to match latter examples
with barriers.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Documentation/memory-barriers.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -115,8 +115,8 @@ For example, consider the following sequence of events:
 	CPU 1		CPU 2
 	===============	===============
 	{ A == 1; B == 2 }
-	A = 3;		x = A;
-	B = 4;		y = B;
+	A = 3;		x = B;
+	B = 4;		y = A;
 
 The set of accesses as seen by the memory system in the middle can be arranged
 in 24 different combinations:
