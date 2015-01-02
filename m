Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbbABEif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 23:38:35 -0500
Received: from mail-bl2on0095.outbound.protection.outlook.com ([65.55.169.95]:35664
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751531AbbABEic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 23:38:32 -0500
X-Greylist: delayed 957 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2015 23:38:32 EST
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <dougthompson@xmission.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <michal.simek@xilinx.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <bp@alien8.de>
CC: <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        <punnaia@xilinx.com>
Subject: [PATCH v7] edac: synps: Added EDAC support for zynq ddr ecc controller
Date: Fri, 2 Jan 2015 09:52:20 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21218.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <d71411fd1be84d99af5936138cbcc9c7@BL2FFO11FD014.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(22564002)(199003)(86362001)(87936001)(575784001)(74316001)(120916001)(2201001)(89996001)(92566001)(106466001)(50986999)(92726002)(47776003)(64706001)(53416004)(229853001)(107046002)(31966008)(48376002)(19580395003)(77156002)(46102003)(19580405001)(99396003)(21056001)(50466002)(4396001)(6806004)(50226001)(62966003)(108616004)(20776003)(104016003)(921003)(107986001)(24736002)(23106004)(1121003)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB034;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB034;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB034;
X-Forefront-PRVS: 0444EB1997
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB034;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2015 04:22:32.8430
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB034
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added EDAC support for reporting the ecc errors of synopsys ddr controller.
The ddr ecc controller corrects single bit errors and detects double bit
errors.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes for v7:
- Fixed indentation and removed insignificant comments
- I have not taken care of spliting synps_edac_geterror_info function as
  it adds additional indentation levels and moreover the existing changes were
  made as part of the v2 review comments
Changes for v6:
- Fixed indentation and typo errors 
- Corrected the function and structure headers
Changes for v5:
- Removed dt binding info as already there is a binding info available
   under memorycontroller. so, updated ecc info there.
- corrected the ip version and function return types
Changes for v4:
- Shorten the macro definitions
- Corrected the ddr ip version
- Reverted the file name change
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
 MAINTAINERS                  |    1 +
 drivers/edac/Kconfig         |    7 +
 drivers/edac/Makefile        |    1 +
 drivers/edac/synopsys_edac.c |  528 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 537 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/synopsys_edac.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ff630d..7601298 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1556,6 +1556,7 @@ N:	xilinx
 F:	drivers/clocksource/cadence_ttc_timer.c
 F:	drivers/i2c/busses/i2c-cadence.c
 F:	drivers/mmc/host/sdhci-of-arasan.c
+F:	drivers/edac/synopsys_edac.c
 
 ARM SMMU DRIVER
 M:	Will Deacon <will.deacon@arm.com>
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 7072c28..b7b6691 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -385,4 +385,11 @@ config EDAC_ALTERA_MC
 	  preloader must initialize the SDRAM before loading
 	  the kernel.
 
+config EDAC_SYNOPSYS
+	tristate "Synopsys DDR Memory Controller"
+	depends on EDAC_MM_EDAC && ARCH_ZYNQ
+	help
+	  Support for error detection and correction on the Synopsys DDR
+	  memory controller.
+
 endif # EDAC
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 359aa49..9b5a095 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -67,3 +67,4 @@ obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
 obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
 
 obj-$(CONFIG_EDAC_ALTERA_MC)		+= altera_edac.o
+obj-$(CONFIG_EDAC_SYNOPSYS)		+= synopsys_edac.o
diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
new file mode 100644
index 0000000..fa0e6fa
--- /dev/null
+++ b/drivers/edac/synopsys_edac.c
@@ -0,0 +1,528 @@
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
+#define CTRL_OFST		0x0
+#define T_ZQ_OFST		0xA4
+
+/* ECC control register */
+#define ECC_CTRL_OFST		0xC4
+/* ECC log register */
+#define CE_LOG_OFST		0xC8
+/* ECC address register */
+#define CE_ADDR_OFST		0xCC
+/* ECC data[31:0] register */
+#define CE_DATA_31_0_OFST	0xD0
+
+/* Uncorrectable error info registers */
+#define UE_LOG_OFST		0xDC
+#define UE_ADDR_OFST		0xE0
+#define UE_DATA_31_0_OFST	0xE4
+
+#define STAT_OFST		0xF0
+#define SCRUB_OFST		0xF4
+
+/* Control register bit field definitions */
+#define CTRL_BW_MASK		0xC
+#define CTRL_BW_SHIFT		2
+
+#define DDRCTL_WDTH_16		1
+#define DDRCTL_WDTH_32		0
+
+/* ZQ register bit field definitions */
+#define T_ZQ_DDRMODE_MASK	0x2
+
+/* ECC control register bit field definitions */
+#define ECC_CTRL_CLR_CE_ERR	0x2
+#define ECC_CTRL_CLR_UE_ERR	0x1
+
+/* ECC correctable/uncorrectable error log register definitions */
+#define LOG_VALID		0x1
+#define CE_LOG_BITPOS_MASK	0xFE
+#define CE_LOG_BITPOS_SHIFT	1
+
+/* ECC correctable/uncorrectable error address register definitions */
+#define ADDR_COL_MASK		0xFFF
+#define ADDR_ROW_MASK		0xFFFF000
+#define ADDR_ROW_SHIFT		12
+#define ADDR_BANK_MASK		0x70000000
+#define ADDR_BANK_SHIFT		28
+
+/* ECC statistic register definitions */
+#define STAT_UECNT_MASK		0xFF
+#define STAT_CECNT_MASK		0xFF00
+#define STAT_CECNT_SHIFT	8
+
+/* ECC scrub register definitions */
+#define SCRUB_MODE_MASK		0x7
+#define SCRUB_MODE_SECDED	0x4
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
+ * @ce_cnt:	Correctable error count
+ * @ue_cnt:	Uncorrectable error count
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
+ * @ce_cnt:		Correctable Error count
+ * @ue_cnt:		Uncorrectable Error count
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
+ * @p:		Pointer to the synopsys ecc status structure
+ *
+ * Determines there is any ecc error or not
+ *
+ * Return: one if there is no error otherwise returns zero
+ */
+static int synps_edac_geterror_info(void __iomem *base,
+				    struct synps_ecc_status *p)
+{
+	u32 regval, clearval = 0;
+
+	regval = readl(base + STAT_OFST);
+	if (!regval)
+		return 1;
+
+	memset(p, 0, sizeof(*p));
+
+	p->ce_cnt = (regval & STAT_CECNT_MASK) >> STAT_CECNT_SHIFT;
+	p->ue_cnt = regval & STAT_UECNT_MASK;
+
+	regval = readl(base + CE_LOG_OFST);
+	if (!(p->ce_cnt && (regval & LOG_VALID)))
+		goto ue_err;
+
+	p->ceinfo.bitpos = (regval & CE_LOG_BITPOS_MASK) >> CE_LOG_BITPOS_SHIFT;
+	regval = readl(base + CE_ADDR_OFST);
+	p->ceinfo.row = (regval & ADDR_ROW_MASK) >> ADDR_ROW_SHIFT;
+	p->ceinfo.col = regval & ADDR_COL_MASK;
+	p->ceinfo.bank = (regval & ADDR_BANK_MASK) >> ADDR_BANK_SHIFT;
+	p->ceinfo.data = readl(base + CE_DATA_31_0_OFST);
+	edac_dbg(3, "ce bit position: %d data: %d\n", p->ceinfo.bitpos,
+		 p->ceinfo.data);
+	clearval = ECC_CTRL_CLR_CE_ERR;
+
+ue_err:
+	regval = readl(base + UE_LOG_OFST);
+	if (!(p->ue_cnt && (regval & LOG_VALID)))
+		goto out;
+
+	regval = readl(base + UE_ADDR_OFST);
+	p->ueinfo.row = (regval & ADDR_ROW_MASK) >> ADDR_ROW_SHIFT;
+	p->ueinfo.col = regval & ADDR_COL_MASK;
+	p->ueinfo.bank = (regval & ADDR_BANK_MASK) >> ADDR_BANK_SHIFT;
+	p->ueinfo.data = readl(base + UE_DATA_31_0_OFST);
+	clearval |= ECC_CTRL_CLR_UE_ERR;
+
+out:
+	writel(clearval, base + ECC_CTRL_OFST);
+	writel(0x0, base + ECC_CTRL_OFST);
+
+	return 0;
+}
+
+/**
+ * synps_edac_handle_error - Handle controller error types CE and UE
+ * @mci:	Pointer to the edac memory controller instance
+ * @p:		Pointer to the synopsys ecc status structure
+ *
+ * Handles the controller ECC correctable and un correctable error.
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
+ * Used to check and post ECC errors. Called by the polling thread
+ */
+static void synps_edac_check(struct mem_ctl_info *mci)
+{
+	struct synps_edac_priv *priv = mci->pvt_info;
+	struct synps_ecc_status stat;
+	int status;
+
+	status = synps_edac_geterror_info(priv->baseaddr, &stat);
+	if (status)
+		return;
+
+	priv->ce_cnt += stat.ce_cnt;
+	priv->ue_cnt += stat.ue_cnt;
+	synps_edac_handle_error(mci, &stat);
+
+	edac_dbg(3, "Total error count ce %d ue %d\n",
+		 priv->ce_cnt, priv->ue_cnt);
+}
+
+/**
+ * synps_edac_get_dtype - Return the controller memory width
+ * @base:	Pointer to the ddr memory controller base address
+ *
+ * Get the EDAC device type width appropriate for the current controller
+ * configuration.
+ *
+ * Return: a device type width enumeration.
+ */
+static enum dev_type synps_edac_get_dtype(const void __iomem *base)
+{
+	enum dev_type dt;
+	u32 width;
+
+	width = readl(base + CTRL_OFST);
+	width = (width & CTRL_BW_MASK) >> CTRL_BW_SHIFT;
+
+	switch (width) {
+	case DDRCTL_WDTH_16:
+		dt = DEV_X2;
+		break;
+	case DDRCTL_WDTH_32:
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
+ * @base:	Pointer to the ddr memory controller base address
+ *
+ * Get the ECC enable/disable status for the controller
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
+	ecctype = readl(base + SCRUB_OFST) & SCRUB_MODE_MASK;
+	if ((ecctype == SCRUB_MODE_SECDED) && (dt == DEV_X2))
+		state = true;
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
+ * Get the EDAC memory type appropriate for the current controller
+ * configuration.
+ *
+ * Return: a memory type enumeration.
+ */
+static enum mem_type synps_edac_get_mtype(const void __iomem *base)
+{
+	enum mem_type mt;
+	u32 memtype;
+
+	memtype = readl(base + T_ZQ_OFST);
+
+	if (memtype & T_ZQ_DDRMODE_MASK)
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
+ * Initializes the chip select rows associated with the EDAC memory
+ * controller instance
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
+			dimm            = csi->channels[j]->dimm;
+			dimm->edac_mode = EDAC_FLAG_SECDED;
+			dimm->mtype     = synps_edac_get_mtype(priv->baseaddr);
+			dimm->nr_pages  = (size >> PAGE_SHIFT) / csi->nr_channels;
+			dimm->grain     = SYNPS_EDAC_ERR_GRAIN;
+			dimm->dtype     = synps_edac_get_dtype(priv->baseaddr);
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
+ * Performs initialization of the EDAC memory controller instance and
+ * related driver-private data associated with the memory controller the
+ * instance is bound to.
+ *
+ * Return: Always zero.
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
+	status = synps_edac_init_csrows(mci);
+
+	return status;
+}
+
+/**
+ * synps_edac_mc_probe - Check controller and bind driver
+ * @pdev:	Pointer to the platform_device struct
+ *
+ * Probes a specific controller instance for binding with the driver.
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
+	if (!synps_edac_get_eccstate(baseaddr)) {
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
+			    "Failed memory allocation for mc instance\n");
+		return -ENOMEM;
+	}
+
+	priv = mci->pvt_info;
+	priv->baseaddr = baseaddr;
+	rc = synps_edac_mc_init(mci, pdev);
+	if (rc) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Failed to initialize instance\n");
+		goto free_edac_mc;
+	}
+
+	rc = edac_mc_add_mc(mci);
+	if (rc) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Failed to register with EDAC core\n");
+		goto free_edac_mc;
+	}
+
+	writel(0x0, baseaddr + ECC_CTRL_OFST);
+	return rc;
+
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
+	{ .compatible = "xlnx,zynq-ddrc-a05", },
+	{ /* end of table */ }
+};
+
+MODULE_DEVICE_TABLE(of, synps_edac_match);
+
+static struct platform_driver synps_edac_mc_driver = {
+	.driver = {
+		   .name = "synopsys-edac",
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

