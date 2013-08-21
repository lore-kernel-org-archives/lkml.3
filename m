Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3HUHOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:14:15 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41024 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3HUHOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:14:11 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <davem@davemloft.net>
CC: <gregkh@linuxfoundation.org>, <wfp5p@virginia.edu>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 8/8] net: emac: remove unnecessary dev_set_drvdata()
Date: Wed, 21 Aug 2013 15:02:45 +0800
Message-ID: <1377068565-8524-1-git-send-email-libo.chen@huawei.com>
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
 drivers/net/ethernet/ibm/emac/core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index d300a0c..2d3b064 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2955,8 +2955,6 @@ static int emac_remove(struct platform_device *ofdev)
 
 	DBG(dev, "remove" NL);
 
-	dev_set_drvdata(&ofdev->dev, NULL);
-
 	unregister_netdev(dev->ndev);
 
 	cancel_work_sync(&dev->reset_work);
-- 
1.7.1


