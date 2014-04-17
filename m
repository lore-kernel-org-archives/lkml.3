Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaDQOpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:45:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51362 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbaDQOp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:45:27 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 05/18] alpha: io: implement relaxed accessor macros for writes
Date: Thu, 17 Apr 2014 14:44:08 +0100
Message-Id: <1397742261-15621-6-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O writes with weaker barrier semantics than the
non-relaxed variants.

This patch implements these write macros for Alpha, in the same vein as
the relaxed read macros, which are already implemented.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/alpha/include/asm/io.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index 5ebab5895edb..f05bdb4b1cb9 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -500,10 +500,14 @@ extern inline void writeq(u64 b, volatile void __iomem *addr)
 #define outb_p		outb
 #define outw_p		outw
 #define outl_p		outl
-#define readb_relaxed(addr) __raw_readb(addr)
-#define readw_relaxed(addr) __raw_readw(addr)
-#define readl_relaxed(addr) __raw_readl(addr)
-#define readq_relaxed(addr) __raw_readq(addr)
+#define readb_relaxed(addr)	__raw_readb(addr)
+#define readw_relaxed(addr)	__raw_readw(addr)
+#define readl_relaxed(addr)	__raw_readl(addr)
+#define readq_relaxed(addr)	__raw_readq(addr)
+#define writeb_relaxed(b, addr)	__raw_writeb(b, addr)
+#define writew_relaxed(b, addr)	__raw_writew(b, addr)
+#define writel_relaxed(b, addr)	__raw_writel(b, addr)
+#define writeq_relaxed(b, addr)	__raw_writeq(b, addr)
 
 #define mmiowb()
 
-- 
1.9.1

