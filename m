Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab3DBTgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:36:00 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59319 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630Ab3DBTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:35:13 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 02 Apr 2013 14:35:09 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        David Daney <david.daney@cavium.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5/5] net/nxp/lpc_eth: Drop ifdef CONFIG_OF_NET
Date: Tue,  2 Apr 2013 12:35:11 -0700
Message-Id: <1364931311-30603-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
References: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since of_get_mac_address() is now declared even if CONFIG_OF_NET
is not configured, the ifdef is no longer necessary and can be
removed.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/ethernet/nxp/lpc_eth.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index efa29b7..99276d7 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1434,13 +1434,11 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	/* Get MAC address from current HW setting (POR state is all zeros) */
 	__lpc_get_mac(pldat, ndev->dev_addr);
 
-#ifdef CONFIG_OF_NET
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		const char *macaddr = of_get_mac_address(pdev->dev.of_node);
 		if (macaddr)
 			memcpy(ndev->dev_addr, macaddr, ETH_ALEN);
 	}
-#endif
 	if (!is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
 
-- 
1.7.9.7

