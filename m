Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaLAK1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:27:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50371 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752646AbaLAK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:27:32 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 01/11] mfd: syscon: Add atmel-matrix registers definition
Date: Mon,  1 Dec 2014 11:27:17 +0100
Message-Id: <1417429647-3419-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AT91 SoCs have a memory range reserved for internal bus configuration.
Expose those registers so that drivers can make use of the matrix syscon
declared in at91 DTs.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/syscon/atmel-matrix.h | 114 ++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100644 include/linux/mfd/syscon/atmel-matrix.h

diff --git a/include/linux/mfd/syscon/atmel-matrix.h b/include/linux/mfd/syscon/atmel-matrix.h
new file mode 100644
index 0000000..d0da495
--- /dev/null
+++ b/include/linux/mfd/syscon/atmel-matrix.h
@@ -0,0 +1,114 @@
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
+#define AT91SAM9260_MATRIX_MCFG_OFF	0x00
+#define AT91SAM9260_MATRIX_SCFG_OFF	0x40
+#define AT91SAM9260_MATRIX_PRS_OFF	0x80
+#define AT91SAM9260_MATRIX_MRCR_OFF	0x100
+#define AT91SAM9260_MATRIX_EBICSA_OFF	0x11c
+
+#define AT91SAM9261_MATRIX_MRCR_OFF	0x0
+#define AT91SAM9261_MATRIX_SCFG_OFF	0x4
+#define AT91SAM9261_MATRIX_TCR_OFF	0x24
+#define AT91SAM9261_MATRIX_EBICSA_OFF	0x30
+#define AT91SAM9261_MATRIX_USBPUCR_OFF	0x34
+
+#define AT91SAM9263_MATRIX_MCFG_OFF	0x00
+#define AT91SAM9263_MATRIX_SCFG_OFF	0x40
+#define AT91SAM9263_MATRIX_PRS_OFF	0x80
+#define AT91SAM9263_MATRIX_MRCR_OFF	0x100
+#define AT91SAM9263_MATRIX_TCR_OFF	0x114
+#define AT91SAM9263_MATRIX_EBI0CSA_OFF	0x120
+#define AT91SAM9263_MATRIX_EBI1CSA_OFF	0x124
+
+#define AT91SAM9G45_MATRIX_MCFG_OFF	0x00
+#define AT91SAM9G45_MATRIX_SCFG_OFF	0x40
+#define AT91SAM9G45_MATRIX_PRS_OFF	0x80
+#define AT91SAM9G45_MATRIX_MRCR_OFF	0x100
+#define AT91SAM9G45_MATRIX_TCR_OFF	0x110
+#define AT91SAM9G45_MATRIX_DDRMPR_OFF	0x118
+#define AT91SAM9G45_MATRIX_EBICSA_OFF	0x128
+
+#define AT91SAM9N12_MATRIX_MCFG_OFF	0x00
+#define AT91SAM9N12_MATRIX_SCFG_OFF	0x40
+#define AT91SAM9N12_MATRIX_PRS_OFF	0x80
+#define AT91SAM9N12_MATRIX_MRCR_OFF	0x100
+#define AT91SAM9N12_MATRIX_EBICSA_OFF	0x118
+
+#define AT91SAM9X5_MATRIX_MCFG_OFF	0x00
+#define AT91SAM9X5_MATRIX_SCFG_OFF	0x40
+#define AT91SAM9X5_MATRIX_PRS_OFF	0x80
+#define AT91SAM9X5_MATRIX_MRCR_OFF	0x100
+#define AT91SAM9X5_MATRIX_EBICSA_OFF	0x120
+
+#define SAMA5D3_MATRIX_MCFG_OFF		0x00
+#define SAMA5D3_MATRIX_SCFG_OFF		0x40
+#define SAMA5D3_MATRIX_PRS_OFF		0x80
+#define SAMA5D3_MATRIX_MRCR_OFF		0x100
+
+#define AT91_MATRIX_MCFG(o, x)		((o) + ((x) * 0x4))
+#define AT91_MATRIX_ULBT		(7 << 0)
+#define AT91_MATRIX_ULBT_INFINITE	(0 << 0)
+#define AT91_MATRIX_ULBT_SINGLE		(1 << 0)
+#define AT91_MATRIX_ULBT_FOUR		(2 << 0)
+#define AT91_MATRIX_ULBT_EIGHT		(3 << 0)
+#define AT91_MATRIX_ULBT_SIXTEEN	(4 << 0)
+
+#define AT91_MATRIX_SCFG(o, x)		((o) + ((x) * 0x4))
+#define AT91_MATRIX_SLOT_CYCLE		(0xff <<  0)
+#define AT91_MATRIX_DEFMSTR_TYPE	(3 << 16)
+#define AT91_MATRIX_DEFMSTR_TYPE_NONE	(0 << 16)
+#define AT91_MATRIX_DEFMSTR_TYPE_LAST	(1 << 16)
+#define AT91_MATRIX_DEFMSTR_TYPE_FIXED	(2 << 16)
+#define AT91_MATRIX_FIXED_DEFMSTR	(7 << 18)
+#define AT91_MATRIX_ARBT		(3 << 24)
+#define AT91_MATRIX_ARBT_ROUND_ROBIN	(0 << 24)
+#define AT91_MATRIX_ARBT_FIXED_PRIORITY	(1 << 24)
+
+#define AT91_MATRIX_TCR(o)		(o)
+#define AT91_MATRIX_ITCM_SIZE		(0xf << 0)
+#define AT91_MATRIX_ITCM_0		(0 << 0)
+#define AT91_MATRIX_ITCM_16		(5 << 0)
+#define AT91_MATRIX_ITCM_32		(6 << 0)
+#define AT91_MATRIX_ITCM_64		(7 << 0)
+#define	AT91_MATRIX_DTCM_SIZE		(0xf << 4)
+#define	AT91_MATRIX_DTCM_0		(0 << 4)
+#define	AT91_MATRIX_DTCM_16		(5 << 4)
+#define AT91_MATRIX_DTCM_32		(6 << 4)
+#define AT91_MATRIX_DTCM_64		(7 << 4)
+
+#define AT91_MATRIX_PRAS(o, x)		((o) + ((x) * 0x8))
+#define AT91_MATRIX_PRBS(o, x)		((o) + ((x) * 0x8) + 0x4)
+#define AT91_MATRIX_MPR_MSK(x)		(3 << ((x) * 0x4))
+
+#define AT91_MATRIX_MRC(o)		(o)
+#define AT91_MATRIX_RCB(x)		BIT(x)
+
+#define AT91_MATRIX_EBICSA(o)		(o)
+#define AT91_MATRIX_CSA(cs, val)	(val << (cs))
+#define AT91_MATRIX_DBPUC		BIT(8)
+#define AT91_MATRIX_DBPDC		BIT(9)
+#define AT91_MATRIX_VDDIOMSEL		BIT(16)
+#define AT91_MATRIX_VDDIOMSEL_1_8V	(0 << 16)
+#define AT91_MATRIX_VDDIOMSEL_3_3V	(1 << 16)
+#define AT91_MATRIX_EBI_IOSR		BIT(17)
+#define AT91_MATRIX_DDR_IOSR		BIT(18)
+#define AT91_MATRIX_NFD0_SELECT		BIT(24)
+#define AT91_MATRIX_DDR_MP_EN		BIT(25)
+#define AT91_MATRIX_EBI_NUM_CS		8
+
+#define AT91_MATRIX_WPMR(o)		(o)
+#define AT91_MATRIX_WPSR(o)		(o)
+
+#endif /* _LINUX_MFD_SYSCON_ATMEL_MATRIX_H */
-- 
1.9.1

