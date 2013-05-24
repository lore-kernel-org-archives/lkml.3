Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3EXXY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:24:26 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:48485 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab3EXXYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:24:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1369437862!23032961!4
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/14] misc/ep93xx_pwm: remove ep93xx_pwm_{write,read}l() inline functions
Date: Fri, 24 May 2013 16:22:30 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241622.30652.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are simple wrappers around writel() and readl(). Remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
---
 drivers/misc/ep93xx_pwm.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index af01fb9..06f0c63 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -39,61 +39,49 @@ struct ep93xx_pwm {
 	u32		duty_percent;
 };
 
-static inline void ep93xx_pwm_writel(struct ep93xx_pwm *pwm,
-		unsigned int val, unsigned int off)
-{
-	writel(val, pwm->mmio_base + off);
-}
-
-static inline unsigned int ep93xx_pwm_readl(struct ep93xx_pwm *pwm,
-		unsigned int off)
-{
-	return readl(pwm->mmio_base + off);
-}
-
 static inline void ep93xx_pwm_write_tc(struct ep93xx_pwm *pwm, u16 value)
 {
-	ep93xx_pwm_writel(pwm, value, EP93XX_PWMx_TERM_COUNT);
+	writel(value, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 }
 
 static inline u16 ep93xx_pwm_read_tc(struct ep93xx_pwm *pwm)
 {
-	return ep93xx_pwm_readl(pwm, EP93XX_PWMx_TERM_COUNT);
+	return readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 }
 
 static inline void ep93xx_pwm_write_dc(struct ep93xx_pwm *pwm, u16 value)
 {
-	ep93xx_pwm_writel(pwm, value, EP93XX_PWMx_DUTY_CYCLE);
+	writel(value, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
 }
 
 static inline void ep93xx_pwm_enable(struct ep93xx_pwm *pwm)
 {
-	ep93xx_pwm_writel(pwm, 0x1, EP93XX_PWMx_ENABLE);
+	writel(0x1, pwm->mmio_base + EP93XX_PWMx_ENABLE);
 }
 
 static inline void ep93xx_pwm_disable(struct ep93xx_pwm *pwm)
 {
-	ep93xx_pwm_writel(pwm, 0x0, EP93XX_PWMx_ENABLE);
+	writel(0x0, pwm->mmio_base + EP93XX_PWMx_ENABLE);
 }
 
 static inline int ep93xx_pwm_is_enabled(struct ep93xx_pwm *pwm)
 {
-	return ep93xx_pwm_readl(pwm, EP93XX_PWMx_ENABLE) & 0x1;
+	return readl(pwm->mmio_base + EP93XX_PWMx_ENABLE) & 0x1;
 }
 
 static inline void ep93xx_pwm_invert(struct ep93xx_pwm *pwm)
 {
-	ep93xx_pwm_writel(pwm, 0x1, EP93XX_PWMx_INVERT);
+	writel(0x1, pwm->mmio_base + EP93XX_PWMx_INVERT);
 }
 
 static inline void ep93xx_pwm_normal(struct ep93xx_pwm *pwm)
 {
-	ep93xx_pwm_writel(pwm, 0x0, EP93XX_PWMx_INVERT);
+	writel(0x0, pwm->mmio_base + EP93XX_PWMx_INVERT);
 }
 
 static inline int ep93xx_pwm_is_inverted(struct ep93xx_pwm *pwm)
 {
-	return ep93xx_pwm_readl(pwm, EP93XX_PWMx_INVERT) & 0x1;
+	return readl(pwm->mmio_base + EP93XX_PWMx_INVERT) & 0x1;
 }
 
 /*
-- 
1.8.1.4

