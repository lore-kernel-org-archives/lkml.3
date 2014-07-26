Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaGZSlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 14:41:20 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:8652
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751448AbaGZSlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 14:41:17 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <dougthompson@xmission.com>, <bp@alien8.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <michal.simek@xilinx.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kpc528@gmail.com>,
        <kalluripunnaiahchoudary@gmail.com>, <anirudh@xilinx.com>,
        <svemula@xilinx.com>, Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr ecc controller
Date: Sun, 27 Jul 2014 00:10:52 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
Message-ID: <64d65965-45a3-41c3-9b04-9743b8b1e49c@BL2FFO11FD025.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(22564002)(199002)(189002)(76482001)(31966008)(92726001)(2201001)(95666004)(106466001)(77096002)(87286001)(83072002)(19580405001)(87936001)(74662001)(53416004)(50466002)(99396002)(48376002)(89996001)(62966002)(88136002)(70736001)(92566001)(74316001)(85306003)(77982001)(31696002)(50986999)(47776003)(85852003)(21056001)(80022001)(20776003)(1496007)(107046002)(81542001)(86362001)(50226001)(77156001)(6806004)(102836001)(19580395003)(74502001)(44976005)(4396001)(46102001)(229853001)(83322001)(81342001)(104166001)(79102001)(64706001)(93916002)(104016003)(107986001)(2004002)(2101003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB045;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02843AA9E0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added EDAC support for reporting the ecc errors of synopsys ddr controller.
The ddr ecc controller corrects single bit errors and detects double bit
errors.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes for v3:
- Updated maintainer information
- Driver cleanup as per the review comments
- Shortened the prefix "sysnopsys" to "synps"
Changes for v2:
- Updated the commit header and message
- Renamed the filenames to synopsys_edac
- Corrected the compatilble string, commnets
- Renamed the macros,fucntions and data structures
---

 .../devicetree/bindings/edac/synps_edac.txt        |   18 +
 MAINTAINERS                                        |    1 +
 drivers/edac/Kconfig                               |    7 +
 drivers/edac/Makefile                              |    1 +
 drivers/edac/synps_edac.c                          |  554 ++++++++++++++++++++
 5 files changed, 581 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/edac/synps_edac.txt
 create mode 100644 drivers/edac/synps_edac.c

diff --git a/Documentation/devicetree/bindings/edac/synps_edac.txt b/Documentation/devicetree/bindings/edac/synps_edac.txt
new file mode 100644
index 0000000..c4a559b
--- /dev/null
+++ b/Documentation/devicetree/bindings/edac/synps_edac.txt
@@ -0,0 +1,18 @@
+Synopsys EDAC driver, it does reports the DDR ECC single bit errors that are
+corrected and double bit ecc errors that are detected by the DDR ECC controller.
+ECC support for DDR is available in half-bus width(16 bit) configuration only.
+
+Required properties:
+- compatible: Should be "xlnx,zynq-ddrc-1.04"
+- reg: Should contain DDR controller registers location and length.
+
+Example:
+++++++++
+
+ddrc0: ddrc@f8006000 {
+	compatible = "xlnx,zynq-ddrc-1.04";
+	reg = <0xf8006000 0x1000>;
+};
+
+Synopsys EDAC driver detects the DDR ECC enable state by reading the appropriate
+control register.
diff --git a/MAINTAINERS b/MAINTAINERS
index d76e077..984b5a7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1479,6 +1479,7 @@ N:	xilinx
 F:	drivers/clocksource/cadence_ttc_timer.c
 F:	drivers/i2c/busses/i2c-cadence.c
 F:	drivers/mmc/host/sdhci-of-arasan.c
+F:	drivers/edac/synps_edac.c
 
 ARM SMMU DRIVER
 M:	Will Deacon <will.deacon@arm.com>
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 878f090..f628a2b 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -368,4 +368,11 @@ config EDAC_OCTEON_PCI
 	  Support for error detection and correction on the
 	  Cavium Octeon family of SOCs.
 
+config EDAC_SYNPS
+	tristate "Synopsys DDR Memory Controller"
+	depends on EDAC_MM_EDAC && ARCH_ZYNQ
+	help
+	  Support for EDAC on the ECC memory used with the Synopsys DDR
+	  memory controller.
+
 endif # EDAC
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 4154ed6..0af900f 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -64,3 +64,4 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
 obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
 obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
 obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
+obj-$(CONFIG_EDAC_SYNPS)		+= synps_edac.o
diff --git a/drivers/edac/synps_edac.c b/drivers/edac/synps_edac.c
new file mode 100644
index 0000000..a9417fe
--- /dev/null
+++ b/drivers/edac/synps_edac.c
@@ -0,0 +1,554 @@
+/*
+ * Synopsys DDR ECC Driver
+ * This driver is based on ppc4xx_edac.c drivers
+ *
+ * Copyright (C) 2012 - 2014 Xilinx, Inc.
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details
+ */
+
+#include <linux/edac.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include "edac_core.h"
+
+/* Number of cs_rows needed per memory controller */
+#define SYNPS_EDAC_NR_CSROWS	1
+
+/* Number of channels per memory controller */
+#define SYNPS_EDAC_NR_CHANS	1
+
+/* Granularity of reported error in bytes */
+#define SYNPS_EDAC_ERR_GRAIN	1
+
+#define SYNPS_EDAC_MSG_SIZE	256
+
+#define SYNPS_EDAC_MOD_STRING	"synps_edac"
+#define SYNPS_EDAC_MOD_VER	"1"
+
+/* Synopsys DDR memory controller registers that are relevant to ECC */
+#define SYNPS_DDRC_CTRL_REG_OFST	0x0
+#define SYNPS_DDRC_T_ZQ_REG_OFST	0xA4
+
+/* ECC control register */
+#define SYNPS_DDRC_ECC_CTRL_REG_OFST		0xC4
+/* ECC log register */
+#define SYNPS_DDRC_ECC_CE_LOG_REG_OFST		0xC8
+/* ECC address register */
+#define SYNPS_DDRC_ECC_CE_ADDR_REG_OFST		0xCC
+/* ECC data[31:0] register */
+#define SYNPS_DDRC_ECC_CE_DATA_31_0_REG_OFST	0xD0
+
+/* Uncorrectable error info regsisters */
+#define SYNPS_DDRC_ECC_UE_LOG_REG_OFST		0xDC
+#define SYNPS_DDRC_ECC_UE_ADDR_REG_OFST		0xE0
+#define SYNPS_DDRC_ECC_UE_DATA_31_0_REG_OFST	0xE4
+
+#define SYNPS_DDRC_ECC_STAT_REG_OFST		0xF0
+#define SYNPS_DDRC_ECC_SCRUB_REG_OFST		0xF4
+
+/* Control regsiter bitfield definitions */
+#define SYNPS_DDRC_CTRLREG_BUSWIDTH_MASK	0xC
+#define SYNPS_DDRC_CTRLREG_BUSWIDTH_SHIFT	2
+
+#define SYNPS_DDRCTL_WDTH_16	1
+#define SYNPS_DDRCTL_WDTH_32	0
+
+/* ZQ register bitfield definitions */
+#define SYNPS_DDRC_T_ZQ_REG_DDRMODE_MASK	0x2
+
+/* ECC control register bitfield definitions */
+#define SYNPS_DDRC_ECCCTRL_CLR_CE_ERR		0x2
+#define SYNPS_DDRC_ECCCTRL_CLR_UE_ERR		0x1
+
+/* ECC correctable/uncorrectable error log register definitions */
+#define SYNPS_DDRC_ECC_CE_LOGREG_VALID		0x1
+#define SYNPS_DDRC_ECC_CE_LOGREG_BITPOS_MASK	0xFE
+#define SYNPS_DDRC_ECC_CE_LOGREG_BITPOS_SHIFT	1
+
+/* ECC correctable/uncorrectable error address register definitions */
+#define SYNPS_DDRC_ECC_ADDRREG_COL_MASK		0xFFF
+#define SYNPS_DDRC_ECC_ADDRREG_ROW_MASK		0xFFFF000
+#define SYNPS_DDRC_ECC_ADDRREG_ROW_SHIFT	12
+#define SYNPS_DDRC_ECC_ADDRREG_BANK_MASK	0x70000000
+#define SYNPS_DDRC_ECC_ADDRREG_BANK_SHIFT	28
+
+/* ECC statistic regsiter definitions */
+#define SYNPS_DDRC_ECC_STATREG_UECNT_MASK	0xFF
+#define SYNPS_DDRC_ECC_STATREG_CECNT_MASK	0xFF00
+#define SYNPS_DDRC_ECC_STATREG_CECNT_SHIFT	8
+
+/* ECC scrub regsiter definitions */
+#define SYNPS_DDRC_ECC_SCRUBREG_ECC_MODE_MASK	0x7
+#define SYNPS_DDRC_ECC_SCRUBREG_ECCMODE_SECDED	0x4
+
+/**
+ * struct ecc_error_info - ECC error log information
+ * @row:	Row number
+ * @col:	Column number
+ * @bank:	Bank number
+ * @bitpos:	Bit position
+ * @data:	Data causing the error
+ */
+struct ecc_error_info {
+	u32 row;
+	u32 col;
+	u32 bank;
+	u32 bitpos;
+	u32 data;
+};
+
+/**
+ * struct synps_ecc_status - ECC status information to report
+ * @ce_count:	Correctable error count
+ * @ue_count:	Uncorrectable error count
+ * @ceinfo:	Correctable error log information
+ * @ueinfo:	Uncorrectable error log information
+ */
+struct synps_ecc_status {
+	u32 ce_cnt;
+	u32 ue_cnt;
+	struct ecc_error_info ceinfo;
+	struct ecc_error_info ueinfo;
+};
+
+/**
+ * struct synps_edac_priv - DDR memory controller private instance data
+ * @baseaddr:		Base address of the DDR controller
+ * @ce_count:		Correctable Error count
+ * @ue_count:		Uncorrectable Error count
+ */
+struct synps_edac_priv {
+	void __iomem *baseaddr;
+	u32 ce_cnt;
+	u32 ue_cnt;
+};
+
+/**
+ * synps_edac_geterror_info - Get the current ecc error info
+ * @base:	Pointer to the base address of the ddr memory controller
+ * @perrstatus:	Pointer to the synopsys ecc status structure
+ *
+ * This routine determines there is any ecc error or not
+ *
+ * Return: zero if there is no error otherwise returns 1
+ */
+static int synps_edac_geterror_info(void __iomem *base,
+				    struct synps_ecc_status *p)
+{
+	u32 regval;
+	u32 clearval = 0;
+
+	regval = readl(base + SYNPS_DDRC_ECC_STAT_REG_OFST) &
+			(SYNPS_DDRC_ECC_STATREG_UECNT_MASK |
+			SYNPS_DDRC_ECC_STATREG_CECNT_MASK);
+
+	if (!regval)
+		return 0;
+
+	memset(p, 0, sizeof(*p));
+
+	p->ce_cnt = (regval & SYNPS_DDRC_ECC_STATREG_CECNT_MASK) >>
+				SYNPS_DDRC_ECC_STATREG_CECNT_SHIFT;
+	p->ue_cnt = regval & SYNPS_DDRC_ECC_STATREG_UECNT_MASK;
+
+	regval = readl(base + SYNPS_DDRC_ECC_CE_LOG_REG_OFST);
+	if (!(p->ce_cnt && (regval & SYNPS_DDRC_ECC_CE_LOGREG_VALID)))
+		goto ue_err;
+
+	p->ceinfo.bitpos = (regval & SYNPS_DDRC_ECC_CE_LOGREG_BITPOS_MASK) >>
+					SYNPS_DDRC_ECC_CE_LOGREG_BITPOS_SHIFT;
+	regval = readl(base + SYNPS_DDRC_ECC_CE_ADDR_REG_OFST);
+	p->ceinfo.row = (regval & SYNPS_DDRC_ECC_ADDRREG_ROW_MASK) >>
+					SYNPS_DDRC_ECC_ADDRREG_ROW_SHIFT;
+	p->ceinfo.col = regval & SYNPS_DDRC_ECC_ADDRREG_COL_MASK;
+	p->ceinfo.bank = (regval & SYNPS_DDRC_ECC_ADDRREG_BANK_MASK) >>
+					SYNPS_DDRC_ECC_ADDRREG_BANK_SHIFT;
+	p->ceinfo.data = readl(base + SYNPS_DDRC_ECC_CE_DATA_31_0_REG_OFST);
+	edac_dbg(3, "ce bitposition: %d data: %d\n", p->ceinfo.bitpos,
+						p->ceinfo.data);
+	clearval = SYNPS_DDRC_ECCCTRL_CLR_CE_ERR;
+
+ue_err:
+	regval = readl(base + SYNPS_DDRC_ECC_UE_LOG_REG_OFST);
+	if (!(p->ue_cnt && (regval & SYNPS_DDRC_ECC_CE_LOGREG_VALID)))
+		goto out;
+
+	regval = readl(base + SYNPS_DDRC_ECC_UE_ADDR_REG_OFST);
+	p->ueinfo.row = (regval & SYNPS_DDRC_ECC_ADDRREG_ROW_MASK) >>
+					SYNPS_DDRC_ECC_ADDRREG_ROW_SHIFT;
+	p->ueinfo.col = regval & SYNPS_DDRC_ECC_ADDRREG_COL_MASK;
+	p->ueinfo.bank = (regval & SYNPS_DDRC_ECC_ADDRREG_BANK_MASK) >>
+					SYNPS_DDRC_ECC_ADDRREG_BANK_SHIFT;
+	p->ueinfo.data = readl(base + SYNPS_DDRC_ECC_UE_DATA_31_0_REG_OFST);
+	clearval |= SYNPS_DDRC_ECCCTRL_CLR_UE_ERR;
+
+out:
+	writel(clearval, base + SYNPS_DDRC_ECC_CTRL_REG_OFST);
+	writel(0x0, base + SYNPS_DDRC_ECC_CTRL_REG_OFST);
+
+	return 1;
+}
+
+/**
+ * synps_edac_handle_error - Handle controller error types CE and UE
+ * @mci:	Pointer to the edac memory controller instance
+ * @perrstatus:	Pointer to the synopsys ecc status structure
+ *
+ * This routine handles the controller ECC correctable and un correctable
+ * error.
+ */
+static void synps_edac_handle_error(struct mem_ctl_info *mci,
+				    struct synps_ecc_status *p)
+{
+	char message[SYNPS_EDAC_MSG_SIZE];
+	struct ecc_error_info *pinf;
+
+	if (p->ce_cnt) {
+		pinf = &p->ceinfo;
+		snprintf(message, SYNPS_EDAC_MSG_SIZE,
+			 "DDR ECC error type :%s Row %d Bank %d Col %d ",
+			 "CE", pinf->row, pinf->bank, pinf->col);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     p->ce_cnt, 0, 0, 0, 0, 0, -1,
+				     message, "");
+	}
+
+	if (p->ue_cnt) {
+		pinf = &p->ueinfo;
+		snprintf(message, SYNPS_EDAC_MSG_SIZE,
+			 "DDR ECC error type :%s Row %d Bank %d Col %d ",
+			 "UE", pinf->row, pinf->bank, pinf->col);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     p->ue_cnt, 0, 0, 0, 0, 0, -1,
+				     message, "");
+	}
+}
+
+/**
+ * synps_edac_check - Check controller for ECC errors
+ * @mci:	Pointer to the edac memory controller instance
+ *
+ * This routine is used to check and post ECC errors and is called by
+ * the EDAC polling thread
+ */
+static void synps_edac_check(struct mem_ctl_info *mci)
+{
+	struct synps_edac_priv *priv = mci->pvt_info;
+	struct synps_ecc_status stat;
+	int status;
+
+	status = synps_edac_geterror_info(priv->baseaddr, &stat);
+	if (!status)
+		return;
+
+	priv->ce_cnt += stat.ce_cnt;
+	priv->ue_cnt += stat.ue_cnt;
+	synps_edac_handle_error(mci, &stat);
+
+	edac_dbg(3, "Total error count ce %d ue %d\n",
+			 priv->ce_cnt, priv->ue_cnt);
+}
+
+/**
+ * synps_edac_get_dtype - Return the controller memory width
+ * @base:	Pointer to the ddr memory contoller base address
+ *
+ * This routine returns the EDAC device type width appropriate for the
+ * current controller configuration.
+ *
+ * Return: a device type width enumeration.
+ */
+static enum dev_type synps_edac_get_dtype(const void __iomem *base)
+{
+	enum dev_type dt;
+	u32 width;
+
+	width = readl(base + SYNPS_DDRC_CTRL_REG_OFST);
+	width = (width & SYNPS_DDRC_CTRLREG_BUSWIDTH_MASK) >>
+			SYNPS_DDRC_CTRLREG_BUSWIDTH_SHIFT;
+
+	switch (width) {
+	case SYNPS_DDRCTL_WDTH_16:
+		dt = DEV_X2;
+		break;
+	case SYNPS_DDRCTL_WDTH_32:
+		dt = DEV_X4;
+		break;
+	default:
+		dt = DEV_UNKNOWN;
+	}
+
+	return dt;
+}
+
+/**
+ * synps_edac_get_eccstate - Return the controller ecc enable/disable status
+ * @base:	Pointer to the ddr memory contoller base address
+ *
+ * This routine returns the ECC enable/diable status for the controller
+ *
+ * Return: a ecc status boolean i.e true/false - enabled/disabled.
+ */
+static bool synps_edac_get_eccstate(void __iomem *base)
+{
+	enum dev_type dt;
+	u32 ecctype;
+	bool state = false;
+
+	dt = synps_edac_get_dtype(base);
+	if (dt == DEV_UNKNOWN)
+		return state;
+
+	ecctype = (readl(base + SYNPS_DDRC_ECC_SCRUB_REG_OFST) &
+			SYNPS_DDRC_ECC_SCRUBREG_ECC_MODE_MASK);
+
+	if ((ecctype == SYNPS_DDRC_ECC_SCRUBREG_ECCMODE_SECDED)
+			&& (dt == DEV_X2)) {
+		state = true;
+		writel(0x0, base + SYNPS_DDRC_ECC_CTRL_REG_OFST);
+	}
+
+	return state;
+}
+
+/**
+ * synps_edac_get_memsize - reads the size of the attached memory device
+ *
+ * Return: the memory size in bytes
+ */
+static u32 synps_edac_get_memsize(void)
+{
+	struct sysinfo inf;
+
+	si_meminfo(&inf);
+
+	return inf.totalram * inf.mem_unit;
+}
+
+/**
+ * synps_edac_get_mtype - Returns controller memory type
+ * @base:	pointer to the synopsys ecc status structure
+ *
+ * This routine returns the EDAC memory type appropriate for the
+ * current controller configuration.
+ *
+ * Return: a memory type enumeration.
+ */
+static enum mem_type synps_edac_get_mtype(const void __iomem *base)
+{
+	enum mem_type mt;
+	u32 memtype;
+
+	memtype = readl(base + SYNPS_DDRC_T_ZQ_REG_OFST);
+
+	if (memtype & SYNPS_DDRC_T_ZQ_REG_DDRMODE_MASK)
+		mt = MEM_DDR3;
+	else
+		mt = MEM_DDR2;
+
+	return mt;
+}
+
+/**
+ * synps_edac_init_csrows - Initialize the cs row data
+ * @mci:	Pointer to the edac memory controller instance
+ *
+ * This routine initializes the chip select rows associated
+ * with the EDAC memory controller instance
+ *
+ * Return: Unconditionally 0.
+ */
+static int synps_edac_init_csrows(struct mem_ctl_info *mci)
+{
+	struct csrow_info *csi;
+	struct dimm_info *dimm;
+	struct synps_edac_priv *priv = mci->pvt_info;
+	u32 size;
+	int row, j;
+
+	for (row = 0; row < mci->nr_csrows; row++) {
+		csi = mci->csrows[row];
+		size = synps_edac_get_memsize();
+
+		for (j = 0; j < csi->nr_channels; j++) {
+			dimm = csi->channels[j]->dimm;
+			dimm->edac_mode = EDAC_FLAG_SECDED;
+			dimm->mtype = synps_edac_get_mtype(priv->baseaddr);
+			dimm->nr_pages =
+			    (size >> PAGE_SHIFT) / csi->nr_channels;
+			dimm->grain = SYNPS_EDAC_ERR_GRAIN;
+			dimm->dtype = synps_edac_get_dtype(priv->baseaddr);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * synps_edac_mc_init - Initialize driver instance
+ * @mci:	Pointer to the edac memory controller instance
+ * @pdev:	Pointer to the platform_device struct
+ *
+ * This routine performs initialization of the EDAC memory controller
+ * instance and related driver-private data associated with the
+ * memory controller the instance is bound to.
+ *
+ * Return: 0 if OK; otherwise, < 0 on error.
+ */
+static int synps_edac_mc_init(struct mem_ctl_info *mci,
+				 struct platform_device *pdev)
+{
+	int status;
+	struct synps_edac_priv *priv;
+
+	mci->pdev = &pdev->dev;
+	priv = mci->pvt_info;
+	platform_set_drvdata(pdev, mci);
+
+	/* Initialize controller capabilities and configuration */
+	mci->mtype_cap = MEM_FLAG_DDR3 | MEM_FLAG_DDR2;
+	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
+	mci->scrub_cap = SCRUB_HW_SRC;
+	mci->scrub_mode = SCRUB_NONE;
+
+	mci->edac_cap = EDAC_FLAG_SECDED;
+	mci->ctl_name = "synps_ddr_controller";
+	mci->dev_name = SYNPS_EDAC_MOD_STRING;
+	mci->mod_name = SYNPS_EDAC_MOD_VER;
+	mci->mod_ver = "1";
+
+	edac_op_state = EDAC_OPSTATE_POLL;
+	mci->edac_check = synps_edac_check;
+	mci->ctl_page_to_phys = NULL;
+
+	/*
+	 * Initialize the MC control structure 'csrows' table
+	 * with the mapping and control information.
+	 */
+	status = synps_edac_init_csrows(mci);
+
+	return status;
+}
+
+/**
+ * synps_edac_mc_probe - Check controller and bind driver
+ * @pdev:	Pointer to the platform_device struct
+ *
+ * This routine probes a specific controller
+ * instance for binding with the driver.
+ *
+ * Return: 0 if the controller instance was successfully bound to the
+ * driver; otherwise, < 0 on error.
+ */
+static int synps_edac_mc_probe(struct platform_device *pdev)
+{
+	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
+	struct synps_edac_priv *priv;
+	int rc;
+	struct resource *res;
+	void __iomem *baseaddr;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	baseaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(baseaddr))
+		return PTR_ERR(baseaddr);
+
+	if (synps_edac_get_eccstate(baseaddr) == false) {
+		edac_printk(KERN_INFO, EDAC_MC, "ECC not enabled\n");
+		return -ENXIO;
+	}
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = SYNPS_EDAC_NR_CSROWS;
+	layers[0].is_virt_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = SYNPS_EDAC_NR_CHANS;
+	layers[1].is_virt_csrow = false;
+
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+			    sizeof(struct synps_edac_priv));
+	if (!mci) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			"Failed memory allocation for mc instance\n");
+		return -ENOMEM;
+	}
+
+	priv = mci->pvt_info;
+	priv->baseaddr = baseaddr;
+	rc = synps_edac_mc_init(mci, pdev);
+	if (rc) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			"Failed to initialize instance\n");
+		goto free_edac_mc;
+	}
+
+	rc = edac_mc_add_mc(mci);
+	if (rc) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			"Failed to register with EDAC core\n");
+		goto del_edac_mc;
+	}
+
+	return rc;
+
+del_edac_mc:
+	edac_mc_del_mc(&pdev->dev);
+free_edac_mc:
+	edac_mc_free(mci);
+
+	return rc;
+}
+
+/**
+ * synps_edac_mc_remove - Unbind driver from controller
+ * @pdev:	Pointer to the platform_device struct
+ *
+ * Return: Unconditionally 0
+ */
+static int synps_edac_mc_remove(struct platform_device *pdev)
+{
+	struct mem_ctl_info *mci = platform_get_drvdata(pdev);
+
+	edac_mc_del_mc(&pdev->dev);
+	edac_mc_free(mci);
+
+	return 0;
+}
+
+static struct of_device_id synps_edac_match[] = {
+	{ .compatible = "xlnx,zynq-ddrc-1.04", },
+	{ /* end of table */ }
+};
+
+MODULE_DEVICE_TABLE(of, synps_edac_match);
+
+static struct platform_driver synps_edac_mc_driver = {
+	.driver = {
+		   .name = "synps-edac",
+		   .owner = THIS_MODULE,
+		   .of_match_table = synps_edac_match,
+		   },
+	.probe = synps_edac_mc_probe,
+	.remove = synps_edac_mc_remove,
+};
+
+module_platform_driver(synps_edac_mc_driver);
+
+MODULE_AUTHOR("Xilinx Inc");
+MODULE_DESCRIPTION("Synopsys DDR ECC driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4


