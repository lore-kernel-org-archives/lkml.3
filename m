Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3A3TkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:40:19 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:52669 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845Ab3A3TkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:40:17 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] pinctrl/abx500: use the BIT() macro where appropriate
Date: Wed, 30 Jan 2013 20:39:59 +0100
Message-ID: <1359574799-15627-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

The BIT() macro provides a simple and easy to read way of
obtaining bit offsets into things like masks and hardware
registers. In this patch we're simply replacing all
instances of '1 << x' with 'bit(x)'.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-abx500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 7046aef..539c9bb 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -157,7 +157,7 @@ static int abx500_gpio_set_bits(struct gpio_chip *chip, u8 reg,
 
 	reg += offset / 8;
 	ret = abx500_mask_and_set_register_interruptible(pct->dev,
-				AB8500_MISC, reg, 1 << pos, val << pos);
+				AB8500_MISC, reg, BIT(pos), val << pos);
 	if (ret < 0)
 		dev_err(pct->dev, "%s write failed\n", __func__);
 	return ret;
-- 
1.7.11.3

