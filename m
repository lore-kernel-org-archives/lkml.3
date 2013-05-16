Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3EPLPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:11 -0400
Received: from sauhun.de ([89.238.76.85]:56150 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab3EPLPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:06 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Prisk <linux@prisktech.co.nz>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/33] drivers/pwm: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:43 +0200
Message-Id: <1368702961-4325-16-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/pwm/pwm-imx.c      |    5 -----
 drivers/pwm/pwm-puv3.c     |    5 -----
 drivers/pwm/pwm-pxa.c      |    5 -----
 drivers/pwm/pwm-tegra.c    |    5 -----
 drivers/pwm/pwm-tiecap.c   |    5 -----
 drivers/pwm/pwm-tiehrpwm.c |    5 -----
 drivers/pwm/pwm-tipwmss.c  |    5 -----
 drivers/pwm/pwm-vt8500.c   |    5 -----
 8 files changed, 40 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index ec28798..c938bae 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -265,11 +265,6 @@ static int imx_pwm_probe(struct platform_device *pdev)
 	imx->chip.npwm = 1;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
-		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENODEV;
-	}
-
 	imx->mmio_base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(imx->mmio_base))
 		return PTR_ERR(imx->mmio_base);
diff --git a/drivers/pwm/pwm-puv3.c b/drivers/pwm/pwm-puv3.c
index d1eb499..ed6007b 100644
--- a/drivers/pwm/pwm-puv3.c
+++ b/drivers/pwm/pwm-puv3.c
@@ -117,11 +117,6 @@ static int pwm_probe(struct platform_device *pdev)
 		return PTR_ERR(puv3->clk);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
-		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENODEV;
-	}
-
 	puv3->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(puv3->base))
 		return PTR_ERR(puv3->base);
diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index dee6ab55..dc97175 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -147,11 +147,6 @@ static int pwm_probe(struct platform_device *pdev)
 	pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
-		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENODEV;
-	}
-
 	pwm->mmio_base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(pwm->mmio_base))
 		return PTR_ERR(pwm->mmio_base);
diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index 3d75f4a..a540293 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -181,11 +181,6 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 	pwm->dev = &pdev->dev;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "no memory resources defined\n");
-		return -ENODEV;
-	}
-
 	pwm->mmio_base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(pwm->mmio_base))
 		return PTR_ERR(pwm->mmio_base);
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 0d65fb2..72ca42d 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -240,11 +240,6 @@ static int ecap_pwm_probe(struct platform_device *pdev)
 	pc->chip.npwm = 1;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENODEV;
-	}
-
 	pc->mmio_base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(pc->mmio_base))
 		return PTR_ERR(pc->mmio_base);
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 6a21759..48a485c 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -471,11 +471,6 @@ static int ehrpwm_pwm_probe(struct platform_device *pdev)
 	pc->chip.npwm = NUM_PWM_CHANNEL;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENODEV;
-	}
-
 	pc->mmio_base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(pc->mmio_base))
 		return PTR_ERR(pc->mmio_base);
diff --git a/drivers/pwm/pwm-tipwmss.c b/drivers/pwm/pwm-tipwmss.c
index c9c3d3a..3b119bc 100644
--- a/drivers/pwm/pwm-tipwmss.c
+++ b/drivers/pwm/pwm-tipwmss.c
@@ -70,11 +70,6 @@ static int pwmss_probe(struct platform_device *pdev)
 	mutex_init(&info->pwmss_lock);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENODEV;
-	}
-
 	info->mmio_base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(info->mmio_base))
 		return PTR_ERR(info->mmio_base);
diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index 69effd1..323125a 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -230,11 +230,6 @@ static int vt8500_pwm_probe(struct platform_device *pdev)
 	}
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
-		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENODEV;
-	}
-
 	chip->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(chip->base))
 		return PTR_ERR(chip->base);
-- 
1.7.10.4

