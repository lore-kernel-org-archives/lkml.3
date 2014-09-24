Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaIXRUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:20:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41682 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbaIXRUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:40 -0400
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
Subject: [PATCH v3 08/17] m32r: io: implement dummy relaxed accessor macros for writes
Date: Wed, 24 Sep 2014 18:17:27 +0100
Message-Id: <1411579056-16966-9-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to m32r, in the
same vein as the dummy definitions for the relaxed read accessors.

Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/m32r/include/asm/io.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index 4010f1fc5b65..6e7787f3dac7 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -161,6 +161,9 @@ static inline void _writel(unsigned long l, unsigned long addr)
 #define __raw_writeb writeb
 #define __raw_writew writew
 #define __raw_writel writel
+#define writeb_relaxed writeb
+#define writew_relaxed writew
+#define writel_relaxed writel
 
 #define ioread8 read
 #define ioread16 readw
-- 
2.1.0

