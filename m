Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaIXRUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:20:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41727 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619AbaIXRUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:46 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net,
        cmetcalf@tilera.com, davem@davemloft.net, deller@gmx.de,
        dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com,
        hpa@zytor.com, jcmvbkbc@gmail.com, jesper.nilsson@axis.com,
        mingo@redhat.com, monstr@monstr.eu, paulmck@linux.vnet.ibm.com,
        rdunlap@infradead.org, sam@ravnborg.org, schwidefsky@de.ibm.com,
        starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de,
        tony.luck@intel.com, daniel.thompson@linaro.org, broonie@linaro.org,
        linux@arm.linux.org.uk, Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 16/17] documentation: memory-barriers: clarify relaxed io accessor semantics
Date: Wed, 24 Sep 2014 18:17:35 +0100
Message-Id: <1411579056-16966-17-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
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
index a4de88fb55f0..6b2b4d735a5b 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -2461,10 +2461,15 @@ functions:
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
2.1.0

