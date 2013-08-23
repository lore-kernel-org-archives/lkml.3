Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3HWG2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:28:48 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:65288 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3HWG2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:28:47 -0400
Message-ID: <1377239323.14131.1.camel@phoenix>
Subject: [PATCH 2/2] pinctrl: rockchip: Remove non-reachable break statement
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Aug 2013 14:28:43 +0800
In-Reply-To: <1377239273.14131.0.camel@phoenix>
References: <1377239273.14131.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The break statement after return is non-reachable, remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-rockchip.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 7eb1249..319a64a 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -585,7 +585,6 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
 		return rockchip_set_pull(bank, pin - bank->pin_base, param);
-		break;
 	case PIN_CONFIG_BIAS_PULL_UP:
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 	case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
@@ -596,10 +595,8 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			return -EINVAL;
 
 		return rockchip_set_pull(bank, pin - bank->pin_base, param);
-		break;
 	default:
 		return -ENOTSUPP;
-		break;
 	}
 
 	return 0;
@@ -633,7 +630,6 @@ static int rockchip_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
 		break;
 	default:
 		return -ENOTSUPP;
-		break;
 	}
 
 	return 0;
-- 
1.8.1.2



