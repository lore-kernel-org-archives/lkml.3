Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbaIWTFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:05:54 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:42737 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbaIWTFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:05:51 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 2/5] pinctrl: samsung: Drop unused label field in samsung_pin_ctrl struct
Date: Tue, 23 Sep 2014 21:05:38 +0200
Message-Id: <1411499141-26551-3-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
References: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no code using it and in fact there are pin controller variants
that do not even have this field initialized in their init data. This
patch removes it completely.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c  | 22 ----------------------
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c |  4 ----
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c |  1 -
 drivers/pinctrl/samsung/pinctrl-samsung.h |  3 ---
 4 files changed, 30 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index d7154ed0b0eb..7e6463f970ff 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -682,7 +682,6 @@ struct samsung_pin_ctrl s5pv210_pin_ctrl[] = {
 		.eint_wkup_init = exynos_eint_wkup_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "s5pv210-gpio-ctrl0",
 	},
 };
 
@@ -729,7 +728,6 @@ struct samsung_pin_ctrl exynos3250_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos3250-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos3250_pin_banks1,
@@ -738,7 +736,6 @@ struct samsung_pin_ctrl exynos3250_pin_ctrl[] = {
 		.eint_wkup_init = exynos_eint_wkup_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos3250-gpio-ctrl1",
 	},
 };
 
@@ -803,7 +800,6 @@ struct samsung_pin_ctrl exynos4210_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4210-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos4210_pin_banks1,
@@ -812,12 +808,10 @@ struct samsung_pin_ctrl exynos4210_pin_ctrl[] = {
 		.eint_wkup_init = exynos_eint_wkup_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4210-gpio-ctrl1",
 	}, {
 		/* pin-controller instance 2 data */
 		.pin_banks	= exynos4210_pin_banks2,
 		.nr_banks	= ARRAY_SIZE(exynos4210_pin_banks2),
-		.label		= "exynos4210-gpio-ctrl2",
 	},
 };
 
@@ -891,7 +885,6 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4x12-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos4x12_pin_banks1,
@@ -900,7 +893,6 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 		.eint_wkup_init = exynos_eint_wkup_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4x12-gpio-ctrl1",
 	}, {
 		/* pin-controller instance 2 data */
 		.pin_banks	= exynos4x12_pin_banks2,
@@ -908,7 +900,6 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4x12-gpio-ctrl2",
 	}, {
 		/* pin-controller instance 3 data */
 		.pin_banks	= exynos4x12_pin_banks3,
@@ -916,7 +907,6 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4x12-gpio-ctrl3",
 	},
 };
 
@@ -989,7 +979,6 @@ struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
 		.eint_wkup_init = exynos_eint_wkup_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos5250-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos5250_pin_banks1,
@@ -997,7 +986,6 @@ struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos5250-gpio-ctrl1",
 	}, {
 		/* pin-controller instance 2 data */
 		.pin_banks	= exynos5250_pin_banks2,
@@ -1005,7 +993,6 @@ struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos5250-gpio-ctrl2",
 	}, {
 		/* pin-controller instance 3 data */
 		.pin_banks	= exynos5250_pin_banks3,
@@ -1013,7 +1000,6 @@ struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos5250-gpio-ctrl3",
 	},
 };
 
@@ -1068,19 +1054,16 @@ struct samsung_pin_ctrl exynos5260_pin_ctrl[] = {
 		.nr_banks	= ARRAY_SIZE(exynos5260_pin_banks0),
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.eint_wkup_init = exynos_eint_wkup_init,
-		.label		= "exynos5260-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos5260_pin_banks1,
 		.nr_banks	= ARRAY_SIZE(exynos5260_pin_banks1),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.label		= "exynos5260-gpio-ctrl1",
 	}, {
 		/* pin-controller instance 2 data */
 		.pin_banks	= exynos5260_pin_banks2,
 		.nr_banks	= ARRAY_SIZE(exynos5260_pin_banks2),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.label		= "exynos5260-gpio-ctrl2",
 	},
 };
 
@@ -1151,30 +1134,25 @@ struct samsung_pin_ctrl exynos5420_pin_ctrl[] = {
 		.nr_banks	= ARRAY_SIZE(exynos5420_pin_banks0),
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.eint_wkup_init = exynos_eint_wkup_init,
-		.label		= "exynos5420-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos5420_pin_banks1,
 		.nr_banks	= ARRAY_SIZE(exynos5420_pin_banks1),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.label		= "exynos5420-gpio-ctrl1",
 	}, {
 		/* pin-controller instance 2 data */
 		.pin_banks	= exynos5420_pin_banks2,
 		.nr_banks	= ARRAY_SIZE(exynos5420_pin_banks2),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.label		= "exynos5420-gpio-ctrl2",
 	}, {
 		/* pin-controller instance 3 data */
 		.pin_banks	= exynos5420_pin_banks3,
 		.nr_banks	= ARRAY_SIZE(exynos5420_pin_banks3),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.label		= "exynos5420-gpio-ctrl3",
 	}, {
 		/* pin-controller instance 4 data */
 		.pin_banks	= exynos5420_pin_banks4,
 		.nr_banks	= ARRAY_SIZE(exynos5420_pin_banks4),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.label		= "exynos5420-gpio-ctrl4",
 	},
 };
diff --git a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
index ad3eaad17001..e38925906bd3 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
@@ -578,7 +578,6 @@ struct samsung_pin_ctrl s3c2412_pin_ctrl[] = {
 		.pin_banks	= s3c2412_pin_banks,
 		.nr_banks	= ARRAY_SIZE(s3c2412_pin_banks),
 		.eint_wkup_init = s3c24xx_eint_init,
-		.label		= "S3C2412-GPIO",
 	},
 };
 
@@ -601,7 +600,6 @@ struct samsung_pin_ctrl s3c2416_pin_ctrl[] = {
 		.pin_banks	= s3c2416_pin_banks,
 		.nr_banks	= ARRAY_SIZE(s3c2416_pin_banks),
 		.eint_wkup_init = s3c24xx_eint_init,
-		.label		= "S3C2416-GPIO",
 	},
 };
 
@@ -622,7 +620,6 @@ struct samsung_pin_ctrl s3c2440_pin_ctrl[] = {
 		.pin_banks	= s3c2440_pin_banks,
 		.nr_banks	= ARRAY_SIZE(s3c2440_pin_banks),
 		.eint_wkup_init = s3c24xx_eint_init,
-		.label		= "S3C2440-GPIO",
 	},
 };
 
@@ -646,6 +643,5 @@ struct samsung_pin_ctrl s3c2450_pin_ctrl[] = {
 		.pin_banks	= s3c2450_pin_banks,
 		.nr_banks	= ARRAY_SIZE(s3c2450_pin_banks),
 		.eint_wkup_init = s3c24xx_eint_init,
-		.label		= "S3C2450-GPIO",
 	},
 };
diff --git a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
index 89143c903000..fcf8c36e727e 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
@@ -811,6 +811,5 @@ struct samsung_pin_ctrl s3c64xx_pin_ctrl[] = {
 		.nr_banks	= ARRAY_SIZE(s3c64xx_pin_banks0),
 		.eint_gpio_init = s3c64xx_eint_gpio_init,
 		.eint_wkup_init = s3c64xx_eint_eint0_init,
-		.label		= "S3C64xx-GPIO",
 	},
 };
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index 5cedc9d26390..da527b390513 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -161,7 +161,6 @@ struct samsung_pin_bank {
  *	interrupts for the controller.
  * @eint_wkup_init: platform specific callback to setup the external wakeup
  *	interrupts for the controller.
- * @label: for debug information.
  */
 struct samsung_pin_ctrl {
 	struct samsung_pin_bank	*pin_banks;
@@ -174,8 +173,6 @@ struct samsung_pin_ctrl {
 	int		(*eint_wkup_init)(struct samsung_pinctrl_drv_data *);
 	void		(*suspend)(struct samsung_pinctrl_drv_data *);
 	void		(*resume)(struct samsung_pinctrl_drv_data *);
-
-	char		*label;
 };
 
 /**
-- 
2.1.0

