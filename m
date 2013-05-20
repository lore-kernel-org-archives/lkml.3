Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3ETGe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:34:28 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:48246 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3ETGdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:33:24 -0400
From: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Subject: [RFC PATCH 2/6] ARM: imx: use the core cpu hotplug functions
Date: Mon, 20 May 2013 12:03:24 +0530
Message-Id: <1369031608-27347-3-git-send-email-sanjay.rawat@linaro.org>
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
 arch/arm/mach-imx/hotplug.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/arch/arm/mach-imx/hotplug.c b/arch/arm/mach-imx/hotplug.c
index 3daf1ed..280c6f3 100644
--- a/arch/arm/mach-imx/hotplug.c
+++ b/arch/arm/mach-imx/hotplug.c
@@ -14,30 +14,10 @@
 #include <linux/jiffies.h>
 #include <asm/cp15.h>
 #include <asm/proc-fns.h>
+#include <asm/hotplug.h>
 
 #include "common.h"
 
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
 /*
  * platform-specific code to shutdown a CPU
  *
-- 
1.7.9.5

