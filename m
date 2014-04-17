Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaDQNtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:49:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48814 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbaDQNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:55 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 18/18] asm-generic: io: define relaxed accessor macros unconditionally
Date: Thu, 17 Apr 2014 14:44:21 +0100
Message-Id: <1397742261-15621-19-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that no architectures using asm-generic/io.h define their own relaxed
accessors, the dummy definitions can be used unconditionally.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/asm-generic/io.h | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 6a93889aeb0d..ad80cab2a758 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -53,23 +53,17 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 #endif
 
 #define readb		__raw_readb
-#ifndef readb_relaxed
 #define readb_relaxed	readb
-#endif
 
 #define readw		readw
-#ifndef readw_relaxed
 #define readw_relaxed	readw
-#endif
 static inline u16 readw(const volatile void __iomem *addr)
 {
 	return __le16_to_cpu(__raw_readw(addr));
 }
 
 #define readl		readl
-#ifndef readl_relaxed
 #define readl_relaxed	readl
-#endif
 static inline u32 readl(const volatile void __iomem *addr)
 {
 	return __le32_to_cpu(__raw_readl(addr));
@@ -100,17 +94,9 @@ static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 #define writew(b,addr)	__raw_writew(__cpu_to_le16(b),addr)
 #define writel(b,addr)	__raw_writel(__cpu_to_le32(b),addr)
 
-#ifndef writeb_relaxed
 #define writeb_relaxed	writeb
-#endif
-
-#ifndef writew_relaxed
 #define writew_relaxed	writew
-#endif
-
-#ifndef writel_relaxed
 #define writel_relaxed	writel
-#endif
 
 #ifdef CONFIG_64BIT
 #ifndef __raw_readq
@@ -121,9 +107,7 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #endif
 
 #define readq		readq
-#ifndef readq_relaxed
 #define readq_relaxed	readq
-#endif
 static inline u64 readq(const volatile void __iomem *addr)
 {
 	return __le64_to_cpu(__raw_readq(addr));
@@ -137,9 +121,7 @@ static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 #endif
 
 #define writeq(b, addr) __raw_writeq(__cpu_to_le64(b), addr)
-#ifndef writeq_relaxed
 #define writeq_relaxed	writeq
-#endif
 #endif /* CONFIG_64BIT */
 
 #ifndef PCI_IOBASE
-- 
1.9.1

