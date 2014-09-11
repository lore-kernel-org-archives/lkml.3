Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbaIKOvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:51:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47152 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755401AbaIKOvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:51:40 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] net/macb: Add hardware revision information during probe
Date: Thu, 11 Sep 2014 16:51:36 +0200
Message-Id: <1410447096-29980-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bo Shen <voice.shen@atmel.com>

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/net/ethernet/cadence/macb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index ca5d7798b265..a3b35c146d9c 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -2241,6 +2241,7 @@ static int __init macb_probe(struct platform_device *pdev)
 
 	netif_carrier_off(dev);
 
+	netdev_info(dev, "Cadence rev 0x%08x\n", macb_readl(bp, MID));
 	netdev_info(dev, "Cadence %s at 0x%08lx irq %d (%pM)\n",
 		    macb_is_gem(bp) ? "GEM" : "MACB", dev->base_addr,
 		    dev->irq, dev->dev_addr);
-- 
1.9.1

