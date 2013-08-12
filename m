Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3HLNZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:25:01 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37075 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab3HLNY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:24:57 -0400
Message-ID: <5208E21A.3020805@huawei.com>
Date: Mon, 12 Aug 2013 21:24:42 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <leoli@freescale.com>, David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 2/8] net: ucc_geth: use platform_{get,set}_drvdata()
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
 drivers/net/ethernet/freescale/ucc_geth.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 3c43dac..5930c39 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3911,14 +3911,12 @@ static int ucc_geth_probe(struct platform_device* ofdev)

 static int ucc_geth_remove(struct platform_device* ofdev)
 {
-	struct device *device = &ofdev->dev;
-	struct net_device *dev = dev_get_drvdata(device);
+	struct net_device *dev = platform_get_drvdata(ofdev);
 	struct ucc_geth_private *ugeth = netdev_priv(dev);

 	unregister_netdev(dev);
 	free_netdev(dev);
 	ucc_geth_memclean(ugeth);
-	dev_set_drvdata(device, NULL);

 	return 0;
 }
-- 
1.7.1

