Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbbA0SIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:08:32 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10665 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924AbbA0SIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:08:31 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/7] ARM: at91: remove at91_boot_soc
Date: Tue, 27 Jan 2015 19:07:23 +0100
Message-ID: <c1b6b92f3c11d2779aef2f6da26ae7b8bf38a9d0.1422381280.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1422381280.git.nicolas.ferre@atmel.com>
References: <cover.1422381280.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

at91_boot_soc and at91_init_soc structures are not used by any SoC, remove
their use. Also remove all the now empty SoC files.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
[nicolas.ferre@atmel.com: different organization of the patches]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Makefile     |  4 +---
 arch/arm/mach-at91/at91rm9200.c | 32 --------------------------------
 arch/arm/mach-at91/sama5d3.c    | 29 -----------------------------
 arch/arm/mach-at91/sama5d4.c    | 30 ------------------------------
 arch/arm/mach-at91/setup.c      |  7 -------
 arch/arm/mach-at91/soc.h        | 41 -----------------------------------------
 6 files changed, 1 insertion(+), 142 deletions(-)
 delete mode 100644 arch/arm/mach-at91/at91rm9200.c
 delete mode 100644 arch/arm/mach-at91/sama5d3.c
 delete mode 100644 arch/arm/mach-at91/sama5d4.c
 delete mode 100644 arch/arm/mach-at91/soc.h

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index ad7fc5834188..3362f51ffd82 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -7,9 +7,7 @@ obj-y		:= setup.o
 obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
 # CPU-specific support
-obj-$(CONFIG_SOC_AT91RM9200)	+= at91rm9200.o at91rm9200_time.o
-obj-$(CONFIG_SOC_SAMA5D3)	+= sama5d3.o
-obj-$(CONFIG_SOC_SAMA5D4)	+= sama5d4.o
+obj-$(CONFIG_SOC_AT91RM9200)	+= at91rm9200_time.o
 
 # AT91SAM board with device-tree
 obj-$(CONFIG_SOC_AT91RM9200) += board-dt-rm9200.o
diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
deleted file mode 100644
index ae0d5f0eb108..000000000000
--- a/arch/arm/mach-at91/at91rm9200.c
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * arch/arm/mach-at91/at91rm9200.c
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
-#include <linux/module.h>
-#include <linux/clk/at91_pmc.h>
-
-#include <asm/mach/map.h>
-#include <asm/system_misc.h>
-#include <mach/at91_st.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-
-
-/* --------------------------------------------------------------------
- *  AT91RM9200 processor initialization
- * -------------------------------------------------------------------- */
-
-
-AT91_SOC_START(at91rm9200)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
deleted file mode 100644
index b7c64ca7107f..000000000000
--- a/arch/arm/mach-at91/sama5d3.c
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- *  Chip-specific setup code for the SAMA5D3 family
- *
- *  Copyright (C) 2013 Atmel,
- *                2013 Ludovic Desroches <ludovic.desroches@atmel.com>
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <linux/module.h>
-#include <linux/dma-mapping.h>
-#include <linux/clk/at91_pmc.h>
-
-#include <asm/irq.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <mach/sama5d3.h>
-#include <mach/cpu.h>
-
-#include "soc.h"
-#include "generic.h"
-#include "sam9_smc.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9x5 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(sama5d3)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
deleted file mode 100644
index 268f2d238f80..000000000000
--- a/arch/arm/mach-at91/sama5d4.c
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- *  Chip-specific setup code for the SAMA5D4 family
- *
- *  Copyright (C) 2013 Atmel Corporation,
- *                     Nicolas Ferre <nicolas.ferre@atmel.com>
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <linux/module.h>
-#include <linux/dma-mapping.h>
-#include <linux/clk/at91_pmc.h>
-
-#include <asm/irq.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <mach/sama5d4.h>
-#include <mach/cpu.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-#include "sam9_smc.h"
-
-/* --------------------------------------------------------------------
- *  Processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(sama5d4)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index af6086b69bb1..b6a903410b92 100644
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
 
@@ -60,7 +57,6 @@ static void __init soc_detect(u32 dbgu_base)
 		at91_soc_initdata.type = AT91_SOC_RM9200;
 		if (at91_soc_initdata.subtype == AT91_SOC_SUBTYPE_UNKNOWN)
 			at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
-		at91_boot_soc = at91rm9200_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9260:
@@ -106,7 +102,6 @@ static void __init soc_detect(u32 dbgu_base)
 		at91_soc_initdata.exid = __raw_readl(AT91_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
 		if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D3) {
 			at91_soc_initdata.type = AT91_SOC_SAMA5D3;
-			at91_boot_soc = sama5d3_soc;
 		}
 		break;
 	}
@@ -199,10 +194,8 @@ static void __init alt_soc_detect(u32 dbgu_base)
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
diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
deleted file mode 100644
index 0593dcceb287..000000000000
--- a/arch/arm/mach-at91/soc.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
- *
- * Under GPLv2
- */
-
-struct at91_init_soc {
-	int builtin;
-	void (*map_io)(void);
-};
-
-extern struct at91_init_soc at91_boot_soc;
-extern struct at91_init_soc at91rm9200_soc;
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
-#if !defined(CONFIG_SOC_SAMA5D3)
-#define sama5d3_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_SAMA5D4)
-#define sama5d4_soc	at91_boot_soc
-#endif
-- 
2.1.3

