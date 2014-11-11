Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaKKRnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:43:39 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:45853 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaKKRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:38:47 -0500
From: Johan Hovold <johan@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 09/22] net: phy: micrel: add led-mode sanity check
Date: Tue, 11 Nov 2014 18:37:27 +0100
Message-Id: <1415727460-20417-10-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415727460-20417-1-git-send-email-johan@kernel.org>
References: <1415727460-20417-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure never to update more than two bits when setting the led mode,
something which could for example change the reference-clock setting.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/phy/micrel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 16135ac18bfe..1b3985cdc64c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -173,6 +173,11 @@ static int kszphy_setup_led(struct phy_device *phydev,
 	if (of_property_read_u32(of_node, "micrel,led-mode", &val))
 		return 0;
 
+	if (val > 3) {
+		dev_err(&phydev->dev, "invalid led mode: 0x%02x\n", val);
+		return -EINVAL;
+	}
+
 	temp = phy_read(phydev, reg);
 	if (temp < 0)
 		return temp;
-- 
2.0.4

