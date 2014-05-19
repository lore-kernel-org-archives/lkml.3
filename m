Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaESUaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:30:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54866 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751482AbaESUay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:30:54 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH resend] pwm: atmel: set pwm_chip can_sleep flag
Date: Mon, 19 May 2014 22:30:44 +0200
Message-Id: <1400531444-28613-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atmel_pwm_config() calls clk_get_rate() which might sleep, so we need to set
pwm_chip can_sleep flag.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/pwm/pwm-atmel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index 0adc952cc4ef..6e700a541ca3 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -357,6 +357,7 @@ static int atmel_pwm_probe(struct platform_device *pdev)
 
 	atmel_pwm->chip.base = -1;
 	atmel_pwm->chip.npwm = 4;
+	atmel_pwm->chip.can_sleep = true;
 	atmel_pwm->config = data->config;
 
 	ret = pwmchip_add(&atmel_pwm->chip);
-- 
1.9.1

