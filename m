Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3HONDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:03:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:52601 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab3HONDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:03:08 -0400
Message-ID: <520CD138.8030204@huawei.com>
Date: Thu, 15 Aug 2013 21:01:44 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <jg1.han@samsung.com>, Bill Pemberton <wfp5p@virginia.edu>,
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v3 5/7] net: sunhme: use platform_{get,set}_drvdata()
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
 drivers/net/ethernet/sun/sunhme.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 171f5b0..4900ea8 100644
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
@@ -3231,7 +3231,7 @@ static int hme_sbus_probe(struct platform_device *op)

 static int hme_sbus_remove(struct platform_device *op)
 {
-	struct happy_meal *hp = dev_get_drvdata(&op->dev);
+	struct happy_meal *hp = platform_get_drvdata(op);
 	struct net_device *net_dev = hp->dev;

 	unregister_netdev(net_dev);
-- 
1.7.1

