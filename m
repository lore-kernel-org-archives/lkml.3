Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3HLNZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:25:18 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19087 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3HLNZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:25:13 -0400
Message-ID: <5208E222.60300@huawei.com>
Date: Mon, 12 Aug 2013 21:24:50 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <pantelis.antoniou@gmail.com>, <vbordug@ru.mvista.com>,
        David Miller <davem@davemloft.net>
CC: <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 4/8] net: fs_enet: use platform_{get,set}_drvdata()
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
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 8de53a1..7e3de10 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1122,7 +1122,6 @@ static int fs_enet_remove(struct platform_device *ofdev)

 	fep->ops->free_bd(ndev);
 	fep->ops->cleanup_data(ndev);
-	dev_set_drvdata(fep->dev, NULL);
 	of_node_put(fep->fpi->phy_node);
 	free_netdev(ndev);
 	return 0;
-- 
1.7.1

