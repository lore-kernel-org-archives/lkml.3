Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbaH0X2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:28:19 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38099 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964948AbaH0X2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:28:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ZTHIf5/nrJdv2kCeOv9+Y
From: Tony Lindgren <tony@atomide.com>
To: kishon@ti.com
Cc: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 1/5] usb: phy: twl4030-usb: Remove unused irq_enabled
Date: Wed, 27 Aug 2014 16:28:07 -0700
Message-Id: <1409182091-31191-2-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1409182091-31191-1-git-send-email-tony@atomide.com>
References: <1409182091-31191-1-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not being used any longer.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/phy/phy-twl4030-usb.c     | 2 --
 drivers/usb/phy/phy-twl6030-usb.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 9cd33a4..bc28ecc 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -164,7 +164,6 @@ struct twl4030_usb {
 	enum omap_musb_vbus_id_status linkstat;
 	bool			vbus_supplied;
 	u8			asleep;
-	bool			irq_enabled;
 
 	struct delayed_work	id_workaround_work;
 };
@@ -755,7 +754,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	 * set_host() and/or set_peripheral() ... OTG_capable boards
 	 * need both handles, otherwise just one suffices.
 	 */
-	twl->irq_enabled = true;
 	status = devm_request_threaded_irq(twl->dev, twl->irq, NULL,
 			twl4030_usb_irq, IRQF_TRIGGER_FALLING |
 			IRQF_TRIGGER_RISING | IRQF_ONESHOT, "twl4030_usb", twl);
diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index 04778cf..44ea082 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -104,7 +104,6 @@ struct twl6030_usb {
 	int			irq2;
 	enum omap_musb_vbus_id_status linkstat;
 	u8			asleep;
-	bool			irq_enabled;
 	bool			vbus_enable;
 	const char		*regulator;
 };
@@ -373,7 +372,6 @@ static int twl6030_usb_probe(struct platform_device *pdev)
 
 	INIT_WORK(&twl->set_vbus_work, otg_set_vbus_work);
 
-	twl->irq_enabled = true;
 	status = request_threaded_irq(twl->irq1, NULL, twl6030_usbotg_irq,
 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 			"twl6030_usb", twl);
-- 
1.8.1.1

