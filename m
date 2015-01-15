Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbbAOWAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:00:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57604 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932331AbbAOWAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:00:02 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 11/17] ARM: at91: remove at91_boot_soc
Date: Thu, 15 Jan 2015 22:58:14 +0100
Message-Id: <1421359100-8930-12-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91_boot_soc is not used by any SoC, remove its usage. Also remove all the now
empty SoC files.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Makefile        |  7 ----
 arch/arm/mach-at91/at91rm9200.c    | 17 +--------
 arch/arm/mach-at91/at91sam9260.c   | 26 -------------
 arch/arm/mach-at91/at91sam9261.c   | 25 -------------
 arch/arm/mach-at91/at91sam9263.c   | 24 ------------
 arch/arm/mach-at91/at91sam9g45.c   | 25 -------------
 arch/arm/mach-at91/at91sam9n12.c   | 25 -------------
 arch/arm/mach-at91/at91sam9rl.c    | 26 -------------
 arch/arm/mach-at91/at91sam9x5.c    | 26 -------------
 arch/arm/mach-at91/board-dt-sam9.c |  1 +
 arch/arm/mach-at91/sama5d3.c       |  9 -----
 arch/arm/mach-at91/sama5d4.c       | 24 +-----------
 arch/arm/mach-at91/setup.c         | 32 ----------------
 arch/arm/mach-at91/soc.h           | 77 --------------------------------------
 14 files changed, 4 insertions(+), 340 deletions(-)
 delete mode 100644 arch/arm/mach-at91/at91sam9260.c
 delete mode 100644 arch/arm/mach-at91/at91sam9261.c
 delete mode 100644 arch/arm/mach-at91/at91sam9263.c
 delete mode 100644 arch/arm/mach-at91/at91sam9g45.c
 delete mode 100644 arch/arm/mach-at91/at91sam9n12.c
 delete mode 100644 arch/arm/mach-at91/at91sam9rl.c
 delete mode 100644 arch/arm/mach-at91/at91sam9x5.c
 delete mode 100644 arch/arm/mach-at91/soc.h

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 4bce1fac680e..76d6d869bf4e 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -8,13 +8,6 @@ obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
 # CPU-specific support
 obj-$(CONFIG_SOC_AT91RM9200)	+= at91rm9200.o at91rm9200_time.o
-obj-$(CONFIG_SOC_AT91SAM9260)	+= at91sam9260.o
-obj-$(CONFIG_SOC_AT91SAM9261)	+= at91sam9261.o
-obj-$(CONFIG_SOC_AT91SAM9263)	+= at91sam9263.o
-obj-$(CONFIG_SOC_AT91SAM9G45)	+= at91sam9g45.o
-obj-$(CONFIG_SOC_AT91SAM9N12)	+= at91sam9n12.o
-obj-$(CONFIG_SOC_AT91SAM9X5)	+= at91sam9x5.o
-obj-$(CONFIG_SOC_AT91SAM9RL)	+= at91sam9rl.o
 obj-$(CONFIG_SOC_SAMA5D3)	+= sama5d3.o
 obj-$(CONFIG_SOC_SAMA5D4)	+= sama5d4.o
 
diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index eaa30b1fea01..a3c0dd612d77 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -28,7 +28,6 @@
 #include <mach/at91_st.h>
 #include <mach/hardware.h>
 
-#include "soc.h"
 #include "generic.h"
 
 
@@ -41,20 +40,6 @@ static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
 	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
 }
 
-/* --------------------------------------------------------------------
- *  AT91RM9200 processor initialization
- * -------------------------------------------------------------------- */
-
-static void __init at91rm9200_initialize(void)
-{
-	arm_pm_idle = at91rm9200_idle;
-	arm_pm_restart = at91rm9200_restart;
-}
-
-AT91_SOC_START(at91rm9200)
-	.init = at91rm9200_initialize,
-AT91_SOC_END
-
 static void __init at91rm9200_dt_timer_init(void)
 {
 	of_clk_init(NULL);
@@ -63,6 +48,8 @@ static void __init at91rm9200_dt_timer_init(void)
 
 static void __init rm9200_dt_device_init(void)
 {
+	arm_pm_idle = at91rm9200_idle;
+	arm_pm_restart = at91rm9200_restart;
 	at91_rm9200_pm_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
deleted file mode 100644
index 37b7ce4c6a3b..000000000000
--- a/arch/arm/mach-at91/at91sam9260.c
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * arch/arm/mach-at91/at91sam9260.c
- *
- *  Copyright (C) 2006 SAN People
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <asm/system_misc.h>
-#include <mach/cpu.h>
-#include <mach/at91_dbgu.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9260 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9260)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
deleted file mode 100644
index aebbf76b6038..000000000000
--- a/arch/arm/mach-at91/at91sam9261.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * arch/arm/mach-at91/at91sam9261.c
- *
- *  Copyright (C) 2005 SAN People
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <asm/system_misc.h>
-#include <mach/cpu.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9261 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9261)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
deleted file mode 100644
index dca29457d9cc..000000000000
--- a/arch/arm/mach-at91/at91sam9263.c
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * arch/arm/mach-at91/at91sam9263.c
- *
- *  Copyright (C) 2007 Atmel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <asm/system_misc.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9263 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9263)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
deleted file mode 100644
index d77d10cf10f6..000000000000
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- *  Chip-specific setup code for the AT91SAM9G45 family
- *
- *  Copyright (C) 2009 Atmel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <asm/system_misc.h>
-#include <asm/irq.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9G45 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9g45)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
deleted file mode 100644
index 276b8f0e4183..000000000000
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * SoC specific setup code for the AT91SAM9N12
- *
- * Copyright (C) 2012 Atmel Corporation.
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <asm/system_misc.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9N12 processor initialization
- * -------------------------------------------------------------------- */
-static void __init at91sam9n12_initialize(void)
-{
-	arm_pm_idle = at91sam9_idle;
-}
-
-AT91_SOC_START(at91sam9n12)
-	.init = at91sam9n12_initialize,
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
deleted file mode 100644
index a585ff3adf96..000000000000
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * arch/arm/mach-at91/at91sam9rl.c
- *
- *  Copyright (C) 2005 SAN People
- *  Copyright (C) 2007 Atmel Corporation
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive for
- * more details.
- */
-
-#include <asm/system_misc.h>
-#include <asm/irq.h>
-#include <mach/cpu.h>
-#include <mach/at91_dbgu.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9RL processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9rl)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
deleted file mode 100644
index 7b6fb1bca505..000000000000
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- *  Chip-specific setup code for the AT91SAM9x5 family
- *
- *  Copyright (C) 2010-2012 Atmel Corporation.
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <asm/system_misc.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9x5 processor initialization
- * -------------------------------------------------------------------- */
-
-static void __init at91sam9x5_initialize(void)
-{
-	arm_pm_idle = at91sam9_idle;
-}
-
-AT91_SOC_START(at91sam9x5)
-	.init = at91sam9x5_initialize,
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 508468d77475..6f90201dbd47 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -21,6 +21,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
+#include <asm/system_misc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index ecd35f135a9f..6f73a34cb7e4 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -12,21 +12,12 @@
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
-#include <asm/mach/irq.h>
 
 #include <mach/sama5d3.h>
 #include <mach/cpu.h>
 
-#include "soc.h"
 #include "generic.h"
 
-/* --------------------------------------------------------------------
- *  AT91SAM9x5 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(sama5d3)
-AT91_SOC_END
-
 static void __init sama5_dt_device_init(void)
 {
 	at91_sam9260_pm_init();
diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
index 68573cd9d8f9..87c71afedb57 100644
--- a/arch/arm/mach-at91/sama5d4.c
+++ b/arch/arm/mach-at91/sama5d4.c
@@ -7,34 +7,16 @@
  * Licensed under GPLv2 or later.
  */
 
-#include <linux/module.h>
-#include <linux/dma-mapping.h>
-#include <linux/clk/at91_pmc.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/gpio.h>
-#include <linux/micrel_phy.h>
-#include <linux/of.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
-#include <linux/phy.h>
-#include <linux/clk-provider.h>
 
-#include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
-#include <asm/mach/irq.h>
 
 #include <mach/sama5d4.h>
-#include <mach/cpu.h>
 #include <mach/hardware.h>
 
-#include "soc.h"
 #include "generic.h"
 
-/* --------------------------------------------------------------------
- *  Processor initialization
- * -------------------------------------------------------------------- */
 static struct map_desc at91_io_desc[] __initdata = {
 	{
 	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_MPDDRC),
@@ -67,10 +49,6 @@ static void __init sama5d4_map_io(void)
 	iotable_init(at91_io_desc, ARRAY_SIZE(at91_io_desc));
 }
 
-AT91_SOC_START(sama5d4)
-	.map_io = sama5d4_map_io,
-AT91_SOC_END
-
 static void __init sama5d4_dt_device_init(void)
 {
 	at91_sam9260_pm_init();
@@ -84,7 +62,7 @@ static const char *sama5_alt_dt_board_compat[] __initconst = {
 
 DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
-	.map_io		= at91_alt_map_io,
+	.map_io		= sama5d4_map_io,
 	.init_early	= at91_dt_initialize,
 	.init_machine	= sama5d4_dt_device_init,
 	.dt_compat	= sama5_alt_dt_board_compat,
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 88649dee830e..42ebe8d41433 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -22,12 +22,9 @@
 #include <mach/cpu.h>
 #include <mach/at91_dbgu.h>
 
-#include "soc.h"
 #include "generic.h"
 #include "pm.h"
 
-struct at91_init_soc __initdata at91_boot_soc;
-
 struct at91_socinfo at91_soc_initdata;
 EXPORT_SYMBOL(at91_soc_initdata);
 
@@ -60,61 +57,51 @@ static void __init soc_detect(u32 dbgu_base)
 		at91_soc_initdata.type = AT91_SOC_RM9200;
 		if (at91_soc_initdata.subtype == AT91_SOC_SUBTYPE_UNKNOWN)
 			at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
-		at91_boot_soc = at91rm9200_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9260:
 		at91_soc_initdata.type = AT91_SOC_SAM9260;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9260_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9261:
 		at91_soc_initdata.type = AT91_SOC_SAM9261;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9261_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9263:
 		at91_soc_initdata.type = AT91_SOC_SAM9263;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9263_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9G20:
 		at91_soc_initdata.type = AT91_SOC_SAM9G20;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9260_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9G45:
 		at91_soc_initdata.type = AT91_SOC_SAM9G45;
 		if (cidr == ARCH_ID_AT91SAM9G45ES)
 			at91_soc_initdata.subtype = AT91_SOC_SAM9G45ES;
-		at91_boot_soc = at91sam9g45_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9RL64:
 		at91_soc_initdata.type = AT91_SOC_SAM9RL;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9rl_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9X5:
 		at91_soc_initdata.type = AT91_SOC_SAM9X5;
-		at91_boot_soc = at91sam9x5_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9N12:
 		at91_soc_initdata.type = AT91_SOC_SAM9N12;
-		at91_boot_soc = at91sam9n12_soc;
 		break;
 
 	case ARCH_ID_SAMA5:
 		at91_soc_initdata.exid = __raw_readl(AT91_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
 		if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D3) {
 			at91_soc_initdata.type = AT91_SOC_SAMA5D3;
-			at91_boot_soc = sama5d3_soc;
 		}
 		break;
 	}
@@ -123,13 +110,11 @@ static void __init soc_detect(u32 dbgu_base)
 	if ((socid & ~AT91_CIDR_EXT) == ARCH_ID_AT91SAM9G10) {
 		at91_soc_initdata.type = AT91_SOC_SAM9G10;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9261_soc;
 	}
 	/* at91sam9xe */
 	else if ((cidr & AT91_CIDR_ARCH) == ARCH_FAMILY_AT91SAM9XE) {
 		at91_soc_initdata.type = AT91_SOC_SAM9260;
 		at91_soc_initdata.subtype = AT91_SOC_SAM9XE;
-		at91_boot_soc = at91sam9260_soc;
 	}
 
 	if (!at91_soc_is_detected())
@@ -209,10 +194,8 @@ static void __init alt_soc_detect(u32 dbgu_base)
 		at91_soc_initdata.exid = __raw_readl(AT91_ALT_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
 		if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D3) {
 			at91_soc_initdata.type = AT91_SOC_SAMA5D3;
-			at91_boot_soc = sama5d3_soc;
 		} else if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D4) {
 			at91_soc_initdata.type = AT91_SOC_SAMA5D4;
-			at91_boot_soc = sama5d4_soc;
 		}
 		break;
 	}
@@ -318,12 +301,6 @@ void __init at91_map_io(void)
 	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
 		pr_info("Detected soc subtype: %s\n",
 			at91_get_soc_subtype(&at91_soc_initdata));
-
-	if (!at91_soc_is_enabled())
-		panic(pr_fmt("Soc not enabled"));
-
-	if (at91_boot_soc.map_io)
-		at91_boot_soc.map_io();
 }
 
 void __init at91_alt_map_io(void)
@@ -343,12 +320,6 @@ void __init at91_alt_map_io(void)
 	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
 		pr_info("AT91: Detected soc subtype: %s\n",
 			at91_get_soc_subtype(&at91_soc_initdata));
-
-	if (!at91_soc_is_enabled())
-		panic("AT91: Soc not enabled");
-
-	if (at91_boot_soc.map_io)
-		at91_boot_soc.map_io();
 }
 
 static struct of_device_id ramc_ids[] = {
@@ -391,7 +362,4 @@ static void at91_dt_ramc(void)
 void __init at91_dt_initialize(void)
 {
 	at91_dt_ramc();
-
-	if (at91_boot_soc.init)
-		at91_boot_soc.init();
 }
diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
deleted file mode 100644
index ae6c0b2f1146..000000000000
--- a/arch/arm/mach-at91/soc.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- * Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
- *
- * Under GPLv2
- */
-
-struct at91_init_soc {
-	int builtin;
-	void (*map_io)(void);
-	void (*init)(void);
-};
-
-extern struct at91_init_soc at91_boot_soc;
-extern struct at91_init_soc at91rm9200_soc;
-extern struct at91_init_soc at91sam9260_soc;
-extern struct at91_init_soc at91sam9261_soc;
-extern struct at91_init_soc at91sam9263_soc;
-extern struct at91_init_soc at91sam9g45_soc;
-extern struct at91_init_soc at91sam9rl_soc;
-extern struct at91_init_soc at91sam9x5_soc;
-extern struct at91_init_soc at91sam9n12_soc;
-extern struct at91_init_soc sama5d3_soc;
-extern struct at91_init_soc sama5d4_soc;
-
-#define AT91_SOC_START(_name)				\
-struct at91_init_soc __initdata _name##_soc		\
- __used							\
-						= {	\
-	.builtin	= 1,				\
-
-#define AT91_SOC_END					\
-};
-
-static inline int at91_soc_is_enabled(void)
-{
-	return at91_boot_soc.builtin;
-}
-
-#if !defined(CONFIG_SOC_AT91RM9200)
-#define at91rm9200_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9260)
-#define at91sam9260_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9261)
-#define at91sam9261_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9263)
-#define at91sam9263_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9G45)
-#define at91sam9g45_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9RL)
-#define at91sam9rl_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9X5)
-#define at91sam9x5_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9N12)
-#define at91sam9n12_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_SAMA5D3)
-#define sama5d3_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_SAMA5D4)
-#define sama5d4_soc	at91_boot_soc
-#endif
-- 
2.1.0

