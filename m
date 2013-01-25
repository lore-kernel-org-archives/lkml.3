Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3AYKJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:09:34 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:56186 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755336Ab3AYKIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:08:44 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH 2/3] pwm: Add can_sleep property to drivers
Date: Fri, 25 Jan 2013 11:01:53 +0100
Message-Id: <1359108114-16998-3-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1359108114-16998-1-git-send-email-florian.vaussard@epfl.ch>
References: <1359108114-16998-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calls to PWM drivers connected through I2C can sleep.
Use the new can_sleep property.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/pwm/pwm-twl-led.c |    1 +
 drivers/pwm/pwm-twl.c     |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-twl-led.c b/drivers/pwm/pwm-twl-led.c
index 9dfa0f3..6261193 100644
--- a/drivers/pwm/pwm-twl-led.c
+++ b/drivers/pwm/pwm-twl-led.c
@@ -300,6 +300,7 @@ static int twl_pwmled_probe(struct platform_device *pdev)
 
 	twl->chip.dev = &pdev->dev;
 	twl->chip.base = -1;
+	twl->chip.can_sleep = 1;
 
 	mutex_init(&twl->mutex);
 
diff --git a/drivers/pwm/pwm-twl.c b/drivers/pwm/pwm-twl.c
index e65db95..4e56cd8 100644
--- a/drivers/pwm/pwm-twl.c
+++ b/drivers/pwm/pwm-twl.c
@@ -315,6 +315,7 @@ static int twl_pwm_probe(struct platform_device *pdev)
 	twl->chip.dev = &pdev->dev;
 	twl->chip.base = -1;
 	twl->chip.npwm = 2;
+	twl->chip.can_sleep = 1;
 
 	mutex_init(&twl->mutex);
 
-- 
1.7.5.4

