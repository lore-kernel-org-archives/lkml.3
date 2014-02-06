Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaBFSFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:05:09 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:62806 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaBFSDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:03:49 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-12.tower-179.messagelabs.com!1391709809!22887069!5
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <1234f50ae0bcf6e9fe057cbe26f9c55b042d2c2e.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 6 Feb 2014 18:03:21 +0000
Subject: [PATCH v2 8/8] regulator: da9055: Remove use of regmap_irq_get_virq()
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
 drivers/regulator/da9055-regulator.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index d90f785..3b7a26c 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -637,7 +637,9 @@ static int da9055_regulator_probe(struct platform_device *pdev)
 	/* Only LDO 5 and 6 has got the over current interrupt */
 	if (pdev->id == DA9055_ID_LDO5 || pdev->id ==  DA9055_ID_LDO6) {
 		irq = platform_get_irq_byname(pdev, "REGULATOR");
-		irq = regmap_irq_get_virq(da9055->irq_data, irq);
+		if (irq < 0)
+			return irq;
+
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 						da9055_ldo5_6_oc_irq,
 						IRQF_TRIGGER_HIGH |
--
1.7.0.4

