Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaIOKG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:06:56 -0400
Received: from atl4mhfb02.myregisteredsite.com ([209.17.115.56]:33643 "EHLO
	atl4mhfb02.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772AbaIOKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:06:52 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: f.fainelli@gmail.com, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH v3] net/phy: micrel: Disable asymmetric pause for KSZ9031
Date: Mon, 15 Sep 2014 12:06:33 +0200
Message-Id: <1410775594-3129-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140912.181820.1440041146938289489.davem@davemloft.net>
References: <20140912.181820.1440041146938289489.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KSZ9031 appears to suffer from the same hardware bug as described
for the KSZ9021 in commit 32fcafbcd1c9f6c7013016a22a5369b4acb93577
("net/phy: micrel: Disable asymmetric pause for KSZ9021")
you have to unplug the cable and plug it back to get it to work.

Remove the SUPPORTED_Asym_Pause flag for the KSZ9031 to fix this.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/net/phy/micrel.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index fd0ea7c..011dbda 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -592,8 +592,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_KSZ9031,
 	.phy_id_mask	= 0x00fffff0,
 	.name		= "Micrel KSZ9031 Gigabit PHY",
-	.features	= (PHY_GBIT_FEATURES | SUPPORTED_Pause
-				| SUPPORTED_Asym_Pause),
+	.features	= (PHY_GBIT_FEATURES | SUPPORTED_Pause),
 	.flags		= PHY_HAS_MAGICANEG | PHY_HAS_INTERRUPT,
 	.config_init	= ksz9031_config_init,
 	.config_aneg	= genphy_config_aneg,
-- 
1.7.9.5

