Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaIXRUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:20:39 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41657 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbaIXRUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:36 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net,
        cmetcalf@tilera.com, davem@davemloft.net, deller@gmx.de,
        dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com,
        hpa@zytor.com, jcmvbkbc@gmail.com, jesper.nilsson@axis.com,
        mingo@redhat.com, monstr@monstr.eu, paulmck@linux.vnet.ibm.com,
        rdunlap@infradead.org, sam@ravnborg.org, schwidefsky@de.ibm.com,
        starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de,
        tony.luck@intel.com, daniel.thompson@linaro.org, broonie@linaro.org,
        linux@arm.linux.org.uk, Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 10/17] mn10300: io: implement dummy relaxed accessor macros for writes
Date: Wed, 24 Sep 2014 18:17:29 +0100
Message-Id: <1411579056-16966-11-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
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
2.1.0

