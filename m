Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaIXGmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:42:17 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:42076 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbaIXGmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:42:15 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: swarren@wwwdotorg.org, vinod.koul@intel.com, dan.j.williams@intel.com,
        ldewangan@nvidia.com, thierry.reding@gmail.com
Cc: dmaengine@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        kiran.padwal21@gmail.com, Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH 2/5] DMA: Remove .owner field for driver
Date: Wed, 24 Sep 2014 12:09:23 +0530
Message-Id: <1411540764-27571-1-git-send-email-kiran.padwal@smartplayin.com>
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
 drivers/dma/bcm2835-dma.c     |    1 -
 drivers/dma/cppi41.c          |    1 -
 drivers/dma/dma-jz4740.c      |    1 -
 drivers/dma/iop-adma.c        |    1 -
 drivers/dma/k3dma.c           |    1 -
 drivers/dma/mmp_pdma.c        |    1 -
 drivers/dma/mmp_tdma.c        |    1 -
 drivers/dma/mpc512x_dma.c     |    1 -
 drivers/dma/nbpfaxi.c         |    1 -
 drivers/dma/qcom_bam_dma.c    |    1 -
 drivers/dma/s3c24xx-dma.c     |    1 -
 drivers/dma/sh/rcar-audmapp.c |    1 -
 drivers/dma/sh/rcar-hpbdma.c  |    1 -
 drivers/dma/sh/shdma-of.c     |    1 -
 drivers/dma/sh/sudmac.c       |    1 -
 drivers/dma/tegra20-apb-dma.c |    1 -
 drivers/dma/timb_dma.c        |    1 -
 17 files changed, 17 deletions(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 6800797..815dbdf 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -694,7 +694,6 @@ static struct platform_driver bcm2835_dma_driver = {
 	.remove	= bcm2835_dma_remove,
 	.driver = {
 		.name = "bcm2835-dma",
-		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(bcm2835_dma_of_match),
 	},
 };
diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index 8f8b0b6..5921ce3 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -1094,7 +1094,6 @@ static struct platform_driver cpp41_dma_driver = {
 	.remove = cppi41_dma_remove,
 	.driver = {
 		.name = "cppi41-dma-engine",
-		.owner = THIS_MODULE,
 		.pm = &cppi41_pm_ops,
 		.of_match_table = of_match_ptr(cppi41_dma_ids),
 	},
diff --git a/drivers/dma/dma-jz4740.c b/drivers/dma/dma-jz4740.c
index ae2ab14..8605ed1 100644
--- a/drivers/dma/dma-jz4740.c
+++ b/drivers/dma/dma-jz4740.c
@@ -608,7 +608,6 @@ static struct platform_driver jz4740_dma_driver = {
 	.remove = jz4740_dma_remove,
 	.driver = {
 		.name = "jz4740-dma",
-		.owner = THIS_MODULE,
 	},
 };
 module_platform_driver(jz4740_dma_driver);
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index c56137b..263d9f6 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1557,7 +1557,6 @@ static struct platform_driver iop_adma_driver = {
 	.probe		= iop_adma_probe,
 	.remove		= iop_adma_remove,
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= "iop-adma",
 	},
 };
diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index a1f911a..9349021 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -822,7 +822,6 @@ static SIMPLE_DEV_PM_OPS(k3_dma_pmops, k3_dma_suspend, k3_dma_resume);
 static struct platform_driver k3_pdma_driver = {
 	.driver		= {
 		.name	= DRIVER_NAME,
-		.owner  = THIS_MODULE,
 		.pm	= &k3_dma_pmops,
 		.of_match_table = k3_pdma_dt_ids,
 	},
diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index a1a4db5..8b8952f 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -1098,7 +1098,6 @@ static const struct platform_device_id mmp_pdma_id_table[] = {
 static struct platform_driver mmp_pdma_driver = {
 	.driver		= {
 		.name	= "mmp-pdma",
-		.owner  = THIS_MODULE,
 		.of_match_table = mmp_pdma_dt_ids,
 	},
 	.id_table	= mmp_pdma_id_table,
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index c6bd015..bfb4695 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -703,7 +703,6 @@ static const struct platform_device_id mmp_tdma_id_table[] = {
 static struct platform_driver mmp_tdma_driver = {
 	.driver		= {
 		.name	= "mmp-tdma",
-		.owner  = THIS_MODULE,
 		.of_match_table = mmp_tdma_dt_ids,
 	},
 	.id_table	= mmp_tdma_id_table,
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 881db2b..586d52c 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -1090,7 +1090,6 @@ static struct platform_driver mpc_dma_driver = {
 	.remove		= mpc_dma_remove,
 	.driver = {
 		.name = DRV_NAME,
-		.owner = THIS_MODULE,
 		.of_match_table	= mpc_dma_match,
 	},
 };
diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index 5aeada5..a7a3683 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -1500,7 +1500,6 @@ static const struct dev_pm_ops nbpf_pm_ops = {
 
 static struct platform_driver nbpf_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "dma-nbpf",
 		.of_match_table = nbpf_match,
 		.pm = &nbpf_pm_ops,
diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index 7a4bbb0..9d7b554 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -1115,7 +1115,6 @@ static struct platform_driver bam_dma_driver = {
 	.remove = bam_dma_remove,
 	.driver = {
 		.name = "bam-dma-engine",
-		.owner = THIS_MODULE,
 		.of_match_table = bam_of_match,
 	},
 };
diff --git a/drivers/dma/s3c24xx-dma.c b/drivers/dma/s3c24xx-dma.c
index 7416572..6941a77 100644
--- a/drivers/dma/s3c24xx-dma.c
+++ b/drivers/dma/s3c24xx-dma.c
@@ -1402,7 +1402,6 @@ static int s3c24xx_dma_remove(struct platform_device *pdev)
 static struct platform_driver s3c24xx_dma_driver = {
 	.driver		= {
 		.name	= "s3c24xx-dma",
-		.owner	= THIS_MODULE,
 	},
 	.id_table	= s3c24xx_dma_driver_ids,
 	.probe		= s3c24xx_dma_probe,
diff --git a/drivers/dma/sh/rcar-audmapp.c b/drivers/dma/sh/rcar-audmapp.c
index 80fd2ae..02979d5 100644
--- a/drivers/dma/sh/rcar-audmapp.c
+++ b/drivers/dma/sh/rcar-audmapp.c
@@ -367,7 +367,6 @@ static struct platform_driver audmapp_driver = {
 	.probe		= audmapp_probe,
 	.remove		= audmapp_remove,
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= "rcar-audmapp-engine",
 		.of_match_table = audmapp_of_match,
 	},
diff --git a/drivers/dma/sh/rcar-hpbdma.c b/drivers/dma/sh/rcar-hpbdma.c
index b212d94..fe83320 100644
--- a/drivers/dma/sh/rcar-hpbdma.c
+++ b/drivers/dma/sh/rcar-hpbdma.c
@@ -655,7 +655,6 @@ static struct platform_driver hpb_dmae_driver = {
 	.remove		= hpb_dmae_remove,
 	.shutdown	= hpb_dmae_shutdown,
 	.driver = {
-		.owner	= THIS_MODULE,
 		.name	= "hpb-dma-engine",
 	},
 };
diff --git a/drivers/dma/sh/shdma-of.c b/drivers/dma/sh/shdma-of.c
index b4ff9d3..f999f9b 100644
--- a/drivers/dma/sh/shdma-of.c
+++ b/drivers/dma/sh/shdma-of.c
@@ -66,7 +66,6 @@ MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
 
 static struct platform_driver shdma_of = {
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= "shdma-of",
 		.of_match_table = shdma_of_match,
 	},
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index 3ce1039..2d7a480 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -411,7 +411,6 @@ static int sudmac_remove(struct platform_device *pdev)
 
 static struct platform_driver sudmac_driver = {
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= SUDMAC_DRV_NAME,
 	},
 	.probe		= sudmac_probe,
diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 16efa60..a6c0b3f 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1597,7 +1597,6 @@ static const struct dev_pm_ops tegra_dma_dev_pm_ops = {
 static struct platform_driver tegra_dmac_driver = {
 	.driver = {
 		.name	= "tegra-apbdma",
-		.owner = THIS_MODULE,
 		.pm	= &tegra_dma_dev_pm_ops,
 		.of_match_table = tegra_dma_of_match,
 	},
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 4506a7b..2407ccf 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -783,7 +783,6 @@ static int td_remove(struct platform_device *pdev)
 static struct platform_driver td_driver = {
 	.driver = {
 		.name	= DRIVER_NAME,
-		.owner  = THIS_MODULE,
 	},
 	.probe	= td_probe,
 	.remove	= td_remove,
-- 
1.7.9.5

