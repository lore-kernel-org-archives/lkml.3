Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbaGCOUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:20:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50996 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758500AbaGCOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:32 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 16/18] AT91: Remove rstc and shdwnc global base addresses
Date: Thu,  3 Jul 2014 16:15:02 +0200
Message-Id: <1404396906-25194-30-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there's no user left for the global variables holding the reset and
shutdown controllers base address, we can remove these variables and their
associated mapping function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9260.c |  2 --
 arch/arm/mach-at91/at91sam9261.c |  2 --
 arch/arm/mach-at91/at91sam9263.c |  2 --
 arch/arm/mach-at91/at91sam9g45.c |  2 --
 arch/arm/mach-at91/at91sam9rl.c  |  2 --
 arch/arm/mach-at91/generic.h     |  6 ------
 arch/arm/mach-at91/setup.c       | 18 ------------------
 7 files changed, 34 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 5fa1986be2aa..16dd13800b1f 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -339,8 +339,6 @@ static void __init at91sam9260_map_io(void)
 
 static void __init at91sam9260_ioremap_registers(void)
 {
-	at91_ioremap_shdwc(AT91SAM9260_BASE_SHDWC);
-	at91_ioremap_rstc(AT91SAM9260_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9260_BASE_SDRAMC, 512);
 	at91sam926x_ioremap_pit(AT91SAM9260_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9260_BASE_SMC);
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 5ccc67235e7a..2c8553e63785 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -302,8 +302,6 @@ static void __init at91sam9261_map_io(void)
 
 static void __init at91sam9261_ioremap_registers(void)
 {
-	at91_ioremap_shdwc(AT91SAM9261_BASE_SHDWC);
-	at91_ioremap_rstc(AT91SAM9261_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9261_BASE_SDRAMC, 512);
 	at91sam926x_ioremap_pit(AT91SAM9261_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9261_BASE_SMC);
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 4d28c3479d4b..63a47c7d7f2b 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -317,8 +317,6 @@ static void __init at91sam9263_map_io(void)
 
 static void __init at91sam9263_ioremap_registers(void)
 {
-	at91_ioremap_shdwc(AT91SAM9263_BASE_SHDWC);
-	at91_ioremap_rstc(AT91SAM9263_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9263_BASE_SDRAMC0, 512);
 	at91_ioremap_ramc(1, AT91SAM9263_BASE_SDRAMC1, 512);
 	at91sam926x_ioremap_pit(AT91SAM9263_BASE_PIT);
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 22034c96d488..f0b78923da75 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -367,8 +367,6 @@ static void __init at91sam9g45_map_io(void)
 
 static void __init at91sam9g45_ioremap_registers(void)
 {
-	at91_ioremap_shdwc(AT91SAM9G45_BASE_SHDWC);
-	at91_ioremap_rstc(AT91SAM9G45_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9G45_BASE_DDRSDRC1, 512);
 	at91_ioremap_ramc(1, AT91SAM9G45_BASE_DDRSDRC0, 512);
 	at91sam926x_ioremap_pit(AT91SAM9G45_BASE_PIT);
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 323a9f90931a..ea9ac0ee0895 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -311,8 +311,6 @@ static void __init at91sam9rl_map_io(void)
 
 static void __init at91sam9rl_ioremap_registers(void)
 {
-	at91_ioremap_shdwc(AT91SAM9RL_BASE_SHDWC);
-	at91_ioremap_rstc(AT91SAM9RL_BASE_RSTC);
 	at91_ioremap_ramc(0, AT91SAM9RL_BASE_SDRAMC, 512);
 	at91sam926x_ioremap_pit(AT91SAM9RL_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9RL_BASE_SMC);
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 5d5e55237c41..f42b0490ad98 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -64,12 +64,6 @@ extern void at91_irq_resume(void);
 /* idle */
 extern void at91sam9_idle(void);
 
-/* reset */
-extern void at91_ioremap_rstc(u32 base_addr);
-
-/* shutdown */
-extern void at91_ioremap_shdwc(u32 base_addr);
-
 /* Matrix */
 extern void at91_ioremap_matrix(u32 base_addr);
 
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 7124b0334bb1..fd3b6f0dd50d 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -319,24 +319,6 @@ void __init at91_map_io(void)
 		at91_boot_soc.map_io();
 }
 
-void __iomem *at91_shdwc_base = NULL;
-
-void __init at91_ioremap_shdwc(u32 base_addr)
-{
-	at91_shdwc_base = ioremap(base_addr, 16);
-	if (!at91_shdwc_base)
-		panic(pr_fmt("Impossible to ioremap at91_shdwc_base\n"));
-}
-
-void __iomem *at91_rstc_base;
-
-void __init at91_ioremap_rstc(u32 base_addr)
-{
-	at91_rstc_base = ioremap(base_addr, 16);
-	if (!at91_rstc_base)
-		panic(pr_fmt("Impossible to ioremap at91_rstc_base\n"));
-}
-
 void __iomem *at91_matrix_base;
 EXPORT_SYMBOL_GPL(at91_matrix_base);
 
-- 
2.0.1

