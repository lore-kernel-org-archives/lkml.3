Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3C3Mnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:43:41 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:39675 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab3C3Mn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:43:28 -0400
Message-ID: <1364647402.3822.1.camel@phoenix>
Subject: [PATCH] pwm: spear: Fix checking return value of clk_enable() and
 clk_prepare()
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Sat, 30 Mar 2013 20:43:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic to check return value of clk_enable() and clk_prepare() is reversed,
fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: <stable@vger.kernel.org>
---
This is v3 of "pwm: spear: Fix enable pwm output".
I change the subject line because it also fixes checking return value of
clk_prepare().
Also add cc stable.

Axel

 drivers/pwm/pwm-spear.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 69a2d9e..3223b57 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -143,7 +143,7 @@ static int spear_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	u32 val;
 
 	rc = clk_enable(pc->clk);
-	if (!rc)
+	if (rc)
 		return rc;
 
 	val = spear_pwm_readl(pc, pwm->hwpwm, PWMCR);
@@ -209,12 +209,12 @@ static int spear_pwm_probe(struct platform_device *pdev)
 	pc->chip.npwm = NUM_PWM;
 
 	ret = clk_prepare(pc->clk);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	if (of_device_is_compatible(np, "st,spear1340-pwm")) {
 		ret = clk_enable(pc->clk);
-		if (!ret) {
+		if (ret) {
 			clk_unprepare(pc->clk);
 			return ret;
 		}
-- 
1.7.10.4



