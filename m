Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbaDQNp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:45:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48891 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbaDQNpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:45:25 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 14/18] sparc: io: implement dummy relaxed accessor macros for writes
Date: Thu, 17 Apr 2014 14:44:17 +0100
Message-Id: <1397742261-15621-15-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to sparc, in the
same vein as the dummy definitions for the relaxed read accessors. The
existing relaxed read{b,w,l} accessors are moved into asm/io.h, since
they are identical between 32-bit and 64-bit machines.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/sparc/include/asm/io.h    |  9 +++++++++
 arch/sparc/include/asm/io_32.h |  3 ---
 arch/sparc/include/asm/io_64.h | 22 ++++++++++------------
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
index f6902cf3cbe9..493f22c4684f 100644
--- a/arch/sparc/include/asm/io.h
+++ b/arch/sparc/include/asm/io.h
@@ -10,6 +10,15 @@
  * Defines used for both SPARC32 and SPARC64
  */
 
+/* Relaxed accessors for MMIO */
+#define readb_relaxed(__addr)		readb(__addr)
+#define readw_relaxed(__addr)		readw(__addr)
+#define readl_relaxed(__addr)		readl(__addr)
+
+#define writeb_relaxed(__b, __addr)	writeb(__b, __addr)
+#define writew_relaxed(__w, __addr)	writew(__w, __addr)
+#define writel_relaxed(__l, __addr)	writel(__l, __addr)
+
 /* Big endian versions of memory read/write routines */
 #define readb_be(__addr)	__raw_readb(__addr)
 #define readw_be(__addr)	__raw_readw(__addr)
diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index c1acbd891cbc..41d33e567f1d 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -89,9 +89,6 @@ static inline void __writel(u32 l, volatile void __iomem *addr)
 #define readb(__addr)		__readb(__addr)
 #define readw(__addr)		__readw(__addr)
 #define readl(__addr)		__readl(__addr)
-#define readb_relaxed(__addr)	readb(__addr)
-#define readw_relaxed(__addr)	readw(__addr)
-#define readl_relaxed(__addr)	readl(__addr)
 
 #define writeb(__b, __addr)	__writeb((__b),(__addr))
 #define writew(__w, __addr)	__writew((__w),(__addr))
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 09b0b88aeb2a..2b4cd52831d0 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -203,18 +203,16 @@ static inline void _writeq(u64 q, volatile void __iomem *addr)
 			     : "memory");
 }
 
-#define readb(__addr)		_readb(__addr)
-#define readw(__addr)		_readw(__addr)
-#define readl(__addr)		_readl(__addr)
-#define readq(__addr)		_readq(__addr)
-#define readb_relaxed(__addr)	_readb(__addr)
-#define readw_relaxed(__addr)	_readw(__addr)
-#define readl_relaxed(__addr)	_readl(__addr)
-#define readq_relaxed(__addr)	_readq(__addr)
-#define writeb(__b, __addr)	_writeb(__b, __addr)
-#define writew(__w, __addr)	_writew(__w, __addr)
-#define writel(__l, __addr)	_writel(__l, __addr)
-#define writeq(__q, __addr)	_writeq(__q, __addr)
+#define readb(__addr)			_readb(__addr)
+#define readw(__addr)			_readw(__addr)
+#define readl(__addr)			_readl(__addr)
+#define readq(__addr)			_readq(__addr)
+#define readq_relaxed(__addr)		_readq(__addr)
+#define writeb(__b, __addr)		_writeb(__b, __addr)
+#define writew(__w, __addr)		_writew(__w, __addr)
+#define writel(__l, __addr)		_writel(__l, __addr)
+#define writeq(__q, __addr)		_writeq(__q, __addr)
+#define writeq_relaxed(__q, __addr)	_writeq(__q, __addr)
 
 /* Now versions without byte-swapping. */
 static inline u8 _raw_readb(unsigned long addr)
-- 
1.9.1

