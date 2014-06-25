Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaFYJTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:19:01 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12438 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaFYJS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:18:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 25 Jun 2014 02:09:08 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] pwm-backlight: use devm_gpiod_get_optional()
Date: Wed, 25 Jun 2014 18:18:18 +0900
Message-ID: <1403687898-26881-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new devm_gpiod_get_optional() to simplify the probe
code.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/video/backlight/pwm_bl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 38ca88bc5c3e..d1e0a7c6cac7 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -245,13 +245,10 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	pb->dev = &pdev->dev;
 	pb->enabled = false;
 
-	pb->enable_gpio = devm_gpiod_get(&pdev->dev, "enable");
+	pb->enable_gpio = devm_gpiod_get_optional(&pdev->dev, "enable");
 	if (IS_ERR(pb->enable_gpio)) {
 		ret = PTR_ERR(pb->enable_gpio);
-		if (ret == -ENOENT)
-			pb->enable_gpio = NULL;
-		else
-			goto err_alloc;
+		goto err_alloc;
 	}
 
 	/*
-- 
2.0.0

