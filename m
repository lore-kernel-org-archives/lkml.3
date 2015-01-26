Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbbAZMP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:15:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37101 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbbAZMPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:15:49 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>
CC: <george.cherian@ti.com>, <nsekhar@ti.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 2/7] usb: extcon: Fix USB-Host cable name
Date: Mon, 26 Jan 2015 14:15:27 +0200
Message-ID: <1422274532-9488-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422274532-9488-1-git-send-email-rogerq@ti.com>
References: <1422274532-9488-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recommended name for USB-Host cable state is "USB-Host" and not
"USB-HOST" as per drivers/extcon/extcon-class.c extcon_cable_name.

Change all instances of "USB-HOST" to "USB-Host".

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/extcon/extcon-palmas.c | 18 +++++++++---------
 drivers/usb/dwc3/dwc3-omap.c   |  6 +++---
 drivers/usb/phy/phy-omap-otg.c |  4 ++--
 drivers/usb/phy/phy-tahvo.c    |  8 ++++----
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 11c6757..6d002c3 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -31,7 +31,7 @@
 
 static const char *palmas_extcon_cable[] = {
 	[0] = "USB",
-	[1] = "USB-HOST",
+	[1] = "USB-Host",
 	NULL,
 };
 
@@ -93,26 +93,26 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
 			PALMAS_USB_ID_INT_LATCH_CLR,
 			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
 		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
-		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", true);
-		dev_info(palmas_usb->dev, "USB-HOST cable is attached\n");
+		extcon_set_cable_state(palmas_usb->edev, "USB-Host", true);
+		dev_info(palmas_usb->dev, "USB-Host cable is attached\n");
 	} else if ((set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) &&
 				(id_src & PALMAS_USB_ID_INT_SRC_ID_FLOAT)) {
 		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
 			PALMAS_USB_ID_INT_LATCH_CLR,
 			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
 		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
-		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", false);
-		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
+		extcon_set_cable_state(palmas_usb->edev, "USB-Host", false);
+		dev_info(palmas_usb->dev, "USB-Host cable is detached\n");
 	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_ID) &&
 				(!(set & PALMAS_USB_ID_INT_SRC_ID_GND))) {
 		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
-		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", false);
-		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
+		extcon_set_cable_state(palmas_usb->edev, "USB-Host", false);
+		dev_info(palmas_usb->dev, "USB-Host cable is detached\n");
 	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_DISCONNECT) &&
 				(id_src & PALMAS_USB_ID_INT_SRC_ID_GND)) {
 		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
-		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", true);
-		dev_info(palmas_usb->dev, " USB-HOST cable is attached\n");
+		extcon_set_cable_state(palmas_usb->edev, "USB-Host", true);
+		dev_info(palmas_usb->dev, " USB-Host cable is attached\n");
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 172d64e..6713ad9 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -445,14 +445,14 @@ static int dwc3_omap_extcon_register(struct dwc3_omap *omap)
 
 		omap->id_nb.notifier_call = dwc3_omap_id_notifier;
 		ret = extcon_register_interest(&omap->extcon_id_dev,
-					       edev->name, "USB-HOST",
+					       edev->name, "USB-Host",
 					       &omap->id_nb);
 		if (ret < 0)
-			dev_vdbg(omap->dev, "failed to register notifier for USB-HOST\n");
+			dev_vdbg(omap->dev, "failed to register notifier for USB-Host\n");
 
 		if (extcon_get_cable_state(edev, "USB") == true)
 			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
-		if (extcon_get_cable_state(edev, "USB-HOST") == true)
+		if (extcon_get_cable_state(edev, "USB-Host") == true)
 			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
 	}
 
diff --git a/drivers/usb/phy/phy-omap-otg.c b/drivers/usb/phy/phy-omap-otg.c
index 56ee760..53cba3f 100644
--- a/drivers/usb/phy/phy-omap-otg.c
+++ b/drivers/usb/phy/phy-omap-otg.c
@@ -119,7 +119,7 @@ static int omap_otg_probe(struct platform_device *pdev)
 	otg_dev->vbus_nb.notifier_call = omap_otg_vbus_notifier;
 
 	ret = extcon_register_interest(&otg_dev->id_dev, config->extcon,
-				       "USB-HOST", &otg_dev->id_nb);
+				       "USB-Host", &otg_dev->id_nb);
 	if (ret)
 		return ret;
 
@@ -130,7 +130,7 @@ static int omap_otg_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	otg_dev->id = extcon_get_cable_state(extcon, "USB-HOST");
+	otg_dev->id = extcon_get_cable_state(extcon, "USB-Host");
 	otg_dev->vbus = extcon_get_cable_state(extcon, "USB");
 	omap_otg_set_mode(otg_dev);
 
diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index 845f658..56d3704 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -61,7 +61,7 @@ struct tahvo_usb {
 };
 
 static const char *tahvo_cable[] = {
-	"USB-HOST",
+	"USB-Host",
 	"USB",
 	NULL,
 };
@@ -129,7 +129,7 @@ static void tahvo_usb_become_host(struct tahvo_usb *tu)
 {
 	struct retu_dev *rdev = dev_get_drvdata(tu->pt_dev->dev.parent);
 
-	extcon_set_cable_state(&tu->extcon, "USB-HOST", true);
+	extcon_set_cable_state(&tu->extcon, "USB-Host", true);
 
 	/* Power up the transceiver in USB host mode */
 	retu_write(rdev, TAHVO_REG_USBR, USBR_REGOUT | USBR_NSUSPEND |
@@ -148,7 +148,7 @@ static void tahvo_usb_become_peripheral(struct tahvo_usb *tu)
 {
 	struct retu_dev *rdev = dev_get_drvdata(tu->pt_dev->dev.parent);
 
-	extcon_set_cable_state(&tu->extcon, "USB-HOST", false);
+	extcon_set_cable_state(&tu->extcon, "USB-Host", false);
 
 	/* Power up transceiver and set it in USB peripheral mode */
 	retu_write(rdev, TAHVO_REG_USBR, USBR_SLAVE_CONTROL | USBR_REGOUT |
@@ -376,7 +376,7 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 	}
 
 	/* Set the initial cable state. */
-	extcon_set_cable_state(&tu->extcon, "USB-HOST",
+	extcon_set_cable_state(&tu->extcon, "USB-Host",
 			       tu->tahvo_mode == TAHVO_MODE_HOST);
 	extcon_set_cable_state(&tu->extcon, "USB", tu->vbus_state);
 
-- 
2.1.0

