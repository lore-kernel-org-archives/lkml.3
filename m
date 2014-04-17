Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbaDQNt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:49:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48813 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbaDQNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:55 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 11/18] mn10300: io: implement dummy relaxed accessor macros for writes
Date: Thu, 17 Apr 2014 14:44:14 +0100
Message-Id: <1397742261-15621-12-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to mn10300, in the
same vein as the dummy definitions for the relaxed read accessors.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/mn10300/include/asm/io.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mn10300/include/asm/io.h b/arch/mn10300/include/asm/io.h
index e6ed0d897ccc..897ba3c12b32 100644
--- a/arch/mn10300/include/asm/io.h
+++ b/arch/mn10300/include/asm/io.h
@@ -67,6 +67,10 @@ static inline void writel(u32 b, volatile void __iomem *addr)
 #define __raw_writew writew
 #define __raw_writel writel
 
+#define writeb_relaxed writeb
+#define writew_relaxed writew
+#define writel_relaxed writel
+
 /*****************************************************************************/
 /*
  * traditional input/output functions
-- 
1.9.1

