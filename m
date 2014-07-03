Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbaGCOUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:20:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51001 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758554AbaGCOUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:35 -0400
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
Subject: [PATCH 17/18] AT91: Remove rstc and shdwc headers
Date: Thu,  3 Jul 2014 16:15:03 +0200
Message-Id: <1404396906-25194-31-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These headers used to provide an "API" to access the rstc and shdwc registers.
Now that no-one uses this API anymore, we can safely remove those.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91_rstc.h          | 53 ---------------------------------
 arch/arm/mach-at91/at91_shdwc.h         | 50 -------------------------------
 arch/arm/mach-at91/at91sam9260.c        |  1 -
 arch/arm/mach-at91/at91sam9261.c        |  1 -
 arch/arm/mach-at91/at91sam9263.c        |  1 -
 arch/arm/mach-at91/at91sam9rl.c         |  1 -
 arch/arm/mach-at91/board-sam9260ek.c    |  1 -
 arch/arm/mach-at91/board-sam9261ek.c    |  1 -
 arch/arm/mach-at91/board-sam9263ek.c    |  1 -
 arch/arm/mach-at91/board-sam9m10g45ek.c |  1 -
 arch/arm/mach-at91/board-sam9rlek.c     |  1 -
 arch/arm/mach-at91/setup.c              |  1 -
 12 files changed, 113 deletions(-)
 delete mode 100644 arch/arm/mach-at91/at91_rstc.h
 delete mode 100644 arch/arm/mach-at91/at91_shdwc.h

diff --git a/arch/arm/mach-at91/at91_rstc.h b/arch/arm/mach-at91/at91_rstc.h
deleted file mode 100644
index a600e6992920..000000000000
--- a/arch/arm/mach-at91/at91_rstc.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91_rstc.h
- *
- * Copyright (C) 2007 Andrew Victor
- * Copyright (C) 2007 Atmel Corporation.
- *
- * Reset Controller (RSTC) - System peripherals regsters.
- * Based on AT91SAM9261 datasheet revision D.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91_RSTC_H
-#define AT91_RSTC_H
-
-#ifndef __ASSEMBLY__
-extern void __iomem *at91_rstc_base;
-
-#define at91_rstc_read(field) \
-	__raw_readl(at91_rstc_base + field)
-
-#define at91_rstc_write(field, value) \
-	__raw_writel(value, at91_rstc_base + field)
-#else
-.extern at91_rstc_base
-#endif
-
-#define AT91_RSTC_CR		0x00			/* Reset Controller Control Register */
-#define		AT91_RSTC_PROCRST	(1 << 0)		/* Processor Reset */
-#define		AT91_RSTC_PERRST	(1 << 2)		/* Peripheral Reset */
-#define		AT91_RSTC_EXTRST	(1 << 3)		/* External Reset */
-#define		AT91_RSTC_KEY		(0xa5 << 24)		/* KEY Password */
-
-#define AT91_RSTC_SR		0x04			/* Reset Controller Status Register */
-#define		AT91_RSTC_URSTS		(1 << 0)		/* User Reset Status */
-#define		AT91_RSTC_RSTTYP	(7 << 8)		/* Reset Type */
-#define			AT91_RSTC_RSTTYP_GENERAL	(0 << 8)
-#define			AT91_RSTC_RSTTYP_WAKEUP		(1 << 8)
-#define			AT91_RSTC_RSTTYP_WATCHDOG	(2 << 8)
-#define			AT91_RSTC_RSTTYP_SOFTWARE	(3 << 8)
-#define			AT91_RSTC_RSTTYP_USER	(4 << 8)
-#define		AT91_RSTC_NRSTL		(1 << 16)		/* NRST Pin Level */
-#define		AT91_RSTC_SRCMP		(1 << 17)		/* Software Reset Command in Progress */
-
-#define AT91_RSTC_MR		0x08			/* Reset Controller Mode Register */
-#define		AT91_RSTC_URSTEN	(1 << 0)		/* User Reset Enable */
-#define		AT91_RSTC_URSTIEN	(1 << 4)		/* User Reset Interrupt Enable */
-#define		AT91_RSTC_ERSTL		(0xf << 8)		/* External Reset Length */
-
-#endif
diff --git a/arch/arm/mach-at91/at91_shdwc.h b/arch/arm/mach-at91/at91_shdwc.h
deleted file mode 100644
index 9e29f31ec9a6..000000000000
--- a/arch/arm/mach-at91/at91_shdwc.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91_shdwc.h
- *
- * Copyright (C) 2007 Andrew Victor
- * Copyright (C) 2007 Atmel Corporation.
- *
- * Shutdown Controller (SHDWC) - System peripherals regsters.
- * Based on AT91SAM9261 datasheet revision D.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91_SHDWC_H
-#define AT91_SHDWC_H
-
-#ifndef __ASSEMBLY__
-extern void __iomem *at91_shdwc_base;
-
-#define at91_shdwc_read(field) \
-	__raw_readl(at91_shdwc_base + field)
-
-#define at91_shdwc_write(field, value) \
-	__raw_writel(value, at91_shdwc_base + field)
-#endif
-
-#define AT91_SHDW_CR		0x00			/* Shut Down Control Register */
-#define		AT91_SHDW_SHDW		(1    << 0)		/* Shut Down command */
-#define		AT91_SHDW_KEY		(0xa5 << 24)		/* KEY Password */
-
-#define AT91_SHDW_MR		0x04			/* Shut Down Mode Register */
-#define		AT91_SHDW_WKMODE0	(3 << 0)		/* Wake-up 0 Mode Selection */
-#define			AT91_SHDW_WKMODE0_NONE		0
-#define			AT91_SHDW_WKMODE0_HIGH		1
-#define			AT91_SHDW_WKMODE0_LOW		2
-#define			AT91_SHDW_WKMODE0_ANYLEVEL	3
-#define		AT91_SHDW_CPTWK0_MAX	0xf			/* Maximum Counter On Wake Up 0 */
-#define		AT91_SHDW_CPTWK0	(AT91_SHDW_CPTWK0_MAX << 4) /* Counter On Wake Up 0 */
-#define			AT91_SHDW_CPTWK0_(x)	((x) << 4)
-#define		AT91_SHDW_RTTWKEN	(1   << 16)		/* Real Time Timer Wake-up Enable */
-#define		AT91_SHDW_RTCWKEN	(1   << 17)		/* Real Time Clock Wake-up Enable */
-
-#define AT91_SHDW_SR		0x08			/* Shut Down Status Register */
-#define		AT91_SHDW_WAKEUP0	(1 <<  0)		/* Wake-up 0 Status */
-#define		AT91_SHDW_RTTWK		(1 << 16)		/* Real-time Timer Wake-up */
-#define		AT91_SHDW_RTCWK		(1 << 17)		/* Real-time Clock Wake-up [SAM9RL] */
-
-#endif
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 16dd13800b1f..624fe15ec352 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -25,7 +25,6 @@
 #include <mach/hardware.h>
 
 #include "at91_aic.h"
-#include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
 #include "clock.h"
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 2c8553e63785..f115f4709021 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -24,7 +24,6 @@
 #include <mach/hardware.h>
 
 #include "at91_aic.h"
-#include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 63a47c7d7f2b..08e0f4ec7d11 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -23,7 +23,6 @@
 #include <mach/hardware.h>
 
 #include "at91_aic.h"
-#include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
 #include "clock.h"
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index ea9ac0ee0895..d6ad162b9a88 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -24,7 +24,6 @@
 #include <mach/hardware.h>
 
 #include "at91_aic.h"
-#include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index da9c5f1f2c49..18f49c93f3f3 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -45,7 +45,6 @@
 #include <mach/system_rev.h>
 
 #include "at91_aic.h"
-#include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index d1be10b09ab3..5a23e7211203 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -49,7 +49,6 @@
 #include <mach/system_rev.h>
 
 #include "at91_aic.h"
-#include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 3f613d962d9b..e2aa41d19fc1 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -48,7 +48,6 @@
 #include <mach/system_rev.h>
 
 #include "at91_aic.h"
-#include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 33a7b19f7400..e7d793b7601e 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -46,7 +46,6 @@
 #include <mach/system_rev.h>
 
 #include "at91_aic.h"
-#include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index 262e3f957d9f..5cb82464be1a 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -35,7 +35,6 @@
 
 
 #include "at91_aic.h"
-#include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index fd3b6f0dd50d..06aaf857ddc4 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -22,7 +22,6 @@
 #include <mach/cpu.h>
 #include <mach/at91_dbgu.h>
 
-#include "at91_shdwc.h"
 #include "soc.h"
 #include "generic.h"
 #include "pm.h"
-- 
2.0.1

