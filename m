Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935275AbaGYAwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:52:12 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37808 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934900AbaGYAwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:52:08 -0400
From: Matt Turner <mattst88@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 2/2] alpha: io: implement relaxed accessor macros for writes
Date: Thu, 24 Jul 2014 17:53:54 -0700
Message-Id: <1406249634-27136-2-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406249634-27136-1-git-send-email-mattst88@gmail.com>
References: <1406249634-27136-1-git-send-email-mattst88@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O writes with weaker barrier semantics than the
non-relaxed variants.

This patch implements these write macros for Alpha, in the same vein as
the relaxed read macros, which are already implemented.

Acked-by: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/include/asm/io.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index 5ebab58..f05bdb4 100644
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
1.8.5.5

