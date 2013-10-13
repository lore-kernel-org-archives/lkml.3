Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3JMQSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:18:49 -0400
Received: from sauhun.de ([89.238.76.85]:56486 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab3JMQSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:18:21 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] drivers/pwm: don't use devm_pinctrl_get_select_default() in probe
Date: Sun, 13 Oct 2013 18:17:49 +0200
Message-Id: <1381681071-6021-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/pwm/pwm-tiecap.c   | 6 ------
 drivers/pwm/pwm-tiehrpwm.c | 6 ------
 2 files changed, 12 deletions(-)

diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index c2e2e58..4e5c3d1 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -26,7 +26,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/pwm.h>
 #include <linux/of_device.h>
-#include <linux/pinctrl/consumer.h>
 
 #include "pwm-tipwmss.h"
 
@@ -208,11 +207,6 @@ static int ecap_pwm_probe(struct platform_device *pdev)
 	struct clk *clk;
 	struct ecap_pwm_chip *pc;
 	u16 status;
-	struct pinctrl *pinctrl;
-
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "unable to select pin group\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 084f552..a4d8f51 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -26,7 +26,6 @@
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
 #include <linux/of_device.h>
-#include <linux/pinctrl/consumer.h>
 
 #include "pwm-tipwmss.h"
 
@@ -439,11 +438,6 @@ static int ehrpwm_pwm_probe(struct platform_device *pdev)
 	struct clk *clk;
 	struct ehrpwm_pwm_chip *pc;
 	u16 status;
-	struct pinctrl *pinctrl;
-
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "unable to select pin group\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
-- 
1.8.4.rc3

