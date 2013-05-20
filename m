Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3ETGdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:33:38 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:44276 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3ETGdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:33:36 -0400
From: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Subject: [RFC PATCH 5/6] ARM: vexpress: use the core cpu hotplug functions
Date: Mon, 20 May 2013 12:03:27 +0530
Message-Id: <1369031608-27347-6-git-send-email-sanjay.rawat@linaro.org>
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
 arch/arm/mach-vexpress/hotplug.c |   38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/arch/arm/mach-vexpress/hotplug.c b/arch/arm/mach-vexpress/hotplug.c
index f0ce6b8..cca1361 100644
--- a/arch/arm/mach-vexpress/hotplug.c
+++ b/arch/arm/mach-vexpress/hotplug.c
@@ -14,43 +14,7 @@
 
 #include <asm/smp_plat.h>
 #include <asm/cp15.h>
-
-static inline void cpu_enter_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-		"mcr	p15, 0, %1, c7, c5, 0\n"
-	"	mcr	p15, 0, %1, c7, c10, 4\n"
-	/*
-	 * Turn off coherency
-	 */
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	bic	%0, %0, %3\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	"	mrc	p15, 0, %0, c1, c0, 0\n"
-	"	bic	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	  : "=&r" (v)
-	  : "r" (0), "Ir" (CR_C), "Ir" (0x40)
-	  : "cc");
-}
-
-static inline void cpu_leave_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-		"mrc	p15, 0, %0, c1, c0, 0\n"
-	"	orr	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	orr	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	  : "=&r" (v)
-	  : "Ir" (CR_C), "Ir" (0x40)
-	  : "cc");
-}
+#include <asm/hotplug.h>
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 {
-- 
1.7.9.5

