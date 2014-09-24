Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaIXRXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:23:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41664 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858AbaIXRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:37 -0400
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
Subject: [PATCH v3 07/17] ia64: io: implement dummy relaxed accessor macros for writes
Date: Wed, 24 Sep 2014 18:17:26 +0100
Message-Id: <1411579056-16966-8-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
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
index bee0acd52f7e..80a7e34be009 100644
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
2.1.0

