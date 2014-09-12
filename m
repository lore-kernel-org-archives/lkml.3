Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaILX6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:58:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58147 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751773AbaILX6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:58:04 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Bo Shen <voice.shen@atmel.com>
Subject: [PATCHv2] net/macb: Add hardware revision information during probe
Date: Sat, 13 Sep 2014 01:57:49 +0200
Message-Id: <1410566269-16445-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bo Shen <voice.shen@atmel.com>

Print the IP revision when probing.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Changes in v2:
 - condense information on one line

 drivers/net/ethernet/cadence/macb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index ca5d7798b265..d9b8e94b805f 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -2241,9 +2241,9 @@ static int __init macb_probe(struct platform_device *pdev)
 
 	netif_carrier_off(dev);
 
-	netdev_info(dev, "Cadence %s at 0x%08lx irq %d (%pM)\n",
-		    macb_is_gem(bp) ? "GEM" : "MACB", dev->base_addr,
-		    dev->irq, dev->dev_addr);
+	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
+		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
+		    dev->base_addr, dev->irq, dev->dev_addr);
 
 	phydev = bp->phy_dev;
 	netdev_info(dev, "attached PHY driver [%s] (mii_bus:phy_addr=%s, irq=%d)\n",
-- 
1.9.1

