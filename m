Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab3FCVgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:36:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3FCVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:36:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: sun4i-emac: remove erroneous assignment
Date: Mon, 03 Jun 2013 23:36:50 +0200
Message-ID: <3298610.K0DeJZEM4E@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FWGGSnceXZgdYpH1en7MQM1kUgQtA+IkxpAUvW3Slo9
 P5MBPKBpqAmJDKv93D7YvziFZ+TIP2CpvYbJ2JlZy3Tuo6ewo1
 SOVCD5CIxT8pC4avFJFgKU8yuVLfUEtx8IrPOvAmc/xN0zRL2y
 QfcxEHkqWpygQtDwHRxgvtVv+CU30/dSpLXSrj1KkyCHU7TgfO
 1f6qp6ZB/pG2vTj4o1iHEpE2kANAu9FTm1uZNzgxfTGI6NO8Lw
 EG8AF4wcafnZM3dtCefca4ZX8ZO3MgkIXDaoGZ4kP5r4SRwGwO
 V9PybrFXeyKQfcyRZL6FGNImR0hEp9f9cyQxpQn3xn6Ho2v9pt
 0T8G1pThPZcd8qjj/4cQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added sun4i-emac driver causes a build error when
CONFIG_NET_POLL_CONTROLLER is set, because it attempts to
assign a pointer to netdev->poll_controller, which has
been replaced with ops->ndo_poll_controller in 2.6.31!

The correct assignment is present as well, so we just need
to remove the wrong one.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stefan Roese <sr@denx.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Richard Genoud <richard.genoud@gmail.com>
---
diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index b411344..3e7b220 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -869,10 +869,6 @@ static int emac_probe(struct platform_device *pdev)
 	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
 	ndev->ethtool_ops = &emac_ethtool_ops;
 
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	ndev->poll_controller = &emac_poll_controller;
-#endif
-
 	platform_set_drvdata(pdev, ndev);
 
 	/* Carrier starts down, phylib will bring it up */

