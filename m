Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3HONBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:01:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:52147 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3HONBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:01:49 -0400
Message-ID: <520CD131.80004@huawei.com>
Date: Thu, 15 Aug 2013 21:01:37 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v3 3/7] net: fec_mpc52xx_phy: use platform_{get,set}_drvdata()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &of->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
index 360a578..eb44797 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
@@ -123,8 +123,7 @@ static int mpc52xx_fec_mdio_probe(struct platform_device *of)

 static int mpc52xx_fec_mdio_remove(struct platform_device *of)
 {
-	struct device *dev = &of->dev;
-	struct mii_bus *bus = dev_get_drvdata(dev);
+	struct mii_bus *bus = platform_get_drvdata(of);
 	struct mpc52xx_fec_mdio_priv *priv = bus->priv;

 	mdiobus_unregister(bus);
-- 
1.7.1

