Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbbAOWRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:17:30 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57856 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753511AbbAOWQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:16:55 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 5/5] ARM: at91: remove useless SoC includes
Date: Thu, 15 Jan 2015 23:16:49 +0100
Message-Id: <1421360209-15852-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421360209-15852-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421360209-15852-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SoC includes are now useless.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/include/mach/at91rm9200.h  | 103 -------------------
 arch/arm/mach-at91/include/mach/at91sam9260.h | 129 -----------------------
 arch/arm/mach-at91/include/mach/at91sam9261.h |  99 ------------------
 arch/arm/mach-at91/include/mach/at91sam9263.h | 117 ---------------------
 arch/arm/mach-at91/include/mach/at91sam9g45.h | 143 --------------------------
 arch/arm/mach-at91/include/mach/at91sam9n12.h |  65 ------------
 arch/arm/mach-at91/include/mach/at91sam9rl.h  | 105 -------------------
 arch/arm/mach-at91/include/mach/at91sam9x5.h  |  71 -------------
 arch/arm/mach-at91/include/mach/hardware.h    |  11 --
 arch/arm/mach-at91/include/mach/sama5d3.h     |  86 ----------------
 arch/arm/mach-at91/include/mach/sama5d4.h     |  33 ------
 11 files changed, 962 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91rm9200.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9260.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9261.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9263.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9g45.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9n12.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9rl.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9x5.h
 delete mode 100644 arch/arm/mach-at91/include/mach/sama5d3.h
 delete mode 100644 arch/arm/mach-at91/include/mach/sama5d4.h

diff --git a/arch/arm/mach-at91/include/mach/at91rm9200.h b/arch/arm/mach-at91/include/mach/at91rm9200.h
deleted file mode 100644
index e67317c67761..000000000000
--- a/arch/arm/mach-at91/include/mach/at91rm9200.h
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91rm9200.h
- *
- * Copyright (C) 2005 Ivan Kokshaysky
- * Copyright (C) SAN People
- *
- * Common definitions.
- * Based on AT91RM9200 datasheet revision E.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91RM9200_H
-#define AT91RM9200_H
-
-/*
- * Peripheral identifiers/interrupts.
- */
-#define AT91RM9200_ID_PIOA	2	/* Parallel IO Controller A */
-#define AT91RM9200_ID_PIOB	3	/* Parallel IO Controller B */
-#define AT91RM9200_ID_PIOC	4	/* Parallel IO Controller C */
-#define AT91RM9200_ID_PIOD	5	/* Parallel IO Controller D */
-#define AT91RM9200_ID_US0	6	/* USART 0 */
-#define AT91RM9200_ID_US1	7	/* USART 1 */
-#define AT91RM9200_ID_US2	8	/* USART 2 */
-#define AT91RM9200_ID_US3	9	/* USART 3 */
-#define AT91RM9200_ID_MCI	10	/* Multimedia Card Interface */
-#define AT91RM9200_ID_UDP	11	/* USB Device Port */
-#define AT91RM9200_ID_TWI	12	/* Two-Wire Interface */
-#define AT91RM9200_ID_SPI	13	/* Serial Peripheral Interface */
-#define AT91RM9200_ID_SSC0	14	/* Serial Synchronous Controller 0 */
-#define AT91RM9200_ID_SSC1	15	/* Serial Synchronous Controller 1 */
-#define AT91RM9200_ID_SSC2	16	/* Serial Synchronous Controller 2 */
-#define AT91RM9200_ID_TC0	17	/* Timer Counter 0 */
-#define AT91RM9200_ID_TC1	18	/* Timer Counter 1 */
-#define AT91RM9200_ID_TC2	19	/* Timer Counter 2 */
-#define AT91RM9200_ID_TC3	20	/* Timer Counter 3 */
-#define AT91RM9200_ID_TC4	21	/* Timer Counter 4 */
-#define AT91RM9200_ID_TC5	22	/* Timer Counter 5 */
-#define AT91RM9200_ID_UHP	23	/* USB Host port */
-#define AT91RM9200_ID_EMAC	24	/* Ethernet MAC */
-#define AT91RM9200_ID_IRQ0	25	/* Advanced Interrupt Controller (IRQ0) */
-#define AT91RM9200_ID_IRQ1	26	/* Advanced Interrupt Controller (IRQ1) */
-#define AT91RM9200_ID_IRQ2	27	/* Advanced Interrupt Controller (IRQ2) */
-#define AT91RM9200_ID_IRQ3	28	/* Advanced Interrupt Controller (IRQ3) */
-#define AT91RM9200_ID_IRQ4	29	/* Advanced Interrupt Controller (IRQ4) */
-#define AT91RM9200_ID_IRQ5	30	/* Advanced Interrupt Controller (IRQ5) */
-#define AT91RM9200_ID_IRQ6	31	/* Advanced Interrupt Controller (IRQ6) */
-
-
-/*
- * Peripheral physical base addresses.
- */
-#define AT91RM9200_BASE_TCB0	0xfffa0000
-#define AT91RM9200_BASE_TC0	0xfffa0000
-#define AT91RM9200_BASE_TC1	0xfffa0040
-#define AT91RM9200_BASE_TC2	0xfffa0080
-#define AT91RM9200_BASE_TCB1	0xfffa4000
-#define AT91RM9200_BASE_TC3	0xfffa4000
-#define AT91RM9200_BASE_TC4	0xfffa4040
-#define AT91RM9200_BASE_TC5	0xfffa4080
-#define AT91RM9200_BASE_UDP	0xfffb0000
-#define AT91RM9200_BASE_MCI	0xfffb4000
-#define AT91RM9200_BASE_TWI	0xfffb8000
-#define AT91RM9200_BASE_EMAC	0xfffbc000
-#define AT91RM9200_BASE_US0	0xfffc0000
-#define AT91RM9200_BASE_US1	0xfffc4000
-#define AT91RM9200_BASE_US2	0xfffc8000
-#define AT91RM9200_BASE_US3	0xfffcc000
-#define AT91RM9200_BASE_SSC0	0xfffd0000
-#define AT91RM9200_BASE_SSC1	0xfffd4000
-#define AT91RM9200_BASE_SSC2	0xfffd8000
-#define AT91RM9200_BASE_SPI	0xfffe0000
-
-
-/*
- * System Peripherals
- */
-#define AT91RM9200_BASE_DBGU	AT91_BASE_DBGU0	/* Debug Unit */
-#define AT91RM9200_BASE_PIOA	0xfffff400	/* PIO Controller A */
-#define AT91RM9200_BASE_PIOB	0xfffff600	/* PIO Controller B */
-#define AT91RM9200_BASE_PIOC	0xfffff800	/* PIO Controller C */
-#define AT91RM9200_BASE_PIOD	0xfffffa00	/* PIO Controller D */
-#define AT91RM9200_BASE_ST	0xfffffd00	/* System Timer */
-#define AT91RM9200_BASE_RTC	0xfffffe00	/* Real-Time Clock */
-#define AT91RM9200_BASE_MC	0xffffff00	/* Memory Controllers */
-
-/*
- * Internal Memory.
- */
-#define AT91RM9200_ROM_BASE	0x00100000	/* Internal ROM base address */
-#define AT91RM9200_ROM_SIZE	SZ_128K		/* Internal ROM size (128Kb) */
-
-#define AT91RM9200_SRAM_BASE	0x00200000	/* Internal SRAM base address */
-#define AT91RM9200_SRAM_SIZE	SZ_16K		/* Internal SRAM size (16Kb) */
-
-#define AT91RM9200_UHP_BASE	0x00300000	/* USB Host controller */
-
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9260.h b/arch/arm/mach-at91/include/mach/at91sam9260.h
deleted file mode 100644
index 416c7b6c56d3..000000000000
--- a/arch/arm/mach-at91/include/mach/at91sam9260.h
+++ /dev/null
@@ -1,129 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91sam9260.h
- *
- * (C) 2006 Andrew Victor
- *
- * Common definitions.
- * Based on AT91SAM9260 datasheet revision A (Preliminary).
- *
- * Includes also definitions for AT91SAM9XE and AT91SAM9G families
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91SAM9260_H
-#define AT91SAM9260_H
-
-/*
- * Peripheral identifiers/interrupts.
- */
-#define AT91SAM9260_ID_PIOA	2	/* Parallel IO Controller A */
-#define AT91SAM9260_ID_PIOB	3	/* Parallel IO Controller B */
-#define AT91SAM9260_ID_PIOC	4	/* Parallel IO Controller C */
-#define AT91SAM9260_ID_ADC	5	/* Analog-to-Digital Converter */
-#define AT91SAM9260_ID_US0	6	/* USART 0 */
-#define AT91SAM9260_ID_US1	7	/* USART 1 */
-#define AT91SAM9260_ID_US2	8	/* USART 2 */
-#define AT91SAM9260_ID_MCI	9	/* Multimedia Card Interface */
-#define AT91SAM9260_ID_UDP	10	/* USB Device Port */
-#define AT91SAM9260_ID_TWI	11	/* Two-Wire Interface */
-#define AT91SAM9260_ID_SPI0	12	/* Serial Peripheral Interface 0 */
-#define AT91SAM9260_ID_SPI1	13	/* Serial Peripheral Interface 1 */
-#define AT91SAM9260_ID_SSC	14	/* Serial Synchronous Controller */
-#define AT91SAM9260_ID_TC0	17	/* Timer Counter 0 */
-#define AT91SAM9260_ID_TC1	18	/* Timer Counter 1 */
-#define AT91SAM9260_ID_TC2	19	/* Timer Counter 2 */
-#define AT91SAM9260_ID_UHP	20	/* USB Host port */
-#define AT91SAM9260_ID_EMAC	21	/* Ethernet */
-#define AT91SAM9260_ID_ISI	22	/* Image Sensor Interface */
-#define AT91SAM9260_ID_US3	23	/* USART 3 */
-#define AT91SAM9260_ID_US4	24	/* USART 4 */
-#define AT91SAM9260_ID_US5	25	/* USART 5 */
-#define AT91SAM9260_ID_TC3	26	/* Timer Counter 3 */
-#define AT91SAM9260_ID_TC4	27	/* Timer Counter 4 */
-#define AT91SAM9260_ID_TC5	28	/* Timer Counter 5 */
-#define AT91SAM9260_ID_IRQ0	29	/* Advanced Interrupt Controller (IRQ0) */
-#define AT91SAM9260_ID_IRQ1	30	/* Advanced Interrupt Controller (IRQ1) */
-#define AT91SAM9260_ID_IRQ2	31	/* Advanced Interrupt Controller (IRQ2) */
-
-
-/*
- * User Peripheral physical base addresses.
- */
-#define AT91SAM9260_BASE_TCB0		0xfffa0000
-#define AT91SAM9260_BASE_TC0		0xfffa0000
-#define AT91SAM9260_BASE_TC1		0xfffa0040
-#define AT91SAM9260_BASE_TC2		0xfffa0080
-#define AT91SAM9260_BASE_UDP		0xfffa4000
-#define AT91SAM9260_BASE_MCI		0xfffa8000
-#define AT91SAM9260_BASE_TWI		0xfffac000
-#define AT91SAM9260_BASE_US0		0xfffb0000
-#define AT91SAM9260_BASE_US1		0xfffb4000
-#define AT91SAM9260_BASE_US2		0xfffb8000
-#define AT91SAM9260_BASE_SSC		0xfffbc000
-#define AT91SAM9260_BASE_ISI		0xfffc0000
-#define AT91SAM9260_BASE_EMAC		0xfffc4000
-#define AT91SAM9260_BASE_SPI0		0xfffc8000
-#define AT91SAM9260_BASE_SPI1		0xfffcc000
-#define AT91SAM9260_BASE_US3		0xfffd0000
-#define AT91SAM9260_BASE_US4		0xfffd4000
-#define AT91SAM9260_BASE_US5		0xfffd8000
-#define AT91SAM9260_BASE_TCB1		0xfffdc000
-#define AT91SAM9260_BASE_TC3		0xfffdc000
-#define AT91SAM9260_BASE_TC4		0xfffdc040
-#define AT91SAM9260_BASE_TC5		0xfffdc080
-#define AT91SAM9260_BASE_ADC		0xfffe0000
-
-/*
- * System Peripherals
- */
-#define AT91SAM9260_BASE_ECC	0xffffe800
-#define AT91SAM9260_BASE_SDRAMC	0xffffea00
-#define AT91SAM9260_BASE_SMC	0xffffec00
-#define AT91SAM9260_BASE_MATRIX	0xffffee00
-#define AT91SAM9260_BASE_DBGU	AT91_BASE_DBGU0
-#define AT91SAM9260_BASE_PIOA	0xfffff400
-#define AT91SAM9260_BASE_PIOB	0xfffff600
-#define AT91SAM9260_BASE_PIOC	0xfffff800
-#define AT91SAM9260_BASE_RSTC	0xfffffd00
-#define AT91SAM9260_BASE_SHDWC	0xfffffd10
-#define AT91SAM9260_BASE_RTT	0xfffffd20
-#define AT91SAM9260_BASE_PIT	0xfffffd30
-#define AT91SAM9260_BASE_WDT	0xfffffd40
-#define AT91SAM9260_BASE_GPBR	0xfffffd50
-
-
-/*
- * Internal Memory.
- */
-#define AT91SAM9260_ROM_BASE	0x00100000	/* Internal ROM base address */
-#define AT91SAM9260_ROM_SIZE	SZ_32K		/* Internal ROM size (32Kb) */
-
-#define AT91SAM9260_SRAM0_BASE	0x00200000	/* Internal SRAM 0 base address */
-#define AT91SAM9260_SRAM0_SIZE	SZ_4K		/* Internal SRAM 0 size (4Kb) */
-#define AT91SAM9260_SRAM1_BASE	0x00300000	/* Internal SRAM 1 base address */
-#define AT91SAM9260_SRAM1_SIZE	SZ_4K		/* Internal SRAM 1 size (4Kb) */
-#define AT91SAM9260_SRAM_BASE	0x002FF000	/* Internal SRAM base address */
-#define AT91SAM9260_SRAM_SIZE	SZ_8K		/* Internal SRAM size (8Kb) */
-
-#define AT91SAM9260_UHP_BASE	0x00500000	/* USB Host controller */
-
-#define AT91SAM9XE_FLASH_BASE	0x00200000	/* Internal FLASH base address */
-#define AT91SAM9XE_SRAM_BASE	0x00300000	/* Internal SRAM base address */
-
-#define AT91SAM9G20_ROM_BASE	0x00100000	/* Internal ROM base address */
-#define AT91SAM9G20_ROM_SIZE	SZ_32K		/* Internal ROM size (32Kb) */
-
-#define AT91SAM9G20_SRAM0_BASE	0x00200000	/* Internal SRAM 0 base address */
-#define AT91SAM9G20_SRAM0_SIZE	SZ_16K		/* Internal SRAM 0 size (16Kb) */
-#define AT91SAM9G20_SRAM1_BASE	0x00300000	/* Internal SRAM 1 base address */
-#define AT91SAM9G20_SRAM1_SIZE	SZ_16K		/* Internal SRAM 1 size (16Kb) */
-#define AT91SAM9G20_SRAM_BASE	0x002FC000	/* Internal SRAM base address */
-#define AT91SAM9G20_SRAM_SIZE	SZ_32K		/* Internal SRAM size (32Kb) */
-
-#define AT91SAM9G20_UHP_BASE	0x00500000	/* USB Host controller */
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9261.h b/arch/arm/mach-at91/include/mach/at91sam9261.h
deleted file mode 100644
index a041406d06ee..000000000000
--- a/arch/arm/mach-at91/include/mach/at91sam9261.h
+++ /dev/null
@@ -1,99 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91sam9261.h
- *
- * Copyright (C) SAN People
- *
- * Common definitions.
- * Based on AT91SAM9261 datasheet revision E. (Preliminary)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91SAM9261_H
-#define AT91SAM9261_H
-
-/*
- * Peripheral identifiers/interrupts.
- */
-#define AT91SAM9261_ID_PIOA	2	/* Parallel IO Controller A */
-#define AT91SAM9261_ID_PIOB	3	/* Parallel IO Controller B */
-#define AT91SAM9261_ID_PIOC	4	/* Parallel IO Controller C */
-#define AT91SAM9261_ID_US0	6	/* USART 0 */
-#define AT91SAM9261_ID_US1	7	/* USART 1 */
-#define AT91SAM9261_ID_US2	8	/* USART 2 */
-#define AT91SAM9261_ID_MCI	9	/* Multimedia Card Interface */
-#define AT91SAM9261_ID_UDP	10	/* USB Device Port */
-#define AT91SAM9261_ID_TWI	11	/* Two-Wire Interface */
-#define AT91SAM9261_ID_SPI0	12	/* Serial Peripheral Interface 0 */
-#define AT91SAM9261_ID_SPI1	13	/* Serial Peripheral Interface 1 */
-#define AT91SAM9261_ID_SSC0	14	/* Serial Synchronous Controller 0 */
-#define AT91SAM9261_ID_SSC1	15	/* Serial Synchronous Controller 1 */
-#define AT91SAM9261_ID_SSC2	16	/* Serial Synchronous Controller 2 */
-#define AT91SAM9261_ID_TC0	17	/* Timer Counter 0 */
-#define AT91SAM9261_ID_TC1	18	/* Timer Counter 1 */
-#define AT91SAM9261_ID_TC2	19	/* Timer Counter 2 */
-#define AT91SAM9261_ID_UHP	20	/* USB Host port */
-#define AT91SAM9261_ID_LCDC	21	/* LDC Controller */
-#define AT91SAM9261_ID_IRQ0	29	/* Advanced Interrupt Controller (IRQ0) */
-#define AT91SAM9261_ID_IRQ1	30	/* Advanced Interrupt Controller (IRQ1) */
-#define AT91SAM9261_ID_IRQ2	31	/* Advanced Interrupt Controller (IRQ2) */
-
-
-/*
- * User Peripheral physical base addresses.
- */
-#define AT91SAM9261_BASE_TCB0		0xfffa0000
-#define AT91SAM9261_BASE_TC0		0xfffa0000
-#define AT91SAM9261_BASE_TC1		0xfffa0040
-#define AT91SAM9261_BASE_TC2		0xfffa0080
-#define AT91SAM9261_BASE_UDP		0xfffa4000
-#define AT91SAM9261_BASE_MCI		0xfffa8000
-#define AT91SAM9261_BASE_TWI		0xfffac000
-#define AT91SAM9261_BASE_US0		0xfffb0000
-#define AT91SAM9261_BASE_US1		0xfffb4000
-#define AT91SAM9261_BASE_US2		0xfffb8000
-#define AT91SAM9261_BASE_SSC0		0xfffbc000
-#define AT91SAM9261_BASE_SSC1		0xfffc0000
-#define AT91SAM9261_BASE_SSC2		0xfffc4000
-#define AT91SAM9261_BASE_SPI0		0xfffc8000
-#define AT91SAM9261_BASE_SPI1		0xfffcc000
-
-
-/*
- * System Peripherals
- */
-#define AT91SAM9261_BASE_SMC	0xffffec00
-#define AT91SAM9261_BASE_MATRIX	0xffffee00
-#define AT91SAM9261_BASE_SDRAMC	0xffffea00
-#define AT91SAM9261_BASE_DBGU	AT91_BASE_DBGU0
-#define AT91SAM9261_BASE_PIOA	0xfffff400
-#define AT91SAM9261_BASE_PIOB	0xfffff600
-#define AT91SAM9261_BASE_PIOC	0xfffff800
-#define AT91SAM9261_BASE_RSTC	0xfffffd00
-#define AT91SAM9261_BASE_SHDWC	0xfffffd10
-#define AT91SAM9261_BASE_RTT	0xfffffd20
-#define AT91SAM9261_BASE_PIT	0xfffffd30
-#define AT91SAM9261_BASE_WDT	0xfffffd40
-#define AT91SAM9261_BASE_GPBR	0xfffffd50
-
-
-/*
- * Internal Memory.
- */
-#define AT91SAM9261_SRAM_BASE	0x00300000	/* Internal SRAM base address */
-#define AT91SAM9261_SRAM_SIZE	0x00028000	/* Internal SRAM size (160Kb) */
-
-#define AT91SAM9G10_SRAM_BASE	AT91SAM9261_SRAM_BASE	/* Internal SRAM base address */
-#define AT91SAM9G10_SRAM_SIZE	0x00004000	/* Internal SRAM size (16Kb) */
-
-#define AT91SAM9261_ROM_BASE	0x00400000	/* Internal ROM base address */
-#define AT91SAM9261_ROM_SIZE	SZ_32K		/* Internal ROM size (32Kb) */
-
-#define AT91SAM9261_UHP_BASE	0x00500000	/* USB Host controller */
-#define AT91SAM9261_LCDC_BASE	0x00600000	/* LDC controller */
-
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9263.h b/arch/arm/mach-at91/include/mach/at91sam9263.h
deleted file mode 100644
index d201029d60b3..000000000000
--- a/arch/arm/mach-at91/include/mach/at91sam9263.h
+++ /dev/null
@@ -1,117 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91sam9263.h
- *
- * (C) 2007 Atmel Corporation.
- *
- * Common definitions.
- * Based on AT91SAM9263 datasheet revision B (Preliminary).
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91SAM9263_H
-#define AT91SAM9263_H
-
-/*
- * Peripheral identifiers/interrupts.
- */
-#define AT91SAM9263_ID_PIOA	2	/* Parallel IO Controller A */
-#define AT91SAM9263_ID_PIOB	3	/* Parallel IO Controller B */
-#define AT91SAM9263_ID_PIOCDE	4	/* Parallel IO Controller C, D and E */
-#define AT91SAM9263_ID_US0	7	/* USART 0 */
-#define AT91SAM9263_ID_US1	8	/* USART 1 */
-#define AT91SAM9263_ID_US2	9	/* USART 2 */
-#define AT91SAM9263_ID_MCI0	10	/* Multimedia Card Interface 0 */
-#define AT91SAM9263_ID_MCI1	11	/* Multimedia Card Interface 1 */
-#define AT91SAM9263_ID_CAN	12	/* CAN */
-#define AT91SAM9263_ID_TWI	13	/* Two-Wire Interface */
-#define AT91SAM9263_ID_SPI0	14	/* Serial Peripheral Interface 0 */
-#define AT91SAM9263_ID_SPI1	15	/* Serial Peripheral Interface 1 */
-#define AT91SAM9263_ID_SSC0	16	/* Serial Synchronous Controller 0 */
-#define AT91SAM9263_ID_SSC1	17	/* Serial Synchronous Controller 1 */
-#define AT91SAM9263_ID_AC97C	18	/* AC97 Controller */
-#define AT91SAM9263_ID_TCB	19	/* Timer Counter 0, 1 and 2 */
-#define AT91SAM9263_ID_PWMC	20	/* Pulse Width Modulation Controller */
-#define AT91SAM9263_ID_EMAC	21	/* Ethernet */
-#define AT91SAM9263_ID_2DGE	23	/* 2D Graphic Engine */
-#define AT91SAM9263_ID_UDP	24	/* USB Device Port */
-#define AT91SAM9263_ID_ISI	25	/* Image Sensor Interface */
-#define AT91SAM9263_ID_LCDC	26	/* LCD Controller */
-#define AT91SAM9263_ID_DMA	27	/* DMA Controller */
-#define AT91SAM9263_ID_UHP	29	/* USB Host port */
-#define AT91SAM9263_ID_IRQ0	30	/* Advanced Interrupt Controller (IRQ0) */
-#define AT91SAM9263_ID_IRQ1	31	/* Advanced Interrupt Controller (IRQ1) */
-
-
-/*
- * User Peripheral physical base addresses.
- */
-#define AT91SAM9263_BASE_UDP		0xfff78000
-#define AT91SAM9263_BASE_TCB0		0xfff7c000
-#define AT91SAM9263_BASE_TC0		0xfff7c000
-#define AT91SAM9263_BASE_TC1		0xfff7c040
-#define AT91SAM9263_BASE_TC2		0xfff7c080
-#define AT91SAM9263_BASE_MCI0		0xfff80000
-#define AT91SAM9263_BASE_MCI1		0xfff84000
-#define AT91SAM9263_BASE_TWI		0xfff88000
-#define AT91SAM9263_BASE_US0		0xfff8c000
-#define AT91SAM9263_BASE_US1		0xfff90000
-#define AT91SAM9263_BASE_US2		0xfff94000
-#define AT91SAM9263_BASE_SSC0		0xfff98000
-#define AT91SAM9263_BASE_SSC1		0xfff9c000
-#define AT91SAM9263_BASE_AC97C		0xfffa0000
-#define AT91SAM9263_BASE_SPI0		0xfffa4000
-#define AT91SAM9263_BASE_SPI1		0xfffa8000
-#define AT91SAM9263_BASE_CAN		0xfffac000
-#define AT91SAM9263_BASE_PWMC		0xfffb8000
-#define AT91SAM9263_BASE_EMAC		0xfffbc000
-#define AT91SAM9263_BASE_ISI		0xfffc4000
-#define AT91SAM9263_BASE_2DGE		0xfffc8000
-
-/*
- * System Peripherals
- */
-#define AT91SAM9263_BASE_ECC0	0xffffe000
-#define AT91SAM9263_BASE_SDRAMC0 0xffffe200
-#define AT91SAM9263_BASE_SMC0	0xffffe400
-#define AT91SAM9263_BASE_ECC1	0xffffe600
-#define AT91SAM9263_BASE_SDRAMC1 0xffffe800
-#define AT91SAM9263_BASE_SMC1	0xffffea00
-#define AT91SAM9263_BASE_MATRIX	0xffffec00
-#define AT91SAM9263_BASE_DBGU	AT91_BASE_DBGU1
-#define AT91SAM9263_BASE_PIOA	0xfffff200
-#define AT91SAM9263_BASE_PIOB	0xfffff400
-#define AT91SAM9263_BASE_PIOC	0xfffff600
-#define AT91SAM9263_BASE_PIOD	0xfffff800
-#define AT91SAM9263_BASE_PIOE	0xfffffa00
-#define AT91SAM9263_BASE_RSTC	0xfffffd00
-#define AT91SAM9263_BASE_SHDWC	0xfffffd10
-#define AT91SAM9263_BASE_RTT0	0xfffffd20
-#define AT91SAM9263_BASE_PIT	0xfffffd30
-#define AT91SAM9263_BASE_WDT	0xfffffd40
-#define AT91SAM9263_BASE_RTT1	0xfffffd50
-#define AT91SAM9263_BASE_GPBR	0xfffffd60
-
-#define AT91_SMC	AT91_SMC0
-
-/*
- * Internal Memory.
- */
-#define AT91SAM9263_SRAM0_BASE	0x00300000	/* Internal SRAM 0 base address */
-#define AT91SAM9263_SRAM0_SIZE	(80 * SZ_1K)	/* Internal SRAM 0 size (80Kb) */
-
-#define AT91SAM9263_ROM_BASE	0x00400000	/* Internal ROM base address */
-#define AT91SAM9263_ROM_SIZE	SZ_128K		/* Internal ROM size (128Kb) */
-
-#define AT91SAM9263_SRAM1_BASE	0x00500000	/* Internal SRAM 1 base address */
-#define AT91SAM9263_SRAM1_SIZE	SZ_16K		/* Internal SRAM 1 size (16Kb) */
-
-#define AT91SAM9263_LCDC_BASE	0x00700000	/* LCD Controller */
-#define AT91SAM9263_DMAC_BASE	0x00800000	/* DMA Controller */
-#define AT91SAM9263_UHP_BASE	0x00a00000	/* USB Host controller */
-
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45.h b/arch/arm/mach-at91/include/mach/at91sam9g45.h
deleted file mode 100644
index 8eba1021f533..000000000000
--- a/arch/arm/mach-at91/include/mach/at91sam9g45.h
+++ /dev/null
@@ -1,143 +0,0 @@
-/*
- * Chip-specific header file for the AT91SAM9G45 family
- *
- *  Copyright (C) 2008-2009 Atmel Corporation.
- *
- * Common definitions.
- * Based on AT91SAM9G45 preliminary datasheet.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef AT91SAM9G45_H
-#define AT91SAM9G45_H
-
-/*
- * Peripheral identifiers/interrupts.
- */
-#define AT91SAM9G45_ID_PIOA	2	/* Parallel I/O Controller A */
-#define AT91SAM9G45_ID_PIOB	3	/* Parallel I/O Controller B */
-#define AT91SAM9G45_ID_PIOC	4	/* Parallel I/O Controller C */
-#define AT91SAM9G45_ID_PIODE	5	/* Parallel I/O Controller D and E */
-#define AT91SAM9G45_ID_TRNG	6	/* True Random Number Generator */
-#define AT91SAM9G45_ID_US0	7	/* USART 0 */
-#define AT91SAM9G45_ID_US1	8	/* USART 1 */
-#define AT91SAM9G45_ID_US2	9	/* USART 2 */
-#define AT91SAM9G45_ID_US3	10	/* USART 3 */
-#define AT91SAM9G45_ID_MCI0	11	/* High Speed Multimedia Card Interface 0 */
-#define AT91SAM9G45_ID_TWI0	12	/* Two-Wire Interface 0 */
-#define AT91SAM9G45_ID_TWI1	13	/* Two-Wire Interface 1 */
-#define AT91SAM9G45_ID_SPI0	14	/* Serial Peripheral Interface 0 */
-#define AT91SAM9G45_ID_SPI1	15	/* Serial Peripheral Interface 1 */
-#define AT91SAM9G45_ID_SSC0	16	/* Synchronous Serial Controller 0 */
-#define AT91SAM9G45_ID_SSC1	17	/* Synchronous Serial Controller 1 */
-#define AT91SAM9G45_ID_TCB	18	/* Timer Counter 0, 1, 2, 3, 4 and 5 */
-#define AT91SAM9G45_ID_PWMC	19	/* Pulse Width Modulation Controller */
-#define AT91SAM9G45_ID_TSC	20	/* Touch Screen ADC Controller */
-#define AT91SAM9G45_ID_DMA	21	/* DMA Controller */
-#define AT91SAM9G45_ID_UHPHS	22	/* USB Host High Speed */
-#define AT91SAM9G45_ID_LCDC	23	/* LCD Controller */
-#define AT91SAM9G45_ID_AC97C	24	/* AC97 Controller */
-#define AT91SAM9G45_ID_EMAC	25	/* Ethernet MAC */
-#define AT91SAM9G45_ID_ISI	26	/* Image Sensor Interface */
-#define AT91SAM9G45_ID_UDPHS	27	/* USB Device High Speed */
-#define AT91SAM9G45_ID_AESTDESSHA 28	/* AES + T-DES + SHA */
-#define AT91SAM9G45_ID_MCI1	29	/* High Speed Multimedia Card Interface 1 */
-#define AT91SAM9G45_ID_VDEC	30	/* Video Decoder */
-#define AT91SAM9G45_ID_IRQ0	31	/* Advanced Interrupt Controller */
-
-/*
- * User Peripheral physical base addresses.
- */
-#define AT91SAM9G45_BASE_UDPHS		0xfff78000
-#define AT91SAM9G45_BASE_TCB0		0xfff7c000
-#define AT91SAM9G45_BASE_TC0		0xfff7c000
-#define AT91SAM9G45_BASE_TC1		0xfff7c040
-#define AT91SAM9G45_BASE_TC2		0xfff7c080
-#define AT91SAM9G45_BASE_MCI0		0xfff80000
-#define AT91SAM9G45_BASE_TWI0		0xfff84000
-#define AT91SAM9G45_BASE_TWI1		0xfff88000
-#define AT91SAM9G45_BASE_US0		0xfff8c000
-#define AT91SAM9G45_BASE_US1		0xfff90000
-#define AT91SAM9G45_BASE_US2		0xfff94000
-#define AT91SAM9G45_BASE_US3		0xfff98000
-#define AT91SAM9G45_BASE_SSC0		0xfff9c000
-#define AT91SAM9G45_BASE_SSC1		0xfffa0000
-#define AT91SAM9G45_BASE_SPI0		0xfffa4000
-#define AT91SAM9G45_BASE_SPI1		0xfffa8000
-#define AT91SAM9G45_BASE_AC97C		0xfffac000
-#define AT91SAM9G45_BASE_TSC		0xfffb0000
-#define AT91SAM9G45_BASE_ISI		0xfffb4000
-#define AT91SAM9G45_BASE_PWMC		0xfffb8000
-#define AT91SAM9G45_BASE_EMAC		0xfffbc000
-#define AT91SAM9G45_BASE_AES		0xfffc0000
-#define AT91SAM9G45_BASE_TDES		0xfffc4000
-#define AT91SAM9G45_BASE_SHA		0xfffc8000
-#define AT91SAM9G45_BASE_TRNG		0xfffcc000
-#define AT91SAM9G45_BASE_MCI1		0xfffd0000
-#define AT91SAM9G45_BASE_TCB1		0xfffd4000
-#define AT91SAM9G45_BASE_TC3		0xfffd4000
-#define AT91SAM9G45_BASE_TC4		0xfffd4040
-#define AT91SAM9G45_BASE_TC5		0xfffd4080
-
-/*
- * System Peripherals
- */
-#define AT91SAM9G45_BASE_ECC	0xffffe200
-#define AT91SAM9G45_BASE_DDRSDRC1 0xffffe400
-#define AT91SAM9G45_BASE_DDRSDRC0 0xffffe600
-#define AT91SAM9G45_BASE_DMA	0xffffec00
-#define AT91SAM9G45_BASE_SMC	0xffffe800
-#define AT91SAM9G45_BASE_MATRIX	0xffffea00
-#define AT91SAM9G45_BASE_DBGU	AT91_BASE_DBGU1
-#define AT91SAM9G45_BASE_PIOA	0xfffff200
-#define AT91SAM9G45_BASE_PIOB	0xfffff400
-#define AT91SAM9G45_BASE_PIOC	0xfffff600
-#define AT91SAM9G45_BASE_PIOD	0xfffff800
-#define AT91SAM9G45_BASE_PIOE	0xfffffa00
-#define AT91SAM9G45_BASE_RSTC	0xfffffd00
-#define AT91SAM9G45_BASE_SHDWC	0xfffffd10
-#define AT91SAM9G45_BASE_RTT	0xfffffd20
-#define AT91SAM9G45_BASE_PIT	0xfffffd30
-#define AT91SAM9G45_BASE_WDT	0xfffffd40
-#define AT91SAM9G45_BASE_RTC	0xfffffdb0
-#define AT91SAM9G45_BASE_GPBR	0xfffffd60
-
-/*
- * Internal Memory.
- */
-#define AT91SAM9G45_SRAM_BASE	0x00300000	/* Internal SRAM base address */
-#define AT91SAM9G45_SRAM_SIZE	SZ_64K		/* Internal SRAM size (64Kb) */
-
-#define AT91SAM9G45_ROM_BASE	0x00400000	/* Internal ROM base address */
-#define AT91SAM9G45_ROM_SIZE	SZ_64K		/* Internal ROM size (64Kb) */
-
-#define AT91SAM9G45_LCDC_BASE	0x00500000	/* LCD Controller */
-#define AT91SAM9G45_UDPHS_FIFO	0x00600000	/* USB Device HS controller */
-#define AT91SAM9G45_OHCI_BASE	0x00700000	/* USB Host controller (OHCI) */
-#define AT91SAM9G45_EHCI_BASE	0x00800000	/* USB Host controller (EHCI) */
-#define AT91SAM9G45_VDEC_BASE	0x00900000	/* Video Decoder Controller */
-
-/*
- * DMA peripheral identifiers
- * for hardware handshaking interface
- */
-#define AT_DMA_ID_MCI0		 0
-#define AT_DMA_ID_SPI0_TX	 1
-#define AT_DMA_ID_SPI0_RX	 2
-#define AT_DMA_ID_SPI1_TX	 3
-#define AT_DMA_ID_SPI1_RX	 4
-#define AT_DMA_ID_SSC0_TX	 5
-#define AT_DMA_ID_SSC0_RX	 6
-#define AT_DMA_ID_SSC1_TX	 7
-#define AT_DMA_ID_SSC1_RX	 8
-#define AT_DMA_ID_AC97_TX	 9
-#define AT_DMA_ID_AC97_RX	10
-#define AT_DMA_ID_AES_TX	11
-#define AT_DMA_ID_AES_RX	12
-#define AT_DMA_ID_MCI1		13
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9n12.h b/arch/arm/mach-at91/include/mach/at91sam9n12.h
deleted file mode 100644
index 0151bcf6163c..000000000000
--- a/arch/arm/mach-at91/include/mach/at91sam9n12.h
+++ /dev/null
@@ -1,65 +0,0 @@
-/*
- * SoC specific header file for the AT91SAM9N12
- *
- * Copyright (C) 2012 Atmel Corporation
- *
- * Common definitions, based on AT91SAM9N12 SoC datasheet
- *
- * Licensed under GPLv2 or later
- */
-
-#ifndef _AT91SAM9N12_H_
-#define _AT91SAM9N12_H_
-
-/*
- * Peripheral identifiers/interrupts.
- */
-#define AT91SAM9N12_ID_PIOAB	2	/* Parallel I/O Controller A and B */
-#define AT91SAM9N12_ID_PIOCD	3	/* Parallel I/O Controller C and D */
-#define AT91SAM9N12_ID_FUSE	4	/* FUSE Controller */
-#define AT91SAM9N12_ID_USART0	5	/* USART 0 */
-#define AT91SAM9N12_ID_USART1	6	/* USART 1 */
-#define AT91SAM9N12_ID_USART2	7	/* USART 2 */
-#define AT91SAM9N12_ID_USART3	8	/* USART 3 */
-#define AT91SAM9N12_ID_TWI0	9	/* Two-Wire Interface 0 */
-#define AT91SAM9N12_ID_TWI1	10	/* Two-Wire Interface 1 */
-#define AT91SAM9N12_ID_MCI	12	/* High Speed Multimedia Card Interface */
-#define AT91SAM9N12_ID_SPI0	13	/* Serial Peripheral Interface 0 */
-#define AT91SAM9N12_ID_SPI1	14	/* Serial Peripheral Interface 1 */
-#define AT91SAM9N12_ID_UART0	15	/* UART 0 */
-#define AT91SAM9N12_ID_UART1	16	/* UART 1 */
-#define AT91SAM9N12_ID_TCB	17	/* Timer Counter 0, 1, 2, 3, 4 and 5 */
-#define AT91SAM9N12_ID_PWM	18	/* Pulse Width Modulation Controller */
-#define AT91SAM9N12_ID_ADC	19	/* ADC Controller */
-#define AT91SAM9N12_ID_DMA	20	/* DMA Controller */
-#define AT91SAM9N12_ID_UHP	22	/* USB Host High Speed */
-#define AT91SAM9N12_ID_UDP	23	/* USB Device High Speed */
-#define AT91SAM9N12_ID_LCDC	25	/* LCD Controller */
-#define AT91SAM9N12_ID_ISI	25	/* Image Sensor Interface */
-#define AT91SAM9N12_ID_SSC	28	/* Synchronous Serial Controller */
-#define AT91SAM9N12_ID_TRNG	30	/* TRNG */
-#define AT91SAM9N12_ID_IRQ0	31	/* Advanced Interrupt Controller */
-
-/*
- * User Peripheral physical base addresses.
- */
-#define AT91SAM9N12_BASE_USART0	0xf801c000
-#define AT91SAM9N12_BASE_USART1	0xf8020000
-#define AT91SAM9N12_BASE_USART2	0xf8024000
-#define AT91SAM9N12_BASE_USART3	0xf8028000
-
-/*
- * System Peripherals
- */
-#define AT91SAM9N12_BASE_RTC	0xfffffeb0
-
-/*
- * Internal Memory.
- */
-#define AT91SAM9N12_SRAM_BASE	0x00300000	/* Internal SRAM base address */
-#define AT91SAM9N12_SRAM_SIZE	SZ_32K		/* Internal SRAM size (32Kb) */
-
-#define AT91SAM9N12_ROM_BASE	0x00100000	/* Internal ROM base address */
-#define AT91SAM9N12_ROM_SIZE	SZ_128K		/* Internal ROM size (128Kb) */
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9rl.h b/arch/arm/mach-at91/include/mach/at91sam9rl.h
deleted file mode 100644
index a15db56d33fa..000000000000
--- a/arch/arm/mach-at91/include/mach/at91sam9rl.h
+++ /dev/null
@@ -1,105 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/at91sam9260.h
- *
- *  Copyright (C) 2007 Atmel Corporation
- *
- * Common definitions.
- * Based on AT91SAM9RL datasheet revision A. (Preliminary)
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive for
- * more details.
- */
-
-#ifndef AT91SAM9RL_H
-#define AT91SAM9RL_H
-
-/*
- * Peripheral identifiers/interrupts.
- */
-#define AT91SAM9RL_ID_PIOA	2	/* Parallel IO Controller A */
-#define AT91SAM9RL_ID_PIOB	3	/* Parallel IO Controller B */
-#define AT91SAM9RL_ID_PIOC	4	/* Parallel IO Controller C */
-#define AT91SAM9RL_ID_PIOD	5	/* Parallel IO Controller D */
-#define AT91SAM9RL_ID_US0	6	/* USART 0 */
-#define AT91SAM9RL_ID_US1	7	/* USART 1 */
-#define AT91SAM9RL_ID_US2	8	/* USART 2 */
-#define AT91SAM9RL_ID_US3	9	/* USART 3 */
-#define AT91SAM9RL_ID_MCI	10	/* Multimedia Card Interface */
-#define AT91SAM9RL_ID_TWI0	11	/* TWI 0 */
-#define AT91SAM9RL_ID_TWI1	12	/* TWI 1 */
-#define AT91SAM9RL_ID_SPI	13	/* Serial Peripheral Interface */
-#define AT91SAM9RL_ID_SSC0	14	/* Serial Synchronous Controller 0 */
-#define AT91SAM9RL_ID_SSC1	15	/* Serial Synchronous Controller 1 */
-#define AT91SAM9RL_ID_TC0	16	/* Timer Counter 0 */
-#define AT91SAM9RL_ID_TC1	17	/* Timer Counter 1 */
-#define AT91SAM9RL_ID_TC2	18	/* Timer Counter 2 */
-#define AT91SAM9RL_ID_PWMC	19	/* Pulse Width Modulation Controller */
-#define AT91SAM9RL_ID_TSC	20	/* Touch Screen Controller */
-#define AT91SAM9RL_ID_DMA	21	/* DMA Controller */
-#define AT91SAM9RL_ID_UDPHS	22	/* USB Device HS */
-#define AT91SAM9RL_ID_LCDC	23	/* LCD Controller */
-#define AT91SAM9RL_ID_AC97C	24	/* AC97 Controller */
-#define AT91SAM9RL_ID_IRQ0	31	/* Advanced Interrupt Controller (IRQ0) */
-
-
-/*
- * User Peripheral physical base addresses.
- */
-#define AT91SAM9RL_BASE_TCB0	0xfffa0000
-#define AT91SAM9RL_BASE_TC0	0xfffa0000
-#define AT91SAM9RL_BASE_TC1	0xfffa0040
-#define AT91SAM9RL_BASE_TC2	0xfffa0080
-#define AT91SAM9RL_BASE_MCI	0xfffa4000
-#define AT91SAM9RL_BASE_TWI0	0xfffa8000
-#define AT91SAM9RL_BASE_TWI1	0xfffac000
-#define AT91SAM9RL_BASE_US0	0xfffb0000
-#define AT91SAM9RL_BASE_US1	0xfffb4000
-#define AT91SAM9RL_BASE_US2	0xfffb8000
-#define AT91SAM9RL_BASE_US3	0xfffbc000
-#define AT91SAM9RL_BASE_SSC0	0xfffc0000
-#define AT91SAM9RL_BASE_SSC1	0xfffc4000
-#define AT91SAM9RL_BASE_PWMC	0xfffc8000
-#define AT91SAM9RL_BASE_SPI	0xfffcc000
-#define AT91SAM9RL_BASE_TSC	0xfffd0000
-#define AT91SAM9RL_BASE_UDPHS	0xfffd4000
-#define AT91SAM9RL_BASE_AC97C	0xfffd8000
-
-
-/*
- * System Peripherals (offset from AT91_BASE_SYS)
- */
-#define AT91_SCKCR	(0xfffffd50 - AT91_BASE_SYS)
-
-#define AT91SAM9RL_BASE_DMA	0xffffe600
-#define AT91SAM9RL_BASE_ECC	0xffffe800
-#define AT91SAM9RL_BASE_SDRAMC	0xffffea00
-#define AT91SAM9RL_BASE_SMC	0xffffec00
-#define AT91SAM9RL_BASE_MATRIX	0xffffee00
-#define AT91SAM9RL_BASE_DBGU	AT91_BASE_DBGU0
-#define AT91SAM9RL_BASE_PIOA	0xfffff400
-#define AT91SAM9RL_BASE_PIOB	0xfffff600
-#define AT91SAM9RL_BASE_PIOC	0xfffff800
-#define AT91SAM9RL_BASE_PIOD	0xfffffa00
-#define AT91SAM9RL_BASE_RSTC	0xfffffd00
-#define AT91SAM9RL_BASE_SHDWC	0xfffffd10
-#define AT91SAM9RL_BASE_RTT	0xfffffd20
-#define AT91SAM9RL_BASE_PIT	0xfffffd30
-#define AT91SAM9RL_BASE_WDT	0xfffffd40
-#define AT91SAM9RL_BASE_GPBR	0xfffffd60
-#define AT91SAM9RL_BASE_RTC	0xfffffe00
-
-
-/*
- * Internal Memory.
- */
-#define AT91SAM9RL_SRAM_BASE	0x00300000	/* Internal SRAM base address */
-#define AT91SAM9RL_SRAM_SIZE	SZ_16K		/* Internal SRAM size (16Kb) */
-
-#define AT91SAM9RL_ROM_BASE	0x00400000	/* Internal ROM base address */
-#define AT91SAM9RL_ROM_SIZE	(2 * SZ_16K)	/* Internal ROM size (32Kb) */
-
-#define AT91SAM9RL_LCDC_BASE	0x00500000	/* LCD Controller */
-#define AT91SAM9RL_UDPHS_FIFO	0x00600000	/* USB Device HS controller */
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9x5.h b/arch/arm/mach-at91/include/mach/at91sam9x5.h
deleted file mode 100644
index 2fc76c49e97c..000000000000
--- a/arch/arm/mach-at91/include/mach/at91sam9x5.h
+++ /dev/null
@@ -1,71 +0,0 @@
-/*
- * Chip-specific header file for the AT91SAM9x5 family
- *
- *  Copyright (C) 2009-2012 Atmel Corporation.
- *
- * Common definitions.
- * Based on AT91SAM9x5 datasheet.
- *
- * Licensed under GPLv2 or later.
- */
-
-#ifndef AT91SAM9X5_H
-#define AT91SAM9X5_H
-
-/*
- * Peripheral identifiers/interrupts.
- */
-#define AT91SAM9X5_ID_PIOAB	2	/* Parallel I/O Controller A and B */
-#define AT91SAM9X5_ID_PIOCD	3	/* Parallel I/O Controller C and D */
-#define AT91SAM9X5_ID_SMD	4	/* SMD Soft Modem (SMD) */
-#define AT91SAM9X5_ID_USART0	5	/* USART 0 */
-#define AT91SAM9X5_ID_USART1	6	/* USART 1 */
-#define AT91SAM9X5_ID_USART2	7	/* USART 2 */
-#define AT91SAM9X5_ID_USART3	8	/* USART 3 */
-#define AT91SAM9X5_ID_TWI0	9	/* Two-Wire Interface 0 */
-#define AT91SAM9X5_ID_TWI1	10	/* Two-Wire Interface 1 */
-#define AT91SAM9X5_ID_TWI2	11	/* Two-Wire Interface 2 */
-#define AT91SAM9X5_ID_MCI0	12	/* High Speed Multimedia Card Interface 0 */
-#define AT91SAM9X5_ID_SPI0	13	/* Serial Peripheral Interface 0 */
-#define AT91SAM9X5_ID_SPI1	14	/* Serial Peripheral Interface 1 */
-#define AT91SAM9X5_ID_UART0	15	/* UART 0 */
-#define AT91SAM9X5_ID_UART1	16	/* UART 1 */
-#define AT91SAM9X5_ID_TCB	17	/* Timer Counter 0, 1, 2, 3, 4 and 5 */
-#define AT91SAM9X5_ID_PWM	18	/* Pulse Width Modulation Controller */
-#define AT91SAM9X5_ID_ADC	19	/* ADC Controller */
-#define AT91SAM9X5_ID_DMA0	20	/* DMA Controller 0 */
-#define AT91SAM9X5_ID_DMA1	21	/* DMA Controller 1 */
-#define AT91SAM9X5_ID_UHPHS	22	/* USB Host High Speed */
-#define AT91SAM9X5_ID_UDPHS	23	/* USB Device High Speed */
-#define AT91SAM9X5_ID_EMAC0	24	/* Ethernet MAC0 */
-#define AT91SAM9X5_ID_LCDC	25	/* LCD Controller */
-#define AT91SAM9X5_ID_ISI	25	/* Image Sensor Interface */
-#define AT91SAM9X5_ID_MCI1	26	/* High Speed Multimedia Card Interface 1 */
-#define AT91SAM9X5_ID_EMAC1	27	/* Ethernet MAC1 */
-#define AT91SAM9X5_ID_SSC	28	/* Synchronous Serial Controller */
-#define AT91SAM9X5_ID_CAN0	29	/* CAN Controller 0 */
-#define AT91SAM9X5_ID_CAN1	30	/* CAN Controller 1 */
-#define AT91SAM9X5_ID_IRQ0	31	/* Advanced Interrupt Controller */
-
-/*
- * User Peripheral physical base addresses.
- */
-#define AT91SAM9X5_BASE_USART0	0xf801c000
-#define AT91SAM9X5_BASE_USART1	0xf8020000
-#define AT91SAM9X5_BASE_USART2	0xf8024000
-
-/*
- * System Peripherals
- */
-#define AT91SAM9X5_BASE_RTC	0xfffffeb0
-
-/*
- * Internal Memory.
- */
-#define AT91SAM9X5_SRAM_BASE	0x00300000	/* Internal SRAM base address */
-#define AT91SAM9X5_SRAM_SIZE	SZ_32K		/* Internal SRAM size (32Kb) */
-
-#define AT91SAM9X5_ROM_BASE	0x00400000	/* Internal ROM base address */
-#define AT91SAM9X5_ROM_SIZE	SZ_64K		/* Internal ROM size (64Kb) */
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
index cacbaa52418f..2f8ce2d69fdb 100644
--- a/arch/arm/mach-at91/include/mach/hardware.h
+++ b/arch/arm/mach-at91/include/mach/hardware.h
@@ -24,17 +24,6 @@
 /* sama5d4 */
 #define AT91_BASE_DBGU2	0xfc069000
 
-#include <mach/at91rm9200.h>
-#include <mach/at91sam9260.h>
-#include <mach/at91sam9261.h>
-#include <mach/at91sam9263.h>
-#include <mach/at91sam9rl.h>
-#include <mach/at91sam9g45.h>
-#include <mach/at91sam9x5.h>
-#include <mach/at91sam9n12.h>
-#include <mach/sama5d3.h>
-#include <mach/sama5d4.h>
-
 /*
  * On all at91 except rm9200 and x40 have the System Controller starts
  * at address 0xffffc000 and has a size of 16KiB.
diff --git a/arch/arm/mach-at91/include/mach/sama5d3.h b/arch/arm/mach-at91/include/mach/sama5d3.h
deleted file mode 100644
index 25613d8c6dcd..000000000000
--- a/arch/arm/mach-at91/include/mach/sama5d3.h
+++ /dev/null
@@ -1,86 +0,0 @@
-/*
- * Chip-specific header file for the SAMA5D3 family
- *
- *  Copyright (C) 2013 Atmel,
- *                2013 Ludovic Desroches <ludovic.desroches@atmel.com>
- *
- * Common definitions.
- * Based on SAMA5D3 datasheet.
- *
- * Licensed under GPLv2 or later.
- */
-
-#ifndef SAMA5D3_H
-#define SAMA5D3_H
-
-/*
- * Peripheral identifiers/interrupts.
- */
-#define AT91_ID_FIQ		 0	/* Advanced Interrupt Controller (FIQ) */
-#define AT91_ID_SYS		 1	/* System Peripherals */
-#define SAMA5D3_ID_DBGU		 2	/* debug Unit (usually no special interrupt line) */
-#define AT91_ID_PIT		 3	/* PIT */
-#define SAMA5D3_ID_WDT		 4	/* Watchdog Timer Interrupt */
-#define SAMA5D3_ID_HSMC		 5	/* Static Memory Controller */
-#define SAMA5D3_ID_PIOA		 6	/* PIOA */
-#define SAMA5D3_ID_PIOB		 7	/* PIOB */
-#define SAMA5D3_ID_PIOC		 8	/* PIOC */
-#define SAMA5D3_ID_PIOD		 9	/* PIOD */
-#define SAMA5D3_ID_PIOE		10	/* PIOE */
-#define SAMA5D3_ID_SMD		11	/* SMD Soft Modem */
-#define SAMA5D3_ID_USART0	12	/* USART0 */
-#define SAMA5D3_ID_USART1	13	/* USART1 */
-#define SAMA5D3_ID_USART2	14	/* USART2 */
-#define SAMA5D3_ID_USART3	15	/* USART3 */
-#define SAMA5D3_ID_UART0	16	/* UART 0 */
-#define SAMA5D3_ID_UART1	17	/* UART 1 */
-#define SAMA5D3_ID_TWI0		18	/* Two-Wire Interface 0 */
-#define SAMA5D3_ID_TWI1		19	/* Two-Wire Interface 1 */
-#define SAMA5D3_ID_TWI2		20	/* Two-Wire Interface 2 */
-#define SAMA5D3_ID_HSMCI0	21	/* MCI */
-#define SAMA5D3_ID_HSMCI1	22	/* MCI */
-#define SAMA5D3_ID_HSMCI2	23	/* MCI */
-#define SAMA5D3_ID_SPI0		24	/* Serial Peripheral Interface 0 */
-#define SAMA5D3_ID_SPI1		25	/* Serial Peripheral Interface 1 */
-#define SAMA5D3_ID_TC0		26	/* Timer Counter 0 */
-#define SAMA5D3_ID_TC1		27	/* Timer Counter 2 */
-#define SAMA5D3_ID_PWM		28	/* Pulse Width Modulation Controller */
-#define SAMA5D3_ID_ADC		29	/* Touch Screen ADC Controller */
-#define SAMA5D3_ID_DMA0		30	/* DMA Controller 0 */
-#define SAMA5D3_ID_DMA1		31	/* DMA Controller 1 */
-#define SAMA5D3_ID_UHPHS	32	/* USB Host High Speed */
-#define SAMA5D3_ID_UDPHS	33	/* USB Device High Speed */
-#define SAMA5D3_ID_GMAC		34	/* Gigabit Ethernet MAC */
-#define SAMA5D3_ID_EMAC		35	/* Ethernet MAC */
-#define SAMA5D3_ID_LCDC		36	/* LCD Controller */
-#define SAMA5D3_ID_ISI		37	/* Image Sensor Interface */
-#define SAMA5D3_ID_SSC0		38	/* Synchronous Serial Controller 0 */
-#define SAMA5D3_ID_SSC1		39	/* Synchronous Serial Controller 1 */
-#define SAMA5D3_ID_CAN0		40	/* CAN Controller 0 */
-#define SAMA5D3_ID_CAN1		41	/* CAN Controller 1 */
-#define SAMA5D3_ID_SHA		42	/* Secure Hash Algorithm */
-#define SAMA5D3_ID_AES		43	/* Advanced Encryption Standard */
-#define SAMA5D3_ID_TDES		44	/* Triple Data Encryption Standard */
-#define SAMA5D3_ID_TRNG		45	/* True Random Generator Number */
-#define SAMA5D3_ID_IRQ0		47	/* Advanced Interrupt Controller (IRQ0) */
-
-/*
- * User Peripheral physical base addresses.
- */
-#define SAMA5D3_BASE_USART0	0xf001c000
-#define SAMA5D3_BASE_USART1	0xf0020000
-#define SAMA5D3_BASE_USART2	0xf8020000
-#define SAMA5D3_BASE_USART3	0xf8024000
-
-/*
- * System Peripherals
- */
-#define SAMA5D3_BASE_RTC	0xfffffeb0
-
-/*
- * Internal Memory
- */
-#define SAMA5D3_SRAM_BASE	0x00300000	/* Internal SRAM base address */
-#define SAMA5D3_SRAM_SIZE	(128 * SZ_1K)	/* Internal SRAM size (128Kb) */
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/sama5d4.h b/arch/arm/mach-at91/include/mach/sama5d4.h
deleted file mode 100644
index f256a45d9854..000000000000
--- a/arch/arm/mach-at91/include/mach/sama5d4.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Chip-specific header file for the SAMA5D4 family
- *
- *  Copyright (C) 2013 Atmel Corporation,
- *                     Nicolas Ferre <nicolas.ferre@atmel.com>
- *
- * Common definitions.
- * Based on SAMA5D4 datasheet.
- *
- * Licensed under GPLv2 or later.
- */
-
-#ifndef SAMA5D4_H
-#define SAMA5D4_H
-
-/*
- * User Peripheral physical base addresses.
- */
-#define SAMA5D4_BASE_USART3	0xfc00c000 /* (USART3 non-secure) Base Address */
-#define SAMA5D4_BASE_PMC	0xf0018000 /* (PMC) Base Address */
-#define SAMA5D4_BASE_MPDDRC	0xf0010000 /* (MPDDRC) Base Address */
-#define SAMA5D4_BASE_PIOD	0xfc068000 /* (PIOD) Base Address */
-
-/* Some other peripherals */
-#define SAMA5D4_BASE_SYS2	SAMA5D4_BASE_PIOD
-
-/*
- * Internal Memory.
- */
-#define SAMA5D4_NS_SRAM_BASE     0x00210000      /* Internal SRAM base address Non-Secure */
-#define SAMA5D4_NS_SRAM_SIZE     (64 * SZ_1K)   /* Internal SRAM size Non-Secure part (64Kb) */
-
-#endif
-- 
2.1.0

