Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaBKIi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:38:58 -0500
Received: from mail.sensor-technik.de ([80.150.181.156]:53144 "EHLO
	mail.sensor-technik.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBKIix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:38:53 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2014 03:38:53 EST
X-IronPort-AV: E=Sophos;i="4.95,824,1384297200"; 
   d="scan'208,223";a="559028"
From: Waibel Georg <Georg.Waibel@sensor-technik.de>
To: "David S. Miller" <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] Micrel PHY: Allow setting of config flag
 MICREL_PHY_50MHZ_CLK for KSZ8081/KSZ8091 PHY
Thread-Topic: [PATCH 1/1] Micrel PHY: Allow setting of config flag
 MICREL_PHY_50MHZ_CLK for KSZ8081/KSZ8091 PHY
Thread-Index: Ac8nA0qkZQ5kOwpnQbWejfdNDLVh8A==
Date: Tue, 11 Feb 2014 08:28:50 +0000
Message-ID: <E1C9442006A9AE48A7A4B85E0D01C4D4753FB9@stwexdb.stww2k.local>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.230.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TBoneOriginalFrom: Waibel Georg <Georg.Waibel@sensor-technik.de>
X-TBoneOriginalTo: "David S. Miller" <davem@davemloft.net>
X-TBoneOriginalCC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-TBoneDomainSigned: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fe6aad7bb4c61b3ccd14bf637025e87df05ca14c Mon Sep 17 00:00:00 2001
From: Georg Waibel <georg.waibel@sensor-technik.de>
Date: Tue, 11 Feb 2014 08:15:56 +0100
Subject: [PATCH 1/1] Micrel PHY: Allow setting of config flag MICREL_PHY_50MHZ_CLK for KSZ8081/KSZ8091 PHY

The Micrel KSZ8081 and KSZ8091 PHYs support the RMII 50MHz mode. In this
mode, the PHY can be driven by an external 50MHz clock source. This mode
can be selected by the PHY device flag MICREL_PHY_50MHZ_CLK.
The driver already supports this feature for the KSZ8051 PHY. Thus, the
config_init function of this device can be used for the KSZ8081/8091 PHY
too.

Signed-off-by: Georg Waibel <georg.waibel@sensor-technik.de>
---
 drivers/net/phy/micrel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 26fa05a..0aeecb5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -384,9 +384,9 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KSZ8081 or KSZ8091",
 	.phy_id_mask	= 0x00fffff0,
 	.features	= (PHY_BASIC_FEATURES | SUPPORTED_Pause),
 	.flags		= PHY_HAS_MAGICANEG | PHY_HAS_INTERRUPT,
-	.config_init	= kszphy_config_init,
+	.config_init	= ks8051_config_init,
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
-- 
1.7.9.5

