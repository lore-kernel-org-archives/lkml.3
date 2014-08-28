Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaH1STI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:19:08 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40226 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaH1STG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:19:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18sYBiob+CfyL3aSzkb1+Rc
Date: Thu, 28 Aug 2014 11:19:02 -0700
From: Tony Lindgren <tony@atomide.com>
To: balbi@ti.com
Cc: kishon@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH] usb: phy: twl6030-usb: Remove unused irq_enabled
Message-ID: <20140828181901.GL16006@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not being used any longer.

Signed-off-by: Tony Lindgren <tony@atomide.com>

---

Felipe, here's the twl6030 only version for you to pick.

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
