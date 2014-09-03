Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbaICVlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:41:55 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64553 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbaICVl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:41:27 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/4] staging: et131x: Add auto-negotiation and 1000BT_Half as supported protocols
Date: Wed,  3 Sep 2014 22:40:56 +0100
Message-Id: <1409780457-6060-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409780457-6060-1-git-send-email-mark.einon@gmail.com>
References: <1409780457-6060-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver supports auto-negotiation and 100BaetT_Half but doesn't
advertise or list it in it's phydev. Fix that.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 9819e0e..1ac9e7e 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3643,18 +3643,20 @@ static int et131x_mii_probe(struct net_device *netdev)
 		return PTR_ERR(phydev);
 	}
 
-	phydev->supported &= (SUPPORTED_10baseT_Half
-				| SUPPORTED_10baseT_Full
-				| SUPPORTED_100baseT_Half
-				| SUPPORTED_100baseT_Full
-				| SUPPORTED_Autoneg
-				| SUPPORTED_MII
-				| SUPPORTED_TP);
+	phydev->supported &= (SUPPORTED_10baseT_Half |
+			      SUPPORTED_10baseT_Full |
+			      SUPPORTED_100baseT_Half |
+			      SUPPORTED_100baseT_Full |
+			      SUPPORTED_Autoneg |
+			      SUPPORTED_MII |
+			      SUPPORTED_TP);
 
 	if (adapter->pdev->device != ET131X_PCI_DEVICE_ID_FAST)
-		phydev->supported |= SUPPORTED_1000baseT_Full;
+		phydev->supported |= SUPPORTED_1000baseT_Half |
+				     SUPPORTED_1000baseT_Full;
 
 	phydev->advertising = phydev->supported;
+	phydev->autoneg = AUTONEG_ENABLE;
 	adapter->phydev = phydev;
 
 	dev_info(&adapter->pdev->dev,
-- 
2.1.0

