Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab3HNDly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 23:41:54 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:13160 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759088Ab3HNDjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 23:39:51 -0400
Message-ID: <520AFBEE.7030903@huawei.com>
Date: Wed, 14 Aug 2013 11:39:26 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 1/8] net: fsl_pq_mdio: use platform_{get,set}_drvdata()
References: <5208E215.6030007@huawei.com>
In-Reply-To: <5208E215.6030007@huawei.com>
X-Forwarded-Message-Id: <5208E215.6030007@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We can use the wrapper functions platform_{get,set}_drvdata() instead of
dev_{get,set}_drvdata() with &pdev->dev, it is convenient for user.

Also, unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/freescale/fsl_pq_mdio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fsl_pq_mdio.c b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
index c93a056..995a3ab 100644
--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -409,7 +409,7 @@ static int fsl_pq_mdio_probe(struct platform_device *pdev)
 	priv->regs = priv->map + data->mii_offset;

 	new_bus->parent = &pdev->dev;
-	dev_set_drvdata(&pdev->dev, new_bus);
+	platform_set_drvdata(pdev, new_bus);

 	if (data->get_tbipa) {
 		for_each_child_of_node(np, tbi) {
@@ -468,7 +468,6 @@ static int fsl_pq_mdio_remove(struct platform_device *pdev)

 	mdiobus_unregister(bus);

-	dev_set_drvdata(device, NULL);

 	iounmap(priv->map);
 	mdiobus_free(bus);
-- 
1.7.1




