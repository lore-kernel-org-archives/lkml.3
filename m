Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab3EXXYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:24:01 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.206]:59159 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab3EXXYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:24:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1369437838!15964883!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/14] misc/ep93xx_pwm: use {read,write}* instead of __raw_* versions for io
Date: Fri, 24 May 2013 16:21:50 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241621.50447.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mmio_base is an ioremap'ed memory resource. The normal memory
io functions should be used not the __raw_* versions.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
---
 drivers/misc/ep93xx_pwm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 36370b4..af01fb9 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -42,13 +42,13 @@ struct ep93xx_pwm {
 static inline void ep93xx_pwm_writel(struct ep93xx_pwm *pwm,
 		unsigned int val, unsigned int off)
 {
-	__raw_writel(val, pwm->mmio_base + off);
+	writel(val, pwm->mmio_base + off);
 }
 
 static inline unsigned int ep93xx_pwm_readl(struct ep93xx_pwm *pwm,
 		unsigned int off)
 {
-	return __raw_readl(pwm->mmio_base + off);
+	return readl(pwm->mmio_base + off);
 }
 
 static inline void ep93xx_pwm_write_tc(struct ep93xx_pwm *pwm, u16 value)
-- 
1.8.1.4

