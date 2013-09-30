Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3I3UNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:13:21 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44512 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3I3UMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:12:31 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/3] net: calxedaxgmac: add uc and mc filter addresses in promiscuous mode
Date: Mon, 30 Sep 2013 15:12:16 -0500
Message-Id: <1380571937-23439-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380571937-23439-1-git-send-email-robherring2@gmail.com>
References: <1380571937-23439-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Even in promiscuous mode, we need to add filter addresses for correct
operation. This fixes silent failures when using a bridge and adding
addresses using the "bridge fdb add" command.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/xgmac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 94358d2..35da09b 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1291,10 +1291,8 @@ static void xgmac_set_rx_mode(struct net_device *dev)
 	netdev_dbg(priv->dev, "# mcasts %d, # unicast %d\n",
 		 netdev_mc_count(dev), netdev_uc_count(dev));
 
-	if (dev->flags & IFF_PROMISC) {
-		writel(XGMAC_FRAME_FILTER_PR, ioaddr + XGMAC_FRAME_FILTER);
-		return;
-	}
+	if (dev->flags & IFF_PROMISC)
+		value |= XGMAC_FRAME_FILTER_PR;
 
 	memset(hash_filter, 0, sizeof(hash_filter));
 
-- 
1.8.1.2

