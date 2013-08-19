Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab3HSMBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:01:00 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28487 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3HSMA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:00:58 -0400
Message-ID: <521208E5.7060601@huawei.com>
Date: Mon, 19 Aug 2013 20:00:37 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <mugunthanvnm@ti.com>, <bigeasy@linutronix.de>,
        <prabhakar.csengg@gmail.com>, <b-liu@ti.com>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v4 7/7] net: davinci_mdio: use platform_{get,set}_drvdata()
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
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/net/ethernet/ti/davinci_mdio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 16ddfc3..01b0cc5 100644
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
-- 
1.7.1

