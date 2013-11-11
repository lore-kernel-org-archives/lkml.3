Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3KKOrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:47:00 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63265 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3KKOqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:46:52 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev@vger.kernel.org
Cc: r58129@freescale.com, linux-kernel@vger.kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] PHY: Add RTL8201CP phy_driver to realtek
Date: Mon, 11 Nov 2013 15:46:06 +0100
Message-Id: <1384181166-15501-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RTL8201CP phy_driver.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    RTL8201CP PHY is used on MOXA UC-711X hardware(s).
    
    Adding the ID allows the PHY to be probed (by libphy), and eventually connected from MAC code.
    
    Applies to next-20131111

 drivers/net/phy/realtek.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 138de83..fa1d69a 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -64,6 +64,18 @@ static int rtl8211e_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+/* RTL8201CP */
+static struct phy_driver rtl8201cp_driver = {
+	.phy_id         = 0x00008201,
+	.name           = "RTL8201CP Ethernet",
+	.phy_id_mask    = 0x0000ffff,
+	.features       = PHY_BASIC_FEATURES,
+	.flags          = PHY_HAS_INTERRUPT,
+	.config_aneg    = &genphy_config_aneg,
+	.read_status    = &genphy_read_status,
+	.driver         = { .owner = THIS_MODULE,},
+};
+
 /* RTL8211B */
 static struct phy_driver rtl8211b_driver = {
 	.phy_id		= 0x001cc912,
@@ -98,6 +110,9 @@ static int __init realtek_init(void)
 {
 	int ret;
 
+	ret = phy_driver_register(&rtl8201cp_driver);
+	if (ret < 0)
+		return -ENODEV;
 	ret = phy_driver_register(&rtl8211b_driver);
 	if (ret < 0)
 		return -ENODEV;
-- 
1.8.2.1

