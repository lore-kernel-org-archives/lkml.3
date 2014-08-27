Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbaH0KyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:54:13 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:49027 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708AbaH0KyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:54:11 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: qcom: Release pin ranges when gpiochip_irqchip_add fails
Date: Wed, 27 Aug 2014 16:27:29 +0530
Message-Id: <1409137049-15848-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches adds a call to gpiochip_remove_pin_ranges when
gpiochip_irqchip_add fails to release memory allocated for pin_ranges.

CC: Ivan T. Ivanov <iivanov@mm-sol.com>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/qcom/pinctrl-msm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index f4e4f8f..aa34b5a 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -845,6 +845,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 				   IRQ_TYPE_NONE);
 	if (ret) {
 		dev_err(pctrl->dev, "Failed to add irqchip to gpiochip\n");
+		gpiochip_remove_pin_ranges(chip);
 		return -ENOSYS;
 	}
 
-- 
1.7.9.5

