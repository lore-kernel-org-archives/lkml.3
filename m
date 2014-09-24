Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaIXRVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:21:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41747 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbaIXRUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:47 -0400
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
Subject: [PATCH v3 11/17] parisc: io: implement dummy relaxed accessor macros for writes
Date: Wed, 24 Sep 2014 18:17:30 +0100
Message-Id: <1411579056-16966-12-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to parisc, in the
same vein as the dummy definitions for the relaxed read accessors.

Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/parisc/include/asm/io.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/include/asm/io.h b/arch/parisc/include/asm/io.h
index 1f6d2ae7aba5..8cd0abf28ffb 100644
--- a/arch/parisc/include/asm/io.h
+++ b/arch/parisc/include/asm/io.h
@@ -217,10 +217,14 @@ static inline void writeq(unsigned long long q, volatile void __iomem *addr)
 #define writel	writel
 #define writeq	writeq
 
-#define readb_relaxed(addr) readb(addr)
-#define readw_relaxed(addr) readw(addr)
-#define readl_relaxed(addr) readl(addr)
-#define readq_relaxed(addr) readq(addr)
+#define readb_relaxed(addr)	readb(addr)
+#define readw_relaxed(addr)	readw(addr)
+#define readl_relaxed(addr)	readl(addr)
+#define readq_relaxed(addr)	readq(addr)
+#define writeb_relaxed(b, addr)	writeb(b, addr)
+#define writew_relaxed(w, addr)	writew(w, addr)
+#define writel_relaxed(l, addr)	writel(l, addr)
+#define writeq_relaxed(q, addr)	writeq(q, addr)
 
 #define mmiowb() do { } while (0)
 
-- 
2.1.0

