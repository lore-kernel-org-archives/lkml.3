Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaGIPMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:12:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44762 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbaGIPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:11:47 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] arm64: Use include/asm-generic/io.h
Date: Wed,  9 Jul 2014 17:11:39 +0200
Message-Id: <1404918699-17284-3-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404918699-17284-1-git-send-email-thierry.reding@gmail.com>
References: <1404918699-17284-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Include the generic I/O header file so that duplicate implementations
can be removed. This will also help to establish consistency across more
architectures regarding which accessors they support.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/Kconfig              |  1 -
 arch/arm64/include/asm/io.h     | 99 ++++-------------------------------------
 arch/arm64/include/asm/memory.h |  2 +
 3 files changed, 11 insertions(+), 91 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a497556520d4..a428ac1573e7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -20,7 +20,6 @@ config ARM64
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_CPU_AUTOPROBE
 	select GENERIC_EARLY_IOREMAP
-	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SCHED_CLOCK
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index e0ecdcf6632d..00c7f9faf2a3 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -34,26 +34,31 @@
 /*
  * Generic IO read/write.  These perform native-endian accesses.
  */
+#define __raw_writeb __raw_writeb
 static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
 {
 	asm volatile("strb %w0, [%1]" : : "r" (val), "r" (addr));
 }
 
+#define __raw_writew __raw_writew
 static inline void __raw_writew(u16 val, volatile void __iomem *addr)
 {
 	asm volatile("strh %w0, [%1]" : : "r" (val), "r" (addr));
 }
 
+#define __raw_writel __raw_writel
 static inline void __raw_writel(u32 val, volatile void __iomem *addr)
 {
 	asm volatile("str %w0, [%1]" : : "r" (val), "r" (addr));
 }
 
+#define __raw_writeq __raw_writeq
 static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
 {
 	asm volatile("str %0, [%1]" : : "r" (val), "r" (addr));
 }
 
+#define __raw_readb __raw_readb
 static inline u8 __raw_readb(const volatile void __iomem *addr)
 {
 	u8 val;
@@ -61,6 +66,7 @@ static inline u8 __raw_readb(const volatile void __iomem *addr)
 	return val;
 }
 
+#define __raw_readw __raw_readw
 static inline u16 __raw_readw(const volatile void __iomem *addr)
 {
 	u16 val;
@@ -68,6 +74,7 @@ static inline u16 __raw_readw(const volatile void __iomem *addr)
 	return val;
 }
 
+#define __raw_readl __raw_readl
 static inline u32 __raw_readl(const volatile void __iomem *addr)
 {
 	u32 val;
@@ -75,6 +82,7 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 	return val;
 }
 
+#define __raw_readq __raw_readq
 static inline u64 __raw_readq(const volatile void __iomem *addr)
 {
 	u64 val;
@@ -124,94 +132,6 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #define IO_SPACE_LIMIT		0xffff
 #define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_32M))
 
-static inline u8 inb(unsigned long addr)
-{
-	return readb(addr + PCI_IOBASE);
-}
-
-static inline u16 inw(unsigned long addr)
-{
-	return readw(addr + PCI_IOBASE);
-}
-
-static inline u32 inl(unsigned long addr)
-{
-	return readl(addr + PCI_IOBASE);
-}
-
-static inline void outb(u8 b, unsigned long addr)
-{
-	writeb(b, addr + PCI_IOBASE);
-}
-
-static inline void outw(u16 b, unsigned long addr)
-{
-	writew(b, addr + PCI_IOBASE);
-}
-
-static inline void outl(u32 b, unsigned long addr)
-{
-	writel(b, addr + PCI_IOBASE);
-}
-
-#define inb_p(addr)	inb(addr)
-#define inw_p(addr)	inw(addr)
-#define inl_p(addr)	inl(addr)
-
-#define outb_p(x, addr)	outb((x), (addr))
-#define outw_p(x, addr)	outw((x), (addr))
-#define outl_p(x, addr)	outl((x), (addr))
-
-static inline void insb(unsigned long addr, void *buffer, int count)
-{
-	u8 *buf = buffer;
-	while (count--)
-		*buf++ = __raw_readb(addr + PCI_IOBASE);
-}
-
-static inline void insw(unsigned long addr, void *buffer, int count)
-{
-	u16 *buf = buffer;
-	while (count--)
-		*buf++ = __raw_readw(addr + PCI_IOBASE);
-}
-
-static inline void insl(unsigned long addr, void *buffer, int count)
-{
-	u32 *buf = buffer;
-	while (count--)
-		*buf++ = __raw_readl(addr + PCI_IOBASE);
-}
-
-static inline void outsb(unsigned long addr, const void *buffer, int count)
-{
-	const u8 *buf = buffer;
-	while (count--)
-		__raw_writeb(*buf++, addr + PCI_IOBASE);
-}
-
-static inline void outsw(unsigned long addr, const void *buffer, int count)
-{
-	const u16 *buf = buffer;
-	while (count--)
-		__raw_writew(*buf++, addr + PCI_IOBASE);
-}
-
-static inline void outsl(unsigned long addr, const void *buffer, int count)
-{
-	const u32 *buf = buffer;
-	while (count--)
-		__raw_writel(*buf++, addr + PCI_IOBASE);
-}
-
-#define insb_p(port,to,len)	insb(port,to,len)
-#define insw_p(port,to,len)	insw(port,to,len)
-#define insl_p(port,to,len)	insl(port,to,len)
-
-#define outsb_p(port,from,len)	outsb(port,from,len)
-#define outsw_p(port,from,len)	outsw(port,from,len)
-#define outsl_p(port,from,len)	outsl(port,from,len)
-
 /*
  * String version of I/O memory access operations.
  */
@@ -235,8 +155,7 @@ extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
 #define ioremap_wc(addr, size)		__ioremap((addr), (size), __pgprot(PROT_NORMAL_NC))
 #define iounmap				__iounmap
 
-#define ARCH_HAS_IOREMAP_WC
-#include <asm-generic/iomap.h>
+#include <asm-generic/io.h>
 
 /*
  * More restrictive address range checking than the default implementation
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 993bce527b85..ca6116de3155 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -122,11 +122,13 @@ extern phys_addr_t		memstart_addr;
  * translation for translating DMA addresses.  Use the driver
  * DMA support - see dma-mapping.h.
  */
+#define virt_to_phys virt_to_phys
 static inline phys_addr_t virt_to_phys(const volatile void *x)
 {
 	return __virt_to_phys((unsigned long)(x));
 }
 
+#define phys_to_virt phys_to_virt
 static inline void *phys_to_virt(phys_addr_t x)
 {
 	return (void *)(__phys_to_virt(x));
-- 
2.0.1

