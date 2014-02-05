Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaBERzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:55:39 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.140]:42203 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116AbaBERzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:55:36 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-15.tower-179.messagelabs.com!1391622519!28172031!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <0f633e556abaecaa1feb70e0e3f6bbaeffc47874.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 5 Feb 2014 17:48:38 +0000
Subject: [PATCH 8/8] mfd: da9055: Remove unused resource structures for mfd cells.
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
 drivers/mfd/da9055-core.c |   46 ---------------------------------------------
 1 files changed, 0 insertions(+), 46 deletions(-)

diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index caf8dcf..5cf8ca6 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -258,42 +258,6 @@ struct regmap_config da9055_regmap_config = {
 };
 EXPORT_SYMBOL_GPL(da9055_regmap_config);

-static struct resource da9055_onkey_resource = {
-	.name = "ONKEY",
-	.start = DA9055_IRQ_NONKEY,
-	.end   = DA9055_IRQ_NONKEY,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct resource da9055_rtc_resource[] = {
-	{
-		.name = "ALM",
-		.start = DA9055_IRQ_ALARM,
-		.end   = DA9055_IRQ_ALARM,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "TICK",
-		.start = DA9055_IRQ_TICK,
-		.end   = DA9055_IRQ_TICK,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct resource da9055_hwmon_resource = {
-	.name = "HWMON",
-	.start = DA9055_IRQ_HWMON,
-	.end   = DA9055_IRQ_HWMON,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct resource da9055_ld05_6_resource = {
-	.name = "REGULATOR",
-	.start = DA9055_IRQ_REGULATOR,
-	.end   = DA9055_IRQ_REGULATOR,
-	.flags = IORESOURCE_IRQ,
-};
-
 static const struct mfd_cell da9055_devs[] = {
 	{
 		.of_compatible = "dialog,da9055-gpio",
@@ -333,33 +297,23 @@ static const struct mfd_cell da9055_devs[] = {
 		.of_compatible = "dialog,da9055-regulator",
 		.name = "da9055-regulator",
 		.id = 7,
-		.resources = &da9055_ld05_6_resource,
-		.num_resources = 1,
 	},
 	{
 		.of_compatible = "dialog,da9055-regulator",
 		.name = "da9055-regulator",
-		.resources = &da9055_ld05_6_resource,
-		.num_resources = 1,
 		.id = 8,
 	},
 	{
 		.of_compatible = "dialog,da9055-onkey",
 		.name = "da9055-onkey",
-		.resources = &da9055_onkey_resource,
-		.num_resources = 1,
 	},
 	{
 		.of_compatible = "dialog,da9055-rtc",
 		.name = "da9055-rtc",
-		.resources = da9055_rtc_resource,
-		.num_resources = ARRAY_SIZE(da9055_rtc_resource),
 	},
 	{
 		.of_compatible = "dialog,da9055-hwmon",
 		.name = "da9055-hwmon",
-		.resources = &da9055_hwmon_resource,
-		.num_resources = 1,
 	},
 	{
 		.of_compatible = "dialog,da9055-watchdog",
--
1.7.0.4

