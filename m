Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbaCNPHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:07:10 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49749 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbaCNPHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:07:08 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linus.walleij@linaro.org, sboyd@codeaurora.org,
        bjorn.andersson@sonymobile.com
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH] pinctrl: msm: Fix compile error in msm_config_reg()
Date: Fri, 14 Mar 2014 17:06:16 +0200
Message-Id: <1394809576-21255-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compilation error in msm_config_reg():

drivers/pinctrl/pinctrl-msm.c: In function 'msm_config_reg':
drivers/pinctrl/pinctrl-msm.c:218:4: error: 'reg' undeclared (first use in this
function)

Error is caused by the mix of these two commits:
ed118a5fd951bd2def8249ee251842c4f81fe4bd
051a58b4622f0e1b732acb750097c64bc00ddb93

Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/pinctrl/pinctrl-msm.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 19d2feb..343f421 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -215,7 +215,6 @@ static int msm_config_reg(struct msm_pinctrl *pctrl,
 		*mask = 7;
 		break;
 	case PIN_CONFIG_OUTPUT:
-		*reg = g->ctl_reg;
 		*bit = g->oe_bit;
 		*mask = 1;
 		break;
-- 
1.7.9.5

