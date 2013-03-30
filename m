Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab3C3DqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 23:46:18 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:49877 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969Ab3C3DqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 23:46:13 -0400
Message-ID: <1364615166.3771.1.camel@phoenix>
Subject: [PATCH] pwm: spear: Fix enable pwm output
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org
Date: Sat, 30 Mar 2013 11:46:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic to check return value of clk_enable() is reversed, thus
when clek_enable() success PWMCR_PWM_ENABLE bit is never set. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-spear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 69a2d9e..cccb430 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -143,7 +143,7 @@ static int spear_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	u32 val;
 
 	rc = clk_enable(pc->clk);
-	if (!rc)
+	if (rc)
 		return rc;
 
 	val = spear_pwm_readl(pc, pwm->hwpwm, PWMCR);
-- 
1.7.10.4



