Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3HXTVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 15:21:13 -0400
Received: from 3.mo2.mail-out.ovh.net ([46.105.58.226]:53038 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755432Ab3HXTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 15:21:12 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH] net/cadence/macb: fix kernel Oops if no PHY were discovered during probe
Date: Sat, 24 Aug 2013 21:21:05 +0200
Message-Id: <1377372065-8938-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 577305178418935916
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test the presence of a PHY device before printing attached PHY
informations.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/net/ethernet/cadence/macb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index e866608..fd3b67f 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1868,8 +1868,10 @@ static int __init macb_probe(struct platform_device *pdev)
 		    dev->irq, dev->dev_addr);
 
 	phydev = bp->phy_dev;
-	netdev_info(dev, "attached PHY driver [%s] (mii_bus:phy_addr=%s, irq=%d)\n",
-		    phydev->drv->name, dev_name(&phydev->dev), phydev->irq);
+	if (phydev)
+		netdev_info(dev, "attached PHY driver [%s] (mii_bus:phy_addr=%s, irq=%d)\n",
+			    phydev->drv->name, dev_name(&phydev->dev),
+			    phydev->irq);
 
 	return 0;
 
-- 
1.7.9.5

