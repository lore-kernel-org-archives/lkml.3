Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3HUHDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:03:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:20432 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3HUHDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:03:18 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 3/8] net: fec_mpc52xx_phy: remove unnecessary dev_set_drvdata()
Date: Wed, 21 Aug 2013 15:02:22 +0800
Message-ID: <1377068542-21164-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
index eb44797..e052890 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
@@ -127,7 +127,6 @@ static int mpc52xx_fec_mdio_remove(struct platform_device *of)
 	struct mpc52xx_fec_mdio_priv *priv = bus->priv;
 
 	mdiobus_unregister(bus);
-	dev_set_drvdata(dev, NULL);
 	iounmap(priv->regs);
 	kfree(priv);
 	mdiobus_free(bus);
-- 
1.7.1


