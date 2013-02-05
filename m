Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3BEOpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:45:55 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:45805 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3BEOpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:45:54 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH V2] spi: Remove erroneous __init, __exit and __exit_p() references in drivers
Date: Tue,  5 Feb 2013 14:45:48 +0000
Message-Id: <1360075548-28705-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the spi driver module remove hooks were annotated with __exit
and referenced with __exit_p(). Presumably these were supposed to be
__devinit, __devexit and __devexit_p() since __init/__exit for a
probe/remove hook has never been correct. They also got missed during
the big __devinit/__devexit purge since they didn't match the pattern.
Remove then now to be rid of it.

v2: purge __init also

Reported-by: Arnd Bergmann <arnd@arndb.de>
[Arnd set a patch cleaning up one, and then I found more]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/spi/spi-atmel.c      |    2 +-
 drivers/spi/spi-au1550.c     |    8 ++++----
 drivers/spi/spi-bfin5xx.c    |    2 +-
 drivers/spi/spi-omap-100k.c  |    6 +++---
 drivers/spi/spi-omap-uwire.c |    6 +++---
 drivers/spi/spi-orion.c      |    8 ++++----
 drivers/spi/spi-ppc4xx.c     |    6 +++---
 drivers/spi/spi-s3c64xx.c    |    2 +-
 drivers/spi/spi-txx9.c       |    6 +++---
 9 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index ab34497..656d137 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1088,7 +1088,7 @@ static struct platform_driver atmel_spi_driver = {
 	.suspend	= atmel_spi_suspend,
 	.resume		= atmel_spi_resume,
 	.probe		= atmel_spi_probe,
-	.remove		= __exit_p(atmel_spi_remove),
+	.remove		= atmel_spi_remove,
 };
 module_platform_driver(atmel_spi_driver);
 
diff --git a/drivers/spi/spi-au1550.c b/drivers/spi/spi-au1550.c
index 4de66d1c..44dd34b 100644
--- a/drivers/spi/spi-au1550.c
+++ b/drivers/spi/spi-au1550.c
@@ -717,7 +717,7 @@ static void au1550_spi_bits_handlers_set(struct au1550_spi *hw, int bpw)
 	}
 }
 
-static void __init au1550_spi_setup_psc_as_spi(struct au1550_spi *hw)
+static void au1550_spi_setup_psc_as_spi(struct au1550_spi *hw)
 {
 	u32 stat, cfg;
 
@@ -766,7 +766,7 @@ static void __init au1550_spi_setup_psc_as_spi(struct au1550_spi *hw)
 }
 
 
-static int __init au1550_spi_probe(struct platform_device *pdev)
+static int au1550_spi_probe(struct platform_device *pdev)
 {
 	struct au1550_spi *hw;
 	struct spi_master *master;
@@ -968,7 +968,7 @@ err_nomem:
 	return err;
 }
 
-static int __exit au1550_spi_remove(struct platform_device *pdev)
+static int au1550_spi_remove(struct platform_device *pdev)
 {
 	struct au1550_spi *hw = platform_get_drvdata(pdev);
 
@@ -997,7 +997,7 @@ static int __exit au1550_spi_remove(struct platform_device *pdev)
 MODULE_ALIAS("platform:au1550-spi");
 
 static struct platform_driver au1550_spi_drv = {
-	.remove = __exit_p(au1550_spi_remove),
+	.remove = au1550_spi_remove,
 	.driver = {
 		.name = "au1550-spi",
 		.owner = THIS_MODULE,
diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
index 7d7c991..317f564 100644
--- a/drivers/spi/spi-bfin5xx.c
+++ b/drivers/spi/spi-bfin5xx.c
@@ -1273,7 +1273,7 @@ static int bfin_spi_destroy_queue(struct bfin_spi_master_data *drv_data)
 	return 0;
 }
 
-static int __init bfin_spi_probe(struct platform_device *pdev)
+static int bfin_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct bfin5xx_spi_master *platform_info;
diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 3aef7fa..78d29a1 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -481,7 +481,7 @@ static int omap1_spi100k_transfer(struct spi_device *spi, struct spi_message *m)
 	return 0;
 }
 
-static int __init omap1_spi100k_reset(struct omap1_spi100k *spi100k)
+static int omap1_spi100k_reset(struct omap1_spi100k *spi100k)
 {
 	return 0;
 }
@@ -560,7 +560,7 @@ err1:
 	return status;
 }
 
-static int __exit omap1_spi100k_remove(struct platform_device *pdev)
+static int omap1_spi100k_remove(struct platform_device *pdev)
 {
 	struct spi_master       *master;
 	struct omap1_spi100k    *spi100k;
@@ -604,7 +604,7 @@ static struct platform_driver omap1_spi100k_driver = {
 		.name		= "omap1_spi100k",
 		.owner		= THIS_MODULE,
 	},
-	.remove		= __exit_p(omap1_spi100k_remove),
+	.remove		= omap1_spi100k_remove,
 };
 
 
diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index 0a94d9d..102b233 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -476,7 +476,7 @@ static void uwire_off(struct uwire_spi *uwire)
 	spi_master_put(uwire->bitbang.master);
 }
 
-static int __init uwire_probe(struct platform_device *pdev)
+static int uwire_probe(struct platform_device *pdev)
 {
 	struct spi_master	*master;
 	struct uwire_spi	*uwire;
@@ -536,7 +536,7 @@ static int __init uwire_probe(struct platform_device *pdev)
 	return status;
 }
 
-static int __exit uwire_remove(struct platform_device *pdev)
+static int uwire_remove(struct platform_device *pdev)
 {
 	struct uwire_spi	*uwire = dev_get_drvdata(&pdev->dev);
 	int			status;
@@ -557,7 +557,7 @@ static struct platform_driver uwire_driver = {
 		.name		= "omap_uwire",
 		.owner		= THIS_MODULE,
 	},
-	.remove		= __exit_p(uwire_remove),
+	.remove		= uwire_remove,
 	// suspend ... unuse ck
 	// resume ... use ck
 };
diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index b7e7182..6a3cdc7 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -366,7 +366,7 @@ msg_done:
 	return 0;
 }
 
-static int __init orion_spi_reset(struct orion_spi *orion_spi)
+static int orion_spi_reset(struct orion_spi *orion_spi)
 {
 	/* Verify that the CS is deasserted */
 	orion_spi_set_cs(orion_spi, 0);
@@ -396,7 +396,7 @@ static int orion_spi_setup(struct spi_device *spi)
 	return 0;
 }
 
-static int __init orion_spi_probe(struct platform_device *pdev)
+static int orion_spi_probe(struct platform_device *pdev)
 {
 	struct spi_master *master;
 	struct orion_spi *spi;
@@ -479,7 +479,7 @@ out:
 }
 
 
-static int __exit orion_spi_remove(struct platform_device *pdev)
+static int orion_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master;
 	struct resource *r;
@@ -513,7 +513,7 @@ static struct platform_driver orion_spi_driver = {
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(orion_spi_of_match_table),
 	},
-	.remove		= __exit_p(orion_spi_remove),
+	.remove		= orion_spi_remove,
 };
 
 static int __init orion_spi_init(void)
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 7a85f22..424b333 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -389,7 +389,7 @@ static void free_gpios(struct ppc4xx_spi *hw)
 /*
  * platform_device layer stuff...
  */
-static int __init spi_ppc4xx_of_probe(struct platform_device *op)
+static int spi_ppc4xx_of_probe(struct platform_device *op)
 {
 	struct ppc4xx_spi *hw;
 	struct spi_master *master;
@@ -560,7 +560,7 @@ free_master:
 	return ret;
 }
 
-static int __exit spi_ppc4xx_of_remove(struct platform_device *op)
+static int spi_ppc4xx_of_remove(struct platform_device *op)
 {
 	struct spi_master *master = dev_get_drvdata(&op->dev);
 	struct ppc4xx_spi *hw = spi_master_get_devdata(master);
@@ -583,7 +583,7 @@ MODULE_DEVICE_TABLE(of, spi_ppc4xx_of_match);
 
 static struct platform_driver spi_ppc4xx_of_driver = {
 	.probe = spi_ppc4xx_of_probe,
-	.remove = __exit_p(spi_ppc4xx_of_remove),
+	.remove = spi_ppc4xx_of_remove,
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index d8928d0..8f492ed 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1191,7 +1191,7 @@ static inline struct s3c64xx_spi_port_config *s3c64xx_spi_get_port_config(
 			 platform_get_device_id(pdev)->driver_data;
 }
 
-static int __init s3c64xx_spi_probe(struct platform_device *pdev)
+static int s3c64xx_spi_probe(struct platform_device *pdev)
 {
 	struct resource	*mem_res;
 	struct s3c64xx_spi_driver_data *sdd;
diff --git a/drivers/spi/spi-txx9.c b/drivers/spi/spi-txx9.c
index 550b5f4..adb8530 100644
--- a/drivers/spi/spi-txx9.c
+++ b/drivers/spi/spi-txx9.c
@@ -335,7 +335,7 @@ static int txx9spi_transfer(struct spi_device *spi, struct spi_message *m)
 	return 0;
 }
 
-static int __init txx9spi_probe(struct platform_device *dev)
+static int txx9spi_probe(struct platform_device *dev)
 {
 	struct spi_master *master;
 	struct txx9spi *c;
@@ -430,7 +430,7 @@ exit:
 	return ret;
 }
 
-static int __exit txx9spi_remove(struct platform_device *dev)
+static int txx9spi_remove(struct platform_device *dev)
 {
 	struct spi_master *master = spi_master_get(platform_get_drvdata(dev));
 	struct txx9spi *c = spi_master_get_devdata(master);
@@ -448,7 +448,7 @@ static int __exit txx9spi_remove(struct platform_device *dev)
 MODULE_ALIAS("platform:spi_txx9");
 
 static struct platform_driver txx9spi_driver = {
-	.remove = __exit_p(txx9spi_remove),
+	.remove = txx9spi_remove,
 	.driver = {
 		.name = "spi_txx9",
 		.owner = THIS_MODULE,
-- 
1.7.10.4

