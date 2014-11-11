Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaKKRkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:40:37 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52803 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaKKRke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:40:34 -0500
From: Johan Hovold <johan@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 12/22] net: phy: micrel: enable led-mode for KSZ8081/KSZ8091
Date: Tue, 11 Nov 2014 18:37:30 +0100
Message-Id: <1415727460-20417-13-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415727460-20417-1-git-send-email-johan@kernel.org>
References: <1415727460-20417-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable led-mode configuration for KSZ8081 and KSZ8091.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 Documentation/devicetree/bindings/net/micrel.txt | 2 ++
 drivers/net/phy/micrel.c                         | 1 +
 2 files changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
index e1d99b95c4ec..30062fae5623 100644
--- a/Documentation/devicetree/bindings/net/micrel.txt
+++ b/Documentation/devicetree/bindings/net/micrel.txt
@@ -14,6 +14,8 @@ Optional properties:
 	      KSZ8021: register 0x1f, bits 5..4
 	      KSZ8031: register 0x1f, bits 5..4
 	      KSZ8051: register 0x1f, bits 5..4
+	      KSZ8081: register 0x1f, bits 5..4
+	      KSZ8091: register 0x1f, bits 5..4
 
               See the respective PHY datasheet for the mode values.
 
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 12e18f7273ce..30e894d6ffbd 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -265,6 +265,7 @@ static int ks8051_config_init(struct phy_device *phydev)
 static int ksz8081_config_init(struct phy_device *phydev)
 {
 	kszphy_broadcast_disable(phydev);
+	kszphy_setup_led(phydev, MII_KSZPHY_CTRL_2);
 
 	return 0;
 }
-- 
2.0.4

