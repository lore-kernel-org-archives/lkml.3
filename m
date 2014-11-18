Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbaKROq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:46:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbaKROKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:01 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Derek Browne <Derek.Browne@intel.com>,
        "Alvin (Weike) Chen" <alvin.chen@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 132/206] mmc: sdhci-pci: SDIO host controller support for Intel Quark X1000
Date: Tue, 18 Nov 2014 15:08:07 +0100
Message-Id: <0e5b6e1b993f400e1bd184545dedbb23017d6f74.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Derek Browne <Derek.Browne@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 43e968cec79b6334cf7cb3e11184cce720541712 upstream.

This patch is to enable SDIO host controller for Intel Quark X1000.

Signed-off-by: Derek Browne <Derek.Browne@intel.com>
Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/host/sdhci-pci.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 9995fad743a6..b2a4c22507d9 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -43,6 +43,7 @@
 #define PCI_DEVICE_ID_INTEL_CLV_SDIO2	0x08fb
 #define PCI_DEVICE_ID_INTEL_CLV_EMMC0	0x08e5
 #define PCI_DEVICE_ID_INTEL_CLV_EMMC1	0x08e6
+#define PCI_DEVICE_ID_INTEL_QRK_SD	0x08A7
 
 /*
  * PCI registers
@@ -175,6 +176,10 @@ static const struct sdhci_pci_fixes sdhci_cafe = {
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
 
+static const struct sdhci_pci_fixes sdhci_intel_qrk = {
+	.quirks		= SDHCI_QUIRK_NO_HISPD_BIT,
+};
+
 static int mrst_hc_probe_slot(struct sdhci_pci_slot *slot)
 {
 	slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA;
@@ -860,6 +865,14 @@ static const struct pci_device_id pci_ids[] = {
 
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
-- 
2.1.3

