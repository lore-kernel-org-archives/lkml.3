Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3ITItm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:49:42 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:57867 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab3ITItX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:49:23 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] mfd: Remove redundant dev_set_drvdata
Date: Fri, 20 Sep 2013 14:19:34 +0530
Message-Id: <1379666974-24211-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver core sets driver data to NULL upon failure or remove.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/mc13xxx-i2c.c |    1 -
 drivers/mfd/rtsx_pcr.c    |    5 +----
 drivers/mfd/ti-ssp.c      |    1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
index f745e27..898bd33 100644
--- a/drivers/mfd/mc13xxx-i2c.c
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -78,7 +78,6 @@ static int mc13xxx_i2c_probe(struct i2c_client *client,
 		ret = PTR_ERR(mc13xxx->regmap);
 		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
 				ret);
-		dev_set_drvdata(&client->dev, NULL);
 		return ret;
 	}
 
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index e6ae772..11e20af 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1149,7 +1149,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	pcr->remap_addr = ioremap_nocache(base, len);
 	if (!pcr->remap_addr) {
 		ret = -ENOMEM;
-		goto free_host;
+		goto free_handle;
 	}
 
 	pcr->rtsx_resv_buf = dma_alloc_coherent(&(pcidev->dev),
@@ -1209,8 +1209,6 @@ disable_msi:
 			pcr->rtsx_resv_buf, pcr->rtsx_resv_buf_addr);
 unmap:
 	iounmap(pcr->remap_addr);
-free_host:
-	dev_set_drvdata(&pcidev->dev, NULL);
 free_handle:
 	kfree(handle);
 free_pcr:
@@ -1242,7 +1240,6 @@ static void rtsx_pci_remove(struct pci_dev *pcidev)
 		pci_disable_msi(pcr->pci);
 	iounmap(pcr->remap_addr);
 
-	dev_set_drvdata(&pcidev->dev, NULL);
 	pci_release_regions(pcidev);
 	pci_disable_device(pcidev);
 
diff --git a/drivers/mfd/ti-ssp.c b/drivers/mfd/ti-ssp.c
index 1c2b994..71e3e0c 100644
--- a/drivers/mfd/ti-ssp.c
+++ b/drivers/mfd/ti-ssp.c
@@ -445,7 +445,6 @@ static int ti_ssp_remove(struct platform_device *pdev)
 	iounmap(ssp->regs);
 	release_mem_region(ssp->res->start, resource_size(ssp->res));
 	kfree(ssp);
-	dev_set_drvdata(dev, NULL);
 	return 0;
 }
 
-- 
1.7.9.5

