Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbaGOVep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:34:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54210 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609AbaGOVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:34:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 188/198] net: allwinner: emac: Add missing free_irq
Date: Tue, 15 Jul 2014 14:30:58 -0700
Message-Id: <1405459868-15089-189-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit b91113282bf44df46aba374a0b8f88a75bfd4b3f upstream.

If the mdio probe function fails in emac_open, the interrupt we just requested
isn't freed. If emac_open is called again, for example because we try to set up
the interface again, the kernel will oops because the interrupt wasn't properly
released.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 46dfb13..81576c6 100644
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
1.9.1

