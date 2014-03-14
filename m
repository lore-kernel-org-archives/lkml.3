Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaCNSVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:21:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49455 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbaCNSVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:21:14 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-e5-5323489805b0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ata: ahci_st: build fixes
Date: Fri, 14 Mar 2014 19:20:58 +0100
Message-id: <1848075.ERJNt1KrUa@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd2ZHsrBBq/eMlnc/3qU0WLT42us
	Fsd2PGKyuLxrDpvFr+VHGR1YPTat6mTzuHNtD5vH5iX1Hp83yQWwRHHZpKTmZJalFunbJXBl
	zL5yhbHgkUhFz8qbjA2M2wW7GDk4JARMJP7Nt+pi5AQyxSQu3FvP1sXIxSEksIhR4u/d+VBO
	C5NE27J9bCBVbAJWEhPbVzGC2CICshJXpj1kBCliFmhllJi9Yio7SEJYQE+i+dUVFhCbRUBV
	Yl7zbbA4r4CmxPRDv8AGiQp4SuzYvpINIi4o8WPyPbB6ZgF5iX37p7JC2FoS63ceZ5rAyDcL
	SdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcls+kdzCuarA4xCjAwajE
	w3tBSTlYiDWxrLgy9xCjBAezkgjvfmOgEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLp
	iSWp2ampBalFMFkmDk6pBsbqxBta945FL1m6bnZYm/vdIpZD1737775j+bQ9gfVOPe+EqKvT
	vt7c9Onl0QDXMI69EnWCVar7Q2ZNDpKb8HzDxAX2853mPSy13pV0dFXqI0PxNwdz1CMttvw2
	WTFxQ153ZIVH6/con3ThSfrXjy7Yn3xoZuyOGRZv41ZW6IQWTn978Uror/qlSizFGYmGWsxF
	xYkAExAuOkcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* The config option for ahci_st driver was renamed from
  CONFIG_SATA_AHCI_ST to CONFIG_AHCI_ST but Makefile was
  not updated.  Fix it (also while at it move the ahci_st
  driver entry below ahci_imx and ahci_sunxi ones).

* Fix a few build issues in the ahci_st driver itself.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/Makefile  |    2 +-
 drivers/ata/ahci_st.c |   12 +++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

Index: b/drivers/ata/Makefile
===================================================================
--- a/drivers/ata/Makefile	2014-03-14 16:45:04.036724382 +0100
+++ b/drivers/ata/Makefile	2014-03-14 19:07:02.304579137 +0100
@@ -5,7 +5,6 @@ obj-$(CONFIG_ATA)		+= libata.o
 obj-$(CONFIG_SATA_AHCI)		+= ahci.o libahci.o
 obj-$(CONFIG_SATA_ACARD_AHCI)	+= acard-ahci.o libahci.o
 obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
-obj-$(CONFIG_SATA_AHCI_ST)      += ahci_st.o
 obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
@@ -13,6 +12,7 @@ obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460e
 obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
 obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o
 obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o
+obj-$(CONFIG_AHCI_ST)		+= ahci_st.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
Index: b/drivers/ata/ahci_st.c
===================================================================
--- a/drivers/ata/ahci_st.c	2014-03-14 19:03:11.368583073 +0100
+++ b/drivers/ata/ahci_st.c	2014-03-14 19:13:53.900572116 +0100
@@ -87,7 +87,7 @@ static int st_ahci_deassert_resets(struc
 	return 0;
 }
 
-static int st_ahci_exit(struct device *dev)
+static void st_ahci_exit(struct device *dev)
 {
 	struct st_ahci_drv_data *drv_data = dev_get_drvdata(dev);
 	struct ahci_host_priv *hpriv = drv_data->hpriv;
@@ -96,12 +96,10 @@ static int st_ahci_exit(struct device *d
 	if (drv_data->pwr) {
 		err = reset_control_assert(drv_data->pwr);
 		if (err)
-			dev_err(&pdev->dev, "unable to pwrdwn\n");
+			dev_err(dev, "unable to pwrdwn\n");
 	}
 
 	ahci_platform_disable_resources(hpriv);
-
-	return 0;
 }
 
 static int st_ahci_probe_resets(struct platform_device *pdev)
@@ -186,9 +184,9 @@ static int st_ahci_suspend(struct device
 	struct ahci_host_priv *hpriv = drv_data->hpriv;
 	int err;
 
-	ret = ahci_platform_suspend_host(dev);
-	if (ret)
-		return ret;
+	err = ahci_platform_suspend_host(dev);
+	if (err)
+		return err;
 
 	if (drv_data->pwr) {
 		err = reset_control_assert(drv_data->pwr);

