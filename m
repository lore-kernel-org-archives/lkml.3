Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbbALVYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:24:16 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58010 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbbALVYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:24:11 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/6] ARM: at91: remove useless map_io
Date: Mon, 12 Jan 2015 22:23:42 +0100
Message-Id: <1421097825-396-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the SRAM is initialized by the mmio-sram driver, .map_io is useless.
remove it.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91rm9200.c  |  6 ------
 arch/arm/mach-at91/at91sam9260.c | 27 ---------------------------
 arch/arm/mach-at91/at91sam9261.c |  9 ---------
 arch/arm/mach-at91/at91sam9263.c |  7 -------
 arch/arm/mach-at91/at91sam9g45.c |  7 -------
 arch/arm/mach-at91/at91sam9n12.c |  6 ------
 arch/arm/mach-at91/at91sam9rl.c  | 18 ------------------
 arch/arm/mach-at91/at91sam9x5.c  |  6 ------
 arch/arm/mach-at91/sama5d3.c     |  6 ------
 9 files changed, 92 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index b52916947535..fc7c26138037 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -42,11 +42,6 @@ static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
 /* --------------------------------------------------------------------
  *  AT91RM9200 processor initialization
  * -------------------------------------------------------------------- */
-static void __init at91rm9200_map_io(void)
-{
-	/* Map peripherals */
-	at91_init_sram(0, AT91RM9200_SRAM_BASE, AT91RM9200_SRAM_SIZE);
-}
 
 static void __init at91rm9200_initialize(void)
 {
@@ -56,6 +51,5 @@ static void __init at91rm9200_initialize(void)
 
 
 AT91_SOC_START(at91rm9200)
-	.map_io = at91rm9200_map_io,
 	.init = at91rm9200_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 34e2abe82ae4..ab9841c8b0d5 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -22,38 +22,11 @@
  *  AT91SAM9260 processor initialization
  * -------------------------------------------------------------------- */
 
-static void __init at91sam9xe_map_io(void)
-{
-	unsigned long sram_size;
-
-	switch (at91_soc_initdata.cidr & AT91_CIDR_SRAMSIZ) {
-		case AT91_CIDR_SRAMSIZ_32K:
-			sram_size = 2 * SZ_16K;
-			break;
-		case AT91_CIDR_SRAMSIZ_16K:
-		default:
-			sram_size = SZ_16K;
-	}
-
-	at91_init_sram(0, AT91SAM9XE_SRAM_BASE, sram_size);
-}
-
-static void __init at91sam9260_map_io(void)
-{
-	if (cpu_is_at91sam9xe())
-		at91sam9xe_map_io();
-	else if (cpu_is_at91sam9g20())
-		at91_init_sram(0, AT91SAM9G20_SRAM_BASE, AT91SAM9G20_SRAM_SIZE);
-	else
-		at91_init_sram(0, AT91SAM9260_SRAM_BASE, AT91SAM9260_SRAM_SIZE);
-}
-
 static void __init at91sam9260_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 }
 
 AT91_SOC_START(at91sam9260)
-	.map_io = at91sam9260_map_io,
 	.init = at91sam9260_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 47878b849975..2029096b93fa 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -21,20 +21,11 @@
  *  AT91SAM9261 processor initialization
  * -------------------------------------------------------------------- */
 
-static void __init at91sam9261_map_io(void)
-{
-	if (cpu_is_at91sam9g10())
-		at91_init_sram(0, AT91SAM9G10_SRAM_BASE, AT91SAM9G10_SRAM_SIZE);
-	else
-		at91_init_sram(0, AT91SAM9261_SRAM_BASE, AT91SAM9261_SRAM_SIZE);
-}
-
 static void __init at91sam9261_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 }
 
 AT91_SOC_START(at91sam9261)
-	.map_io = at91sam9261_map_io,
 	.init = at91sam9261_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index aabcb66145d0..1fe672a05513 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -20,18 +20,11 @@
  *  AT91SAM9263 processor initialization
  * -------------------------------------------------------------------- */
 
-static void __init at91sam9263_map_io(void)
-{
-	at91_init_sram(0, AT91SAM9263_SRAM0_BASE, AT91SAM9263_SRAM0_SIZE);
-	at91_init_sram(1, AT91SAM9263_SRAM1_BASE, AT91SAM9263_SRAM1_SIZE);
-}
-
 static void __init at91sam9263_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 }
 
 AT91_SOC_START(at91sam9263)
-	.map_io = at91sam9263_map_io,
 	.init = at91sam9263_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 000166777a8d..d0493df40a13 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -19,18 +19,11 @@
 /* --------------------------------------------------------------------
  *  AT91SAM9G45 processor initialization
  * -------------------------------------------------------------------- */
-
-static void __init at91sam9g45_map_io(void)
-{
-	at91_init_sram(0, AT91SAM9G45_SRAM_BASE, AT91SAM9G45_SRAM_SIZE);
-}
-
 static void __init at91sam9g45_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 }
 
 AT91_SOC_START(at91sam9g45)
-	.map_io = at91sam9g45_map_io,
 	.init = at91sam9g45_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
index 0135f868ea4f..b5ea69a3eaf6 100644
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@ -16,11 +16,5 @@
  *  AT91SAM9N12 processor initialization
  * -------------------------------------------------------------------- */
 
-static void __init at91sam9n12_map_io(void)
-{
-	at91_init_sram(0, AT91SAM9N12_SRAM_BASE, AT91SAM9N12_SRAM_SIZE);
-}
-
 AT91_SOC_START(at91sam9n12)
-	.map_io = at91sam9n12_map_io,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 1babfb27694a..33acae30bb0b 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -21,29 +21,11 @@
  *  AT91SAM9RL processor initialization
  * -------------------------------------------------------------------- */
 
-static void __init at91sam9rl_map_io(void)
-{
-	unsigned long sram_size;
-
-	switch (at91_soc_initdata.cidr & AT91_CIDR_SRAMSIZ) {
-		case AT91_CIDR_SRAMSIZ_32K:
-			sram_size = 2 * SZ_16K;
-			break;
-		case AT91_CIDR_SRAMSIZ_16K:
-		default:
-			sram_size = SZ_16K;
-	}
-
-	/* Map SRAM */
-	at91_init_sram(0, AT91SAM9RL_SRAM_BASE, sram_size);
-}
-
 static void __init at91sam9rl_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
 }
 
 AT91_SOC_START(at91sam9rl)
-	.map_io = at91sam9rl_map_io,
 	.init = at91sam9rl_initialize,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index aa17520ccb0a..7b60a529db01 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -16,11 +16,5 @@
  *  AT91SAM9x5 processor initialization
  * -------------------------------------------------------------------- */
 
-static void __init at91sam9x5_map_io(void)
-{
-	at91_init_sram(0, AT91SAM9X5_SRAM_BASE, AT91SAM9X5_SRAM_SIZE);
-}
-
 AT91_SOC_START(at91sam9x5)
-	.map_io = at91sam9x5_map_io,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index ae58feada72b..b7c64ca7107f 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -25,11 +25,5 @@
  *  AT91SAM9x5 processor initialization
  * -------------------------------------------------------------------- */
 
-static void __init sama5d3_map_io(void)
-{
-	at91_init_sram(0, SAMA5D3_SRAM_BASE, SAMA5D3_SRAM_SIZE);
-}
-
 AT91_SOC_START(sama5d3)
-	.map_io = sama5d3_map_io,
 AT91_SOC_END
-- 
2.1.0

