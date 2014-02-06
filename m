Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbaBFSGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:06:22 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.153]:28036 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbaBFSGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:06:19 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-12.tower-179.messagelabs.com!1391709809!22887069!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <36eb26fd1b41f2c1d679152b9df0eeaaeeab66fe.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 6 Feb 2014 18:03:15 +0000
Subject: [PATCH v2 5/8] onkey: da9055: Remove use of regmap_irq_get_virq()
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

Using platform_get_irq_byname() to retrieve the IRQ number
returns the VIRQ number rather than the local IRQ number for
the device. Passing that value then into regmap_irq_get_virq()
causes a failure because the function is expecting the local
IRQ number (e.g. 0, 1, 2, 3, etc). This patch removes use of
regmap_irq_get_virq() to prevent this failure from happening.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 drivers/input/misc/da9055_onkey.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index 4b11ede..4765799 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -109,7 +109,6 @@ static int da9055_onkey_probe(struct platform_device *pdev)

 	INIT_DELAYED_WORK(&onkey->work, da9055_onkey_work);

-	irq = regmap_irq_get_virq(da9055->irq_data, irq);
 	err = request_threaded_irq(irq, NULL, da9055_onkey_irq,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   "ONKEY", onkey);
--
1.7.0.4

