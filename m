Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3ETGdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:33:35 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:34555 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3ETGdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:33:32 -0400
From: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Subject: [RFC PATCH 4/6] ARM: spear: use the core cpu hotplug functions
Date: Mon, 20 May 2013 12:03:26 +0530
Message-Id: <1369031608-27347-5-git-send-email-sanjay.rawat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369031608-27347-1-git-send-email-sanjay.rawat@linaro.org>
References: <1369031608-27347-1-git-send-email-sanjay.rawat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic arm cpu hotplug related functions are moved to core hotplug code,
remove the functions from the platform code.

Signed-off-by: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
---
 arch/arm/mach-spear/hotplug.c |   37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

diff --git a/arch/arm/mach-spear/hotplug.c b/arch/arm/mach-spear/hotplug.c
index d97749c..988a9a6 100644
--- a/arch/arm/mach-spear/hotplug.c
+++ b/arch/arm/mach-spear/hotplug.c
@@ -15,42 +15,7 @@
 #include <linux/smp.h>
 #include <asm/cp15.h>
 #include <asm/smp_plat.h>
-
-static inline void cpu_enter_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-	"	mcr	p15, 0, %1, c7, c5, 0\n"
-	"	dsb\n"
-	/*
-	 * Turn off coherency
-	 */
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	bic	%0, %0, #0x20\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	"	mrc	p15, 0, %0, c1, c0, 0\n"
-	"	bic	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	: "=&r" (v)
-	: "r" (0), "Ir" (CR_C)
-	: "cc", "memory");
-}
-
-static inline void cpu_leave_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile("mrc	p15, 0, %0, c1, c0, 0\n"
-	"	orr	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	orr	%0, %0, #0x20\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	: "=&r" (v)
-	: "Ir" (CR_C)
-	: "cc");
-}
+#include <asm/hotplug.h>
 
 static inline void spear13xx_do_lowpower(unsigned int cpu, int *spurious)
 {
-- 
1.7.9.5

