Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3HUKPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:15:32 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:29894 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3HUKP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:15:27 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <wg@grandegger.com>, <mkl@pengutronix.de>
CC: <linux-can@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 2/2] net: can: flexcan: use platform_set_drvdata()
Date: Wed, 21 Aug 2013 18:15:08 +0800
Message-ID: <1377080108-33780-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_set_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/can/flexcan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 7b0be09..9978de7 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1087,7 +1087,7 @@ static int flexcan_probe(struct platform_device *pdev)
 
 	netif_napi_add(dev, &priv->napi, flexcan_poll, FLEXCAN_NAPI_WEIGHT);
 
-	dev_set_drvdata(&pdev->dev, dev);
+	platform_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	err = register_flexcandev(dev);
-- 
1.7.1


