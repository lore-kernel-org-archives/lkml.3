Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3KYGAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 01:00:33 -0500
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:24864
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077Ab3KYGAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 01:00:31 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1b2fh224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: <shh.xie@gmail.com>
To: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>
CC: <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>
Subject: [PATCH] phy: Add Vitesse 8514 phy ID
Date: Mon, 25 Nov 2013 12:40:49 +0800
Message-ID: <1385354449-2943-1-git-send-email-shh.xie@gmail.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohui Xie <Shaohui.Xie@freescale.com>

Phy is compatible with Vitesse 82xx

Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
---
 drivers/net/phy/vitesse.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/phy/vitesse.c b/drivers/net/phy/vitesse.c
index 508e435..14372c6 100644
--- a/drivers/net/phy/vitesse.c
+++ b/drivers/net/phy/vitesse.c
@@ -64,6 +64,7 @@
 
 #define PHY_ID_VSC8234			0x000fc620
 #define PHY_ID_VSC8244			0x000fc6c0
+#define PHY_ID_VSC8514			0x00070670
 #define PHY_ID_VSC8574			0x000704a0
 #define PHY_ID_VSC8662			0x00070660
 #define PHY_ID_VSC8221			0x000fc550
@@ -131,6 +132,7 @@ static int vsc82xx_config_intr(struct phy_device *phydev)
 		err = phy_write(phydev, MII_VSC8244_IMASK,
 			(phydev->drv->phy_id == PHY_ID_VSC8234 ||
 			 phydev->drv->phy_id == PHY_ID_VSC8244 ||
+			 phydev->drv->phy_id == PHY_ID_VSC8514 ||
 			 phydev->drv->phy_id == PHY_ID_VSC8574) ?
 				MII_VSC8244_IMASK_MASK :
 				MII_VSC8221_IMASK_MASK);
@@ -246,6 +248,18 @@ static struct phy_driver vsc82xx_driver[] = {
 	.config_intr	= &vsc82xx_config_intr,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
+	.phy_id		= PHY_ID_VSC8514,
+	.name		= "Vitesse VSC8514",
+	.phy_id_mask	= 0x000ffff0,
+	.features	= PHY_GBIT_FEATURES,
+	.flags		= PHY_HAS_INTERRUPT,
+	.config_init	= &vsc824x_config_init,
+	.config_aneg	= &vsc82x4_config_aneg,
+	.read_status	= &genphy_read_status,
+	.ack_interrupt	= &vsc824x_ack_interrupt,
+	.config_intr	= &vsc82xx_config_intr,
+	.driver		= { .owner = THIS_MODULE,},
+}, {
 	.phy_id         = PHY_ID_VSC8574,
 	.name           = "Vitesse VSC8574",
 	.phy_id_mask    = 0x000ffff0,
@@ -315,6 +329,7 @@ module_exit(vsc82xx_exit);
 static struct mdio_device_id __maybe_unused vitesse_tbl[] = {
 	{ PHY_ID_VSC8234, 0x000ffff0 },
 	{ PHY_ID_VSC8244, 0x000fffc0 },
+	{ PHY_ID_VSC8514, 0x000ffff0 },
 	{ PHY_ID_VSC8574, 0x000ffff0 },
 	{ PHY_ID_VSC8662, 0x000ffff0 },
 	{ PHY_ID_VSC8221, 0x000ffff0 },
-- 
1.8.4.1


