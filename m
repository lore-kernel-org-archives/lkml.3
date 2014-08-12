Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaHLQOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:14:40 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:41621 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaHLQOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:14:37 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tgih.jun@samsung.com, jh80.chung@samsung.com, chris@printf.net,
        ulf.hansson@linaro.org, jarkko.lavinen@nokia.com, balajitk@ti.com,
        baohua@kernel.org, viresh.linux@gmail.com, ian.molton@codethink.co.uk,
        maxime.ripard@free-electrons.com, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, spear-devel@list.st.com,
        linux-tegra@vger.kernel.org, michal.simek@xilinx.com,
        swarren@wwwdotorg.org
Cc: peter.griffin@linaro.org, patches@linaro.org, lee.jones@linaro.org
Subject: [PATCH 1/5] mmc: remove .owner field for drivers using module_platform_driver
Date: Tue, 12 Aug 2014 17:14:25 +0100
Message-Id: <1407860069-12706-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407860069-12706-1-git-send-email-peter.griffin@linaro.org>
References: <1407860069-12706-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/mmc/host/jz4740_mmc.c      | 1 -
 drivers/mmc/host/moxart-mmc.c      | 1 -
 drivers/mmc/host/mxcmmc.c          | 1 -
 drivers/mmc/host/mxs-mmc.c         | 1 -
 drivers/mmc/host/omap.c            | 1 -
 drivers/mmc/host/omap_hsmmc.c      | 1 -
 drivers/mmc/host/pxamci.c          | 1 -
 drivers/mmc/host/rtsx_pci_sdmmc.c  | 1 -
 drivers/mmc/host/rtsx_usb_sdmmc.c  | 1 -
 drivers/mmc/host/s3cmci.c          | 1 -
 drivers/mmc/host/sdhci-bcm-kona.c  | 1 -
 drivers/mmc/host/sdhci-bcm2835.c   | 1 -
 drivers/mmc/host/sdhci-cns3xxx.c   | 1 -
 drivers/mmc/host/sdhci-dove.c      | 1 -
 drivers/mmc/host/sdhci-esdhc-imx.c | 1 -
 drivers/mmc/host/sdhci-msm.c       | 1 -
 drivers/mmc/host/sdhci-of-arasan.c | 1 -
 drivers/mmc/host/sdhci-of-esdhc.c  | 1 -
 drivers/mmc/host/sdhci-of-hlwd.c   | 1 -
 drivers/mmc/host/sdhci-pxav2.c     | 1 -
 drivers/mmc/host/sdhci-pxav3.c     | 1 -
 drivers/mmc/host/sdhci-s3c.c       | 1 -
 drivers/mmc/host/sdhci-sirf.c      | 1 -
 drivers/mmc/host/sdhci-spear.c     | 1 -
 drivers/mmc/host/sdhci-tegra.c     | 1 -
 drivers/mmc/host/sh_mmcif.c        | 1 -
 drivers/mmc/host/sh_mobile_sdhi.c  | 1 -
 drivers/mmc/host/sunxi-mmc.c       | 1 -
 28 files changed, 28 deletions(-)

diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 537d6c7..e89b37d 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -909,7 +909,6 @@ static struct platform_driver jz4740_mmc_driver = {
 	.remove = jz4740_mmc_remove,
 	.driver = {
 		.name = "jz4740-mmc",
-		.owner = THIS_MODULE,
 		.pm = JZ4740_MMC_PM_OPS,
 	},
 };
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 74924a0..e9f909e 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -718,7 +718,6 @@ static struct platform_driver moxart_mmc_driver = {
 	.remove     = moxart_remove,
 	.driver     = {
 		.name		= "mmc-moxart",
-		.owner		= THIS_MODULE,
 		.of_match_table	= moxart_mmc_match,
 	},
 };
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index ed1cb93..ad11142 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1238,7 +1238,6 @@ static struct platform_driver mxcmci_driver = {
 	.id_table	= mxcmci_devtype,
 	.driver		= {
 		.name		= DRIVER_NAME,
-		.owner		= THIS_MODULE,
 		.pm	= &mxcmci_pm_ops,
 		.of_match_table	= mxcmci_of_match,
 	}
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index babfea0..d7db40b 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -734,7 +734,6 @@ static struct platform_driver mxs_mmc_driver = {
 	.id_table	= mxs_ssp_ids,
 	.driver		= {
 		.name	= DRIVER_NAME,
-		.owner	= THIS_MODULE,
 #ifdef CONFIG_PM
 		.pm	= &mxs_mmc_pm_ops,
 #endif
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 81974ec..68dd6c7 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1494,7 +1494,6 @@ static struct platform_driver mmc_omap_driver = {
 	.remove		= mmc_omap_remove,
 	.driver		= {
 		.name	= DRIVER_NAME,
-		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(mmc_omap_match),
 	},
 };
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 6b7b755..3508121 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2248,7 +2248,6 @@ static struct platform_driver omap_hsmmc_driver = {
 	.remove		= omap_hsmmc_remove,
 	.driver		= {
 		.name = DRIVER_NAME,
-		.owner = THIS_MODULE,
 		.pm = &omap_hsmmc_dev_pm_ops,
 		.of_match_table = of_match_ptr(omap_mmc_of_match),
 	},
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 32fe113..0971a23 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -885,7 +885,6 @@ static struct platform_driver pxamci_driver = {
 	.remove		= pxamci_remove,
 	.driver		= {
 		.name	= DRIVER_NAME,
-		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(pxa_mmc_dt_ids),
 	},
 };
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 0d51964..6b21982 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1295,7 +1295,6 @@ static struct platform_driver rtsx_pci_sdmmc_driver = {
 	.remove		= rtsx_pci_sdmmc_drv_remove,
 	.id_table       = rtsx_pci_sdmmc_ids,
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= DRV_NAME_RTSX_PCI_SDMMC,
 	},
 };
diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 5d3766e..469b383 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1445,7 +1445,6 @@ static struct platform_driver rtsx_usb_sdmmc_driver = {
 	.remove		= rtsx_usb_sdmmc_drv_remove,
 	.id_table       = rtsx_usb_sdmmc_ids,
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= "rtsx_usb_sdmmc",
 	},
 };
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index f237826..2260d72 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1954,7 +1954,6 @@ MODULE_DEVICE_TABLE(platform, s3cmci_driver_ids);
 static struct platform_driver s3cmci_driver = {
 	.driver	= {
 		.name	= "s3c-sdi",
-		.owner	= THIS_MODULE,
 	},
 	.id_table	= s3cmci_driver_ids,
 	.probe		= s3cmci_probe,
diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index dd780c3..2245988 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -359,7 +359,6 @@ static int sdhci_bcm_kona_remove(struct platform_device *pdev)
 static struct platform_driver sdhci_bcm_kona_driver = {
 	.driver		= {
 		.name	= "sdhci-kona",
-		.owner	= THIS_MODULE,
 		.pm	= SDHCI_PLTFM_PMOPS,
 		.of_match_table = sdhci_bcm_kona_of_match,
 	},
diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
index 46af9a4..439d259 100644
--- a/drivers/mmc/host/sdhci-bcm2835.c
+++ b/drivers/mmc/host/sdhci-bcm2835.c
@@ -194,7 +194,6 @@ MODULE_DEVICE_TABLE(of, bcm2835_sdhci_of_match);
 static struct platform_driver bcm2835_sdhci_driver = {
 	.driver = {
 		.name = "sdhci-bcm2835",
-		.owner = THIS_MODULE,
 		.of_match_table = bcm2835_sdhci_of_match,
 		.pm = SDHCI_PLTFM_PMOPS,
 	},
diff --git a/drivers/mmc/host/sdhci-cns3xxx.c b/drivers/mmc/host/sdhci-cns3xxx.c
index 14b7407..a7935a8 100644
--- a/drivers/mmc/host/sdhci-cns3xxx.c
+++ b/drivers/mmc/host/sdhci-cns3xxx.c
@@ -106,7 +106,6 @@ static int sdhci_cns3xxx_remove(struct platform_device *pdev)
 static struct platform_driver sdhci_cns3xxx_driver = {
 	.driver		= {
 		.name	= "sdhci-cns3xxx",
-		.owner	= THIS_MODULE,
 		.pm	= SDHCI_PLTFM_PMOPS,
 	},
 	.probe		= sdhci_cns3xxx_probe,
diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index e6278ec..ca969d2 100644
--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -146,7 +146,6 @@ MODULE_DEVICE_TABLE(of, sdhci_dove_of_match_table);
 static struct platform_driver sdhci_dove_driver = {
 	.driver		= {
 		.name	= "sdhci-dove",
-		.owner	= THIS_MODULE,
 		.pm	= SDHCI_PLTFM_PMOPS,
 		.of_match_table = sdhci_dove_of_match_table,
 	},
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index ccec0e3..46677f0 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1207,7 +1207,6 @@ static const struct dev_pm_ops sdhci_esdhc_pmops = {
 static struct platform_driver sdhci_esdhc_imx_driver = {
 	.driver		= {
 		.name	= "sdhci-esdhc-imx",
-		.owner	= THIS_MODULE,
 		.of_match_table = imx_esdhc_dt_ids,
 		.pm	= &sdhci_esdhc_pmops,
 	},
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 40573a5..fbffc75 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -611,7 +611,6 @@ static struct platform_driver sdhci_msm_driver = {
 	.remove = sdhci_msm_remove,
 	.driver = {
 		   .name = "sdhci_msm",
-		   .owner = THIS_MODULE,
 		   .of_match_table = sdhci_msm_dt_match,
 	},
 };
diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 5bd1092..981d66e 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -213,7 +213,6 @@ MODULE_DEVICE_TABLE(of, sdhci_arasan_of_match);
 static struct platform_driver sdhci_arasan_driver = {
 	.driver = {
 		.name = "sdhci-arasan",
-		.owner = THIS_MODULE,
 		.of_match_table = sdhci_arasan_of_match,
 		.pm = &sdhci_arasan_dev_pm_ops,
 	},
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 8be4dcf..8872c85 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -388,7 +388,6 @@ MODULE_DEVICE_TABLE(of, sdhci_esdhc_of_match);
 static struct platform_driver sdhci_esdhc_driver = {
 	.driver = {
 		.name = "sdhci-esdhc",
-		.owner = THIS_MODULE,
 		.of_match_table = sdhci_esdhc_of_match,
 		.pm = ESDHC_PMOPS,
 	},
diff --git a/drivers/mmc/host/sdhci-of-hlwd.c b/drivers/mmc/host/sdhci-of-hlwd.c
index b341661..be47927 100644
--- a/drivers/mmc/host/sdhci-of-hlwd.c
+++ b/drivers/mmc/host/sdhci-of-hlwd.c
@@ -89,7 +89,6 @@ MODULE_DEVICE_TABLE(of, sdhci_hlwd_of_match);
 static struct platform_driver sdhci_hlwd_driver = {
 	.driver = {
 		.name = "sdhci-hlwd",
-		.owner = THIS_MODULE,
 		.of_match_table = sdhci_hlwd_of_match,
 		.pm = SDHCI_PLTFM_PMOPS,
 	},
diff --git a/drivers/mmc/host/sdhci-pxav2.c b/drivers/mmc/host/sdhci-pxav2.c
index 3c0f3c0..b4c23e9 100644
--- a/drivers/mmc/host/sdhci-pxav2.c
+++ b/drivers/mmc/host/sdhci-pxav2.c
@@ -261,7 +261,6 @@ static int sdhci_pxav2_remove(struct platform_device *pdev)
 static struct platform_driver sdhci_pxav2_driver = {
 	.driver		= {
 		.name	= "sdhci-pxav2",
-		.owner	= THIS_MODULE,
 #ifdef CONFIG_OF
 		.of_match_table = sdhci_pxav2_of_match,
 #endif
diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index f4f1289..95ccadf 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -499,7 +499,6 @@ static struct platform_driver sdhci_pxav3_driver = {
 #ifdef CONFIG_OF
 		.of_match_table = sdhci_pxav3_of_match,
 #endif
-		.owner	= THIS_MODULE,
 		.pm	= SDHCI_PXAV3_PMOPS,
 	},
 	.probe		= sdhci_pxav3_probe,
diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index fa5954a..2777e33 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -747,7 +747,6 @@ static struct platform_driver sdhci_s3c_driver = {
 	.remove		= sdhci_s3c_remove,
 	.id_table	= sdhci_s3c_driver_ids,
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= "s3c-sdhci",
 		.of_match_table = of_match_ptr(sdhci_s3c_dt_match),
 		.pm	= SDHCI_S3C_PMOPS,
diff --git a/drivers/mmc/host/sdhci-sirf.c b/drivers/mmc/host/sdhci-sirf.c
index 1700453..e15dc89 100644
--- a/drivers/mmc/host/sdhci-sirf.c
+++ b/drivers/mmc/host/sdhci-sirf.c
@@ -167,7 +167,6 @@ MODULE_DEVICE_TABLE(of, sdhci_sirf_of_match);
 static struct platform_driver sdhci_sirf_driver = {
 	.driver		= {
 		.name	= "sdhci-sirf",
-		.owner	= THIS_MODULE,
 		.of_match_table = sdhci_sirf_of_match,
 #ifdef CONFIG_PM_SLEEP
 		.pm	= &sdhci_sirf_pm_ops,
diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
index 9d535c7..22e5826 100644
--- a/drivers/mmc/host/sdhci-spear.c
+++ b/drivers/mmc/host/sdhci-spear.c
@@ -230,7 +230,6 @@ MODULE_DEVICE_TABLE(of, sdhci_spear_id_table);
 static struct platform_driver sdhci_driver = {
 	.driver = {
 		.name	= "sdhci",
-		.owner	= THIS_MODULE,
 		.pm	= &sdhci_pm_ops,
 		.of_match_table = of_match_ptr(sdhci_spear_id_table),
 	},
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index d93a063..9ef9e43 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -320,7 +320,6 @@ static int sdhci_tegra_remove(struct platform_device *pdev)
 static struct platform_driver sdhci_tegra_driver = {
 	.driver		= {
 		.name	= "sdhci-tegra",
-		.owner	= THIS_MODULE,
 		.of_match_table = sdhci_tegra_dt_match,
 		.pm	= SDHCI_PLTFM_PMOPS,
 	},
diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index 656fbba..6a01d59 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1573,7 +1573,6 @@ static struct platform_driver sh_mmcif_driver = {
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.pm	= &sh_mmcif_dev_pm_ops,
-		.owner	= THIS_MODULE,
 		.of_match_table = mmcif_of_match,
 	},
 };
diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
index 91058da..be5e25d 100644
--- a/drivers/mmc/host/sh_mobile_sdhi.c
+++ b/drivers/mmc/host/sh_mobile_sdhi.c
@@ -341,7 +341,6 @@ static const struct dev_pm_ops tmio_mmc_dev_pm_ops = {
 static struct platform_driver sh_mobile_sdhi_driver = {
 	.driver		= {
 		.name	= "sh_mobile_sdhi",
-		.owner	= THIS_MODULE,
 		.pm	= &tmio_mmc_dev_pm_ops,
 		.of_match_table = sh_mobile_sdhi_of_match,
 	},
diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index 024f67c..dafe500 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -1035,7 +1035,6 @@ static int sunxi_mmc_remove(struct platform_device *pdev)
 static struct platform_driver sunxi_mmc_driver = {
 	.driver = {
 		.name	= "sunxi-mmc",
-		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(sunxi_mmc_of_match),
 	},
 	.probe		= sunxi_mmc_probe,
-- 
1.9.1

