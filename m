Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaKLCtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:49:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934589AbaKLBni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Derek Browne <Derek.Browne@intel.com>,
        "Alvin (Weike) Chen" <alvin.chen@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 118/203] mmc: sdhci-pci: SDIO host controller support for Intel Quark X1000
Date: Wed, 12 Nov 2014 10:16:28 +0900
Message-Id: <20141112011548.087788788@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Browne <Derek.Browne@intel.com>

commit 43e968cec79b6334cf7cb3e11184cce720541712 upstream.

This patch is to enable SDIO host controller for Intel Quark X1000.

Signed-off-by: Derek Browne <Derek.Browne@intel.com>
Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci.c |   12 ++++++++++++
 drivers/mmc/host/sdhci-pci.h |    1 +
 2 files changed, 13 insertions(+)

--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -103,6 +103,10 @@ static const struct sdhci_pci_fixes sdhc
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
 
+static const struct sdhci_pci_fixes sdhci_intel_qrk = {
+	.quirks		= SDHCI_QUIRK_NO_HISPD_BIT,
+};
+
 static int mrst_hc_probe_slot(struct sdhci_pci_slot *slot)
 {
 	slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA;
@@ -732,6 +736,14 @@ static const struct pci_device_id pci_id
 	},
 
 	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_QRK_SD,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_qrk,
+	},
+
+	{
 		.vendor		= PCI_VENDOR_ID_INTEL,
 		.device		= PCI_DEVICE_ID_INTEL_MRST_SD0,
 		.subvendor	= PCI_ANY_ID,
--- a/drivers/mmc/host/sdhci-pci.h
+++ b/drivers/mmc/host/sdhci-pci.h
@@ -17,6 +17,7 @@
 #define PCI_DEVICE_ID_INTEL_CLV_SDIO2	0x08fb
 #define PCI_DEVICE_ID_INTEL_CLV_EMMC0	0x08e5
 #define PCI_DEVICE_ID_INTEL_CLV_EMMC1	0x08e6
+#define PCI_DEVICE_ID_INTEL_QRK_SD	0x08A7
 
 /*
  * PCI registers


