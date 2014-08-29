Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaH2IMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:12:33 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:51011 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbaH2IMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:12:25 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2] pinctrl: qcom: remove gpiochip in failure cases
Date: Fri, 29 Aug 2014 13:41:48 +0530
Message-Id: <1409299909-5128-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch releases gpiochip related resources by calling
gpiochip_remove when either of gpiochip_add_pin_range and
gpiochip_irqchip_add fails.

CC: Linus Walleij <linus.walleij@linaro.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---

Changes since v1:
- In v1 of this patch gpiochip_remove was called only in failure case of
  gpiochip_irqchip_add. This patchs adds a call to gpiochip_remove in failure
  case of gpiochip_add_pin_range as well.

 drivers/pinctrl/qcom/pinctrl-msm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 2738108..9175bbc 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -829,6 +829,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	ret = gpiochip_add_pin_range(&pctrl->chip, dev_name(pctrl->dev), 0, 0, chip->ngpio);
 	if (ret) {
 		dev_err(pctrl->dev, "Failed to add pin range\n");
+		gpiochip_remove(&pctrl->chip);
 		return ret;
 	}
 
@@ -839,6 +840,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 				   IRQ_TYPE_NONE);
 	if (ret) {
 		dev_err(pctrl->dev, "Failed to add irqchip to gpiochip\n");
+		gpiochip_remove(&pctrl->chip);
 		return -ENOSYS;
 	}
 
-- 
1.7.0.4

