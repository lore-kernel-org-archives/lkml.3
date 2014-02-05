Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaBERzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:55:49 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.120]:52152 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbaBERzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:55:47 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-16.tower-194.messagelabs.com!1391622518!8244963!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <17c7fc7fe1e2246e32891be55a0e900231272371.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 5 Feb 2014 17:48:36 +0000
Subject: [PATCH 6/8] hwmon: da9055: Remove use of platform_get_irq_byname()
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 drivers/hwmon/da9055-hwmon.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/da9055-hwmon.c b/drivers/hwmon/da9055-hwmon.c
index 029ecab..1867682 100644
--- a/drivers/hwmon/da9055-hwmon.c
+++ b/drivers/hwmon/da9055-hwmon.c
@@ -274,11 +274,8 @@ static int da9055_hwmon_probe(struct platform_device *pdev)

 	platform_set_drvdata(pdev, hwmon);

-	hwmon_irq = platform_get_irq_byname(pdev, "HWMON");
-	if (hwmon_irq < 0)
-		return hwmon_irq;
-
-	hwmon_irq = regmap_irq_get_virq(hwmon->da9055->irq_data, hwmon_irq);
+	hwmon_irq = regmap_irq_get_virq(hwmon->da9055->irq_data,
+					DA9055_IRQ_HWMON);
 	if (hwmon_irq < 0)
 		return hwmon_irq;

--
1.7.0.4

