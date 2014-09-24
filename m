Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaIXRWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:22:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41720 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576AbaIXRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:45 -0400
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
Subject: [PATCH v3 17/17] asm-generic: io: define relaxed accessor macros unconditionally
Date: Wed, 24 Sep 2014 18:17:36 +0100
Message-Id: <1411579056-16966-18-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that no architectures using asm-generic/io.h define their own relaxed
accessors, the dummy definitions can be used unconditionally.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/asm-generic/io.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 9ccedeb06522..f5611abb82ed 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -53,27 +53,21 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 #endif
 
 #define readb __raw_readb
-#ifndef readb_relaxed
 #define readb_relaxed readb
-#endif
 
 #define readw readw
 static inline u16 readw(const volatile void __iomem *addr)
 {
 	return __le16_to_cpu(__raw_readw(addr));
 }
-#ifndef readw_relaxed
 #define readw_relaxed readw
-#endif
 
 #define readl readl
 static inline u32 readl(const volatile void __iomem *addr)
 {
 	return __le32_to_cpu(__raw_readl(addr));
 }
-#ifndef readl_relaxed
 #define readl_relaxed readl
-#endif
 
 #ifndef __raw_writeb
 static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
@@ -97,19 +91,13 @@ static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 #endif
 
 #define writeb __raw_writeb
-#ifndef writeb_relaxed
 #define writeb_relaxed writeb
-#endif
 
 #define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
-#ifndef writew_relaxed
 #define writew_relaxed writew
-#endif
 
 #define writel(b,addr) __raw_writel(__cpu_to_le32(b),addr)
-#ifndef writel_relaxed
 #define writel_relaxed writel
-#endif
 
 #ifdef CONFIG_64BIT
 #ifndef __raw_readq
@@ -124,9 +112,7 @@ static inline u64 readq(const volatile void __iomem *addr)
 {
 	return __le64_to_cpu(__raw_readq(addr));
 }
-#ifndef readq_relaxed
 #define readq_relaxed readq
-#endif
 
 #ifndef __raw_writeq
 static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
@@ -136,9 +122,7 @@ static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 #endif
 
 #define writeq(b, addr) __raw_writeq(__cpu_to_le64(b), addr)
-#ifndef writeq_relaxed
 #define writeq_relaxed writeq
-#endif
 #endif /* CONFIG_64BIT */
 
 #ifndef PCI_IOBASE
-- 
2.1.0

