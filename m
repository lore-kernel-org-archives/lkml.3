Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3BRGwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:52:53 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41144 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab3BRGww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:52:52 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/4] regulator: core: use regulator_ena_pin member
Thread-Topic: [PATCH v3 3/4] regulator: core: use regulator_ena_pin member
Thread-Index: Ac4NpEwh1xD720iiQXOjTk/XPOObGQ==
Date: Mon, 18 Feb 2013 06:50:55 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F79272A01@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The regulator_dev has regulator_enable_gpio structure.
 'ena_gpio' and 'ena_gpio_invert' were moved to in regulator_enable_gpio.

  regulator_dev   --->   regulator_enable_gpio
  .ena_gpio              .gpio
  .ena_gpio_invert       .ena_gpio_invert

  Pointer, 'ena_pin' is used for checking valid enable GPIO pin.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c         |    6 +++---
 include/linux/regulator/driver.h |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 57d434d..6c8c824 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1945,7 +1945,7 @@ EXPORT_SYMBOL_GPL(regulator_disable_regmap);
 static int _regulator_is_enabled(struct regulator_dev *rdev)
 {
 	/* A GPIO control always takes precedence */
-	if (rdev->ena_gpio)
+	if (rdev->ena_pin)
 		return rdev->ena_gpio_state;
 
 	/* If we don't know then assume that the regulator is always on */
@@ -3344,7 +3344,7 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 		if (status < 0)
 			return status;
 	}
-	if (rdev->ena_gpio || ops->is_enabled) {
+	if (rdev->ena_pin || ops->is_enabled) {
 		status = device_create_file(dev, &dev_attr_state);
 		if (status < 0)
 			return status;
@@ -3556,7 +3556,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		if (config->ena_gpio_flags & GPIOF_OUT_INIT_HIGH)
 			rdev->ena_gpio_state = 1;
 
-		if (rdev->ena_gpio_invert)
+		if (config->ena_gpio_invert)
 			rdev->ena_gpio_state = !rdev->ena_gpio_state;
 	}
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index a467d11..7b7aeec 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -302,8 +302,6 @@ struct regulator_dev {
 	struct dentry *debugfs;
 
 	struct regulator_enable_gpio *ena_pin;
-	int ena_gpio;
-	unsigned int ena_gpio_invert:1;
 	unsigned int ena_gpio_state:1;
 };
 
-- 
1.7.9.5


Best Regards,
Milo


