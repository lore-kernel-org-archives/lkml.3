Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaEWVfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:35:20 -0400
Received: from mout.gmx.net ([212.227.15.18]:61333 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbaEWVfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:35:16 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: netdev@vger.kernel.org
Cc: s.hauer@pengutronix.de, f.fainelli@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] of: mdio: fix compile warning in of_mdiobus_register_phy()
Date: Fri, 23 May 2014 23:33:55 +0200
Message-Id: <1400880835-29537-1-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:mgvHEaVLQ5otg6iLEcuiNLghDp0OHoz97ErPpVD878Iju2VKDsp
 Gh4K5hyyb1QKDMOMCSWA/vOnqyENTMJ+9MOgpgco3T4fM+5ad44nD/7fizaf2K2gg1C6Dpw
 cAup6ORX8SyfaWE/vGwrN74+mo4EdGY9S5msOJynklR2rIIpK1Rr08XmkvViRp4hK7Ggs2E
 BuMuSoeH8rgyKVd9ZsdRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit de906af1 (net: phy: make of_set_phy_supported work with genphy driver)
removed the last user of variable 'max_speed' in function
of_mdiobus_register_phy(), leading to compile warning "unused variable
‘max_speed’ [-Wunused-variable]". Thus remove it.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested. Applies against branch master in tree
git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
---
 drivers/of/of_mdio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index b857094..7c6e277 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -46,7 +46,6 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
 	struct phy_device *phy;
 	bool is_c45;
 	int rc;
-	u32 max_speed = 0;
 	u32 phy_id;
 
 	is_c45 = of_device_is_compatible(child,
-- 
1.9.1

