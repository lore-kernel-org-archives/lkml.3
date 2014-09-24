Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaIXNrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:47:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50993 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaIXNri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:38 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/22] usb: phy: twl4030-usb: Remove unused irq_enabled
Date: Wed, 24 Sep 2014 19:17:08 +0530
Message-ID: <1411566440-19169-11-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

It's not being used any longer.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-twl4030-usb.c |    2 --
 1 file changed, 2 deletions(-)

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
-- 
1.7.9.5

