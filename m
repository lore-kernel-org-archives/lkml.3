Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaIXJ7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:59:51 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:47212 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742AbaIXJ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:59:49 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: mpm@selenic.com, kgene.kim@samsung.com, olof@lixom.net,
        gregkh@linuxfoundation.org, sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH 1/5] char: hw_random: Remove .owner field for driver
Date: Wed, 24 Sep 2014 15:27:24 +0530
Message-Id: <1411552645-28025-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/char/hw_random/atmel-rng.c      |    1 -
 drivers/char/hw_random/bcm2835-rng.c    |    1 -
 drivers/char/hw_random/bcm63xx-rng.c    |    1 -
 drivers/char/hw_random/exynos-rng.c     |    1 -
 drivers/char/hw_random/msm-rng.c        |    1 -
 drivers/char/hw_random/n2-drv.c         |    1 -
 drivers/char/hw_random/octeon-rng.c     |    1 -
 drivers/char/hw_random/omap3-rom-rng.c  |    1 -
 drivers/char/hw_random/pasemi-rng.c     |    1 -
 drivers/char/hw_random/ppc4xx-rng.c     |    1 -
 drivers/char/hw_random/timeriomem-rng.c |    1 -
 11 files changed, 11 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 851bc7e..25a4de2 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -128,7 +128,6 @@ static struct platform_driver atmel_trng_driver = {
 	.remove		= atmel_trng_remove,
 	.driver		= {
 		.name	= "atmel-trng",
-		.owner	= THIS_MODULE,
 #ifdef CONFIG_PM
 		.pm	= &atmel_trng_pm_ops,
 #endif /* CONFIG_PM */
diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index e900961..7192ec2 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -99,7 +99,6 @@ MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
 static struct platform_driver bcm2835_rng_driver = {
 	.driver = {
 		.name = "bcm2835-rng",
-		.owner = THIS_MODULE,
 		.of_match_table = bcm2835_rng_of_match,
 	},
 	.probe		= bcm2835_rng_probe,
diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
index 36581ea..ba6a65a 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -162,7 +162,6 @@ static struct platform_driver bcm63xx_rng_driver = {
 	.remove		= bcm63xx_rng_remove,
 	.driver		= {
 		.name	= "bcm63xx-rng",
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index 9f8277c..beaa157 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -169,7 +169,6 @@ static UNIVERSAL_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_runtime_suspend,
 static struct platform_driver exynos_rng_driver = {
 	.driver		= {
 		.name	= "exynos-rng",
-		.owner	= THIS_MODULE,
 		.pm	= &exynos_rng_pm_ops,
 	},
 	.probe		= exynos_rng_probe,
diff --git a/drivers/char/hw_random/msm-rng.c b/drivers/char/hw_random/msm-rng.c
index 148521e..cea1c70 100644
--- a/drivers/char/hw_random/msm-rng.c
+++ b/drivers/char/hw_random/msm-rng.c
@@ -185,7 +185,6 @@ static struct platform_driver msm_rng_driver = {
 	.remove = msm_rng_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
-		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(msm_rng_of_match),
 	}
 };
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 292a588..843d6f6 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -750,7 +750,6 @@ MODULE_DEVICE_TABLE(of, n2rng_match);
 static struct platform_driver n2rng_driver = {
 	.driver = {
 		.name = "n2rng",
-		.owner = THIS_MODULE,
 		.of_match_table = n2rng_match,
 	},
 	.probe		= n2rng_probe,
diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
index b5cc342..be1c3f6 100644
--- a/drivers/char/hw_random/octeon-rng.c
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -117,7 +117,6 @@ static int __exit octeon_rng_remove(struct platform_device *pdev)
 static struct platform_driver octeon_rng_driver = {
 	.driver = {
 		.name		= "octeon_rng",
-		.owner		= THIS_MODULE,
 	},
 	.probe		= octeon_rng_probe,
 	.remove		= __exit_p(octeon_rng_remove),
diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index 6f2eaff..a405cdc 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -126,7 +126,6 @@ static int omap3_rom_rng_remove(struct platform_device *pdev)
 static struct platform_driver omap3_rom_rng_driver = {
 	.driver = {
 		.name		= "omap3-rom-rng",
-		.owner		= THIS_MODULE,
 	},
 	.probe		= omap3_rom_rng_probe,
 	.remove		= omap3_rom_rng_remove,
diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index c66279b..ebd6f65 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -142,7 +142,6 @@ static struct of_device_id rng_match[] = {
 static struct platform_driver rng_driver = {
 	.driver = {
 		.name = "pasemi-rng",
-		.owner = THIS_MODULE,
 		.of_match_table = rng_match,
 	},
 	.probe		= rng_probe,
diff --git a/drivers/char/hw_random/ppc4xx-rng.c b/drivers/char/hw_random/ppc4xx-rng.c
index 521f76b..c85d31a 100644
--- a/drivers/char/hw_random/ppc4xx-rng.c
+++ b/drivers/char/hw_random/ppc4xx-rng.c
@@ -133,7 +133,6 @@ static struct of_device_id ppc4xx_rng_match[] = {
 static struct platform_driver ppc4xx_rng_driver = {
 	.driver = {
 		.name = MODULE_NAME,
-		.owner = THIS_MODULE,
 		.of_match_table = ppc4xx_rng_match,
 	},
 	.probe = ppc4xx_rng_probe,
diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index b6ab9ac..cf37db2 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -200,7 +200,6 @@ MODULE_DEVICE_TABLE(of, timeriomem_rng_match);
 static struct platform_driver timeriomem_rng_driver = {
 	.driver = {
 		.name		= "timeriomem_rng",
-		.owner		= THIS_MODULE,
 		.of_match_table	= timeriomem_rng_match,
 	},
 	.probe		= timeriomem_rng_probe,
-- 
1.7.9.5

