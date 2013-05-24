Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3EXX2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:28:21 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.101]:13125 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab3EXX2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:28:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1369438098!7383235!2
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/14] misc/ep93xx_pwm: remove ep93xx_pwm_is_enabled() inline function
Date: Fri, 24 May 2013 16:27:08 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241627.09007.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple wrapper around readl(), remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
---
 drivers/misc/ep93xx_pwm.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 6f48375..3dd2006 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -39,11 +39,6 @@ struct ep93xx_pwm {
 	u32		duty_percent;
 };
 
-static inline int ep93xx_pwm_is_enabled(struct ep93xx_pwm *pwm)
-{
-	return readl(pwm->mmio_base + EP93XX_PWMx_ENABLE) & 0x1;
-}
-
 static inline int ep93xx_pwm_is_inverted(struct ep93xx_pwm *pwm)
 {
 	return readl(pwm->mmio_base + EP93XX_PWMx_INVERT) & 0x1;
@@ -84,7 +79,7 @@ static ssize_t ep93xx_pwm_get_freq(struct device *dev,
 	struct platform_device *pdev = to_platform_device(dev);
 	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
 
-	if (ep93xx_pwm_is_enabled(pwm)) {
+	if (readl(pwm->mmio_base + EP93XX_PWMx_ENABLE) & 0x1) {
 		unsigned long rate = clk_get_rate(pwm->clk);
 		u16 term = readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 
@@ -129,7 +124,7 @@ static ssize_t ep93xx_pwm_set_freq(struct device *dev,
 			writel(val, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 		}
 
-		if (!ep93xx_pwm_is_enabled(pwm))
+		if (!readl(pwm->mmio_base + EP93XX_PWMx_ENABLE) & 0x1)
 			writel(0x1, pwm->mmio_base + EP93XX_PWMx_ENABLE);
 	} else {
 		return -EINVAL;
-- 
1.8.1.4

