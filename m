Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaE1XVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:21:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47848 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752493AbaE1XVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:21:16 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-leds@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 08/15] avr32/at32ap: switch to the generic PWM framework
Date: Thu, 29 May 2014 01:20:11 +0200
Message-Id: <1401319218-16772-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1401319218-16772-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to the pwm/pwm-atmel driver instead of misc/atmel_pwm

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/mach-at32ap/at32ap700x.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index a1f4d1e91b52..db85b5ec3351 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1553,7 +1553,7 @@ static struct resource atmel_pwm0_resource[] __initdata = {
 	IRQ(24),
 };
 static struct clk atmel_pwm0_mck = {
-	.name		= "pwm_clk",
+	.name		= "at91sam9rl-pwm",
 	.parent		= &pbb_clk,
 	.mode		= pbb_clk_mode,
 	.get_rate	= pbb_clk_get_rate,
@@ -1568,7 +1568,7 @@ struct platform_device *__init at32_add_device_pwm(u32 mask)
 	if (!mask)
 		return NULL;
 
-	pdev = platform_device_alloc("atmel_pwm", 0);
+	pdev = platform_device_alloc("at91sam9rl-pwm", 0);
 	if (!pdev)
 		return NULL;
 
@@ -1576,9 +1576,6 @@ struct platform_device *__init at32_add_device_pwm(u32 mask)
 				ARRAY_SIZE(atmel_pwm0_resource)))
 		goto out_free_pdev;
 
-	if (platform_device_add_data(pdev, &mask, sizeof(mask)))
-		goto out_free_pdev;
-
 	pin_mask = 0;
 	if (mask & (1 << 0))
 		pin_mask |= (1 << 28);
-- 
1.9.1

