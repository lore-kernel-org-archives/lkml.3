Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968182Ab3DSLZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 07:25:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63776 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968097Ab3DSLZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 07:25:29 -0400
X-Spam-Score: -100.8
Message-ID: <51712975.8030104@asianux.com>
Date: Fri, 19 Apr 2013 19:24:37 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM64: kernel: compiling issue: need define readq and writeq
 for driver module using.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  when compiling with allmodconfig, CONFIG_64BIT=y
    the file drivers/base/regmap/regmap-mmio.c will use readq and writeq.

  so we need implement these functions.

BTW:
  the coding style can not pass ./scripts/checkpatch.pl.
  it seems better to provide additional patch for beautifying code.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/include/asm/io.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 57f12c9..2e12258 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -92,10 +92,12 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #define readb_relaxed(c)	({ u8  __v = __raw_readb(c); __v; })
 #define readw_relaxed(c)	({ u16 __v = le16_to_cpu((__force __le16)__raw_readw(c)); __v; })
 #define readl_relaxed(c)	({ u32 __v = le32_to_cpu((__force __le32)__raw_readl(c)); __v; })
+#define readq_relaxed(c)	({ u64 __v = le64_to_cpu((__force __le64)__raw_readq(c)); __v; })
 
 #define writeb_relaxed(v,c)	((void)__raw_writeb((v),(c)))
 #define writew_relaxed(v,c)	((void)__raw_writew((__force u16)cpu_to_le16(v),(c)))
 #define writel_relaxed(v,c)	((void)__raw_writel((__force u32)cpu_to_le32(v),(c)))
+#define writeq_relaxed(v,c)	((void)__raw_writeq((__force u64)cpu_to_le64(v),(c)))
 
 /*
  * I/O memory access primitives. Reads are ordered relative to any
@@ -105,10 +107,12 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #define readb(c)		({ u8  __v = readb_relaxed(c); __iormb(); __v; })
 #define readw(c)		({ u16 __v = readw_relaxed(c); __iormb(); __v; })
 #define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(); __v; })
+#define readq(c)		({ u64 __v = readq_relaxed(c); __iormb(); __v; })
 
 #define writeb(v,c)		({ __iowmb(); writeb_relaxed((v),(c)); })
 #define writew(v,c)		({ __iowmb(); writew_relaxed((v),(c)); })
 #define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c)); })
+#define writeq(v,c)		({ __iowmb(); writeq_relaxed((v),(c)); })
 
 /*
  *  I/O port access primitives.
-- 
1.7.7.6
