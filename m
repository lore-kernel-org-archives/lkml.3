Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaDQNpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:45:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48837 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbaDQNo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:44:56 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 16/18] x86: io: implement dummy relaxed accessor macros for writes
Date: Thu, 17 Apr 2014 14:44:19 +0100
Message-Id: <1397742261-15621-17-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to x86, in the
same vein as the dummy definitions for the relaxed read accessors.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/x86/include/asm/io.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index b8237d8a1e0c..2ea07f5ec7b7 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -74,6 +74,9 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
 #define __raw_readw __readw
 #define __raw_readl __readl
 
+#define writeb_relaxed(v, a) __writeb(v, a)
+#define writew_relaxed(v, a) __writew(v, a)
+#define writel_relaxed(v, a) __writel(v, a)
 #define __raw_writeb __writeb
 #define __raw_writew __writew
 #define __raw_writel __writel
@@ -86,6 +89,7 @@ build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
 build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
 
 #define readq_relaxed(a)	readq(a)
+#define writeq_relaxed(v, a)	writeq(v, a)
 
 #define __raw_readq(a)		readq(a)
 #define __raw_writeq(val, addr)	writeq(val, addr)
-- 
1.9.1

