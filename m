Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3HUHCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:02:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:20112 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3HUHCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:02:37 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <davem@davemloft.net>
CC: <timur@freescale.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH 1/8] net: fsl_pq_mdio: remove unnecessary dev_set_drvdata()
Date: Wed, 21 Aug 2013 15:02:13 +0800
Message-ID: <1377068533-53208-1-git-send-email-libo.chen@huawei.com>
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
 drivers/net/ethernet/freescale/fsl_pq_mdio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fsl_pq_mdio.c b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
index b7dcd41..c4f6506 100644
--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -468,8 +468,6 @@ static int fsl_pq_mdio_remove(struct platform_device *pdev)
 
 	mdiobus_unregister(bus);
 
-	dev_set_drvdata(device, NULL);
-
 	iounmap(priv->map);
 	mdiobus_free(bus);
 
-- 
1.7.1


