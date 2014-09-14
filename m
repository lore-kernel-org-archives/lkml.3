Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaINRaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:30:55 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:47340 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaINRax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:30:53 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>,
        Nimrod Andy <B38611@freescale.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Frank Li <frank.li@freescale.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] net: ethernet: freescale: fec_main.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 14 Sep 2014 19:32:42 +0200
Message-Id: <1410715962-15986-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/freescale/fec_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 89355a7..e84b132 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1674,13 +1674,13 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 				continue;
 			if (dev_id--)
 				continue;
-			strncpy(mdio_bus_id, fep->mii_bus->id, MII_BUS_ID_SIZE);
+			strlcpy(mdio_bus_id, fep->mii_bus->id, MII_BUS_ID_SIZE);
 			break;
 		}
 
 		if (phy_id >= PHY_MAX_ADDR) {
 			netdev_info(ndev, "no PHY, assuming direct connection to switch\n");
-			strncpy(mdio_bus_id, "fixed-0", MII_BUS_ID_SIZE);
+			strlcpy(mdio_bus_id, "fixed-0", MII_BUS_ID_SIZE);
 			phy_id = 0;
 		}
 
-- 
1.7.10.4

