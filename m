Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab3HLNZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:25:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37269 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3HLNZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:25:25 -0400
Message-ID: <5208E231.60104@huawei.com>
Date: Mon, 12 Aug 2013 21:25:05 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <mugunthanvnm@ti.com>, <bigeasy@linutronix.de>,
        <prabhakar.csengg@gmail.com>, <b-liu@ti.com>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 8/8] net: davinci_mdio: use platform_{get,set}_drvdata()
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
 drivers/net/ethernet/ti/davinci_mdio.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 16ddfc3..2249b2c 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -421,8 +421,7 @@ bail_out:

 static int davinci_mdio_remove(struct platform_device *pdev)
 {
-	struct device *dev = &pdev->dev;
-	struct davinci_mdio_data *data = dev_get_drvdata(dev);
+	struct davinci_mdio_data *data = platform_get_drvdata(pdev);

 	if (data->bus) {
 		mdiobus_unregister(data->bus);
@@ -434,7 +433,6 @@ static int davinci_mdio_remove(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);

-	dev_set_drvdata(dev, NULL);

 	kfree(data);

-- 
1.7.1

