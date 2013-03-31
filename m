Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3CaO7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 10:59:55 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58406 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3CaO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 10:59:54 -0400
Message-ID: <1364741987.3834.2.camel@phoenix>
Subject: [PATCH 1/3] pwm: imx: Remove enabled field from struct imx_chip
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 22:59:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can test PWMF_ENABLED bit to know if pwm is enabled or not.
Thus remove enabled field from struct imx_chip.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-imx.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 3f5677b..ec28798 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -43,7 +43,6 @@ struct imx_chip {
 	struct clk	*clk_per;
 	struct clk	*clk_ipg;
 
-	int		enabled;
 	void __iomem	*mmio_base;
 
 	struct pwm_chip	chip;
@@ -135,7 +134,7 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 		MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
 		MX3_PWMCR_DBGEN | MX3_PWMCR_CLKSRC_IPG_HIGH;
 
-	if (imx->enabled)
+	if (test_bit(PWMF_ENABLED, &pwm->flags))
 		cr |= MX3_PWMCR_EN;
 
 	writel(cr, imx->mmio_base + MX3_PWMCR);
@@ -186,8 +185,6 @@ static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	imx->set_enable(chip, true);
 
-	imx->enabled = 1;
-
 	return 0;
 }
 
@@ -198,7 +195,6 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	imx->set_enable(chip, false);
 
 	clk_disable_unprepare(imx->clk_per);
-	imx->enabled = 0;
 }
 
 static struct pwm_ops imx_pwm_ops = {
-- 
1.7.10.4



