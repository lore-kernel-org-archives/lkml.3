Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3JUD1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 23:27:19 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57838 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3JUD1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 23:27:16 -0400
From: Benson Leung <bleung@chromium.org>
To: wsa@the-dreams.de, mika.westerberg@linux.intel.com, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dlaurie@chromium.org, bleung@chromium.org
Subject: [PATCH 1/2] i2c-designware-pci: Add Haswell ULT device IDs
Date: Sun, 20 Oct 2013 20:26:49 -0700
Message-Id: <1382326010-4554-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382326010-4554-1-git-send-email-bleung@chromium.org>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Duncan Laurie <dlaurie@chromium.org>

Add the necessary PCI Device IDs to use the Haswell ULT
I2C controller in PCI mode.

Set the bus numbers to -1 so it will use dynamic assignment
rather than hardcoded.

Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index f6ed06c..e4cbbdf 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -54,6 +54,9 @@ enum dw_pci_ctl_id_t {
 	medfield_3,
 	medfield_4,
 	medfield_5,
+
+	haswell_0,
+	haswell_1,
 };
 
 struct dw_pci_controller {
@@ -132,6 +135,20 @@ static struct  dw_pci_controller  dw_pci_controllers[] = {
 		.rx_fifo_depth = 32,
 		.clk_khz      = 25000,
 	},
+	[haswell_0] = {
+		.bus_num     = -1,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_STD,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
+	[haswell_1] = {
+		.bus_num     = -1,
+		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_STD,
+		.tx_fifo_depth = 32,
+		.rx_fifo_depth = 32,
+		.clk_khz      = 25000,
+	},
 };
 static struct i2c_algorithm i2c_dw_algo = {
 	.master_xfer	= i2c_dw_xfer,
@@ -321,6 +338,9 @@ static DEFINE_PCI_DEVICE_TABLE(i2_designware_pci_ids) = {
 	{ PCI_VDEVICE(INTEL, 0x082C), medfield_0 },
 	{ PCI_VDEVICE(INTEL, 0x082D), medfield_1 },
 	{ PCI_VDEVICE(INTEL, 0x082E), medfield_2 },
+	/* Haswell ULT */
+	{ PCI_VDEVICE(INTEL, 0x9c61), haswell_0 },
+	{ PCI_VDEVICE(INTEL, 0x9c62), haswell_1 },
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, i2_designware_pci_ids);
-- 
1.8.3.2

