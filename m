Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3EXX3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:29:42 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.205]:60873 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106Ab3EXX3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:29:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-131.messagelabs.com!1369438180!24492451!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/14] misc/ep93xx_pwm: remove ep93xx_pwm_is_inverted() inline function
Date: Fri, 24 May 2013 16:27:38 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241627.38721.hartleys@visionengravers.com>
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
 drivers/misc/ep93xx_pwm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 3dd2006..dd570d1 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -39,11 +39,6 @@ struct ep93xx_pwm {
 	u32		duty_percent;
 };
 
-static inline int ep93xx_pwm_is_inverted(struct ep93xx_pwm *pwm)
-{
-	return readl(pwm->mmio_base + EP93XX_PWMx_INVERT) & 0x1;
-}
-
 /*
  * /sys/devices/platform/ep93xx-pwm.N
  *   /min_freq      read-only   minimum pwm output frequency
@@ -171,8 +166,9 @@ static ssize_t ep93xx_pwm_get_invert(struct device *dev,
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
+	int inverted = readl(pwm->mmio_base + EP93XX_PWMx_INVERT) & 0x1;
 
-	return sprintf(buf, "%d\n", ep93xx_pwm_is_inverted(pwm));
+	return sprintf(buf, "%d\n", inverted);
 }
 
 static ssize_t ep93xx_pwm_set_invert(struct device *dev,
-- 
1.8.1.4

