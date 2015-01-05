Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbbAEMHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:07:16 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44550 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753511AbbAEMGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:06:53 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 8/8] ARM: at91: remove useless include
Date: Mon,  5 Jan 2015 13:06:45 +0100
Message-Id: <1420459605-24561-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420459605-24561-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1420459605-24561-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both drivers using the system timer are now converted to an MFD. mach/at91_st.h
is now useless.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/include/mach/at91_st.h | 61 -------------------------------
 1 file changed, 61 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_st.h

diff --git a/arch/arm/mach-at91/include/mach/at91_st.h b/arch/arm/mach-at91/include/mach/at91_st.h
deleted file mode 100644
index 67fdbd13c3ed..000000000000
--- a/arch/arm/mach-at91/include/mach/at91_st.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91_st.h
- *
- * Copyright (C) 2005 Ivan Kokshaysky
- * Copyright (C) SAN People
- *
- * System Timer (ST) - System peripherals registers.
- * Based on AT91RM9200 datasheet revision E.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91_ST_H
-#define AT91_ST_H
-
-#ifndef __ASSEMBLY__
-extern void __iomem *at91_st_base;
-
-#define at91_st_read(field) \
-	__raw_readl(at91_st_base + field)
-
-#define at91_st_write(field, value) \
-	__raw_writel(value, at91_st_base + field)
-#else
-.extern at91_st_base
-#endif
-
-#define	AT91_ST_CR		0x00			/* Control Register */
-#define 	AT91_ST_WDRST		(1 << 0)		/* Watchdog Timer Restart */
-
-#define	AT91_ST_PIMR		0x04			/* Period Interval Mode Register */
-#define		AT91_ST_PIV		(0xffff <<  0)		/* Period Interval Value */
-
-#define	AT91_ST_WDMR		0x08			/* Watchdog Mode Register */
-#define		AT91_ST_WDV		(0xffff <<  0)		/* Watchdog Counter Value */
-#define		AT91_ST_RSTEN		(1	<< 16)		/* Reset Enable */
-#define		AT91_ST_EXTEN		(1	<< 17)		/* External Signal Assertion Enable */
-
-#define	AT91_ST_RTMR		0x0c			/* Real-time Mode Register */
-#define		AT91_ST_RTPRES		(0xffff <<  0)		/* Real-time Prescalar Value */
-
-#define	AT91_ST_SR		0x10			/* Status Register */
-#define		AT91_ST_PITS		(1 << 0)		/* Period Interval Timer Status */
-#define		AT91_ST_WDOVF		(1 << 1) 		/* Watchdog Overflow */
-#define		AT91_ST_RTTINC		(1 << 2) 		/* Real-time Timer Increment */
-#define		AT91_ST_ALMS		(1 << 3) 		/* Alarm Status */
-
-#define	AT91_ST_IER		0x14			/* Interrupt Enable Register */
-#define	AT91_ST_IDR		0x18			/* Interrupt Disable Register */
-#define	AT91_ST_IMR		0x1c			/* Interrupt Mask Register */
-
-#define	AT91_ST_RTAR		0x20			/* Real-time Alarm Register */
-#define		AT91_ST_ALMV		(0xfffff << 0)		/* Alarm Value */
-
-#define	AT91_ST_CRTR		0x24			/* Current Real-time Register */
-#define		AT91_ST_CRTV		(0xfffff << 0)		/* Current Real-Time Value */
-
-#endif
-- 
2.1.0

