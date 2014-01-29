Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaA2T5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:57:07 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:50377 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaA2T5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:57:04 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Gauthier <marc@cadence.com>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 1/4] net: ethoc: implement basic ethtool operations
Date: Wed, 29 Jan 2014 23:56:34 +0400
Message-Id: <1391025397-14965-2-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391025397-14965-1-git-send-email-jcmvbkbc@gmail.com>
References: <1391025397-14965-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following methods are implemented:
- get link state (standard implementation);
- get timestamping info (standard implementation).

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/ethernet/ethoc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 5854d41..6de6352 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -900,6 +900,11 @@ out:
 	return NETDEV_TX_OK;
 }
 
+const struct ethtool_ops ethoc_ethtool_ops = {
+	.get_link = ethtool_op_get_link,
+	.get_ts_info = ethtool_op_get_ts_info,
+};
+
 static const struct net_device_ops ethoc_netdev_ops = {
 	.ndo_open = ethoc_open,
 	.ndo_stop = ethoc_stop,
@@ -1148,6 +1153,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	netdev->netdev_ops = &ethoc_netdev_ops;
 	netdev->watchdog_timeo = ETHOC_TIMEOUT;
 	netdev->features |= 0;
+	netdev->ethtool_ops = &ethoc_ethtool_ops;
 
 	/* setup NAPI */
 	netif_napi_add(netdev, &priv->napi, ethoc_poll, 64);
-- 
1.8.1.4

