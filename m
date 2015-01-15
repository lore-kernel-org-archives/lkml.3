Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbbAOCpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 21:45:20 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:37333 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbbAOCpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 21:45:18 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "Dinh Nguyen (dinguyen@opensource.altera.com)" 
	<dinguyen@opensource.altera.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "robert.jarzmik@free.fr" <robert.jarzmik@free.fr>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: phy: make GPIOs optional for the generic phy
Thread-Topic: [PATCH] usb: phy: make GPIOs optional for the generic phy
Thread-Index: AdAwbTXrO7DxzvJ4SC6YgyOS6Kjhkw==
Date: Thu, 15 Jan 2015 02:45:12 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304845078CE@US01WEMBX2.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 47bd18e210fecf701d493c27884e13c69bc449ea Mon Sep 17 00:00:00 2001
From: Paul Zimmerman <paulz@synopsys.com>
Date: Wed, 14 Jan 2015 18:15:58 -0800
Subject: [PATCH] usb: phy: make GPIOs optional for the generic phy

The use of GPIOs should be optional for the generic phy, otherwise
the Altera SOCFPGA platform at least is broken.

Fixes breakage caused by a combination of e9f2cefb0cd "usb: phy: 
generic: migrate to gpio_desc" and 135b3c4304d "usb: dwc2: platform: 
add generic PHY framework support".

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
---
Based on top of testing/next.

 drivers/usb/phy/phy-generic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index dd05254..9a826ff 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -218,10 +218,10 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop,
 			clk_rate = 0;
 
 		needs_vcc = of_property_read_bool(node, "vcc-supply");
-		nop->gpiod_reset = devm_gpiod_get(dev, "reset-gpios");
+		nop->gpiod_reset = devm_gpiod_get_optional(dev, "reset-gpios");
 		err = PTR_ERR(nop->gpiod_reset);
 		if (!err) {
-			nop->gpiod_vbus = devm_gpiod_get(dev,
+			nop->gpiod_vbus = devm_gpiod_get_optional(dev,
 							 "vbus-detect-gpio");
 			err = PTR_ERR(nop->gpiod_vbus);
 		}
-- 
1.7.6.5

