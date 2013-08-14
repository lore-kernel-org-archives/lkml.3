Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab3HNDkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 23:40:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61162 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3HNDkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 23:40:05 -0400
Message-ID: <520AFBFD.6020005@huawei.com>
Date: Wed, 14 Aug 2013 11:39:41 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <vbordug@ru.mvista.com>,
        <pantelis.antoniou@gmail.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 4/8] net: fs_enet: remove unnecessary dev_set_drvdata()
References: <5208E222.60300@huawei.com>
In-Reply-To: <5208E222.60300@huawei.com>
X-Forwarded-Message-Id: <5208E222.60300@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c  |    1 -
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



