Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaDQNwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:52:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48826 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbaDQNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:55 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 10/18] m68k: io: implement dummy relaxed accessor macros for writes
Date: Thu, 17 Apr 2014 14:44:13 +0100
Message-Id: <1397742261-15621-11-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to m68k, in the
same vein as the dummy definitions for the relaxed read accessors.
Additionally, the existing relaxed read accessors are moved into
asm/io.h, so that they can be used by m68k targets with an MMU.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/m68k/include/asm/io.h    | 8 ++++++++
 arch/m68k/include/asm/io_no.h | 4 ----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/include/asm/io.h b/arch/m68k/include/asm/io.h
index c70cc9155003..bccd5a914eb6 100644
--- a/arch/m68k/include/asm/io.h
+++ b/arch/m68k/include/asm/io.h
@@ -3,3 +3,11 @@
 #else
 #include <asm/io_mm.h>
 #endif
+
+#define readb_relaxed(addr)	readb(addr)
+#define readw_relaxed(addr)	readw(addr)
+#define readl_relaxed(addr)	readl(addr)
+
+#define writeb_relaxed(b, addr)	writeb(b, addr)
+#define writew_relaxed(b, addr)	writew(b, addr)
+#define writel_relaxed(b, addr)	writel(b, addr)
diff --git a/arch/m68k/include/asm/io_no.h b/arch/m68k/include/asm/io_no.h
index 52f7e8499172..19c237c63dc2 100644
--- a/arch/m68k/include/asm/io_no.h
+++ b/arch/m68k/include/asm/io_no.h
@@ -40,10 +40,6 @@ static inline unsigned int _swapl(volatile unsigned long v)
 #define readl(addr) \
     ({ unsigned int __v = (*(volatile unsigned int *) (addr)); __v; })
 
-#define readb_relaxed(addr) readb(addr)
-#define readw_relaxed(addr) readw(addr)
-#define readl_relaxed(addr) readl(addr)
-
 #define writeb(b,addr) (void)((*(volatile unsigned char *) (addr)) = (b))
 #define writew(b,addr) (void)((*(volatile unsigned short *) (addr)) = (b))
 #define writel(b,addr) (void)((*(volatile unsigned int *) (addr)) = (b))
-- 
1.9.1

