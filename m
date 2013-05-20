Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3ETGda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:33:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44327 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3ETGd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:33:28 -0400
From: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Subject: [RFC PATCH 3/6] ARM: RealView: use the core cpu hotplug functions
Date: Mon, 20 May 2013 12:03:25 +0530
Message-Id: <1369031608-27347-4-git-send-email-sanjay.rawat@linaro.org>
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
 arch/arm/mach-realview/hotplug.c |   37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

diff --git a/arch/arm/mach-realview/hotplug.c b/arch/arm/mach-realview/hotplug.c
index ac22dd4..a48cc71 100644
--- a/arch/arm/mach-realview/hotplug.c
+++ b/arch/arm/mach-realview/hotplug.c
@@ -14,42 +14,7 @@
 
 #include <asm/cp15.h>
 #include <asm/smp_plat.h>
-
-static inline void cpu_enter_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-	"	mcr	p15, 0, %1, c7, c5, 0\n"
-	"	mcr	p15, 0, %1, c7, c10, 4\n"
-	/*
-	 * Turn off coherency
-	 */
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	bic	%0, %0, #0x20\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	"	mrc	p15, 0, %0, c1, c0, 0\n"
-	"	bic	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	  : "=&r" (v)
-	  : "r" (0), "Ir" (CR_C)
-	  : "cc");
-}
-
-static inline void cpu_leave_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(	"mrc	p15, 0, %0, c1, c0, 0\n"
-	"	orr	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	orr	%0, %0, #0x20\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	  : "=&r" (v)
-	  : "Ir" (CR_C)
-	  : "cc");
-}
+#include <asm/hotplug.h>
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 {
-- 
1.7.9.5

