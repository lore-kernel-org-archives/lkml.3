Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaDQNwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:52:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48810 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbaDQNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:55 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 06/18] frv: io: implement dummy relaxed accessor macros for writes
Date: Thu, 17 Apr 2014 14:44:09 +0100
Message-Id: <1397742261-15621-7-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to frv, in the same
vein as the dummy definitions for the relaxed read accessors.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/frv/include/asm/io.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/frv/include/asm/io.h b/arch/frv/include/asm/io.h
index 8cb50a2fbcb2..99bb7efaf9b7 100644
--- a/arch/frv/include/asm/io.h
+++ b/arch/frv/include/asm/io.h
@@ -243,6 +243,9 @@ static inline void writel(uint32_t datum, volatile void __iomem *addr)
 		__flush_PCI_writes();
 }
 
+#define writeb_relaxed writeb
+#define writew_relaxed writew
+#define writel_relaxed writel
 
 /* Values for nocacheflag and cmode */
 #define IOMAP_FULL_CACHING		0
-- 
1.9.1

