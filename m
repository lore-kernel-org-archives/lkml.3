Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3HLN0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:26:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19090 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab3HLNZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:25:16 -0400
Message-ID: <5208E229.9070300@huawei.com>
Date: Mon, 12 Aug 2013 21:24:57 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Greg KH <gregkh@linuxfoundation.org>, <jg1.han@samsung.com>,
        Bill Pemberton <wfp5p@virginia.edu>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] net: sunhme: use platform_{get,set}_drvdata()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/sun/sunhme.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 171f5b0..a111f29 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -3111,7 +3111,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		goto err_out_iounmap;
 	}

-	dev_set_drvdata(&pdev->dev, hp);
+	platform_set_drvdata(pdev, hp);

 	if (!qfe_slot) {
 		struct pci_dev *qpdev = qp->quattro_dev;
@@ -3159,7 +3159,7 @@ err_out:

 static void happy_meal_pci_remove(struct pci_dev *pdev)
 {
-	struct happy_meal *hp = dev_get_drvdata(&pdev->dev);
+	struct happy_meal *hp = platform_get_drvdata(pdev);
 	struct net_device *net_dev = hp->dev;

 	unregister_netdev(net_dev);
@@ -3171,7 +3171,6 @@ static void happy_meal_pci_remove(struct pci_dev *pdev)

 	free_netdev(net_dev);

-	dev_set_drvdata(&pdev->dev, NULL);
 }

 static DEFINE_PCI_DEVICE_TABLE(happymeal_pci_ids) = {
@@ -3231,7 +3230,7 @@ static int hme_sbus_probe(struct platform_device *op)

 static int hme_sbus_remove(struct platform_device *op)
 {
-	struct happy_meal *hp = dev_get_drvdata(&op->dev);
+	struct happy_meal *hp = platform_get_drvdata(op);
 	struct net_device *net_dev = hp->dev;

 	unregister_netdev(net_dev);
@@ -3250,7 +3249,6 @@ static int hme_sbus_remove(struct platform_device *op)

 	free_netdev(net_dev);

-	dev_set_drvdata(&op->dev, NULL);

 	return 0;
 }
-- 
1.7.1

