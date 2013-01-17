Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab3AQQCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:02:34 -0500
Received: from mail.prodrive.nl ([212.61.153.67]:7098 "EHLO mail.prodrive.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab3AQQCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:02:32 -0500
X-Greylist: delayed 1567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 11:02:32 EST
From: Stef van Os <stef.van.os@prodrive.nl>
To: <chohnstaedt@innominate.com>, <davem@davemloft.net>,
        <srinivas.kandagatla@st.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Stef van Os <stef.van.os@prodrive.nl>
Subject: [PATCH 1/1] phy/marvell: remove fiber/copper autoselect on 88e1111
Date: Thu, 17 Jan 2013 16:36:18 +0100
Message-ID: <1358436978-7504-1-git-send-email-stef.van.os@prodrive.nl>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-TM-AS-Product-Ver: IMSVA-8.2.0.1520-7.0.0.1014-19564.000
X-TM-AS-Result: No--6.632-5.0-31-10
X-imss-scan-details: No--6.632-5.0-31-10
X-TM-AS-User-Approved-Sender: No
X-TMASE-Version: IMSVA-8.2.0.1520-7.0.1014-19564.000
X-TMASE-Result: 10--6.631500-5.000000
X-TMASE-MatchedRID: 7hQvYNNB0HPU4D7YCSb+lLMsPmSZxbpk+eBf9ovw8I0wEhHW5KVAz/bF
	CxAQ6srCvdT86VL/Xf8BtjkcfRMmqSnPugGsN3p5Q4r9bxJdsVuZ2scyRQcer0UNHQAoZf5cNT0
	2hqjbFakv64ytQjJ6bseQPcxT2kjddB0ntd9Tzp47AFczfjr/7KmCSLIQzpZkT2gIwc/uozHCtE
	vF9M+6GPdxfodjojG1BRKGnZFkgyc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the code that always enables copper/fiber autoselect,
ignoring the DIS_FC strapping pin. The default value for this
register is autoselect on anyway, and if you explicitly disable
autoselect via strapping you probably really don't want
autoselect.

Signed-off-by: Stef van Os <stef.van.os@prodrive.nl>
---
 drivers/net/phy/marvell.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5d2a3f2..22dec9c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -353,15 +353,6 @@ static int m88e1111_config_init(struct phy_device *phydev)
 	int err;
 	int temp;
 
-	/* Enable Fiber/Copper auto selection */
-	temp = phy_read(phydev, MII_M1111_PHY_EXT_SR);
-	temp &= ~MII_M1111_HWCFG_FIBER_COPPER_AUTO;
-	phy_write(phydev, MII_M1111_PHY_EXT_SR, temp);
-
-	temp = phy_read(phydev, MII_BMCR);
-	temp |= BMCR_RESET;
-	phy_write(phydev, MII_BMCR, temp);
-
 	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII) ||
 	    (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) ||
 	    (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) ||
-- 
1.7.2.5

