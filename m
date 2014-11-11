Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaKKRpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:45:11 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:62586 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaKKRip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:38:45 -0500
From: Johan Hovold <johan@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 05/22] net: phy: micrel: fix config_intr error handling
Date: Tue, 11 Nov 2014 18:37:23 +0100
Message-Id: <1415727460-20417-6-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415727460-20417-1-git-send-email-johan@kernel.org>
References: <1415727460-20417-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure never to update the control register with random data (an
error code) by checking the return value after reading it.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/phy/micrel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index bcc6c0ea75fa..62ca9613a514 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -122,6 +122,8 @@ static int kszphy_config_intr(struct phy_device *phydev)
 
 	/* set the interrupt pin active low */
 	temp = phy_read(phydev, MII_KSZPHY_CTRL);
+	if (temp < 0)
+		return temp;
 	temp &= ~KSZPHY_CTRL_INT_ACTIVE_HIGH;
 	phy_write(phydev, MII_KSZPHY_CTRL, temp);
 	rc = kszphy_set_interrupt(phydev);
@@ -134,6 +136,8 @@ static int ksz9021_config_intr(struct phy_device *phydev)
 
 	/* set the interrupt pin active low */
 	temp = phy_read(phydev, MII_KSZPHY_CTRL);
+	if (temp < 0)
+		return temp;
 	temp &= ~KSZ9021_CTRL_INT_ACTIVE_HIGH;
 	phy_write(phydev, MII_KSZPHY_CTRL, temp);
 	rc = kszphy_set_interrupt(phydev);
@@ -146,6 +150,8 @@ static int ks8737_config_intr(struct phy_device *phydev)
 
 	/* set the interrupt pin active low */
 	temp = phy_read(phydev, MII_KSZPHY_CTRL);
+	if (temp < 0)
+		return temp;
 	temp &= ~KS8737_CTRL_INT_ACTIVE_HIGH;
 	phy_write(phydev, MII_KSZPHY_CTRL, temp);
 	rc = kszphy_set_interrupt(phydev);
-- 
2.0.4

