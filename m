Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaKYKtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:49:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59208 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaKYKnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Derek Browne <Derek.Browne@intel.com>,
        "Alvin (Weike) Chen" <alvin.chen@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 238/254] mmc: sdhci-pci: SDIO host controller support for Intel Quark X1000
Date: Tue, 25 Nov 2014 10:39:48 +0000
Message-Id: <1416912004-5928-239-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Browne <Derek.Browne@intel.com>

commit 43e968cec79b6334cf7cb3e11184cce720541712 upstream.

This patch is to enable SDIO host controller for Intel Quark X1000.

Signed-off-by: Derek Browne <Derek.Browne@intel.com>
Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/sdhci-pci.c | 12 ++++++++++++
 drivers/mmc/host/sdhci-pci.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 52c42fcc284c..1aeeefc71512 100644
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
diff --git a/drivers/mmc/host/sdhci-pci.h b/drivers/mmc/host/sdhci-pci.h
index 6d718719659e..c101477ef3be 100644
--- a/drivers/mmc/host/sdhci-pci.h
+++ b/drivers/mmc/host/sdhci-pci.h
@@ -17,6 +17,7 @@
 #define PCI_DEVICE_ID_INTEL_CLV_SDIO2	0x08fb
 #define PCI_DEVICE_ID_INTEL_CLV_EMMC0	0x08e5
 #define PCI_DEVICE_ID_INTEL_CLV_EMMC1	0x08e6
+#define PCI_DEVICE_ID_INTEL_QRK_SD	0x08A7
 
 /*
  * PCI registers
-- 
2.1.0

