Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbbAVSLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:11:55 -0500
Received: from mx2.uti.ro ([91.220.13.110]:56391 "EHLO mx2.uti.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbbAVSLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:11:53 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 13:11:52 EST
From: Nicolae Rosia <nicolae.rosia@certsign.ro>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: [PATCH] net: phy: fix phy device autoneg wrong value
Thread-Topic: [PATCH] net: phy: fix phy device autoneg wrong value
Thread-Index: AQHQNmzHlIhHis5SlkqDW9BJxBx83w==
Date: Thu, 22 Jan 2015 17:56:44 +0000
Message-ID: <1421948980.717.6.camel@uti.ro>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.101.85]
Content-Type: text/plain; charset="utf-8"
Content-ID: <46B504E64B3D0145B8B7EF3904974B2E@uti.ro>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-FEAS-SYSTEM-WL: 10.65.2.20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0MIC0rn028735

In phy_device_create, autoneg is set to AUTONEG_ENABLE.
When using the generic phy driver (phy_device.c),
genphy_config_init reads BMSR and finds out if autonegotiation
is possible and sets the phy device features accordingly.
phy_sanitize_settings is supposed to set the right value of
autoneg, but it is never called if autonegotiation is enabled,
which is always the case.

Signed-off-by: Nicolae Rosia <nicolae.rosia@certsign.ro>
---
 drivers/net/phy/phy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 767cd11..9c35136 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -249,9 +249,6 @@ static void phy_sanitize_settings(struct phy_device
*phydev)
 	unsigned int idx;
 
 	/* Sanitize settings based on PHY capabilities */
-	if ((features & SUPPORTED_Autoneg) == 0)
-		phydev->autoneg = AUTONEG_DISABLE;
-
 	idx = phy_find_valid(phy_find_setting(phydev->speed, phydev->duplex),
 			features);
 
@@ -436,6 +433,9 @@ int phy_start_aneg(struct phy_device *phydev)
 
 	mutex_lock(&phydev->lock);
 
+	if ((phydev->supported & SUPPORTED_Autoneg) == 0)
+		phydev->autoneg = AUTONEG_DISABLE;
+
 	if (AUTONEG_DISABLE == phydev->autoneg)
 		phy_sanitize_settings(phydev);
 
-- 
2.1.0


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
