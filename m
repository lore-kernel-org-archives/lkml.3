Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab3EXXeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:34:31 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.8]:9480 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185Ab3EXXea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:34:30 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2013 19:34:30 EDT
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1369438042!2500264!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/14] misc/ep93xx_pwm: remove ep93xx_pwm_normal() inline function
Date: Fri, 24 May 2013 16:26:11 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241626.12351.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple wrapper around writel(), remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
---
 drivers/misc/ep93xx_pwm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 5193faf..cdc2ffc 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -49,11 +49,6 @@ static inline int ep93xx_pwm_is_enabled(struct ep93xx_pwm *pwm)
 	return readl(pwm->mmio_base + EP93XX_PWMx_ENABLE) & 0x1;
 }
 
-static inline void ep93xx_pwm_normal(struct ep93xx_pwm *pwm)
-{
-	writel(0x0, pwm->mmio_base + EP93XX_PWMx_INVERT);
-}
-
 static inline int ep93xx_pwm_is_inverted(struct ep93xx_pwm *pwm)
 {
 	return readl(pwm->mmio_base + EP93XX_PWMx_INVERT) & 0x1;
@@ -203,7 +198,7 @@ static ssize_t ep93xx_pwm_set_invert(struct device *dev,
 		return -EINVAL;
 
 	if (val == 0)
-		ep93xx_pwm_normal(pwm);
+		writel(0x0, pwm->mmio_base + EP93XX_PWMx_INVERT);
 	else if (val == 1)
 		writel(0x1, pwm->mmio_base + EP93XX_PWMx_INVERT);
 	else
-- 
1.8.1.4

