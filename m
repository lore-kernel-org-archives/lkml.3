Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbaDQNpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:45:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48833 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbaDQNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:55 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 08/18] ia64: io: implement dummy relaxed accessor macros for writes
Date: Thu, 17 Apr 2014 14:44:11 +0100
Message-Id: <1397742261-15621-9-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to ia64, which may
be able to be optimised in a similar manner to the relaxed read
accessors at a later date.

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/ia64/include/asm/io.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 0d2bcb37ec35..379165154c27 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -393,6 +393,10 @@ __writeq (unsigned long val, volatile void __iomem *addr)
 #define writew(v,a)	__writew((v), (a))
 #define writel(v,a)	__writel((v), (a))
 #define writeq(v,a)	__writeq((v), (a))
+#define writeb_relaxed(v,a)	__writeb((v), (a))
+#define writew_relaxed(v,a)	__writew((v), (a))
+#define writel_relaxed(v,a)	__writel((v), (a))
+#define writeq_relaxed(v,a)	__writeq((v), (a))
 #define __raw_writeb	writeb
 #define __raw_writew	writew
 #define __raw_writel	writel
-- 
1.9.1

