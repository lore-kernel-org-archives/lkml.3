Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934311AbaGRNCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:02:40 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17175 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758618AbaGRNCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:02:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 105/170] net: allwinner: emac: Add missing free_irq
Date: Fri, 18 Jul 2014 14:11:50 +0200
Message-Id: <95718f155906684dd0d9a16d8bda93783534fbd4.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b91113282bf44df46aba374a0b8f88a75bfd4b3f upstream.

If the mdio probe function fails in emac_open, the interrupt we just requested
isn't freed. If emac_open is called again, for example because we try to set up
the interface again, the kernel will oops because the interrupt wasn't properly
released.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 46dfb1378c17..81576c6c31e0 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -726,6 +726,7 @@ static int emac_open(struct net_device *dev)
 
 	ret = emac_mdio_probe(dev);
 	if (ret < 0) {
+		free_irq(dev->irq, dev);
 		netdev_err(dev, "cannot probe MDIO bus\n");
 		return ret;
 	}
-- 
2.0.0

