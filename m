Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaA0EAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 23:00:51 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:56153 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaA0D7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 22:59:48 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 1/3] net: ethoc: don't advertise gigabit speed on attached PHY
Date: Mon, 27 Jan 2014 07:59:25 +0400
Message-Id: <1390795167-6677-2-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390795167-6677-1-git-send-email-jcmvbkbc@gmail.com>
References: <1390795167-6677-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OpenCores 10/100 Mbps MAC does not support speeds above 100 Mbps, but does
not disable advertisement when PHY supports them. This results in
non-functioning network when the MAC is connected to a gigabit PHY connected
to a gigabit switch.

The fix is to disable gigabit speed advertisement on attached PHY
unconditionally.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/ethernet/ethoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 4de8cfd..0aa1a05 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -712,6 +712,8 @@ static int ethoc_open(struct net_device *dev)
 		netif_start_queue(dev);
 	}
 
+	priv->phy->advertising &= ~(ADVERTISED_1000baseT_Full |
+				    ADVERTISED_1000baseT_Half);
 	phy_start(priv->phy);
 	napi_enable(&priv->napi);
 
-- 
1.8.1.4

