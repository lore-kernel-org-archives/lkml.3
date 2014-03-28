Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaC1VP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:15:57 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45385 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaC1VMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:12:44 -0400
From: Alex Elder <elder@linaro.org>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, viresh.linux@gmail.com,
        shiraz.hashim@gmail.com, catalin.marinas@arm.com
Cc: spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/7] ARM: allow <asm/cputype.h> inclusion from assembly
Date: Fri, 28 Mar 2014 16:12:54 -0500
Message-Id: <1396041180-29897-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396041180-29897-1-git-send-email-elder@linaro.org>
References: <1396041180-29897-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conditionally exclude some portions of ARM <asm/cputype.h>
to allow that file to be included from assembly source.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/include/asm/cputype.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index acdde76..a74c671 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -2,7 +2,9 @@
 #define __ASM_ARM_CPUTYPE_H
 
 #include <linux/stringify.h>
+#ifndef __ASSEMBLY__
 #include <linux/kernel.h>
+#endif
 
 #define CPUID_ID	0
 #define CPUID_CACHETYPE	1
@@ -77,6 +79,7 @@
 #define ARM_CPU_XSCALE_ARCH_V2		0x4000
 #define ARM_CPU_XSCALE_ARCH_V3		0x6000
 
+#ifndef __ASSEMBLY__
 extern unsigned int processor_id;
 
 #ifdef CONFIG_CPU_CP15
@@ -219,5 +222,6 @@ static inline int cpu_is_xsc3(void)
 #else
 #define	cpu_is_xscale()	1
 #endif
+#endif /* !__ASSEMBLY__ */
 
 #endif
-- 
1.7.9.5

