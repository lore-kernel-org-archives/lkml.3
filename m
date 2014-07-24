Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbaGXJrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:47:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54713 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaGXJrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 031/128] net: allwinner: emac: Add missing free_irq
Date: Thu, 24 Jul 2014 10:44:40 +0100
Message-Id: <1406195177-8656-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit b91113282bf44df46aba374a0b8f88a75bfd4b3f upstream.

If the mdio probe function fails in emac_open, the interrupt we just requested
isn't freed. If emac_open is called again, for example because we try to set up
the interface again, the kernel will oops because the interrupt wasn't properly
released.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

