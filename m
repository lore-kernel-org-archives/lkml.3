Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaKRPIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:08:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbaKROJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:38 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Ernst <eric.ernst@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Chris Ball <cjb@laptop.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/206] mmc: sdhci-pci: Add SDIO/MMC device ID support for Intel Clovertrail
Date: Tue, 18 Nov 2014 15:06:42 +0100
Message-Id: <5044d67c2ef5a035cf3eb9e7a6613f0cc80188ed.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Ernst <eric.ernst@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d052068a0ba43273eb9cfe32460e9445ef75fdc5 upstream.

This patch adds intel_mid clovertrail SDIO and eMMC device
IDs to the sdhci-pci driver.

Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/host/sdhci-pci.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 689e655a122b..9995fad743a6 100644
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
@@ -965,6 +970,47 @@ static const struct pci_device_id pci_ids[] = {
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
2.1.3

