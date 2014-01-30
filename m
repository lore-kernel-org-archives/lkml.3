Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaA3Obd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:31:33 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:54612 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbaA3O3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:29:50 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, florian.vaussard@epfl.ch
Subject: [PATCH 2/5] can: sja1000: convert printk to use netdev API
Date: Thu, 30 Jan 2014 15:29:25 +0100
Message-Id: <1391092168-21246-3-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391092168-21246-1-git-send-email-florian.vaussard@epfl.ch>
References: <1391092168-21246-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use netdev_* where applicable.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/net/can/sja1000/sja1000.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index f17c301..55cce47 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -106,8 +106,7 @@ static int sja1000_probe_chip(struct net_device *dev)
 	struct sja1000_priv *priv = netdev_priv(dev);
 
 	if (priv->reg_base && sja1000_is_absent(priv)) {
-		printk(KERN_INFO "%s: probing @0x%lX failed\n",
-		       DRV_NAME, dev->base_addr);
+		netdev_err(dev, "probing failed\n");
 		return 0;
 	}
 	return -1;
-- 
1.8.1.2

