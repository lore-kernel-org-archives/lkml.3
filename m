Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3DAE3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 00:29:55 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44271 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3DAE3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 00:29:54 -0400
Message-ID: <1364790588.9357.3.camel@phoenix>
Subject: [PATCH v2 2/2] pwm: spear: Remove unused *dev from struct
 spear_pwm_chip
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 12:29:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Shiraz Hashim <shiraz.hashim@st.com>
---
v2: fix the prefix in subject line
 drivers/pwm/pwm-spear.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 3223b57..9563599 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -49,13 +49,11 @@
  * @mmio_base: base address of pwm chip
  * @clk: pointer to clk structure of pwm chip
  * @chip: linux pwm chip representation
- * @dev: pointer to device structure of pwm chip
  */
 struct spear_pwm_chip {
 	void __iomem *mmio_base;
 	struct clk *clk;
 	struct pwm_chip chip;
-	struct device *dev;
 };
 
 static inline struct spear_pwm_chip *to_spear_pwm_chip(struct pwm_chip *chip)
@@ -200,7 +198,6 @@ static int spear_pwm_probe(struct platform_device *pdev)
 	if (IS_ERR(pc->clk))
 		return PTR_ERR(pc->clk);
 
-	pc->dev = &pdev->dev;
 	platform_set_drvdata(pdev, pc);
 
 	pc->chip.dev = &pdev->dev;
-- 
1.7.10.4



