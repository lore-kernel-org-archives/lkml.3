Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbbANQWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:22:20 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45273 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753686AbbANQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:22:17 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 01/12] mfd: syscon: Add atmel-matrix registers definition
Date: Wed, 14 Jan 2015 17:21:53 +0100
Message-Id: <1421252524-24452-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

AT91 SoCs have a memory range reserved for internal bus configuration.
Expose those registers so that drivers can make use of the matrix syscon
declared in at91 DTs.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/syscon/atmel-matrix.h | 117 ++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100644 include/linux/mfd/syscon/atmel-matrix.h

diff --git a/include/linux/mfd/syscon/atmel-matrix.h b/include/linux/mfd/syscon/atmel-matrix.h
new file mode 100644
index 000000000000..8293c3e2a82a
--- /dev/null
+++ b/include/linux/mfd/syscon/atmel-matrix.h
@@ -0,0 +1,117 @@
+/*
+ *  Copyright (C) 2014 Atmel Corporation.
+ *
+ * Memory Controllers (MATRIX, EBI) - System peripherals registers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _LINUX_MFD_SYSCON_ATMEL_MATRIX_H
+#define _LINUX_MFD_SYSCON_ATMEL_MATRIX_H
+
+#define AT91SAM9260_MATRIX_MCFG			0x00
+#define AT91SAM9260_MATRIX_SCFG			0x40
+#define AT91SAM9260_MATRIX_PRS			0x80
+#define AT91SAM9260_MATRIX_MRCR			0x100
+#define AT91SAM9260_MATRIX_EBICSA		0x11c
+
+#define AT91SAM9261_MATRIX_MRCR			0x0
+#define AT91SAM9261_MATRIX_SCFG			0x4
+#define AT91SAM9261_MATRIX_TCR			0x24
+#define AT91SAM9261_MATRIX_EBICSA		0x30
+#define AT91SAM9261_MATRIX_USBPUCR		0x34
+
+#define AT91SAM9263_MATRIX_MCFG			0x00
+#define AT91SAM9263_MATRIX_SCFG			0x40
+#define AT91SAM9263_MATRIX_PRS			0x80
+#define AT91SAM9263_MATRIX_MRCR			0x100
+#define AT91SAM9263_MATRIX_TCR			0x114
+#define AT91SAM9263_MATRIX_EBI0CSA		0x120
+#define AT91SAM9263_MATRIX_EBI1CSA		0x124
+
+#define AT91SAM9RL_MATRIX_MCFG			0x00
+#define AT91SAM9RL_MATRIX_SCFG			0x40
+#define AT91SAM9RL_MATRIX_PRS			0x80
+#define AT91SAM9RL_MATRIX_MRCR			0x100
+#define AT91SAM9RL_MATRIX_TCR			0x114
+#define AT91SAM9RL_MATRIX_EBICSA		0x120
+
+#define AT91SAM9G45_MATRIX_MCFG			0x00
+#define AT91SAM9G45_MATRIX_SCFG			0x40
+#define AT91SAM9G45_MATRIX_PRS			0x80
+#define AT91SAM9G45_MATRIX_MRCR			0x100
+#define AT91SAM9G45_MATRIX_TCR			0x110
+#define AT91SAM9G45_MATRIX_DDRMPR		0x118
+#define AT91SAM9G45_MATRIX_EBICSA		0x128
+
+#define AT91SAM9N12_MATRIX_MCFG			0x00
+#define AT91SAM9N12_MATRIX_SCFG			0x40
+#define AT91SAM9N12_MATRIX_PRS			0x80
+#define AT91SAM9N12_MATRIX_MRCR			0x100
+#define AT91SAM9N12_MATRIX_EBICSA		0x118
+
+#define AT91SAM9X5_MATRIX_MCFG			0x00
+#define AT91SAM9X5_MATRIX_SCFG			0x40
+#define AT91SAM9X5_MATRIX_PRS			0x80
+#define AT91SAM9X5_MATRIX_MRCR			0x100
+#define AT91SAM9X5_MATRIX_EBICSA		0x120
+
+#define SAMA5D3_MATRIX_MCFG			0x00
+#define SAMA5D3_MATRIX_SCFG			0x40
+#define SAMA5D3_MATRIX_PRS			0x80
+#define SAMA5D3_MATRIX_MRCR			0x100
+
+#define AT91_MATRIX_MCFG(o, x)			((o) + ((x) * 0x4))
+#define AT91_MATRIX_ULBT			GENMASK(2, 0)
+#define AT91_MATRIX_ULBT_INFINITE		(0 << 0)
+#define AT91_MATRIX_ULBT_SINGLE			(1 << 0)
+#define AT91_MATRIX_ULBT_FOUR			(2 << 0)
+#define AT91_MATRIX_ULBT_EIGHT			(3 << 0)
+#define AT91_MATRIX_ULBT_SIXTEEN		(4 << 0)
+
+#define AT91_MATRIX_SCFG(o, x)			((o) + ((x) * 0x4))
+#define AT91_MATRIX_SLOT_CYCLE			GENMASK(7,  0)
+#define AT91_MATRIX_DEFMSTR_TYPE		GENMASK(17, 16)
+#define AT91_MATRIX_DEFMSTR_TYPE_NONE		(0 << 16)
+#define AT91_MATRIX_DEFMSTR_TYPE_LAST		(1 << 16)
+#define AT91_MATRIX_DEFMSTR_TYPE_FIXED		(2 << 16)
+#define AT91_MATRIX_FIXED_DEFMSTR		GENMASK(20, 18)
+#define AT91_MATRIX_ARBT			GENMASK(25, 24)
+#define AT91_MATRIX_ARBT_ROUND_ROBIN		(0 << 24)
+#define AT91_MATRIX_ARBT_FIXED_PRIORITY		(1 << 24)
+
+#define AT91_MATRIX_ITCM_SIZE			GENMASK(3, 0)
+#define AT91_MATRIX_ITCM_0			(0 << 0)
+#define AT91_MATRIX_ITCM_16			(5 << 0)
+#define AT91_MATRIX_ITCM_32			(6 << 0)
+#define AT91_MATRIX_ITCM_64			(7 << 0)
+#define	AT91_MATRIX_DTCM_SIZE			GENMASK(7, 4)
+#define	AT91_MATRIX_DTCM_0			(0 << 4)
+#define	AT91_MATRIX_DTCM_16			(5 << 4)
+#define AT91_MATRIX_DTCM_32			(6 << 4)
+#define AT91_MATRIX_DTCM_64			(7 << 4)
+
+#define AT91_MATRIX_PRAS(o, x)			((o) + ((x) * 0x8))
+#define AT91_MATRIX_PRBS(o, x)			((o) + ((x) * 0x8) + 0x4)
+#define AT91_MATRIX_MPR(x)			GENMASK(((x) * 0x4) + 1, ((x) * 0x4))
+
+#define AT91_MATRIX_RCB(x)			BIT(x)
+
+#define AT91_MATRIX_CSA(cs, val)		(val << (cs))
+#define AT91_MATRIX_DBPUC			BIT(8)
+#define AT91_MATRIX_DBPDC			BIT(9)
+#define AT91_MATRIX_VDDIOMSEL			BIT(16)
+#define AT91_MATRIX_VDDIOMSEL_1_8V		(0 << 16)
+#define AT91_MATRIX_VDDIOMSEL_3_3V		(1 << 16)
+#define AT91_MATRIX_EBI_IOSR			BIT(17)
+#define AT91_MATRIX_DDR_IOSR			BIT(18)
+#define AT91_MATRIX_NFD0_SELECT			BIT(24)
+#define AT91_MATRIX_DDR_MP_EN			BIT(25)
+#define AT91_MATRIX_EBI_NUM_CS			8
+
+#define AT91_MATRIX_USBPUCR_PUON		BIT(30)
+
+#endif /* _LINUX_MFD_SYSCON_ATMEL_MATRIX_H */
-- 
2.1.0

