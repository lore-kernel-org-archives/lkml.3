Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaK0G0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:26:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59564 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbaK0G0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:35 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/25] phy: berlin-sata: Add support for BG2 SATA PHY
Date: Thu, 27 Nov 2014 11:56:02 +0530
Message-ID: <1417069577-1169-11-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Berlin BG2 also has a SATA PHY compatible with the current driver
except different PHY_BASE. Add a new compatible to the driver
reflecting the different PHY_BASE.

Acked-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-berlin-sata.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
index cdb46d1..873e7a8 100644
--- a/drivers/phy/phy-berlin-sata.c
+++ b/drivers/phy/phy-berlin-sata.c
@@ -30,6 +30,7 @@
 #define MBUS_WRITE_REQUEST_SIZE_128	(BIT(2) << 16)
 #define MBUS_READ_REQUEST_SIZE_128	(BIT(2) << 19)
 
+#define BG2_PHY_BASE		0x080
 #define BG2Q_PHY_BASE		0x200
 
 /* register 0x01 */
@@ -222,7 +223,10 @@ static int phy_berlin_sata_probe(struct platform_device *pdev)
 	if (!priv->phys)
 		return -ENOMEM;
 
-	priv->phy_base = BG2Q_PHY_BASE;
+	if (of_device_is_compatible(dev->of_node, "marvell,berlin2-sata-phy"))
+		priv->phy_base = BG2_PHY_BASE;
+	else
+		priv->phy_base = BG2Q_PHY_BASE;
 
 	dev_set_drvdata(dev, priv);
 	spin_lock_init(&priv->lock);
@@ -271,6 +275,7 @@ static int phy_berlin_sata_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id phy_berlin_sata_of_match[] = {
+	{ .compatible = "marvell,berlin2-sata-phy" },
 	{ .compatible = "marvell,berlin2q-sata-phy" },
 	{ },
 };
-- 
1.7.9.5

