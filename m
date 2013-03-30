Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3C3Fhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 01:37:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34782 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3C3Fhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 01:37:33 -0400
Message-ID: <1364621848.3568.0.camel@phoenix>
Subject: [PATCH v2] pwm: spear: Fix enable pwm output
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org
Date: Sat, 30 Mar 2013 13:37:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic to check return value of clk_enable() is reversed, thus
when clk_enable() passes PWMCR_PWM_ENABLE bit is not set. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-spear.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 69a2d9e..d836940 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -143,7 +143,7 @@ static int spear_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	u32 val;
 
 	rc = clk_enable(pc->clk);
-	if (!rc)
+	if (rc)
 		return rc;
 
 	val = spear_pwm_readl(pc, pwm->hwpwm, PWMCR);
@@ -214,7 +214,7 @@ static int spear_pwm_probe(struct platform_device *pdev)
 
 	if (of_device_is_compatible(np, "st,spear1340-pwm")) {
 		ret = clk_enable(pc->clk);
-		if (!ret) {
+		if (ret) {
 			clk_unprepare(pc->clk);
 			return ret;
 		}
-- 
1.7.10.4



