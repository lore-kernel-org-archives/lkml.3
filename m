Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbaBFSD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:03:56 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:19487 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755665AbaBFSDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:03:47 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-12.tower-179.messagelabs.com!1391709809!22887069!4
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <b8020329a507379c71a4ef33fc3ae6bcce037ca6.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 6 Feb 2014 18:03:19 +0000
Subject: [PATCH v2 7/8] rtc: da9055: Remove use of regmap_irq_get_virq()
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
 drivers/rtc/rtc-da9055.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-da9055.c b/drivers/rtc/rtc-da9055.c
index 48cb2ac..a825491 100644
--- a/drivers/rtc/rtc-da9055.c
+++ b/drivers/rtc/rtc-da9055.c
@@ -302,7 +302,9 @@ static int da9055_rtc_probe(struct platform_device *pdev)
 	}

 	alm_irq = platform_get_irq_byname(pdev, "ALM");
-	alm_irq = regmap_irq_get_virq(rtc->da9055->irq_data, alm_irq);
+	if (alm_irq < 0)
+		return alm_irq;
+
 	ret = devm_request_threaded_irq(&pdev->dev, alm_irq, NULL,
 					da9055_rtc_alm_irq,
 					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
--
1.7.0.4

