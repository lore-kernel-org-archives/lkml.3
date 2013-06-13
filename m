Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3FMIs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:48:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53146 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758327Ab3FMIpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:45:12 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <sylvester.nawrocki@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <akpm@linux-foundation.org>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: [PATCH v7 8/9] usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
Date: Thu, 13 Jun 2013 14:13:58 +0530
Message-ID: <1371113039-5784-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371113039-5784-1-git-send-email-kishon@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that omap-usb2 is adapted to the new generic PHY framework,
*set_suspend* ops can be removed from omap-usb2 driver.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/phy/phy-omap-usb2.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/usb/phy/phy-omap-usb2.c b/drivers/usb/phy/phy-omap-usb2.c
index 3c275e7..bd2e4ca 100644
--- a/drivers/usb/phy/phy-omap-usb2.c
+++ b/drivers/usb/phy/phy-omap-usb2.c
@@ -97,29 +97,6 @@ static int omap_usb_set_peripheral(struct usb_otg *otg,
 	return 0;
 }
 
-static int omap_usb2_suspend(struct usb_phy *x, int suspend)
-{
-	u32 ret;
-	struct omap_usb *phy = phy_to_omapusb(x);
-
-	if (suspend && !phy->is_suspended) {
-		omap_control_usb_phy_power(phy->control_dev, 0);
-		pm_runtime_put_sync(phy->dev);
-		phy->is_suspended = 1;
-	} else if (!suspend && phy->is_suspended) {
-		ret = pm_runtime_get_sync(phy->dev);
-		if (ret < 0) {
-			dev_err(phy->dev, "get_sync failed with err %d\n",
-									ret);
-			return ret;
-		}
-		omap_control_usb_phy_power(phy->control_dev, 1);
-		phy->is_suspended = 0;
-	}
-
-	return 0;
-}
-
 static int omap_usb_power_off(struct phy *x)
 {
 	struct omap_usb *phy = dev_get_drvdata(&x->dev);
@@ -167,7 +144,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	phy->phy.dev		= phy->dev;
 	phy->phy.label		= "omap-usb2";
-	phy->phy.set_suspend	= omap_usb2_suspend;
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
 
-- 
1.7.10.4

