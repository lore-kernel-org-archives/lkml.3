Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbaDQNrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:47:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48854 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065AbaDQNpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:45:01 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 15/18] tile: io: implement dummy relaxed accessor macros for writes
Date: Thu, 17 Apr 2014 14:44:18 +0100
Message-Id: <1397742261-15621-16-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to tile, in the
same vein as the dummy definitions for the relaxed read accessors.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/tile/include/asm/io.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index 9fe434969fab..d372641054d9 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -241,6 +241,10 @@ static inline void writeq(u64 val, unsigned long addr)
 #define readw_relaxed readw
 #define readl_relaxed readl
 #define readq_relaxed readq
+#define writeb_relaxed writeb
+#define writew_relaxed writew
+#define writel_relaxed writel
+#define writeq_relaxed writeq
 
 #define ioread8 readb
 #define ioread16 readw
-- 
1.9.1

