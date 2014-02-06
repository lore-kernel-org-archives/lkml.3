Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbaBFSEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:04:43 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.145]:49572 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577AbaBFSDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:03:50 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-12.tower-179.messagelabs.com!1391709809!22887069!3
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <43bbe337fea5ac7e19b97179f2abb7e74684d0eb.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 6 Feb 2014 18:03:17 +0000
Subject: [PATCH v2 6/8] hwmon: da9055: Remove use of regmap_irq_get_virq()
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
 drivers/hwmon/da9055-hwmon.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/da9055-hwmon.c b/drivers/hwmon/da9055-hwmon.c
index 029ecab..73b3865 100644
--- a/drivers/hwmon/da9055-hwmon.c
+++ b/drivers/hwmon/da9055-hwmon.c
@@ -278,10 +278,6 @@ static int da9055_hwmon_probe(struct platform_device *pdev)
 	if (hwmon_irq < 0)
 		return hwmon_irq;

-	hwmon_irq = regmap_irq_get_virq(hwmon->da9055->irq_data, hwmon_irq);
-	if (hwmon_irq < 0)
-		return hwmon_irq;
-
 	ret = devm_request_threaded_irq(&pdev->dev, hwmon_irq,
 					NULL, da9055_auxadc_irq,
 					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
--
1.7.0.4

