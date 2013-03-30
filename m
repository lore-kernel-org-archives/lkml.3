Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3C3QGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 12:06:41 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:36023 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab3C3QGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 12:06:40 -0400
Message-ID: <1364659590.15109.5.camel@phoenix>
Subject: [RFT][PATCH 2/2] pwm: lpc32xx: Don't change PWM_ENABLE bit in
 lpc32xx_pwm_config
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Roland Stigge <stigge@antcom.de>, linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 00:06:30 +0800
In-Reply-To: <1364659529.15109.4.camel@phoenix>
References: <1364659529.15109.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lpc32xx_pwm_config() is supposed to set duty_ns and period_ns,
it should not change PWM_ENABLE bit.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-lpc32xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index 1a5075e..ac4d28d 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -68,7 +68,7 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		c = 255;
 	duty_cycles = 256 - c;
 
-	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
+	writel(PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
 		lpc32xx->base + (pwm->hwpwm << 2));
 
 	return 0;
-- 
1.7.10.4



