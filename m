Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3DACtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 22:49:31 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:39894 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3DACta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 22:49:30 -0400
Message-ID: <1364784565.7725.2.camel@phoenix>
Subject: [PATCH 2/2] pwm: mxs: Remove unused *dev from struct spear_pwm_chip
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 10:49:25 +0800
In-Reply-To: <1364784493.7725.1.camel@phoenix>
References: <1364784493.7725.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
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



