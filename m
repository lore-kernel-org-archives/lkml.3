Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3EXXZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:25:39 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.100]:28522 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610Ab3EXXZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:25:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1369437868!7352445!4
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/14] misc/ep93xx_pwm: remove ep93xx_pwm_enable() inline function
Date: Fri, 24 May 2013 16:24:16 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241624.17007.hartleys@visionengravers.com>
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
index 7a13304..cf42347 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -44,11 +44,6 @@ static inline u16 ep93xx_pwm_read_tc(struct ep93xx_pwm *pwm)
 	return readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 }
 
-static inline void ep93xx_pwm_enable(struct ep93xx_pwm *pwm)
-{
-	writel(0x1, pwm->mmio_base + EP93XX_PWMx_ENABLE);
-}
-
 static inline void ep93xx_pwm_disable(struct ep93xx_pwm *pwm)
 {
 	writel(0x0, pwm->mmio_base + EP93XX_PWMx_ENABLE);
@@ -155,7 +150,7 @@ static ssize_t ep93xx_pwm_set_freq(struct device *dev,
 		}
 
 		if (!ep93xx_pwm_is_enabled(pwm))
-			ep93xx_pwm_enable(pwm);
+			writel(0x1, pwm->mmio_base + EP93XX_PWMx_ENABLE);
 	} else {
 		return -EINVAL;
 	}
-- 
1.8.1.4

