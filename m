Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaKKK1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:27:46 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:63118 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaKKK1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:27:43 -0500
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <mcuos.com@gmail.com>, <ben-linux@fluff.org>
CC: <gregkh@linuxfoundation.org>, <linux-mtd@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] mtd: remove .owner field for driver using module_platform_driver
Date: Tue, 11 Nov 2014 15:57:29 +0530
Message-ID: <1415701649-25915-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the .owner field for drivers which use the
platform_driver_register api because this is overriden in
_platform_driver_register.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/mtd/nand/ams-delta.c     | 1 -
 drivers/mtd/nand/atmel_nand.c    | 2 --
 drivers/mtd/nand/au1550nd.c      | 1 -
 drivers/mtd/nand/bf5xx_nand.c    | 1 -
 drivers/mtd/nand/davinci_nand.c  | 1 -
 drivers/mtd/nand/denali_dt.c     | 1 -
 drivers/mtd/nand/docg4.c         | 1 -
 drivers/mtd/nand/fsl_elbc_nand.c | 1 -
 drivers/mtd/nand/fsl_ifc_nand.c  | 1 -
 drivers/mtd/nand/fsl_upm.c       | 1 -
 drivers/mtd/nand/fsmc_nand.c     | 1 -
 drivers/mtd/nand/gpio.c          | 1 -
 drivers/mtd/nand/jz4740_nand.c   | 1 -
 drivers/mtd/nand/lpc32xx_mlc.c   | 1 -
 drivers/mtd/nand/lpc32xx_slc.c   | 1 -
 drivers/mtd/nand/mpc5121_nfc.c   | 1 -
 drivers/mtd/nand/mxc_nand.c      | 1 -
 drivers/mtd/nand/ndfc.c          | 1 -
 drivers/mtd/nand/nuc900_nand.c   | 1 -
 drivers/mtd/nand/omap2.c         | 1 -
 drivers/mtd/nand/omap_elm.c      | 1 -
 drivers/mtd/nand/orion_nand.c    | 1 -
 drivers/mtd/nand/pasemi_nand.c   | 1 -
 drivers/mtd/nand/plat_nand.c     | 1 -
 drivers/mtd/nand/s3c2410.c       | 1 -
 drivers/mtd/nand/sh_flctl.c      | 1 -
 drivers/mtd/nand/sharpsl.c       | 1 -
 drivers/mtd/nand/socrates_nand.c | 1 -
 drivers/mtd/nand/tmio_nand.c     | 1 -
 drivers/mtd/nand/txx9ndfmc.c     | 1 -
 30 files changed, 31 deletions(-)

diff --git a/drivers/mtd/nand/ams-delta.c b/drivers/mtd/nand/ams-delta.c
index 4936e9e..f1d555c 100644
--- a/drivers/mtd/nand/ams-delta.c
+++ b/drivers/mtd/nand/ams-delta.c
@@ -290,7 +290,6 @@ static struct platform_driver ams_delta_nand_driver = {
 	.remove		= ams_delta_cleanup,
 	.driver		= {
 		.name	= "ams-delta-nand",
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 19d1e9d..84c38f3 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -2312,7 +2312,6 @@ MODULE_DEVICE_TABLE(of, atmel_nand_nfc_match);
 static struct platform_driver atmel_nand_nfc_driver = {
 	.driver = {
 		.name = "atmel_nand_nfc",
-		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(atmel_nand_nfc_match),
 	},
 	.probe = atmel_nand_nfc_probe,
@@ -2324,7 +2323,6 @@ static struct platform_driver atmel_nand_driver = {
 	.remove		= atmel_nand_remove,
 	.driver		= {
 		.name	= "atmel_nand",
-		.owner	= THIS_MODULE,
 		.of_match_table	= of_match_ptr(atmel_nand_dt_ids),
 	},
 };
diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index 77d6c17..c0c3be1 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -503,7 +503,6 @@ static int au1550nd_remove(struct platform_device *pdev)
 static struct platform_driver au1550nd_driver = {
 	.driver = {
 		.name	= "au1550-nand",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= au1550nd_probe,
 	.remove		= au1550nd_remove,
diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 871c4f7..4d8d4ba 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -836,7 +836,6 @@ static struct platform_driver bf5xx_nand_driver = {
 	.remove		= bf5xx_nand_remove,
 	.driver		= {
 		.name	= DRV_NAME,
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index b922c8e..feb6d18 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -870,7 +870,6 @@ static struct platform_driver nand_davinci_driver = {
 	.remove		= nand_davinci_remove,
 	.driver		= {
 		.name	= "davinci_nand",
-		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(davinci_nand_of_match),
 	},
 };
diff --git a/drivers/mtd/nand/denali_dt.c b/drivers/mtd/nand/denali_dt.c
index 35cb17f..0cb1e8d 100644
--- a/drivers/mtd/nand/denali_dt.c
+++ b/drivers/mtd/nand/denali_dt.c
@@ -120,7 +120,6 @@ static struct platform_driver denali_dt_driver = {
 	.remove		= denali_dt_remove,
 	.driver		= {
 		.name	= "denali-nand-dt",
-		.owner	= THIS_MODULE,
 		.of_match_table	= denali_nand_dt_ids,
 	},
 };
diff --git a/drivers/mtd/nand/docg4.c b/drivers/mtd/nand/docg4.c
index ce24637..e5d7bca 100644
--- a/drivers/mtd/nand/docg4.c
+++ b/drivers/mtd/nand/docg4.c
@@ -1380,7 +1380,6 @@ static int __exit cleanup_docg4(struct platform_device *pdev)
 static struct platform_driver docg4_driver = {
 	.driver		= {
 		.name	= "docg4",
-		.owner	= THIS_MODULE,
 	},
 	.suspend	= docg4_suspend,
 	.resume		= docg4_resume,
diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 545a5c0..04b22fd 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -950,7 +950,6 @@ static const struct of_device_id fsl_elbc_nand_match[] = {
 static struct platform_driver fsl_elbc_nand_driver = {
 	.driver = {
 		.name = "fsl,elbc-fcm-nand",
-		.owner = THIS_MODULE,
 		.of_match_table = fsl_elbc_nand_match,
 	},
 	.probe = fsl_elbc_nand_probe,
diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index 2338124..b9ef7a6 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -1167,7 +1167,6 @@ static const struct of_device_id fsl_ifc_nand_match[] = {
 static struct platform_driver fsl_ifc_nand_driver = {
 	.driver = {
 		.name	= "fsl,ifc-nand",
-		.owner = THIS_MODULE,
 		.of_match_table = fsl_ifc_nand_match,
 	},
 	.probe       = fsl_ifc_nand_probe,
diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index 4d203e8..72755d7 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -347,7 +347,6 @@ MODULE_DEVICE_TABLE(of, of_fun_match);
 static struct platform_driver of_fun_driver = {
 	.driver = {
 		.name = "fsl,upm-nand",
-		.owner = THIS_MODULE,
 		.of_match_table = of_fun_match,
 	},
 	.probe		= fun_probe,
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 7a91587..edfaa21 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -1224,7 +1224,6 @@ MODULE_DEVICE_TABLE(of, fsmc_nand_id_table);
 static struct platform_driver fsmc_nand_driver = {
 	.remove = fsmc_nand_remove,
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "fsmc-nand",
 		.of_match_table = of_match_ptr(fsmc_nand_id_table),
 		.pm = &fsmc_nand_pm_ops,
diff --git a/drivers/mtd/nand/gpio.c b/drivers/mtd/nand/gpio.c
index 117ce33..9182839 100644
--- a/drivers/mtd/nand/gpio.c
+++ b/drivers/mtd/nand/gpio.c
@@ -308,7 +308,6 @@ static struct platform_driver gpio_nand_driver = {
 	.remove		= gpio_nand_remove,
 	.driver		= {
 		.name	= "gpio-nand",
-		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(gpio_nand_id_table),
 	},
 };
diff --git a/drivers/mtd/nand/jz4740_nand.c b/drivers/mtd/nand/jz4740_nand.c
index a2c804d..1633ec9 100644
--- a/drivers/mtd/nand/jz4740_nand.c
+++ b/drivers/mtd/nand/jz4740_nand.c
@@ -577,7 +577,6 @@ static struct platform_driver jz_nand_driver = {
 	.remove = jz_nand_remove,
 	.driver = {
 		.name = "jz4740-nand",
-		.owner = THIS_MODULE,
 	},
 };
 
diff --git a/drivers/mtd/nand/lpc32xx_mlc.c b/drivers/mtd/nand/lpc32xx_mlc.c
index 7335346..79c3b78 100644
--- a/drivers/mtd/nand/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/lpc32xx_mlc.c
@@ -878,7 +878,6 @@ static struct platform_driver lpc32xx_nand_driver = {
 	.suspend	= lpc32xx_nand_suspend,
 	.driver		= {
 		.name	= DRV_NAME,
-		.owner	= THIS_MODULE,
 		.of_match_table = lpc32xx_nand_match,
 	},
 };
diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index 8caef28..abfec13 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -999,7 +999,6 @@ static struct platform_driver lpc32xx_nand_driver = {
 	.suspend	= lpc32xx_nand_suspend,
 	.driver		= {
 		.name	= LPC32XX_MODNAME,
-		.owner	= THIS_MODULE,
 		.of_match_table = lpc32xx_nand_match,
 	},
 };
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index e78841a..1f12e5b 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -847,7 +847,6 @@ static struct platform_driver mpc5121_nfc_driver = {
 	.remove		= mpc5121_nfc_remove,
 	.driver		= {
 		.name = DRV_NAME,
-		.owner = THIS_MODULE,
 		.of_match_table = mpc5121_nfc_match,
 	},
 };
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index dba262b..e1d56be 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1600,7 +1600,6 @@ static int mxcnd_remove(struct platform_device *pdev)
 static struct platform_driver mxcnd_driver = {
 	.driver = {
 		   .name = DRIVER_NAME,
-		   .owner = THIS_MODULE,
 		   .of_match_table = of_match_ptr(mxcnd_dt_ids),
 	},
 	.id_table = mxcnd_devtype,
diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index 253a644..3187c6b 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -277,7 +277,6 @@ MODULE_DEVICE_TABLE(of, ndfc_match);
 static struct platform_driver ndfc_driver = {
 	.driver = {
 		.name = "ndfc",
-		.owner = THIS_MODULE,
 		.of_match_table = ndfc_match,
 	},
 	.probe = ndfc_probe,
diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
index e8a5fff..e58c644 100644
--- a/drivers/mtd/nand/nuc900_nand.c
+++ b/drivers/mtd/nand/nuc900_nand.c
@@ -300,7 +300,6 @@ static struct platform_driver nuc900_nand_driver = {
 	.remove		= nuc900_nand_remove,
 	.driver		= {
 		.name	= "nuc900-fmi",
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 3b357e9..6d74b56 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -2095,7 +2095,6 @@ static struct platform_driver omap_nand_driver = {
 	.remove		= omap_nand_remove,
 	.driver		= {
 		.name	= DRIVER_NAME,
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/mtd/nand/omap_elm.c b/drivers/mtd/nand/omap_elm.c
index 0585310..376bfe1 100644
--- a/drivers/mtd/nand/omap_elm.c
+++ b/drivers/mtd/nand/omap_elm.c
@@ -563,7 +563,6 @@ MODULE_DEVICE_TABLE(of, elm_of_match);
 static struct platform_driver elm_driver = {
 	.driver	= {
 		.name	= DRIVER_NAME,
-		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(elm_of_match),
 		.pm	= &elm_pm_ops,
 	},
diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index 471b4df..c53e369 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -224,7 +224,6 @@ static struct platform_driver orion_nand_driver = {
 	.remove		= orion_nand_remove,
 	.driver		= {
 		.name	= "orion_nand",
-		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(orion_nand_of_match_table),
 	},
 };
diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index 2c98f9d..66c345b 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -223,7 +223,6 @@ static struct platform_driver pasemi_nand_driver =
 {
 	.driver = {
 		.name = driver_name,
-		.owner = THIS_MODULE,
 		.of_match_table = pasemi_nand_match,
 	},
 	.probe		= pasemi_nand_probe,
diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 0b068a5..4535c26 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -138,7 +138,6 @@ static struct platform_driver plat_nand_driver = {
 	.remove	= plat_nand_remove,
 	.driver	= {
 		.name		= "gen_nand",
-		.owner		= THIS_MODULE,
 		.of_match_table = plat_nand_match,
 	},
 };
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 6b97bf1..35aef5e 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -1135,7 +1135,6 @@ static struct platform_driver s3c24xx_nand_driver = {
 	.id_table	= s3c24xx_driver_ids,
 	.driver		= {
 		.name	= "s3c24xx-nand",
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index 0ed7c60..a21c378 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -1190,7 +1190,6 @@ static struct platform_driver flctl_driver = {
 	.remove		= flctl_remove,
 	.driver = {
 		.name	= "sh_flctl",
-		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(of_flctl_match),
 	},
 };
diff --git a/drivers/mtd/nand/sharpsl.c b/drivers/mtd/nand/sharpsl.c
index e81059b..842c47a 100644
--- a/drivers/mtd/nand/sharpsl.c
+++ b/drivers/mtd/nand/sharpsl.c
@@ -220,7 +220,6 @@ static int sharpsl_nand_remove(struct platform_device *pdev)
 static struct platform_driver sharpsl_nand_driver = {
 	.driver = {
 		.name	= "sharpsl-nand",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= sharpsl_nand_probe,
 	.remove		= sharpsl_nand_remove,
diff --git a/drivers/mtd/nand/socrates_nand.c b/drivers/mtd/nand/socrates_nand.c
index fe8058a..d710622 100644
--- a/drivers/mtd/nand/socrates_nand.c
+++ b/drivers/mtd/nand/socrates_nand.c
@@ -240,7 +240,6 @@ MODULE_DEVICE_TABLE(of, socrates_nand_match);
 static struct platform_driver socrates_nand_driver = {
 	.driver = {
 		.name = "socrates_nand",
-		.owner = THIS_MODULE,
 		.of_match_table = socrates_nand_match,
 	},
 	.probe		= socrates_nand_probe,
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index fb8fd35..5c168a2 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -493,7 +493,6 @@ static int tmio_resume(struct platform_device *dev)
 
 static struct platform_driver tmio_driver = {
 	.driver.name	= "tmio-nand",
-	.driver.owner	= THIS_MODULE,
 	.probe		= tmio_probe,
 	.remove		= tmio_remove,
 	.suspend	= tmio_suspend,
diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index c1622a5..9c0bc45 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -417,7 +417,6 @@ static struct platform_driver txx9ndfmc_driver = {
 	.resume		= txx9ndfmc_resume,
 	.driver		= {
 		.name	= "txx9ndfmc",
-		.owner	= THIS_MODULE,
 	},
 };
 
-- 
1.7.11.7

