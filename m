Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3G2EjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:39:24 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43218 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3G2EjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:39:21 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, srinivas.kandagatla@st.com,
        sachin.kamat@linaro.org
Subject: [PATCH 1/2] pinctrl: st: Convert to use devm_ioremap_resource
Date: Mon, 29 Jul 2013 09:52:55 +0530
Message-Id: <1375071776-29037-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_request_and_ioremap is deprecated. Use devm_ioremap_resource
instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-st.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 04d4506..6246d7a 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1222,11 +1222,9 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 	if (of_address_to_resource(np, 0, &res))
 		return -ENODEV;
 
-	bank->base = devm_request_and_ioremap(dev, &res);
-	if (!bank->base) {
-		dev_err(dev, "Can't get IO memory mapping!\n");
-		return -ENODEV;
-	}
+	bank->base = devm_ioremap_resource(dev, &res);
+	if (IS_ERR(bank->base))
+		return PTR_ERR(bank->base);
 
 	bank->gpio_chip = st_gpio_template;
 	bank->gpio_chip.base = bank_num * ST_GPIO_PINS_PER_BANK;
-- 
1.7.9.5

