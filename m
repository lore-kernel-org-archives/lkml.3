Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbbARRId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 12:08:33 -0500
Received: from mout.web.de ([212.227.17.12]:50619 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbbARRIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 12:08:31 -0500
Message-ID: <54BBE87C.9020705@users.sourceforge.net>
Date: Sun, 18 Jan 2015 18:08:12 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] MTD: Deletion of checks before the function call "iounmap"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Zza98jPRwal+gHCLY05pf2hQtb+OgeI7M8ThP8cEEIqZspDI1gm
 8pQYFjAeMZvCoGJPt4uG9zsidaLGToKSBDsbp31QVLDMf8arDjQEopMC1NVl4CO1hufvhhc
 eZicZ0Ti1Od0fE6qyVKj7r7f7z3KNiX+1SYMUdaHFVnd7OX5+VFKmz+DjC7BUzArSnjKjst
 ibR/QtM9IXcs2RTCbntpA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 17:30:23 +0100

The iounmap() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/mtd/maps/latch-addr-flash.c |  3 +--
 drivers/mtd/maps/pci.c              |  6 ++----
 drivers/mtd/maps/physmap_of.c       |  3 +--
 drivers/mtd/maps/plat-ram.c         |  3 +--
 drivers/mtd/maps/pxa2xx-flash.c     |  6 ++----
 drivers/mtd/maps/sa1100-flash.c     |  3 +--
 drivers/mtd/nand/fsl_elbc_nand.c    |  3 +--
 drivers/mtd/nand/fsl_ifc_nand.c     |  3 +--
 drivers/mtd/nand/mpc5121_nfc.c      |  3 +--
 drivers/mtd/onenand/samsung.c       | 12 ++++--------
 10 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/mtd/maps/latch-addr-flash.c b/drivers/mtd/maps/latch-addr-flash.c
index cadfbe0..60496cd 100644
--- a/drivers/mtd/maps/latch-addr-flash.c
+++ b/drivers/mtd/maps/latch-addr-flash.c
@@ -109,8 +109,7 @@ static int latch_addr_flash_remove(struct platform_device *dev)
 		map_destroy(info->mtd);
 	}
 
-	if (info->map.virt != NULL)
-		iounmap(info->map.virt);
+	iounmap(info->map.virt);
 
 	if (info->res != NULL)
 		release_mem_region(info->res->start, resource_size(info->res));
diff --git a/drivers/mtd/maps/pci.c b/drivers/mtd/maps/pci.c
index eb0242e..0006794 100644
--- a/drivers/mtd/maps/pci.c
+++ b/drivers/mtd/maps/pci.c
@@ -118,8 +118,7 @@ intel_iq80310_init(struct pci_dev *dev, struct map_pci_info *map)
 static void
 intel_iq80310_exit(struct pci_dev *dev, struct map_pci_info *map)
 {
-	if (map->base)
-		iounmap(map->base);
+	iounmap(map->base);
 	pci_write_config_dword(dev, 0x44, map->map.map_priv_2);
 }
 
@@ -202,8 +201,7 @@ intel_dc21285_init(struct pci_dev *dev, struct map_pci_info *map)
 static void
 intel_dc21285_exit(struct pci_dev *dev, struct map_pci_info *map)
 {
-	if (map->base)
-		iounmap(map->base);
+	iounmap(map->base);
 
 	/*
 	 * We need to undo the PCI BAR2/PCI ROM BAR address alteration.
diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index f35cd20..89f5d42 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -57,8 +57,7 @@ static int of_flash_remove(struct platform_device *dev)
 		if (info->list[i].mtd)
 			map_destroy(info->list[i].mtd);
 
-		if (info->list[i].map.virt)
-			iounmap(info->list[i].map.virt);
+		iounmap(info->list[i].map.virt);
 
 		if (info->list[i].res) {
 			release_resource(info->list[i].res);
diff --git a/drivers/mtd/maps/plat-ram.c b/drivers/mtd/maps/plat-ram.c
index 4b65c08..da09274 100644
--- a/drivers/mtd/maps/plat-ram.c
+++ b/drivers/mtd/maps/plat-ram.c
@@ -104,8 +104,7 @@ static int platram_remove(struct platform_device *pdev)
 		kfree(info->area);
 	}
 
-	if (info->map.virt != NULL)
-		iounmap(info->map.virt);
+	iounmap(info->map.virt);
 
 	kfree(info);
 
diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index 12fa75d..a5f27b9 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -89,8 +89,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 
 	if (!info->mtd) {
 		iounmap((void *)info->map.virt);
-		if (info->map.cached)
-			iounmap(info->map.cached);
+		iounmap(info->map.cached);
 		return -EIO;
 	}
 	info->mtd->owner = THIS_MODULE;
@@ -110,8 +109,7 @@ static int pxa2xx_flash_remove(struct platform_device *dev)
 
 	map_destroy(info->mtd);
 	iounmap(info->map.virt);
-	if (info->map.cached)
-		iounmap(info->map.cached);
+	iounmap(info->map.cached);
 	kfree(info);
 	return 0;
 }
diff --git a/drivers/mtd/maps/sa1100-flash.c b/drivers/mtd/maps/sa1100-flash.c
index ea69720..22e5d7d 100644
--- a/drivers/mtd/maps/sa1100-flash.c
+++ b/drivers/mtd/maps/sa1100-flash.c
@@ -58,8 +58,7 @@ static void sa1100_destroy_subdev(struct sa_subdev_info *subdev)
 {
 	if (subdev->mtd)
 		map_destroy(subdev->mtd);
-	if (subdev->map.virt)
-		iounmap(subdev->map.virt);
+	iounmap(subdev->map.virt);
 	release_mem_region(subdev->map.phys, subdev->map.size);
 }
 
diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 04b22fd..a0f2a91 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -801,8 +801,7 @@ static int fsl_elbc_chip_remove(struct fsl_elbc_mtd *priv)
 
 	kfree(priv->mtd.name);
 
-	if (priv->vbase)
-		iounmap(priv->vbase);
+	iounmap(priv->vbase);
 
 	elbc_fcm_ctrl->chips[priv->bank] = NULL;
 	kfree(priv);
diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index 4c05f4f..360d9a3 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -995,8 +995,7 @@ static int fsl_ifc_chip_remove(struct fsl_ifc_mtd *priv)
 
 	kfree(priv->mtd.name);
 
-	if (priv->vbase)
-		iounmap(priv->vbase);
+	iounmap(priv->vbase);
 
 	ifc_nand_ctrl->chips[priv->bank] = NULL;
 
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index 1f12e5b..34fa6db 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -621,8 +621,7 @@ static void mpc5121_nfc_free(struct device *dev, struct mtd_info *mtd)
 	if (prv->clk)
 		clk_disable_unprepare(prv->clk);
 
-	if (prv->csreg)
-		iounmap(prv->csreg);
+	iounmap(prv->csreg);
 }
 
 static int mpc5121_nfc_probe(struct platform_device *op)
diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
index 19cfb97..24ac4cb 100644
--- a/drivers/mtd/onenand/samsung.c
+++ b/drivers/mtd/onenand/samsung.c
@@ -1001,8 +1001,7 @@ static int s3c_onenand_probe(struct platform_device *pdev)
 	return 0;
 
 scan_failed:
-	if (onenand->dma_addr)
-		iounmap(onenand->dma_addr);
+	iounmap(onenand->dma_addr);
 dma_ioremap_failed:
 	if (onenand->dma_res)
 		release_mem_region(onenand->dma_res->start,
@@ -1011,8 +1010,7 @@ dma_ioremap_failed:
 oob_buf_fail:
 	kfree(onenand->page_buf);
 page_buf_fail:
-	if (onenand->ahb_addr)
-		iounmap(onenand->ahb_addr);
+	iounmap(onenand->ahb_addr);
 ahb_ioremap_failed:
 	if (onenand->ahb_res)
 		release_mem_region(onenand->ahb_res->start,
@@ -1036,13 +1034,11 @@ static int s3c_onenand_remove(struct platform_device *pdev)
 	struct mtd_info *mtd = platform_get_drvdata(pdev);
 
 	onenand_release(mtd);
-	if (onenand->ahb_addr)
-		iounmap(onenand->ahb_addr);
+	iounmap(onenand->ahb_addr);
 	if (onenand->ahb_res)
 		release_mem_region(onenand->ahb_res->start,
 				   resource_size(onenand->ahb_res));
-	if (onenand->dma_addr)
-		iounmap(onenand->dma_addr);
+	iounmap(onenand->dma_addr);
 	if (onenand->dma_res)
 		release_mem_region(onenand->dma_res->start,
 				   resource_size(onenand->dma_res));
-- 
2.2.2

