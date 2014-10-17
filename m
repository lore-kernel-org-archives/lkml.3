Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaJQJuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:50:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46838 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051AbaJQJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:50:06 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] pinctrl: at91: use own header
Date: Fri, 17 Oct 2014 11:49:40 +0200
Message-Id: <1413539380-7046-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy the mach/at91_pio.h header locally and use it for pinctrl-at91.c. This
allows to remove the dependency on mach/at91_pio.h to be able to move at91 to
multiplatform.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
Note that mach/at91_pio.h should go away soon hopefully as the remaining board
files in mach-at91 are schedulded to be removed.

 MAINTAINERS                    |  2 +-
 drivers/pinctrl/pinctrl-at91.c |  4 +--
 drivers/pinctrl/pinctrl-at91.h | 66 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 4 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-at91.h

diff --git a/MAINTAINERS b/MAINTAINERS
index f10ed3914ea8..37c98aa5fb77 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7049,7 +7049,7 @@ PIN CONTROLLER - ATMEL AT91
 M:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	drivers/pinctrl/pinctrl-at91.c
+F:	drivers/pinctrl/pinctrl-at91.*
 
 PIN CONTROLLER - RENESAS
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 60464a2648aa..0058817b12fd 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -25,9 +25,7 @@
 /* Since we request GPIOs from ourself */
 #include <linux/pinctrl/consumer.h>
 
-#include <mach/hardware.h>
-#include <mach/at91_pio.h>
-
+#include "pinctrl-at91.h"
 #include "core.h"
 
 #define MAX_GPIO_BANKS		5
diff --git a/drivers/pinctrl/pinctrl-at91.h b/drivers/pinctrl/pinctrl-at91.h
new file mode 100644
index 000000000000..c837c66ea360
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-at91.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2005 Ivan Kokshaysky
+ * Copyright (C) SAN People
+ *
+ * Parallel I/O Controller (PIO) - System peripherals registers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __PINCTRL_AT91_H
+#define __PINCTRL_AT91_H
+
+#define PIO_PER		0x00	/* Enable Register */
+#define PIO_PDR		0x04	/* Disable Register */
+#define PIO_PSR		0x08	/* Status Register */
+#define PIO_OER		0x10	/* Output Enable Register */
+#define PIO_ODR		0x14	/* Output Disable Register */
+#define PIO_OSR		0x18	/* Output Status Register */
+#define PIO_IFER	0x20	/* Glitch Input Filter Enable */
+#define PIO_IFDR	0x24	/* Glitch Input Filter Disable */
+#define PIO_IFSR	0x28	/* Glitch Input Filter Status */
+#define PIO_SODR	0x30	/* Set Output Data Register */
+#define PIO_CODR	0x34	/* Clear Output Data Register */
+#define PIO_ODSR	0x38	/* Output Data Status Register */
+#define PIO_PDSR	0x3c	/* Pin Data Status Register */
+#define PIO_IER		0x40	/* Interrupt Enable Register */
+#define PIO_IDR		0x44	/* Interrupt Disable Register */
+#define PIO_IMR		0x48	/* Interrupt Mask Register */
+#define PIO_ISR		0x4c	/* Interrupt Status Register */
+#define PIO_MDER	0x50	/* Multi-driver Enable Register */
+#define PIO_MDDR	0x54	/* Multi-driver Disable Register */
+#define PIO_MDSR	0x58	/* Multi-driver Status Register */
+#define PIO_PUDR	0x60	/* Pull-up Disable Register */
+#define PIO_PUER	0x64	/* Pull-up Enable Register */
+#define PIO_PUSR	0x68	/* Pull-up Status Register */
+#define PIO_ASR		0x70	/* Peripheral A Select Register */
+#define PIO_ABCDSR1	0x70	/* Peripheral ABCD Select Register 1 [some sam9 only] */
+#define PIO_BSR		0x74	/* Peripheral B Select Register */
+#define PIO_ABCDSR2	0x74	/* Peripheral ABCD Select Register 2 [some sam9 only] */
+#define PIO_ABSR	0x78	/* AB Status Register */
+#define PIO_IFSCDR	0x80	/* Input Filter Slow Clock Disable Register */
+#define PIO_IFSCER	0x84	/* Input Filter Slow Clock Enable Register */
+#define PIO_IFSCSR	0x88	/* Input Filter Slow Clock Status Register */
+#define PIO_SCDR	0x8c	/* Slow Clock Divider Debouncing Register */
+#define		PIO_SCDR_DIV	(0x3fff <<  0)		/* Slow Clock Divider Mask */
+#define PIO_PPDDR	0x90	/* Pad Pull-down Disable Register */
+#define PIO_PPDER	0x94	/* Pad Pull-down Enable Register */
+#define PIO_PPDSR	0x98	/* Pad Pull-down Status Register */
+#define PIO_OWER	0xa0	/* Output Write Enable Register */
+#define PIO_OWDR	0xa4	/* Output Write Disable Register */
+#define PIO_OWSR	0xa8	/* Output Write Status Register */
+#define PIO_AIMER	0xb0	/* Additional Interrupt Modes Enable Register */
+#define PIO_AIMDR	0xb4	/* Additional Interrupt Modes Disable Register */
+#define PIO_AIMMR	0xb8	/* Additional Interrupt Modes Mask Register */
+#define PIO_ESR		0xc0	/* Edge Select Register */
+#define PIO_LSR		0xc4	/* Level Select Register */
+#define PIO_ELSR	0xc8	/* Edge/Level Status Register */
+#define PIO_FELLSR	0xd0	/* Falling Edge/Low Level Select Register */
+#define PIO_REHLSR	0xd4	/* Rising Edge/ High Level Select Register */
+#define PIO_FRLHSR	0xd8	/* Fall/Rise - Low/High Status Register */
+#define PIO_SCHMITT	0x100	/* Schmitt Trigger Register */
+
+#endif
-- 
1.9.1

