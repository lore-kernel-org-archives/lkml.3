Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab3LMJUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:20:45 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41878 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3LMJUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:20:39 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mugunthan V N <mugunthanvnm@ti.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] net: mv643xx_eth: properly start/stop phy device
Date: Fri, 13 Dec 2013 10:20:25 +0100
Message-Id: <1386926429-28818-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1386513631-11284-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1386513631-11284-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using phydev, it should be phy_start/phy_stop'ed properly. This
driver doesn't do that, so add the corresponding calls to port_start/
stop respectively.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Cc: David Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 61088a6..3aa706f 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2098,6 +2098,7 @@ static void port_start(struct mv643xx_eth_private *mp)
 		mv643xx_eth_get_settings(mp->dev, &cmd);
 		phy_reset(mp);
 		mv643xx_eth_set_settings(mp->dev, &cmd);
+		phy_start(mp->phy);
 	}
 
 	/*
@@ -2293,7 +2294,8 @@ static int mv643xx_eth_stop(struct net_device *dev)
 	del_timer_sync(&mp->rx_oom);
 
 	netif_carrier_off(dev);
-
+	if (mp->phy)
+		phy_stop(mp->phy);
 	free_irq(dev->irq, dev);
 
 	port_reset(mp);
-- 
1.7.2.5

