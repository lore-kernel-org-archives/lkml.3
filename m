Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3HUHDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:03:05 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39465 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3HUHDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:03:00 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <davem@davemloft.net>
CC: <michal.simek@xilinx.com>, <renner@efe-gmbh.de>,
        <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH 6/8] net: xilinx_emaclite: remove unnecessary dev_set_drvdata()
Date: Wed, 21 Aug 2013 15:02:36 +0800
Message-ID: <1377068556-51316-1-git-send-email-libo.chen@huawei.com>
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
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 7c1ccbc..4c619ea 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1249,7 +1249,6 @@ static int xemaclite_of_remove(struct platform_device *of_dev)
 	lp->phy_node = NULL;
 
 	xemaclite_remove_ndev(ndev, of_dev);
-	dev_set_drvdata(dev, NULL);
 
 	return 0;
 }
-- 
1.7.1


