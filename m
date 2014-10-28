Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaJ1U5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:57:38 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42544 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaJ1U5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:57:36 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] pinctrl: rockchip: Implement PIN_CONFIG_OUTPUT_DISABLE
Date: Tue, 28 Oct 2014 13:57:15 -0700
Message-Id: <1414529835-16207-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414529835-16207-1-git-send-email-dianders@chromium.org>
References: <1414529835-16207-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If someone requests us to disable output for a pin, we'll configure it
as an input.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 40970c3..c1ac14c 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -971,6 +971,12 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			if (rc)
 				return rc;
 			break;
+		case PIN_CONFIG_OUTPUT_DISABLE:
+			rc = _rockchip_pmx_gpio_set_direction(&bank->gpio_chip,
+					  pin - bank->pin_base, true);
+			if (rc)
+				return rc;
+			break;
 		case PIN_CONFIG_OUTPUT:
 			rockchip_gpio_set(&bank->gpio_chip,
 					  pin - bank->pin_base, arg);
-- 
2.1.0.rc2.206.gedb03e5

