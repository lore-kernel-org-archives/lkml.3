Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3BAMH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:07:59 -0500
Received: from nbd.name ([46.4.11.11]:41387 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471Ab3BAMH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:07:57 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>
Subject: [PATCH 05/11] PINCTRL: lantiq: the pinconf OD parameter argument was ignored
Date: Fri,  1 Feb 2013 13:04:59 +0100
Message-Id: <1359720305-31933-5-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting the OpenDrain bit we should really honour the argument passed
inside the devicetree.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-xway.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index b23b895..53cb6a3 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -494,7 +494,10 @@ static int xway_pinconf_set(struct pinctrl_dev *pctldev,
 			reg = GPIO3_OD;
 		else
 			reg = GPIO_OD(pin);
-		gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
+		if (arg == 0)
+			gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
+		else
+			gpio_clearbit(info->membase[0], reg, PORT_PIN(pin));
 		break;
 
 	case LTQ_PINCONF_PARAM_PULL:
-- 
1.7.10.4

