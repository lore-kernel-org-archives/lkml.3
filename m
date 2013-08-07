Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3HGWkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:40:10 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1088 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452Ab3HGWkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:40:08 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Markus Mayer" <markus.mayer@linaro.org>
To: "Chris Ball" <cjb@laptop.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>
cc: "Christian Daudt" <csd@broadcom.com>,
        "Linaro Patches" <patches@linaro.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Markus Mayer" <markus.mayer@linaro.org>
Subject: [PATCH] mmc: sdhci-bcm-kona: make linker-section warning go
 away
Date: Wed, 7 Aug 2013 15:39:59 -0700
Message-ID: <1375915199-13694-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-WSS-ID: 7E1C145031W81966189-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes the following build warning go away:
[...]
  LINK    vmlinux
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Christian Daudt <csd@broadcom.com>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 drivers/mmc/host/sdhci-bcm-kona.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index 87175f9..34fd652 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -221,13 +221,13 @@ static struct sdhci_pltfm_data sdhci_pltfm_data_kona = {
 		SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 };
 
-static const struct of_device_id sdhci_bcm_kona_of_match[] __initdata = {
+static struct __initconst of_device_id sdhci_bcm_kona_of_match[] = {
 	{ .compatible = "bcm,kona-sdhci"},
 	{}
 };
 MODULE_DEVICE_TABLE(of, sdhci_bcm_kona_of_match);
 
-static int __init sdhci_bcm_kona_probe(struct platform_device *pdev)
+static int sdhci_bcm_kona_probe(struct platform_device *pdev)
 {
 	struct sdhci_bcm_kona_dev *kona_dev = NULL;
 	struct sdhci_pltfm_host *pltfm_priv;
@@ -336,10 +336,10 @@ static struct platform_driver sdhci_bcm_kona_driver = {
 		.name	= "sdhci-kona",
 		.owner	= THIS_MODULE,
 		.pm	= SDHCI_PLTFM_PMOPS,
-		.of_match_table = of_match_ptr(sdhci_bcm_kona_of_match),
+		.of_match_table = sdhci_bcm_kona_of_match,
 	},
 	.probe		= sdhci_bcm_kona_probe,
-	.remove		= __exit_p(sdhci_bcm_kona_remove),
+	.remove		= sdhci_bcm_kona_remove,
 };
 module_platform_driver(sdhci_bcm_kona_driver);
 
-- 
1.7.9.5


