Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3GJQAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:00:01 -0400
Received: from sauhun.de ([89.238.76.85]:44353 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab3GJP76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:59:58 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH 10/12] drivers/pwm: don't use devm_pinctrl_get_select_default() in probe
Date: Wed, 10 Jul 2013 16:57:45 +0100
Message-Id: <1373471889-18107-10-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/pwm/pwm-mxs.c      |    6 ------
 drivers/pwm/pwm-tiecap.c   |    6 ------
 drivers/pwm/pwm-tiehrpwm.c |    6 ------
 3 files changed, 18 deletions(-)

diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
index 3febddd..6489a4b 100644
--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pwm.h>
 #include <linux/slab.h>
@@ -130,7 +129,6 @@ static int mxs_pwm_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct mxs_pwm_chip *mxs;
 	struct resource *res;
-	struct pinctrl *pinctrl;
 	int ret;
 
 	mxs = devm_kzalloc(&pdev->dev, sizeof(*mxs), GFP_KERNEL);
@@ -142,10 +140,6 @@ static int mxs_pwm_probe(struct platform_device *pdev)
 	if (IS_ERR(mxs->base))
 		return PTR_ERR(mxs->base);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		return PTR_ERR(pinctrl);
-
 	mxs->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(mxs->clk))
 		return PTR_ERR(mxs->clk);
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 72ca42d..050abe1 100644
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
index 48a485c..5f7632d 100644
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
1.7.10.4

