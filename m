Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936104Ab3DPRlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:41:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16723 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935536Ab3DPRlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:41:50 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fa86d0000045ae-5f-516d8d5c313c
Content-transfer-encoding: 8BIT
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linus.walleij@linaro.org, grant.likely@secretlab.ca
Cc: kyungmin.park@samsung.com, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>
Subject: [PATCH 1/2] gpio: samsung: Remove OF support for s3c24xx
Date: Tue, 16 Apr 2013 19:41:34 +0200
Message-id: <1366134094-23140-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jAd2Y3txAg6ebNSwOzH7IavHqzEY2
	i/+PXrNa9C64ymZxtukNu8WUP8uZLC7vmsNmcfhNO6sDh8eda3vYPM7PWMjo0bdlFaPHz5c6
	HtuvzWP2+LxJLoAtissmJTUnsyy1SN8ugSujZ/cFtoIdGhUnJq1ibmCcpdDFyMEhIWAi0Xc9
	qouRE8gUk7hwbz1bFyMXh5DAIkaJ6ZNeMIIkeAUEJX5MvscCUs8sIC9x5FI2SJhZQF1i0rxF
	zBD1HUwSra9nsYMk2AQMJXqP9oH1igiYS/RcW8QIUsQscI9R4u3+NWBFwgKOEje+LAErYhFQ
	lbjyDWQByDI3iUX3/7BDHKcgMWeSzQRGvllIzpiFcMYsJGcsYGRexSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iREcws+kdjCubLA4xCjAwajEw3uhIDdQiDWxrLgy9xCjBAezkgjvWUegEG9K
	YmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsbqM/tn7Uy85a/T
	q5V7vFttecDjORO1yllNIgJOCBmflSt/seaoqZ6i08JHLLuPHVlete6RcMr8tIjUKUd116as
	9mpSkfq9cp9KdkriKyUWzWsPerqCbXYqVbz1eau2+PLmd5t23+ZRdblZOC9zWZY543KpLcmr
	p36Zm5Cnlh+o+vvW/wXbLI8osRRnJBpqMRcVJwIAhepEhF0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no users of this code and there is already a pinctrl
driver written for s3c24xx which is going to be used on any
s3c24xx DT platforms. Hence this has been effectively a dead
code in mainline.

This reverts commit 172c6a13653ac8cd6a231293b87c93821e90c1d6
gpio: samsung: add devicetree init for s3c24xx arches

Cc: Heiko Stübner <heiko@sntech.de>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

The pinctrl driver patch can be found at:
http://www.spinics.net/lists/linux-samsung-soc/msg17624.html
---
 .../devicetree/bindings/gpio/gpio-samsung.txt      |   43 -------------
 drivers/gpio/gpio-samsung.c                        |   63 --------------------
 2 files changed, 106 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-samsung.txt b/Documentation/devicetree/bindings/gpio/gpio-samsung.txt
index f1e5dfe..5375625 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-samsung.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-samsung.txt
@@ -39,46 +39,3 @@ Example:
 		#gpio-cells = <4>;
 		gpio-controller;
 	};
-
-
-Samsung S3C24XX GPIO Controller
-
-Required properties:
-- compatible: Compatible property value should be "samsung,s3c24xx-gpio".
-
-- reg: Physical base address of the controller and length of memory mapped
-  region.
-
-- #gpio-cells: Should be 3. The syntax of the gpio specifier used by client nodes
-  should be the following with values derived from the SoC user manual.
-     <[phandle of the gpio controller node]
-      [pin number within the gpio controller]
-      [mux function]
-      [flags and pull up/down]
-
-  Values for gpio specifier:
-  - Pin number: depending on the controller a number from 0 up to 15.
-  - Mux function: Depending on the SoC and the gpio bank the gpio can be set
-                  as input, output or a special function
-  - Flags and Pull Up/Down: the values to use differ for the individual SoCs
-                    example S3C2416/S3C2450:
-                            0 - Pull Up/Down Disabled.
-                            1 - Pull Down Enabled.
-                            2 - Pull Up Enabled.
-          Bit 16 (0x00010000) - Input is active low.
-  Consult the user manual for the correct values of Mux and Pull Up/Down.
-
-- gpio-controller: Specifies that the node is a gpio controller.
-- #address-cells: should be 1.
-- #size-cells: should be 1.
-
-Example:
-
-	gpa: gpio-controller@56000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "samsung,s3c24xx-gpio";
-		reg = <0x56000000 0x10>;
-		#gpio-cells = <3>;
-		gpio-controller;
-	};
diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index c4b51d8..4fecfb8 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -933,67 +933,6 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
 		s3c_gpiolib_track(chip);
 }
 
-#if defined(CONFIG_PLAT_S3C24XX) && defined(CONFIG_OF)
-static int s3c24xx_gpio_xlate(struct gpio_chip *gc,
-			const struct of_phandle_args *gpiospec, u32 *flags)
-{
-	unsigned int pin;
-
-	if (WARN_ON(gc->of_gpio_n_cells < 3))
-		return -EINVAL;
-
-	if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
-		return -EINVAL;
-
-	if (gpiospec->args[0] > gc->ngpio)
-		return -EINVAL;
-
-	pin = gc->base + gpiospec->args[0];
-
-	if (s3c_gpio_cfgpin(pin, S3C_GPIO_SFN(gpiospec->args[1])))
-		pr_warn("gpio_xlate: failed to set pin function\n");
-	if (s3c_gpio_setpull(pin, gpiospec->args[2] & 0xffff))
-		pr_warn("gpio_xlate: failed to set pin pull up/down\n");
-
-	if (flags)
-		*flags = gpiospec->args[2] >> 16;
-
-	return gpiospec->args[0];
-}
-
-static const struct of_device_id s3c24xx_gpio_dt_match[] __initdata = {
-	{ .compatible = "samsung,s3c24xx-gpio", },
-	{}
-};
-
-static __init void s3c24xx_gpiolib_attach_ofnode(struct samsung_gpio_chip *chip,
-						 u64 base, u64 offset)
-{
-	struct gpio_chip *gc =  &chip->chip;
-	u64 address;
-
-	if (!of_have_populated_dt())
-		return;
-
-	address = chip->base ? base + ((u32)chip->base & 0xfff) : base + offset;
-	gc->of_node = of_find_matching_node_by_address(NULL,
-			s3c24xx_gpio_dt_match, address);
-	if (!gc->of_node) {
-		pr_info("gpio: device tree node not found for gpio controller"
-			" with base address %08llx\n", address);
-		return;
-	}
-	gc->of_gpio_n_cells = 3;
-	gc->of_xlate = s3c24xx_gpio_xlate;
-}
-#else
-static __init void s3c24xx_gpiolib_attach_ofnode(struct samsung_gpio_chip *chip,
-						 u64 base, u64 offset)
-{
-	return;
-}
-#endif /* defined(CONFIG_PLAT_S3C24XX) && defined(CONFIG_OF) */
-
 static void __init s3c24xx_gpiolib_add_chips(struct samsung_gpio_chip *chip,
 					     int nr_chips, void __iomem *base)
 {
@@ -1018,8 +957,6 @@ static void __init s3c24xx_gpiolib_add_chips(struct samsung_gpio_chip *chip,
 			gc->direction_output = samsung_gpiolib_2bit_output;
 
 		samsung_gpiolib_add(chip);
-
-		s3c24xx_gpiolib_attach_ofnode(chip, S3C24XX_PA_GPIO, i * 0x10);
 	}
 }
 
-- 
1.7.9.5

