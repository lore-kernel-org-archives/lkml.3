Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845AbaFTIRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:17:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:63991 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934721AbaFTIRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:17:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,512,1400050800"; 
   d="scan'208";a="558394305"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Chris Ball <chris@printf.net>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdhci-pci: Quark SDIO host controller supporting
Date: Fri, 20 Jun 2014 09:13:56 -0700
Message-Id: <1403280836-26943-2-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403280836-26943-1-git-send-email-alvin.chen@intel.com>
References: <1403280836-26943-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Derek Browne <Derek.Browne@intel.com>

On Intel Quark, there is a SDIO host controller. This patch is added to
enable the SDIO host controller.

Signed-off-by: Derek Browne <Derek.Browne@intel.com>
Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |   12 ++++++++++++
 include/linux/pci_ids.h      |    2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 52c42fc..1aeeefc 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -103,6 +103,10 @@ static const struct sdhci_pci_fixes sdhci_cafe = {
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
 
+static const struct sdhci_pci_fixes sdhci_intel_qrk = {
+	.quirks		= SDHCI_QUIRK_NO_HISPD_BIT,
+};
+
 static int mrst_hc_probe_slot(struct sdhci_pci_slot *slot)
 {
 	slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA;
@@ -753,6 +757,14 @@ static const struct pci_device_id pci_ids[] = {
 
 	{
 		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_QRK_SD,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_qrk,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
 		.device		= PCI_DEVICE_ID_INTEL_MRST_SD0,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d4de24b..5bba2c3 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2557,6 +2557,7 @@
 #define PCI_DEVICE_ID_INTEL_MFD_EMMC0	0x0823
 #define PCI_DEVICE_ID_INTEL_MFD_EMMC1	0x0824
 #define PCI_DEVICE_ID_INTEL_MRST_SD2	0x084F
+#define PCI_DEVICE_ID_INTEL_QUARK_ILB	0x095E
 #define PCI_DEVICE_ID_INTEL_I960	0x0960
 #define PCI_DEVICE_ID_INTEL_I960RM	0x0962
 #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60
@@ -2579,6 +2580,7 @@
 #define PCI_DEVICE_ID_INTEL_82840_HB	0x1a21
 #define PCI_DEVICE_ID_INTEL_82845_HB	0x1a30
 #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
+#define PCI_DEVICE_ID_INTEL_QRK_SD	0x08A7
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
-- 
1.7.9.5

