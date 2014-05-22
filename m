Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaEVQtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:49:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48917 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbaEVQtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:49:04 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Mikael Starvik <starvik@axis.com>
Subject: [PATCH v2 07/18] cris: io: implement dummy relaxed accessor macros for writes
Date: Thu, 22 May 2014 17:47:19 +0100
Message-Id: <1400777250-17335-8-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to Cris, in the same
vein as the dummy definitions for the relaxed read accessors.

Cc: Mikael Starvik <starvik@axis.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/cris/include/asm/io.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index e59dba12ce94..752a3f45df60 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -112,6 +112,9 @@ static inline void writel(unsigned int b, volatile void __iomem *addr)
 	else
 		*(volatile unsigned int __force *) addr = b;
 }
+#define writeb_relaxed(b, addr) writeb(b, addr)
+#define writew_relaxed(b, addr) writew(b, addr)
+#define writel_relaxed(b, addr) writel(b, addr)
 #define __raw_writeb writeb
 #define __raw_writew writew
 #define __raw_writel writel
-- 
1.9.2

