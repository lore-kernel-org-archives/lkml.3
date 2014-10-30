Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbaJ3KXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:23:03 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41988 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955AbaJ3KVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:21:42 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] phy: berlin-sata: Add support for BG2 SATA PHY
Date: Thu, 30 Oct 2014 11:21:25 +0100
Message-Id: <1414664488-5911-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1414664488-5911-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413882477-27922-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1414664488-5911-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Berlin BG2 also has a SATA PHY compatible with the current driver
except different PHY_BASE. Add a new compatible to the driver
reflecting the different PHY_BASE.

Acked-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- none
v2->v3:
- Use of_device_is_compatible for different PHY_BASE (Suggested by
  Felipe Balbi)

Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/phy/phy-berlin-sata.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
index cdb46d1203a4..873e7a890fee 100644
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
2.1.1

