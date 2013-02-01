Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3BAMKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:10:24 -0500
Received: from nbd.name ([46.4.11.11]:41377 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025Ab3BAMHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:07:54 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>
Subject: [PATCH 02/11] PINCTRL: lantiq: faulty bit inversion
Date: Fri,  1 Feb 2013 13:04:56 +0100
Message-Id: <1359720305-31933-2-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic of the OD bit was inverted when calling the pinconf get methode.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-xway.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index 69dec9b..c49c9db 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -443,7 +443,7 @@ static int xway_pinconf_get(struct pinctrl_dev *pctldev,
 		else
 			reg = GPIO_OD(pin);
 		*config = LTQ_PINCONF_PACK(param,
-			!!gpio_getbit(info->membase[0], reg, PORT_PIN(pin)));
+			!gpio_getbit(info->membase[0], reg, PORT_PIN(pin)));
 		break;
 
 	case LTQ_PINCONF_PARAM_PULL:
-- 
1.7.10.4

