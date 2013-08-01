Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3HAGwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:52:25 -0400
Received: from 3.mo2.mail-out.ovh.net ([46.105.58.226]:38640 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751108Ab3HAGwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:52:24 -0400
X-Greylist: delayed 2111 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Aug 2013 02:52:23 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH 1/8] ARM: at91: move peripheral id definitions to dt-bindings include dir
Date: Thu,  1 Aug 2013 08:52:13 +0200
Message-Id: <1375339933-3643-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 476818612084242540
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves peripheral id definitions from machine specific include
dir (arch/arm/mach-at91/include/mach/'soc-name'.h) to dt-bindinds include
dir (include/dt-bindings/at91/'soc-name'/peripherals.h).

These definitions will be used inside dt to define interrupt ids and
peripheral clk ids.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/include/mach/at91rm9200.h       |   31 +---------
 arch/arm/mach-at91/include/mach/at91sam9260.h      |   29 +--------
 arch/arm/mach-at91/include/mach/at91sam9261.h      |   23 +------
 arch/arm/mach-at91/include/mach/at91sam9263.h      |   27 +--------
 arch/arm/mach-at91/include/mach/at91sam9g45.h      |   31 +---------
 arch/arm/mach-at91/include/mach/at91sam9n12.h      |   26 +-------
 arch/arm/mach-at91/include/mach/at91sam9rl.h       |   25 +-------
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |   32 +---------
 arch/arm/mach-at91/include/mach/hardware.h         |    3 +-
 arch/arm/mach-at91/include/mach/sama5d3.h          |   48 +--------------
 include/dt-bindings/at91/at91rm9200/peripherals.h  |   44 ++++++++++++++
 include/dt-bindings/at91/at91sam9260/peripherals.h |   42 +++++++++++++
 include/dt-bindings/at91/at91sam9261/peripherals.h |   36 +++++++++++
 include/dt-bindings/at91/at91sam9263/peripherals.h |   40 +++++++++++++
 include/dt-bindings/at91/at91sam9g45/peripherals.h |   44 ++++++++++++++
 include/dt-bindings/at91/at91sam9n12/peripherals.h |   41 +++++++++++++
 include/dt-bindings/at91/at91sam9rl/peripherals.h  |   38 ++++++++++++
 include/dt-bindings/at91/at91sam9x5/peripherals.h  |   45 ++++++++++++++
 include/dt-bindings/at91/common/peripherals.h      |   14 +++++
 include/dt-bindings/at91/sama5d3/peripherals.h     |   63 ++++++++++++++++++++
 20 files changed, 417 insertions(+), 265 deletions(-)
 create mode 100644 include/dt-bindings/at91/at91rm9200/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9260/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9261/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9263/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9g45/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9n12/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9rl/peripherals.h
 create mode 100644 include/dt-bindings/at91/at91sam9x5/peripherals.h
 create mode 100644 include/dt-bindings/at91/common/peripherals.h
 create mode 100644 include/dt-bindings/at91/sama5d3/peripherals.h

diff --git a/arch/arm/mach-at91/include/mach/at91rm9200.h b/arch/arm/mach-at91/include/mach/at91rm9200.h
index e67317c..975b587 100644
--- a/arch/arm/mach-at91/include/mach/at91rm9200.h
+++ b/arch/arm/mach-at91/include/mach/at91rm9200.h
@@ -19,36 +19,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
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
+#include <dt-bindings/at91/at91rm9200/peripherals.h>
 
 
 /*
diff --git a/arch/arm/mach-at91/include/mach/at91sam9260.h b/arch/arm/mach-at91/include/mach/at91sam9260.h
index 416c7b6..7eb4ae0 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9260.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9260.h
@@ -20,34 +20,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
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
+#include <dt-bindings/at91/at91sam9260/peripherals.h>
 
 
 /*
diff --git a/arch/arm/mach-at91/include/mach/at91sam9261.h b/arch/arm/mach-at91/include/mach/at91sam9261.h
index a041406..0cb62a3 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9261.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9261.h
@@ -18,28 +18,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
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
+#include <dt-bindings/at91/at91sam9261/peripherals.h>
 
 
 /*
diff --git a/arch/arm/mach-at91/include/mach/at91sam9263.h b/arch/arm/mach-at91/include/mach/at91sam9263.h
index d201029..991ca66 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9263.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9263.h
@@ -18,32 +18,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
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
+#include <dt-bindings/at91/at91sam9263/peripherals.h>
 
 
 /*
diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45.h b/arch/arm/mach-at91/include/mach/at91sam9g45.h
index 8eba102..3f1a509 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9g45.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9g45.h
@@ -18,36 +18,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
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
+#include <dt-bindings/at91/at91sam9263/peripherals.h>
 
 /*
  * User Peripheral physical base addresses.
diff --git a/arch/arm/mach-at91/include/mach/at91sam9n12.h b/arch/arm/mach-at91/include/mach/at91sam9n12.h
index d374b87..a78f203 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9n12.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9n12.h
@@ -14,31 +14,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
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
+#include <dt-bindings/at91/at91sam9n12/peripherals.h>
 
 /*
  * User Peripheral physical base addresses.
diff --git a/arch/arm/mach-at91/include/mach/at91sam9rl.h b/arch/arm/mach-at91/include/mach/at91sam9rl.h
index a15db56..efe5d60 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9rl.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9rl.h
@@ -17,30 +17,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
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
+#include <dt-bindings/at91/at91sam9rl/peripherals.h>
 
 
 /*
diff --git a/arch/arm/mach-at91/include/mach/at91sam9x5.h b/arch/arm/mach-at91/include/mach/at91sam9x5.h
index c75ee19..7e4b029 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9x5.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9x5.h
@@ -15,37 +15,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
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
+#include <dt-bindings/at91/at91sam9x5/peripherals.h>
 
 /*
  * User Peripheral physical base addresses.
diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
index a832e07..588135a 100644
--- a/arch/arm/mach-at91/include/mach/hardware.h
+++ b/arch/arm/mach-at91/include/mach/hardware.h
@@ -58,8 +58,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
-#define AT91_ID_FIQ		0	/* Advanced Interrupt Controller (FIQ) */
-#define AT91_ID_SYS		1	/* System Peripherals */
+#include <dt-bindings/at91/common/peripherals.h>
 
 #ifdef CONFIG_MMU
 /*
diff --git a/arch/arm/mach-at91/include/mach/sama5d3.h b/arch/arm/mach-at91/include/mach/sama5d3.h
index 6dc81ee..8155be4 100644
--- a/arch/arm/mach-at91/include/mach/sama5d3.h
+++ b/arch/arm/mach-at91/include/mach/sama5d3.h
@@ -16,53 +16,7 @@
 /*
  * Peripheral identifiers/interrupts.
  */
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
+#include <dt-bindings/at91/sama5d3/peripherals.h>
 
 /*
  * Internal Memory
diff --git a/include/dt-bindings/at91/at91rm9200/peripherals.h b/include/dt-bindings/at91/at91rm9200/peripherals.h
new file mode 100644
index 0000000..769bd71
--- /dev/null
+++ b/include/dt-bindings/at91/at91rm9200/peripherals.h
@@ -0,0 +1,44 @@
+/*
+ * This header define at91rm9200 peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_AT91RM9200_PERIPH_H
+#define _DT_BINDINGS_AT91RM9200_PERIPH_H
+
+#include <dt-bindings/at91/common/peripherals.h>
+
+#define AT91RM9200_ID_PIOA	2	/* Parallel IO Controller A */
+#define AT91RM9200_ID_PIOB	3	/* Parallel IO Controller B */
+#define AT91RM9200_ID_PIOC	4	/* Parallel IO Controller C */
+#define AT91RM9200_ID_PIOD	5	/* Parallel IO Controller D */
+#define AT91RM9200_ID_US0	6	/* USART 0 */
+#define AT91RM9200_ID_US1	7	/* USART 1 */
+#define AT91RM9200_ID_US2	8	/* USART 2 */
+#define AT91RM9200_ID_US3	9	/* USART 3 */
+#define AT91RM9200_ID_MCI	10	/* Multimedia Card Interface */
+#define AT91RM9200_ID_UDP	11	/* USB Device Port */
+#define AT91RM9200_ID_TWI	12	/* Two-Wire Interface */
+#define AT91RM9200_ID_SPI	13	/* Serial Peripheral Interface */
+#define AT91RM9200_ID_SSC0	14	/* Serial Synchronous Controller 0 */
+#define AT91RM9200_ID_SSC1	15	/* Serial Synchronous Controller 1 */
+#define AT91RM9200_ID_SSC2	16	/* Serial Synchronous Controller 2 */
+#define AT91RM9200_ID_TC0	17	/* Timer Counter 0 */
+#define AT91RM9200_ID_TC1	18	/* Timer Counter 1 */
+#define AT91RM9200_ID_TC2	19	/* Timer Counter 2 */
+#define AT91RM9200_ID_TC3	20	/* Timer Counter 3 */
+#define AT91RM9200_ID_TC4	21	/* Timer Counter 4 */
+#define AT91RM9200_ID_TC5	22	/* Timer Counter 5 */
+#define AT91RM9200_ID_UHP	23	/* USB Host port */
+#define AT91RM9200_ID_EMAC	24	/* Ethernet MAC */
+#define AT91RM9200_ID_IRQ0	25	/* Advanced Interrupt Controller (IRQ0) */
+#define AT91RM9200_ID_IRQ1	26	/* Advanced Interrupt Controller (IRQ1) */
+#define AT91RM9200_ID_IRQ2	27	/* Advanced Interrupt Controller (IRQ2) */
+#define AT91RM9200_ID_IRQ3	28	/* Advanced Interrupt Controller (IRQ3) */
+#define AT91RM9200_ID_IRQ4	29	/* Advanced Interrupt Controller (IRQ4) */
+#define AT91RM9200_ID_IRQ5	30	/* Advanced Interrupt Controller (IRQ5) */
+#define AT91RM9200_ID_IRQ6	31	/* Advanced Interrupt Controller (IRQ6) */
+
+#endif
diff --git a/include/dt-bindings/at91/at91sam9260/peripherals.h b/include/dt-bindings/at91/at91sam9260/peripherals.h
new file mode 100644
index 0000000..d01db78
--- /dev/null
+++ b/include/dt-bindings/at91/at91sam9260/peripherals.h
@@ -0,0 +1,42 @@
+/*
+ * This header define at91sam9260 peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_AT91SAM9260_PERIPH_H
+#define _DT_BINDINGS_AT91SAM9260_PERIPH_H
+
+#include <dt-bindings/at91/common/peripherals.h>
+
+#define AT91SAM9260_ID_PIOA	2	/* Parallel IO Controller A */
+#define AT91SAM9260_ID_PIOB	3	/* Parallel IO Controller B */
+#define AT91SAM9260_ID_PIOC	4	/* Parallel IO Controller C */
+#define AT91SAM9260_ID_ADC	5	/* Analog-to-Digital Converter */
+#define AT91SAM9260_ID_US0	6	/* USART 0 */
+#define AT91SAM9260_ID_US1	7	/* USART 1 */
+#define AT91SAM9260_ID_US2	8	/* USART 2 */
+#define AT91SAM9260_ID_MCI	9	/* Multimedia Card Interface */
+#define AT91SAM9260_ID_UDP	10	/* USB Device Port */
+#define AT91SAM9260_ID_TWI	11	/* Two-Wire Interface */
+#define AT91SAM9260_ID_SPI0	12	/* Serial Peripheral Interface 0 */
+#define AT91SAM9260_ID_SPI1	13	/* Serial Peripheral Interface 1 */
+#define AT91SAM9260_ID_SSC	14	/* Serial Synchronous Controller */
+#define AT91SAM9260_ID_TC0	17	/* Timer Counter 0 */
+#define AT91SAM9260_ID_TC1	18	/* Timer Counter 1 */
+#define AT91SAM9260_ID_TC2	19	/* Timer Counter 2 */
+#define AT91SAM9260_ID_UHP	20	/* USB Host port */
+#define AT91SAM9260_ID_EMAC	21	/* Ethernet */
+#define AT91SAM9260_ID_ISI	22	/* Image Sensor Interface */
+#define AT91SAM9260_ID_US3	23	/* USART 3 */
+#define AT91SAM9260_ID_US4	24	/* USART 4 */
+#define AT91SAM9260_ID_US5	25	/* USART 5 */
+#define AT91SAM9260_ID_TC3	26	/* Timer Counter 3 */
+#define AT91SAM9260_ID_TC4	27	/* Timer Counter 4 */
+#define AT91SAM9260_ID_TC5	28	/* Timer Counter 5 */
+#define AT91SAM9260_ID_IRQ0	29	/* Advanced Interrupt Controller (IRQ0) */
+#define AT91SAM9260_ID_IRQ1	30	/* Advanced Interrupt Controller (IRQ1) */
+#define AT91SAM9260_ID_IRQ2	31	/* Advanced Interrupt Controller (IRQ2) */
+
+#endif
diff --git a/include/dt-bindings/at91/at91sam9261/peripherals.h b/include/dt-bindings/at91/at91sam9261/peripherals.h
new file mode 100644
index 0000000..1fa717c
--- /dev/null
+++ b/include/dt-bindings/at91/at91sam9261/peripherals.h
@@ -0,0 +1,36 @@
+/*
+ * This header define at91sam9261 peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_AT91SAM9261_PERIPH_H
+#define _DT_BINDINGS_AT91SAM9261_PERIPH_H
+
+#include <dt-bindings/at91/common/peripherals.h>
+
+#define AT91SAM9261_ID_PIOA	2	/* Parallel IO Controller A */
+#define AT91SAM9261_ID_PIOB	3	/* Parallel IO Controller B */
+#define AT91SAM9261_ID_PIOC	4	/* Parallel IO Controller C */
+#define AT91SAM9261_ID_US0	6	/* USART 0 */
+#define AT91SAM9261_ID_US1	7	/* USART 1 */
+#define AT91SAM9261_ID_US2	8	/* USART 2 */
+#define AT91SAM9261_ID_MCI	9	/* Multimedia Card Interface */
+#define AT91SAM9261_ID_UDP	10	/* USB Device Port */
+#define AT91SAM9261_ID_TWI	11	/* Two-Wire Interface */
+#define AT91SAM9261_ID_SPI0	12	/* Serial Peripheral Interface 0 */
+#define AT91SAM9261_ID_SPI1	13	/* Serial Peripheral Interface 1 */
+#define AT91SAM9261_ID_SSC0	14	/* Serial Synchronous Controller 0 */
+#define AT91SAM9261_ID_SSC1	15	/* Serial Synchronous Controller 1 */
+#define AT91SAM9261_ID_SSC2	16	/* Serial Synchronous Controller 2 */
+#define AT91SAM9261_ID_TC0	17	/* Timer Counter 0 */
+#define AT91SAM9261_ID_TC1	18	/* Timer Counter 1 */
+#define AT91SAM9261_ID_TC2	19	/* Timer Counter 2 */
+#define AT91SAM9261_ID_UHP	20	/* USB Host port */
+#define AT91SAM9261_ID_LCDC	21	/* LDC Controller */
+#define AT91SAM9261_ID_IRQ0	29	/* Advanced Interrupt Controller (IRQ0) */
+#define AT91SAM9261_ID_IRQ1	30	/* Advanced Interrupt Controller (IRQ1) */
+#define AT91SAM9261_ID_IRQ2	31	/* Advanced Interrupt Controller (IRQ2) */
+
+#endif
diff --git a/include/dt-bindings/at91/at91sam9263/peripherals.h b/include/dt-bindings/at91/at91sam9263/peripherals.h
new file mode 100644
index 0000000..7495e9c
--- /dev/null
+++ b/include/dt-bindings/at91/at91sam9263/peripherals.h
@@ -0,0 +1,40 @@
+/*
+ * This header define at91sam9263 peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_AT91SAM9263_PERIPH_H
+#define _DT_BINDINGS_AT91SAM9263_PERIPH_H
+
+#include <dt-bindings/at91/common/peripherals.h>
+
+#define AT91SAM9263_ID_PIOA	2	/* Parallel IO Controller A */
+#define AT91SAM9263_ID_PIOB	3	/* Parallel IO Controller B */
+#define AT91SAM9263_ID_PIOCDE	4	/* Parallel IO Controller C, D and E */
+#define AT91SAM9263_ID_US0	7	/* USART 0 */
+#define AT91SAM9263_ID_US1	8	/* USART 1 */
+#define AT91SAM9263_ID_US2	9	/* USART 2 */
+#define AT91SAM9263_ID_MCI0	10	/* Multimedia Card Interface 0 */
+#define AT91SAM9263_ID_MCI1	11	/* Multimedia Card Interface 1 */
+#define AT91SAM9263_ID_CAN	12	/* CAN */
+#define AT91SAM9263_ID_TWI	13	/* Two-Wire Interface */
+#define AT91SAM9263_ID_SPI0	14	/* Serial Peripheral Interface 0 */
+#define AT91SAM9263_ID_SPI1	15	/* Serial Peripheral Interface 1 */
+#define AT91SAM9263_ID_SSC0	16	/* Serial Synchronous Controller 0 */
+#define AT91SAM9263_ID_SSC1	17	/* Serial Synchronous Controller 1 */
+#define AT91SAM9263_ID_AC97C	18	/* AC97 Controller */
+#define AT91SAM9263_ID_TCB	19	/* Timer Counter 0, 1 and 2 */
+#define AT91SAM9263_ID_PWMC	20	/* Pulse Width Modulation Controller */
+#define AT91SAM9263_ID_EMAC	21	/* Ethernet */
+#define AT91SAM9263_ID_2DGE	23	/* 2D Graphic Engine */
+#define AT91SAM9263_ID_UDP	24	/* USB Device Port */
+#define AT91SAM9263_ID_ISI	25	/* Image Sensor Interface */
+#define AT91SAM9263_ID_LCDC	26	/* LCD Controller */
+#define AT91SAM9263_ID_DMA	27	/* DMA Controller */
+#define AT91SAM9263_ID_UHP	29	/* USB Host port */
+#define AT91SAM9263_ID_IRQ0	30	/* Advanced Interrupt Controller (IRQ0) */
+#define AT91SAM9263_ID_IRQ1	31	/* Advanced Interrupt Controller (IRQ1) */
+
+#endif
diff --git a/include/dt-bindings/at91/at91sam9g45/peripherals.h b/include/dt-bindings/at91/at91sam9g45/peripherals.h
new file mode 100644
index 0000000..9fc405d
--- /dev/null
+++ b/include/dt-bindings/at91/at91sam9g45/peripherals.h
@@ -0,0 +1,44 @@
+/*
+ * This header define at91sam9g45 peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_AT91SAM9G45_PERIPH_H
+#define _DT_BINDINGS_AT91SAM9G45_PERIPH_H
+
+#include <dt-bindings/at91/common/peripherals.h>
+
+#define AT91SAM9G45_ID_PIOA	2	/* Parallel I/O Controller A */
+#define AT91SAM9G45_ID_PIOB	3	/* Parallel I/O Controller B */
+#define AT91SAM9G45_ID_PIOC	4	/* Parallel I/O Controller C */
+#define AT91SAM9G45_ID_PIODE	5	/* Parallel I/O Controller D and E */
+#define AT91SAM9G45_ID_TRNG	6	/* True Random Number Generator */
+#define AT91SAM9G45_ID_US0	7	/* USART 0 */
+#define AT91SAM9G45_ID_US1	8	/* USART 1 */
+#define AT91SAM9G45_ID_US2	9	/* USART 2 */
+#define AT91SAM9G45_ID_US3	10	/* USART 3 */
+#define AT91SAM9G45_ID_MCI0	11	/* High Speed Multimedia Card Interface 0 */
+#define AT91SAM9G45_ID_TWI0	12	/* Two-Wire Interface 0 */
+#define AT91SAM9G45_ID_TWI1	13	/* Two-Wire Interface 1 */
+#define AT91SAM9G45_ID_SPI0	14	/* Serial Peripheral Interface 0 */
+#define AT91SAM9G45_ID_SPI1	15	/* Serial Peripheral Interface 1 */
+#define AT91SAM9G45_ID_SSC0	16	/* Synchronous Serial Controller 0 */
+#define AT91SAM9G45_ID_SSC1	17	/* Synchronous Serial Controller 1 */
+#define AT91SAM9G45_ID_TCB	18	/* Timer Counter 0, 1, 2, 3, 4 and 5 */
+#define AT91SAM9G45_ID_PWMC	19	/* Pulse Width Modulation Controller */
+#define AT91SAM9G45_ID_TSC	20	/* Touch Screen ADC Controller */
+#define AT91SAM9G45_ID_DMA	21	/* DMA Controller */
+#define AT91SAM9G45_ID_UHPHS	22	/* USB Host High Speed */
+#define AT91SAM9G45_ID_LCDC	23	/* LCD Controller */
+#define AT91SAM9G45_ID_AC97C	24	/* AC97 Controller */
+#define AT91SAM9G45_ID_EMAC	25	/* Ethernet MAC */
+#define AT91SAM9G45_ID_ISI	26	/* Image Sensor Interface */
+#define AT91SAM9G45_ID_UDPHS	27	/* USB Device High Speed */
+#define AT91SAM9G45_ID_AESTDESSHA 28	/* AES + T-DES + SHA */
+#define AT91SAM9G45_ID_MCI1	29	/* High Speed Multimedia Card Interface 1 */
+#define AT91SAM9G45_ID_VDEC	30	/* Video Decoder */
+#define AT91SAM9G45_ID_IRQ0	31	/* Advanced Interrupt Controller */
+
+#endif
diff --git a/include/dt-bindings/at91/at91sam9n12/peripherals.h b/include/dt-bindings/at91/at91sam9n12/peripherals.h
new file mode 100644
index 0000000..be9e1f6
--- /dev/null
+++ b/include/dt-bindings/at91/at91sam9n12/peripherals.h
@@ -0,0 +1,41 @@
+/*
+ * This header define at91sam9n12 peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_AT91SAM9N12_PERIPH_H
+#define _DT_BINDINGS_AT91SAM9N12_PERIPH_H
+
+#include <dt-bindings/at91/common/peripherals.h>
+
+#define AT91SAM9N12_ID_PIOAB	2	/* Parallel I/O Controller A and B */
+#define AT91SAM9N12_ID_PIOCD	3	/* Parallel I/O Controller C and D */
+#define AT91SAM9N12_ID_FUSE	4	/* FUSE Controller */
+#define AT91SAM9N12_ID_USART0	5	/* USART 0 */
+#define AT91SAM9N12_ID_USART1	6	/* USART 1 */
+#define AT91SAM9N12_ID_USART2	7	/* USART 2 */
+#define AT91SAM9N12_ID_USART3	8	/* USART 3 */
+#define AT91SAM9N12_ID_TWI0	9	/* Two-Wire Interface 0 */
+#define AT91SAM9N12_ID_TWI1	10	/* Two-Wire Interface 1 */
+#define AT91SAM9N12_ID_MCI	12	/* High Speed Multimedia Card Interface */
+#define AT91SAM9N12_ID_SPI0	13	/* Serial Peripheral Interface 0 */
+#define AT91SAM9N12_ID_SPI1	14	/* Serial Peripheral Interface 1 */
+#define AT91SAM9N12_ID_UART0	15	/* UART 0 */
+#define AT91SAM9N12_ID_UART1	16	/* UART 1 */
+#define AT91SAM9N12_ID_TCB	17	/* Timer Counter 0, 1, 2, 3, 4 and 5 */
+#define AT91SAM9N12_ID_PWM	18	/* Pulse Width Modulation Controller */
+#define AT91SAM9N12_ID_ADC	19	/* ADC Controller */
+#define AT91SAM9N12_ID_DMA	20	/* DMA Controller */
+#define AT91SAM9N12_ID_UHP	22	/* USB Host High Speed */
+#define AT91SAM9N12_ID_UDP	23	/* USB Device High Speed */
+#define AT91SAM9N12_ID_LCDC	25	/* LCD Controller */
+#define AT91SAM9N12_ID_ISI	25	/* Image Sensor Interface */
+#define AT91SAM9N12_ID_SHA	27	/* Secure Hash Algorithm */
+#define AT91SAM9N12_ID_SSC	28	/* Synchronous Serial Controller */
+#define AT91SAM9N12_ID_AES	29	/* Advanced Encryption Standard */
+#define AT91SAM9N12_ID_TRNG	30	/* TRNG */
+#define AT91SAM9N12_ID_IRQ0	31	/* Advanced Interrupt Controller */
+
+#endif
diff --git a/include/dt-bindings/at91/at91sam9rl/peripherals.h b/include/dt-bindings/at91/at91sam9rl/peripherals.h
new file mode 100644
index 0000000..6cc7279
--- /dev/null
+++ b/include/dt-bindings/at91/at91sam9rl/peripherals.h
@@ -0,0 +1,38 @@
+/*
+ * This header define at91sam9rl peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_AT91SAM9RL_PERIPH_H
+#define _DT_BINDINGS_AT91SAM9RL_PERIPH_H
+
+#include <dt-bindings/at91/common/peripherals.h>
+
+#define AT91SAM9RL_ID_PIOA	2	/* Parallel IO Controller A */
+#define AT91SAM9RL_ID_PIOB	3	/* Parallel IO Controller B */
+#define AT91SAM9RL_ID_PIOC	4	/* Parallel IO Controller C */
+#define AT91SAM9RL_ID_PIOD	5	/* Parallel IO Controller D */
+#define AT91SAM9RL_ID_US0	6	/* USART 0 */
+#define AT91SAM9RL_ID_US1	7	/* USART 1 */
+#define AT91SAM9RL_ID_US2	8	/* USART 2 */
+#define AT91SAM9RL_ID_US3	9	/* USART 3 */
+#define AT91SAM9RL_ID_MCI	10	/* Multimedia Card Interface */
+#define AT91SAM9RL_ID_TWI0	11	/* TWI 0 */
+#define AT91SAM9RL_ID_TWI1	12	/* TWI 1 */
+#define AT91SAM9RL_ID_SPI	13	/* Serial Peripheral Interface */
+#define AT91SAM9RL_ID_SSC0	14	/* Serial Synchronous Controller 0 */
+#define AT91SAM9RL_ID_SSC1	15	/* Serial Synchronous Controller 1 */
+#define AT91SAM9RL_ID_TC0	16	/* Timer Counter 0 */
+#define AT91SAM9RL_ID_TC1	17	/* Timer Counter 1 */
+#define AT91SAM9RL_ID_TC2	18	/* Timer Counter 2 */
+#define AT91SAM9RL_ID_PWMC	19	/* Pulse Width Modulation Controller */
+#define AT91SAM9RL_ID_TSC	20	/* Touch Screen Controller */
+#define AT91SAM9RL_ID_DMA	21	/* DMA Controller */
+#define AT91SAM9RL_ID_UDPHS	22	/* USB Device HS */
+#define AT91SAM9RL_ID_LCDC	23	/* LCD Controller */
+#define AT91SAM9RL_ID_AC97C	24	/* AC97 Controller */
+#define AT91SAM9RL_ID_IRQ0	31	/* Advanced Interrupt Controller (IRQ0) */
+
+#endif
diff --git a/include/dt-bindings/at91/at91sam9x5/peripherals.h b/include/dt-bindings/at91/at91sam9x5/peripherals.h
new file mode 100644
index 0000000..bf5b7b6
--- /dev/null
+++ b/include/dt-bindings/at91/at91sam9x5/peripherals.h
@@ -0,0 +1,45 @@
+/*
+ * This header define at91sam9x5 peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_AT91SAM9X5_PERIPH_H
+#define _DT_BINDINGS_AT91SAM9X5_PERIPH_H
+
+#include <dt-bindings/at91/common/peripherals.h>
+
+#define AT91SAM9X5_ID_PIOAB	2	/* Parallel I/O Controller A and B */
+#define AT91SAM9X5_ID_PIOCD	3	/* Parallel I/O Controller C and D */
+#define AT91SAM9X5_ID_SMD	4	/* SMD Soft Modem (SMD) */
+#define AT91SAM9X5_ID_USART0	5	/* USART 0 */
+#define AT91SAM9X5_ID_USART1	6	/* USART 1 */
+#define AT91SAM9X5_ID_USART2	7	/* USART 2 */
+#define AT91SAM9X5_ID_USART3	8	/* USART 3 */
+#define AT91SAM9X5_ID_TWI0	9	/* Two-Wire Interface 0 */
+#define AT91SAM9X5_ID_TWI1	10	/* Two-Wire Interface 1 */
+#define AT91SAM9X5_ID_TWI2	11	/* Two-Wire Interface 2 */
+#define AT91SAM9X5_ID_MCI0	12	/* High Speed Multimedia Card Interface 0 */
+#define AT91SAM9X5_ID_SPI0	13	/* Serial Peripheral Interface 0 */
+#define AT91SAM9X5_ID_SPI1	14	/* Serial Peripheral Interface 1 */
+#define AT91SAM9X5_ID_UART0	15	/* UART 0 */
+#define AT91SAM9X5_ID_UART1	16	/* UART 1 */
+#define AT91SAM9X5_ID_TCB	17	/* Timer Counter 0, 1, 2, 3, 4 and 5 */
+#define AT91SAM9X5_ID_PWM	18	/* Pulse Width Modulation Controller */
+#define AT91SAM9X5_ID_ADC	19	/* ADC Controller */
+#define AT91SAM9X5_ID_DMA0	20	/* DMA Controller 0 */
+#define AT91SAM9X5_ID_DMA1	21	/* DMA Controller 1 */
+#define AT91SAM9X5_ID_UHPHS	22	/* USB Host High Speed */
+#define AT91SAM9X5_ID_UDPHS	23	/* USB Device High Speed */
+#define AT91SAM9X5_ID_EMAC0	24	/* Ethernet MAC0 */
+#define AT91SAM9X5_ID_LCDC	25	/* LCD Controller */
+#define AT91SAM9X5_ID_ISI	25	/* Image Sensor Interface */
+#define AT91SAM9X5_ID_MCI1	26	/* High Speed Multimedia Card Interface 1 */
+#define AT91SAM9X5_ID_EMAC1	27	/* Ethernet MAC1 */
+#define AT91SAM9X5_ID_SSC	28	/* Synchronous Serial Controller */
+#define AT91SAM9X5_ID_CAN0	29	/* CAN Controller 0 */
+#define AT91SAM9X5_ID_CAN1	30	/* CAN Controller 1 */
+#define AT91SAM9X5_ID_IRQ0	31	/* Advanced Interrupt Controller */
+
+#endif
diff --git a/include/dt-bindings/at91/common/peripherals.h b/include/dt-bindings/at91/common/peripherals.h
new file mode 100644
index 0000000..ca8f1f4
--- /dev/null
+++ b/include/dt-bindings/at91/common/peripherals.h
@@ -0,0 +1,14 @@
+/*
+ * This header define at91 common peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_AT91_PERIPH_H
+#define _DT_BINDINGS_AT91_PERIPH_H
+
+#define AT91_ID_FIQ	0	/* Advanced Interrupt Controller (FIQ) */
+#define AT91_ID_SYS	1	/* System Peripherals */
+
+#endif
diff --git a/include/dt-bindings/at91/sama5d3/peripherals.h b/include/dt-bindings/at91/sama5d3/peripherals.h
new file mode 100644
index 0000000..9177c3f
--- /dev/null
+++ b/include/dt-bindings/at91/sama5d3/peripherals.h
@@ -0,0 +1,63 @@
+/*
+ * This header define sama5d3 peripheral ids.
+ *
+ * The constants defined in this header are being used in dts
+ * and at91 machine specific code.
+ */
+
+#ifndef _DT_BINDINGS_SAMA5D3_PERIPH_H
+#define _DT_BINDINGS_SAMA5D3_PERIPH_H
+
+#include <dt-bindings/at91/common/peripherals.h>
+
+#define AT91_ID_FIQ		 0	/* Advanced Interrupt Controller (FIQ) */
+#define AT91_ID_SYS		 1	/* System Peripherals */
+#define SAMA5D3_ID_DBGU		 2	/* debug Unit (usually no special interrupt line) */
+#define AT91_ID_PIT		 3	/* PIT */
+#define SAMA5D3_ID_WDT		 4	/* Watchdog Timer Interrupt */
+#define SAMA5D3_ID_HSMC		 5	/* Static Memory Controller */
+#define SAMA5D3_ID_PIOA		 6	/* PIOA */
+#define SAMA5D3_ID_PIOB		 7	/* PIOB */
+#define SAMA5D3_ID_PIOC		 8	/* PIOC */
+#define SAMA5D3_ID_PIOD		 9	/* PIOD */
+#define SAMA5D3_ID_PIOE		10	/* PIOE */
+#define SAMA5D3_ID_SMD		11	/* SMD Soft Modem */
+#define SAMA5D3_ID_USART0	12	/* USART0 */
+#define SAMA5D3_ID_USART1	13	/* USART1 */
+#define SAMA5D3_ID_USART2	14	/* USART2 */
+#define SAMA5D3_ID_USART3	15	/* USART3 */
+#define SAMA5D3_ID_UART0	16	/* UART 0 */
+#define SAMA5D3_ID_UART1	17	/* UART 1 */
+#define SAMA5D3_ID_TWI0		18	/* Two-Wire Interface 0 */
+#define SAMA5D3_ID_TWI1		19	/* Two-Wire Interface 1 */
+#define SAMA5D3_ID_TWI2		20	/* Two-Wire Interface 2 */
+#define SAMA5D3_ID_HSMCI0	21	/* MCI */
+#define SAMA5D3_ID_HSMCI1	22	/* MCI */
+#define SAMA5D3_ID_HSMCI2	23	/* MCI */
+#define SAMA5D3_ID_SPI0		24	/* Serial Peripheral Interface 0 */
+#define SAMA5D3_ID_SPI1		25	/* Serial Peripheral Interface 1 */
+#define SAMA5D3_ID_TC0		26	/* Timer Counter 0 */
+#define SAMA5D3_ID_TC1		27	/* Timer Counter 2 */
+#define SAMA5D3_ID_PWM		28	/* Pulse Width Modulation Controller */
+#define SAMA5D3_ID_ADC		29	/* Touch Screen ADC Controller */
+#define SAMA5D3_ID_DMA0		30	/* DMA Controller 0 */
+#define SAMA5D3_ID_DMA1		31	/* DMA Controller 1 */
+#define SAMA5D3_ID_UHPHS	32	/* USB Host High Speed */
+#define SAMA5D3_ID_UDPHS	33	/* USB Device High Speed */
+#define SAMA5D3_ID_GMAC		34	/* Gigabit Ethernet MAC */
+#define SAMA5D3_ID_EMAC		35	/* Ethernet MAC */
+#define SAMA5D3_ID_LCDC		36	/* LCD Controller */
+#define SAMA5D3_ID_ISI		37	/* Image Sensor Interface */
+#define SAMA5D3_ID_SSC0		38	/* Synchronous Serial Controller 0 */
+#define SAMA5D3_ID_SSC1		39	/* Synchronous Serial Controller 1 */
+#define SAMA5D3_ID_CAN0		40	/* CAN Controller 0 */
+#define SAMA5D3_ID_CAN1		41	/* CAN Controller 1 */
+#define SAMA5D3_ID_SHA		42	/* Secure Hash Algorithm */
+#define SAMA5D3_ID_AES		43	/* Advanced Encryption Standard */
+#define SAMA5D3_ID_TDES		44	/* Triple Data Encryption Standard */
+#define SAMA5D3_ID_TRNG		45	/* True Random Generator Number */
+#define SAMA5D3_ID_IRQ0		47	/* Advanced Interrupt Controller (IRQ0) */
+#define SAMA5D3_ID_FUSE		48	/* FUSE Controller */
+#define SAMA5D3_ID_MPDDRC	49	/* MPDDR Controller */
+
+#endif
-- 
1.7.9.5

