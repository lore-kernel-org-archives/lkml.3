Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab3HNDlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 23:41:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61482 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423Ab3HNDkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 23:40:41 -0400
Message-ID: <520AFC20.7050006@huawei.com>
Date: Wed, 14 Aug 2013 11:40:16 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <michal.simek@xilinx.com>, <renner@efe-gmbh.de>,
        Greg KH <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 7/8] net: xilinx_emaclite: use platform_{get,set}_drvdata()
References: <5208E22C.4090101@huawei.com>
In-Reply-To: <5208E22C.4090101@huawei.com>
X-Forwarded-Message-Id: <5208E22C.4090101@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We can use the wrapper functions platform_{get,set}_drvdata() instead of
dev_{get,set}_drvdata() with &of_dev->dev, it is convenient for user.

Also, unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index fd4dbda..4c619ea 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1230,8 +1230,7 @@ error:
  */
 static int xemaclite_of_remove(struct platform_device *of_dev)
 {
-	struct device *dev = &of_dev->dev;
-	struct net_device *ndev = dev_get_drvdata(dev);
+	struct net_device *ndev = platform_get_drvdata(of_dev);

 	struct net_local *lp = netdev_priv(ndev);

@@ -1250,7 +1249,6 @@ static int xemaclite_of_remove(struct platform_device *of_dev)
 	lp->phy_node = NULL;

 	xemaclite_remove_ndev(ndev, of_dev);
-	dev_set_drvdata(dev, NULL);

 	return 0;
 }
-- 
1.7.1



