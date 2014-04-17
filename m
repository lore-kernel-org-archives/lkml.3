Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaDQNv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:51:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48815 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753367AbaDQNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:55 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 13/18] powerpc: io: implement dummy relaxed accessor macros for writes
Date: Thu, 17 Apr 2014 14:44:16 +0100
Message-Id: <1397742261-15621-14-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to powerpc, in the
same vein as the dummy definitions for the relaxed read accessors.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/powerpc/include/asm/io.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 97d3869991ca..9eaf301ac952 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -617,10 +617,14 @@ static inline void name at					\
 /*
  * We don't do relaxed operations yet, at least not with this semantic
  */
-#define readb_relaxed(addr) readb(addr)
-#define readw_relaxed(addr) readw(addr)
-#define readl_relaxed(addr) readl(addr)
-#define readq_relaxed(addr) readq(addr)
+#define readb_relaxed(addr)	readb(addr)
+#define readw_relaxed(addr)	readw(addr)
+#define readl_relaxed(addr)	readl(addr)
+#define readq_relaxed(addr)	readq(addr)
+#define writeb_relaxed(v, addr)	writeb(v, addr)
+#define writew_relaxed(v, addr)	writew(v, addr)
+#define writel_relaxed(v, addr)	writel(v, addr)
+#define writeq_relaxed(v, addr)	writeq(v, addr)
 
 #ifdef CONFIG_PPC32
 #define mmiowb()
-- 
1.9.1

