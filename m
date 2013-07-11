Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab3GKJQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:16:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13277 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608Ab3GKJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:16:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 11 Jul 2013 02:17:21 -0700
From: Wei Ni <wni@nvidia.com>
To: <grant.likely@linaro.org>, <rob@landley.net>, <rob.herring@calxeda.com>,
        <cjb@laptop.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH] mmc: dt: add host-off-card-on dt property
Date: Thu, 11 Jul 2013 17:15:29 +0800
Message-ID: <1373534129-9017-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "host-off-card-on" dt property and parse it to support the
quirk SDHCI_QUIRK2_HOST_OFF_CARD_ON.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 Documentation/devicetree/bindings/mmc/mmc.txt |    2 ++
 drivers/mmc/host/sdhci-pltfm.c                |    3 +++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index 85aada2..95ebe3e 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -28,6 +28,8 @@ Optional properties:
 - cap-mmc-highspeed: MMC high-speed timing is supported
 - cap-power-off-card: powering off the card is safe
 - cap-sdio-irq: enable SDIO IRQ signalling on this interface
+- host-off-card-on: when resume, denote that card keeps power
+  but host controller does not, so that it will reset sdhci all.
 
 *NOTE* on CD and WP polarity. To use common for all SD/MMC host controllers line
 polarity properties, we have to fix the meaning of the "normal" and "inverted"
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index cd0f1f6..b3730cc 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -89,6 +89,9 @@ void sdhci_get_of_property(struct platform_device *pdev)
 		if (of_get_property(np, "no-1-8-v", NULL))
 			host->quirks2 |= SDHCI_QUIRK2_NO_1_8_V;
 
+		if (of_get_property(np, "host-off-card-on", NULL))
+			host->quirks2 |= SDHCI_QUIRK2_HOST_OFF_CARD_ON;
+
 		if (of_device_is_compatible(np, "fsl,p2020-rev1-esdhc"))
 			host->quirks |= SDHCI_QUIRK_BROKEN_DMA;
 
-- 
1.7.9.5

