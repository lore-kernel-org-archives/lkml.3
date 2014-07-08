Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaGHLSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:18:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:44791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbaGHLS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:18:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,625,1400050800"; 
   d="scan'208";a="540204676"
From: Maurice Petallo <mauricex.r.petallo@intel.com>
To: Chris Ball <chris@printf.net>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Maurice Petallo <mauricex.r.petallo@intel.com>
Subject: [PATCH 1/2] mmc: sdhci: Preset value not supported in Baytrail eMMC
Date: Tue,  8 Jul 2014 19:11:00 +0800
Message-Id: <1404817861-23359-2-git-send-email-mauricex.r.petallo@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1404817861-23359-1-git-send-email-mauricex.r.petallo@intel.com>
References: <1404817861-23359-1-git-send-email-mauricex.r.petallo@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"SDHCI_QUIRK2_PRESET_VALUE_BROKEN" quirk is added to prohibit
preset value enabling for Baytrail eMMC controller.

Signed-off-by: Maurice Petallo <mauricex.r.petallo@intel.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/mmc/host/sdhci-acpi.c | 1 +
 drivers/mmc/host/sdhci-pci.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index 8ce3c28..840788e 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -127,6 +127,7 @@ static const struct sdhci_acpi_slot sdhci_acpi_slot_int_emmc = {
 	.caps    = MMC_CAP_8_BIT_DATA | MMC_CAP_NONREMOVABLE | MMC_CAP_HW_RESET,
 	.caps2   = MMC_CAP2_HC_ERASE_SZ,
 	.flags   = SDHCI_ACPI_RUNTIME_PM,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 
 static const struct sdhci_acpi_slot sdhci_acpi_slot_int_sdio = {
diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 52c42fc..7514cc7 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -279,6 +279,7 @@ static int byt_sdio_probe_slot(struct sdhci_pci_slot *slot)
 static const struct sdhci_pci_fixes sdhci_intel_byt_emmc = {
 	.allow_runtime_pm = true,
 	.probe_slot	= byt_emmc_probe_slot,
+	.quirks2	= SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 
 static const struct sdhci_pci_fixes sdhci_intel_byt_sdio = {
-- 
1.8.1.4

