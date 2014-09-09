Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaIIHsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:48:13 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:47329 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099AbaIIHsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:48:12 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com
Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH v2] pinctrl: st: remove gpiochip in failure cases
Date: Tue,  9 Sep 2014 13:21:40 +0530
Message-Id: <1410249101-12234-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch releases gpiochip related resources by calling
gpiochip_remove when gpiochip_irqchip_add fails.

CC: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.com>
CC: Maxime Coquelin <maxime.coquelin@st.com>
CC: Patrice Chotard <patrice.chotard@st.com>
CC: Linus Walleij <linus.walleij@linaro.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
Changes since v1:
Dropped adding remove function as it will never be tested as 
the driver is bool.

 drivers/pinctrl/pinctrl-st.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 5475374..af2f589 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1517,6 +1517,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 					   0, handle_simple_irq,
 					   IRQ_TYPE_LEVEL_LOW);
 		if (err) {
+			gpiochip_remove(&bank->gpio_chip);
 			dev_info(dev, "could not add irqchip\n");
 			return err;
 		}
-- 
1.7.9.5

