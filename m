Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab3EWPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:25:56 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45875 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617Ab3EWPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/16] mfd: janz-cmodio: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:15 +0100
Message-Id: <1369322717-30429-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/janz-cmodio.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index 45ece11..fcbb2e9 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -183,11 +183,10 @@ static int cmodio_pci_probe(struct pci_dev *dev,
 	struct cmodio_device *priv;
 	int ret;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&dev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		dev_err(&dev->dev, "unable to allocate private data\n");
-		ret = -ENOMEM;
-		goto out_return;
+		return -ENOMEM;
 	}
 
 	pci_set_drvdata(dev, priv);
@@ -197,7 +196,7 @@ static int cmodio_pci_probe(struct pci_dev *dev,
 	ret = pci_enable_device(dev);
 	if (ret) {
 		dev_err(&dev->dev, "unable to enable device\n");
-		goto out_free_priv;
+		return ret;
 	}
 
 	pci_set_master(dev);
@@ -248,9 +247,7 @@ out_pci_release_regions:
 	pci_release_regions(dev);
 out_pci_disable_device:
 	pci_disable_device(dev);
-out_free_priv:
-	kfree(priv);
-out_return:
+
 	return ret;
 }
 
@@ -263,7 +260,6 @@ static void cmodio_pci_remove(struct pci_dev *dev)
 	iounmap(priv->ctrl);
 	pci_release_regions(dev);
 	pci_disable_device(dev);
-	kfree(priv);
 }
 
 #define PCI_VENDOR_ID_JANZ		0x13c3
-- 
1.7.10.4

