Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3HWHtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:49:07 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51696 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab3HWHtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:49:05 -0400
Message-ID: <1377244140.24387.1.camel@phoenix>
Subject: [PATCH] pinctrl: rockchip: Simplify pin_to_bank equation
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Aug 2013 15:49:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If (b->pin_base + b->nr_pins - 1) < pin is true, pin >= b->pin_base is always
true because b->nr_pins is never less than 0.
Thus this patch simplify the equation.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-rockchip.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 319a64a..ea27806 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -186,8 +186,7 @@ static struct rockchip_pin_bank *pin_to_bank(struct rockchip_pinctrl *info,
 {
 	struct rockchip_pin_bank *b = info->ctrl->pin_banks;
 
-	while ((pin >= b->pin_base) &&
-			((b->pin_base + b->nr_pins - 1) < pin))
+	while (pin >= (b->pin_base + b->nr_pins))
 		b++;
 
 	return b;
-- 
1.8.1.2



