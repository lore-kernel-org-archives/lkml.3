Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3BAMK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:10:26 -0500
Received: from nbd.name ([46.4.11.11]:41374 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab3BAMHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:07:54 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>
Subject: [PATCH 01/11] PINCTRL: lantiq: pinconf uses port instead of pin
Date: Fri,  1 Feb 2013 13:04:55 +0100
Message-Id: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The XWAY pinctrl driver invalidly uses the port and not the pin number to work
out the registeres and bits to be set for the opendrain and pullup/down
resistors.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-xway.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index 5f0eb04..69dec9b 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -441,17 +441,17 @@ static int xway_pinconf_get(struct pinctrl_dev *pctldev,
 		if (port == PORT3)
 			reg = GPIO3_OD;
 		else
-			reg = GPIO_OD(port);
+			reg = GPIO_OD(pin);
 		*config = LTQ_PINCONF_PACK(param,
-			!!gpio_getbit(info->membase[0], reg, PORT_PIN(port)));
+			!!gpio_getbit(info->membase[0], reg, PORT_PIN(pin)));
 		break;
 
 	case LTQ_PINCONF_PARAM_PULL:
 		if (port == PORT3)
 			reg = GPIO3_PUDEN;
 		else
-			reg = GPIO_PUDEN(port);
-		if (!gpio_getbit(info->membase[0], reg, PORT_PIN(port))) {
+			reg = GPIO_PUDEN(pin);
+		if (!gpio_getbit(info->membase[0], reg, PORT_PIN(pin))) {
 			*config = LTQ_PINCONF_PACK(param, 0);
 			break;
 		}
@@ -459,8 +459,8 @@ static int xway_pinconf_get(struct pinctrl_dev *pctldev,
 		if (port == PORT3)
 			reg = GPIO3_PUDSEL;
 		else
-			reg = GPIO_PUDSEL(port);
-		if (!gpio_getbit(info->membase[0], reg, PORT_PIN(port)))
+			reg = GPIO_PUDSEL(pin);
+		if (!gpio_getbit(info->membase[0], reg, PORT_PIN(pin)))
 			*config = LTQ_PINCONF_PACK(param, 2);
 		else
 			*config = LTQ_PINCONF_PACK(param, 1);
@@ -488,29 +488,29 @@ static int xway_pinconf_set(struct pinctrl_dev *pctldev,
 		if (port == PORT3)
 			reg = GPIO3_OD;
 		else
-			reg = GPIO_OD(port);
-		gpio_setbit(info->membase[0], reg, PORT_PIN(port));
+			reg = GPIO_OD(pin);
+		gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
 		break;
 
 	case LTQ_PINCONF_PARAM_PULL:
 		if (port == PORT3)
 			reg = GPIO3_PUDEN;
 		else
-			reg = GPIO_PUDEN(port);
+			reg = GPIO_PUDEN(pin);
 		if (arg == 0) {
-			gpio_clearbit(info->membase[0], reg, PORT_PIN(port));
+			gpio_clearbit(info->membase[0], reg, PORT_PIN(pin));
 			break;
 		}
-		gpio_setbit(info->membase[0], reg, PORT_PIN(port));
+		gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
 
 		if (port == PORT3)
 			reg = GPIO3_PUDSEL;
 		else
-			reg = GPIO_PUDSEL(port);
+			reg = GPIO_PUDSEL(pin);
 		if (arg == 1)
-			gpio_clearbit(info->membase[0], reg, PORT_PIN(port));
+			gpio_clearbit(info->membase[0], reg, PORT_PIN(pin));
 		else if (arg == 2)
-			gpio_setbit(info->membase[0], reg, PORT_PIN(port));
+			gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
 		else
 			dev_err(pctldev->dev, "Invalid pull value %d\n", arg);
 		break;
-- 
1.7.10.4

