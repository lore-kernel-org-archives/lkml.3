Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaI2Jzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:55:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51388 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaI2Jzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:55:53 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH v2 2/5] ARCNET: add com20020_set_hwddr to change address
Date: Mon, 29 Sep 2014 11:55:35 +0200
Message-Id: <1411984538-953-3-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411984538-953-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1411984538-953-1-git-send-email-m.grzeschik@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds com20020_set_hwaddr to make
it possible to change the hwaddr on runtime.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/arcnet/com20020.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/arcnet/com20020.c b/drivers/net/arcnet/com20020.c
index 7b96c5f..1a84378 100644
--- a/drivers/net/arcnet/com20020.c
+++ b/drivers/net/arcnet/com20020.c
@@ -149,11 +149,25 @@ int com20020_check(struct net_device *dev)
 	return 0;
 }
 
+static int com20020_set_hwaddr(struct net_device *dev, void *addr)
+{
+	int ioaddr = dev->base_addr;
+	struct arcnet_local *lp = netdev_priv(dev);
+	struct sockaddr *hwaddr = addr;
+
+	memcpy(dev->dev_addr, hwaddr->sa_data, 1);
+	SET_SUBADR(SUB_NODE);
+	outb(dev->dev_addr[0], _XREG);
+
+	return 0;
+}
+
 const struct net_device_ops com20020_netdev_ops = {
 	.ndo_open	= arcnet_open,
 	.ndo_stop	= arcnet_close,
 	.ndo_start_xmit = arcnet_send_packet,
 	.ndo_tx_timeout = arcnet_timeout,
+	.ndo_set_mac_address = com20020_set_hwaddr,
 	.ndo_set_rx_mode = com20020_set_mc_list,
 };
 
-- 
2.1.0

