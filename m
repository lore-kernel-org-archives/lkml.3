Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3LBHFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 02:05:36 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:53271 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab3LBHFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 02:05:32 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 2/3] usb: phy-ulpi: Add EXTVBUSIND,CHRGVBUS flag support
Date: Mon,  2 Dec 2013 15:05:18 +0800
Message-Id: <1385967919-13258-3-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: phy-ulpi: Add EXTVBUSIND,CHRGVBUS flag support

ULPI like ISP1504 support external vbus power indication
used in combination with vbus switches mic2075.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/usb/phy/phy-ulpi.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-ulpi.c b/drivers/usb/phy/phy-ulpi.c
index 217339d..e2f15c4 100644
--- a/drivers/usb/phy/phy-ulpi.c
+++ b/drivers/usb/phy/phy-ulpi.c
@@ -180,6 +180,8 @@ static int ulpi_init(struct usb_phy *phy)
 	int i, vid, pid, ret;
 	u32 ulpi_id = 0;
 
+	pr_info("ULPI Viewport 0x%p\n",phy->io_priv);
+
 	for (i = 0; i < 4; i++) {
 		ret = usb_phy_io_read(phy, ULPI_PRODUCT_ID_HIGH - i);
 		if (ret < 0)
@@ -237,7 +239,8 @@ static int ulpi_set_vbus(struct usb_otg *otg, bool on)
 	struct usb_phy *phy = otg->phy;
 	unsigned int flags = usb_phy_io_read(phy, ULPI_OTG_CTRL);
 
-	flags &= ~(ULPI_OTG_CTRL_DRVVBUS | ULPI_OTG_CTRL_DRVVBUS_EXT);
+	flags &= ~(ULPI_OTG_CTRL_DRVVBUS | ULPI_OTG_CTRL_DRVVBUS_EXT |
+			ULPI_OTG_CTRL_EXTVBUSIND | ULPI_OTG_CTRL_CHRGVBUS);
 
 	if (on) {
 		if (phy->flags & ULPI_OTG_DRVVBUS)
@@ -245,6 +248,12 @@ static int ulpi_set_vbus(struct usb_otg *otg, bool on)
 
 		if (phy->flags & ULPI_OTG_DRVVBUS_EXT)
 			flags |= ULPI_OTG_CTRL_DRVVBUS_EXT;
+
+		if (phy->flags & ULPI_OTG_EXTVBUSIND)
+			flags |= ULPI_OTG_CTRL_EXTVBUSIND;
+
+		if (phy->flags & ULPI_OTG_CHRGVBUS)
+			flags |= ULPI_OTG_CTRL_CHRGVBUS;
 	}
 
 	return usb_phy_io_write(phy, flags, ULPI_OTG_CTRL);
-- 
1.7.10.4

