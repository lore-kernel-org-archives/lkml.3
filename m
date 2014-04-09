Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964902AbaDIS0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:26:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34597 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933143AbaDIS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:26:15 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] pwm: atmel: set pwm_chip can_sleep flag
Date: Wed,  9 Apr 2014 20:26:09 +0200
Message-Id: <1397067969-19905-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atmel_pwm_config() calls clk_get_rate() which might sleep, so we need to set
pwm_chip can_sleep flag.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pwm/pwm-atmel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index 0e589594b1cb..180e34e46617 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -369,6 +369,7 @@ static int atmel_pwm_probe(struct platform_device *pdev)
 
 	atmel_pwm->chip.base = -1;
 	atmel_pwm->chip.npwm = 4;
+	atmel_pwm->chip.can_sleep = true;
 	atmel_pwm->config = data->config;
 
 	ret = pwmchip_add(&atmel_pwm->chip);
-- 
1.8.3.2

