Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaBSOKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:10:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:42202 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaBSOKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:10:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="scan'208";a="485817933"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2] i2c: designware-pci: Add Baytrail PCI IDs
Date: Wed, 19 Feb 2014 16:10:29 +0200
Message-Id: <1392819029-6438-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Baytrail I2C controllers can be enumerated from PCI as well as from
ACPI. In order to support this add the Baytrail PCI IDs to the driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changes to previous version:
 * Removed "-%d" from the adapter name.

 drivers/i2c/busses/i2c-designware-pcidrv.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index c0a87a5eb63e..80c3b5e0a5c8 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -54,6 +54,8 @@ enum dw_pci_ctl_id_t {
 	medfield_3,
 	medfield_4,
 	medfield_5,
+
+	baytrail,
 };
 
 struct dw_pci_controller {
@@ -132,6 +134,13 @@ static struct  dw_pci_controller  dw_pci_controllers[] = {
 		.rx_fifo_depth = 32,
 		.clk_khz      = 25000,
 	},
+	[baytrail] = {
+		.bus_num = -1,
+		.bus_cfg = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_FAST,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz = 100000,
+	},
 };
 static struct i2c_algorithm i2c_dw_algo = {
 	.master_xfer	= i2c_dw_xfer,
@@ -226,8 +235,8 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 	adap->algo = &i2c_dw_algo;
 	adap->dev.parent = &pdev->dev;
 	adap->nr = controller->bus_num;
-	snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci-%d",
-		adap->nr);
+
+	snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci");
 
 	r = devm_request_irq(&pdev->dev, pdev->irq, i2c_dw_isr, IRQF_SHARED,
 			adap->name, dev);
@@ -278,6 +287,14 @@ static DEFINE_PCI_DEVICE_TABLE(i2_designware_pci_ids) = {
 	{ PCI_VDEVICE(INTEL, 0x082C), medfield_0 },
 	{ PCI_VDEVICE(INTEL, 0x082D), medfield_1 },
 	{ PCI_VDEVICE(INTEL, 0x082E), medfield_2 },
+	/* Baytrail */
+	{ PCI_VDEVICE(INTEL, 0x0F41), baytrail },
+	{ PCI_VDEVICE(INTEL, 0x0F42), baytrail },
+	{ PCI_VDEVICE(INTEL, 0x0F43), baytrail },
+	{ PCI_VDEVICE(INTEL, 0x0F44), baytrail },
+	{ PCI_VDEVICE(INTEL, 0x0F45), baytrail },
+	{ PCI_VDEVICE(INTEL, 0x0F46), baytrail },
+	{ PCI_VDEVICE(INTEL, 0x0F47), baytrail },
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, i2_designware_pci_ids);
-- 
1.9.0.rc3

