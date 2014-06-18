Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbaFREuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 00:50:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60359 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaFREt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 00:49:59 -0400
From: Andy Gross <agross@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [PATCH] pinctrl: qcom: Add BUS_HOLD pin bias
Date: Tue, 17 Jun 2014 23:49:11 -0500
Message-Id: <1403066951-31266-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the BUS_HOLD (Keeper) bias option for pins.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/pinctrl/pinctrl-msm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index e43fbce..9aa2839 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -206,6 +206,7 @@ static int msm_config_reg(struct msm_pinctrl *pctrl,
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
 	case PIN_CONFIG_BIAS_PULL_DOWN:
+	case PIN_CONFIG_BIAS_BUS_HOLD:
 	case PIN_CONFIG_BIAS_PULL_UP:
 		*bit = g->pull_bit;
 		*mask = 3;
@@ -243,6 +244,7 @@ static int msm_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
 
 #define MSM_NO_PULL	0
 #define MSM_PULL_DOWN	1
+#define MSM_KEEPER	2
 #define MSM_PULL_UP	3
 
 static unsigned msm_regval_to_drive(u32 val)
@@ -280,6 +282,9 @@ static int msm_config_group_get(struct pinctrl_dev *pctldev,
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 		arg = arg == MSM_PULL_DOWN;
 		break;
+	case PIN_CONFIG_BIAS_BUS_HOLD:
+		arg = arg == MSM_KEEPER;
+		break;
 	case PIN_CONFIG_BIAS_PULL_UP:
 		arg = arg == MSM_PULL_UP;
 		break;
@@ -339,6 +344,9 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
 		case PIN_CONFIG_BIAS_PULL_DOWN:
 			arg = MSM_PULL_DOWN;
 			break;
+		case PIN_CONFIG_BIAS_BUS_HOLD:
+			arg = MSM_KEEPER;
+			break;
 		case PIN_CONFIG_BIAS_PULL_UP:
 			arg = MSM_PULL_UP;
 			break;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

