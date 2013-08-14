Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab3HNDjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 23:39:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:22212 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058Ab3HNDjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 23:39:48 -0400
Message-ID: <520AFBF8.9030609@huawei.com>
Date: Wed, 14 Aug 2013 11:39:36 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 3/8] net: fec_mpc52xx_phy: use platform_{get,set}_drvdata()
References: <5208E21F.3090002@huawei.com>
In-Reply-To: <5208E21F.3090002@huawei.com>
X-Forwarded-Message-Id: <5208E21F.3090002@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We can use the wrapper functions platform_{get,set}_drvdata() instead of
dev_{get,set}_drvdata() with &of->dev, it is convenient for user.

Also, unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
index 360a578..e052890 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
@@ -123,12 +123,10 @@ static int mpc52xx_fec_mdio_probe(struct platform_device *of)

 static int mpc52xx_fec_mdio_remove(struct platform_device *of)
 {
-	struct device *dev = &of->dev;
-	struct mii_bus *bus = dev_get_drvdata(dev);
+	struct mii_bus *bus = platform_get_drvdata(of);
 	struct mpc52xx_fec_mdio_priv *priv = bus->priv;

 	mdiobus_unregister(bus);
-	dev_set_drvdata(dev, NULL);
 	iounmap(priv->regs);
 	kfree(priv);
 	mdiobus_free(bus);
-- 
1.7.1



