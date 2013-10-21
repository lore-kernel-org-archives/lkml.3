Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab3JUQye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 12:54:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:4917 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab3JUQyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 12:54:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="377808908"
From: Eric Ernst <eric.ernst@linux.intel.com>
To: cjb@laptop.org, adrian.hunter@intel.com, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Eric Ernst <eric.ernst@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] Add SDIO and MMC device ID support for CLV
Date: Mon, 21 Oct 2013 09:54:41 -0700
Message-Id: <1382374481-197092-1-git-send-email-eric.ernst@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds intel_mid clovertrail SDIO and eMMC device
IDs to the sdhci-pci driver.

Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/mmc/host/sdhci-pci.c |   46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 06f026a..8f75381 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -38,6 +38,11 @@
 #define PCI_DEVICE_ID_INTEL_BYT_SD	0x0f16
 #define PCI_DEVICE_ID_INTEL_BYT_EMMC2	0x0f50
 #define PCI_DEVICE_ID_INTEL_MRFL_MMC	0x1190
+#define PCI_DEVICE_ID_INTEL_CLV_SDIO0	0x08f9
+#define PCI_DEVICE_ID_INTEL_CLV_SDIO1	0x08fa
+#define PCI_DEVICE_ID_INTEL_CLV_SDIO2	0x08fb
+#define PCI_DEVICE_ID_INTEL_CLV_EMMC0	0x08e5
+#define PCI_DEVICE_ID_INTEL_CLV_EMMC1	0x08e6
 
 /*
  * PCI registers
@@ -962,6 +967,47 @@ static const struct pci_device_id pci_ids[] = {
 		.driver_data	= (kernel_ulong_t)&sdhci_intel_byt_emmc,
 	},
 
+
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_CLV_SDIO0,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_mfd_sd,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_CLV_SDIO1,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_mfd_sdio,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_CLV_SDIO2,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_mfd_sdio,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_CLV_EMMC0,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_mfd_emmc,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_CLV_EMMC1,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_mfd_emmc,
+	},
+
 	{
 		.vendor		= PCI_VENDOR_ID_INTEL,
 		.device		= PCI_DEVICE_ID_INTEL_MRFL_MMC,
-- 
1.7.9.5

