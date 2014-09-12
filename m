Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaILMku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:40:50 -0400
Received: from smtp04.online.nl ([194.134.41.34]:51547 "EHLO smtp04.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbaILMks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:40:48 -0400
From: Mike Looijmans <mike.looijmans@topic.nl>
To: f.fainelli@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH v2] net/phy: micrel: Disable asymmetric pause for KSZ9031
Date: Fri, 12 Sep 2014 14:40:37 +0200
Message-Id: <1410525637-849-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <5411ECE9.8050600@gmail.com>
References: <5411ECE9.8050600@gmail.com>
X-Online-Scanned: by Cloudmark authority (on smtp04.online.nl)
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
index 5a8993b..a932a35 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -425,8 +425,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_KSZ9031,
 	.phy_id_mask	= 0x00fffff0,
 	.name		= "Micrel KSZ9031 Gigabit PHY",
-	.features	= (PHY_GBIT_FEATURES | SUPPORTED_Pause
-				| SUPPORTED_Asym_Pause),
+	.features	= (PHY_GBIT_FEATURES | SUPPORTED_Pause),
 	.flags		= PHY_HAS_MAGICANEG | PHY_HAS_INTERRUPT,
 	.config_init	= kszphy_config_init,
 	.config_aneg	= genphy_config_aneg,
-- 
1.7.9.5

