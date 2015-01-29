Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbbA2OwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:52:09 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48189 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbbA2OwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:52:07 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] sparc: io_64.h: Replace io function-link macros
Date: Thu, 29 Jan 2015 15:52:02 +0100
Message-Id: <1422543122-21956-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function like macros cannot be assigned to function pointers. This patch
convert the function-like macros into object-macros, that the
precompiler will replace with the name of the final function.

With this patch this kind of code will work:

if (priv->mode_big_endian)
	priv.read = ioread32be;
else
	priv.read = ioread32;

Same approach has been taken on asm-generic/io.h

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Fixes: 99082eab63449f9d spi/xilinx: Remove iowrite/ioread wrappers
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 arch/sparc/include/asm/io_64.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 9b672be..50d4840 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -407,16 +407,16 @@ static inline void iounmap(volatile void __iomem *addr)
 {
 }
 
-#define ioread8(X)			readb(X)
-#define ioread16(X)			readw(X)
-#define ioread16be(X)			__raw_readw(X)
-#define ioread32(X)			readl(X)
-#define ioread32be(X)			__raw_readl(X)
-#define iowrite8(val,X)			writeb(val,X)
-#define iowrite16(val,X)		writew(val,X)
-#define iowrite16be(val,X)		__raw_writew(val,X)
-#define iowrite32(val,X)		writel(val,X)
-#define iowrite32be(val,X)		__raw_writel(val,X)
+#define ioread8			readb
+#define ioread16		readw
+#define ioread16be		__raw_readw
+#define ioread32		readl
+#define ioread32be		__raw_readl
+#define iowrite8		writeb
+#define iowrite16		writew
+#define iowrite16be		__raw_writew
+#define iowrite32		writel
+#define iowrite32be		__raw_writel
 
 /* Create a virtual mapping cookie for an IO port range */
 void __iomem *ioport_map(unsigned long port, unsigned int nr);
-- 
2.1.4

