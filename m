Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbaDQNpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:45:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48834 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbaDQNo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:56 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 17/18] documentation: memory-barriers: clarify relaxed io accessor semantics
Date: Thu, 17 Apr 2014 14:44:20 +0100
Message-Id: <1397742261-15621-18-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the paragraph describing the relaxed read io accessors
so that the relaxed accessors are defined to be:

 - Ordered with respect to each other if accessing the same peripheral

 - Unordered with respect to normal memory accesses

 - Unordered with respect to LOCK/UNLOCK operations

Whilst many architectures will provide stricter semantics, ARM, Alpha and
PPC can achieve significant performance gains by taking advantage of some
or all of the above relaxations.

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 Documentation/memory-barriers.txt | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 556f951f8626..f31c88691ee9 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -2462,10 +2462,15 @@ functions:
      Please refer to the PCI specification for more information on interactions
      between PCI transactions.
 
- (*) readX_relaxed()
-
-     These are similar to readX(), but are not guaranteed to be ordered in any
-     way. Be aware that there is no I/O read barrier available.
+ (*) readX_relaxed(), writeX_relaxed()
+
+     These are similar to readX() and writeX(), but provide weaker memory
+     ordering guarantees. Specifically, they do not guarantee ordering with
+     respect to normal memory accesses (e.g. DMA buffers) nor do they guarantee
+     ordering with respect to LOCK or UNLOCK operations. If the latter is
+     required, an mmiowb() barrier can be used. Note that relaxed accesses to
+     the same peripheral are guaranteed to be ordered with respect to each
+     other.
 
  (*) ioreadX(), iowriteX()
 
-- 
1.9.1

