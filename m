Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaHIXkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 19:40:20 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:39287 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaHIXkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 19:40:18 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Florian Fainelli <florian@openwrt.org>, netdev@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: ti: cpmac.c:  Cleaning up missing null-terminate after strncpy call
Date: Sun, 10 Aug 2014 01:41:47 +0200
Message-Id: <1407627707-24303-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/ti/cpmac.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index 7399a52..ad268a3 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -1125,6 +1125,7 @@ static int cpmac_probe(struct platform_device *pdev)
 		strncpy(mdio_bus_id, "fixed-0", MII_BUS_ID_SIZE); /* fixed phys bus */
 		phy_id = pdev->id;
 	}
+	mdio_bus_id[sizeof(mdio_bus_id) - 1] = '\0';
 
 	dev = alloc_etherdev_mq(sizeof(*priv), CPMAC_QUEUES);
 	if (!dev)
-- 
1.7.10.4

