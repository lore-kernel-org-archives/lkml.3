Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaJBSwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:52:25 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60728 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaJBSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:52:21 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 2/5] pinctrl: samsung: Drop unused label field in samsung_pin_ctrl struct
Date: Thu,  2 Oct 2014 20:52:08 +0200
Message-Id: <1412275931-10807-3-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412275931-10807-1-git-send-email-tomasz.figa@gmail.com>
References: <1412275931-10807-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no code using it and in fact there are pin controller variants
that do not even have this field initialized in their init data. This
patch removes it completely.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c  | 22 ----------------------
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c |  4 ----
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c |  1 -
 drivers/pinctrl/samsung/pinctrl-samsung.h |  3 ---
 4 files changed, 30 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index 003bfd874a61..67658d6d4b4e 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -625,7 +625,6 @@ struct samsung_pin_ctrl s5pv210_pin_ctrl[] = {
 		.eint_wkup_init = exynos_eint_wkup_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "s5pv210-gpio-ctrl0",
 	},
 };
 
@@ -672,7 +671,6 @@ struct samsung_pin_ctrl exynos3250_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos3250-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos3250_pin_banks1,
@@ -681,7 +679,6 @@ struct samsung_pin_ctrl exynos3250_pin_ctrl[] = {
 		.eint_wkup_init = exynos_eint_wkup_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos3250-gpio-ctrl1",
 	},
 };
 
@@ -746,7 +743,6 @@ struct samsung_pin_ctrl exynos4210_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4210-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos4210_pin_banks1,
@@ -755,12 +751,10 @@ struct samsung_pin_ctrl exynos4210_pin_ctrl[] = {
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
 
@@ -834,7 +828,6 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4x12-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos4x12_pin_banks1,
@@ -843,7 +836,6 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 		.eint_wkup_init = exynos_eint_wkup_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4x12-gpio-ctrl1",
 	}, {
 		/* pin-controller instance 2 data */
 		.pin_banks	= exynos4x12_pin_banks2,
@@ -851,7 +843,6 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4x12-gpio-ctrl2",
 	}, {
 		/* pin-controller instance 3 data */
 		.pin_banks	= exynos4x12_pin_banks3,
@@ -859,7 +850,6 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos4x12-gpio-ctrl3",
 	},
 };
 
@@ -932,7 +922,6 @@ struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
 		.eint_wkup_init = exynos_eint_wkup_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos5250-gpio-ctrl0",
 	}, {
 		/* pin-controller instance 1 data */
 		.pin_banks	= exynos5250_pin_banks1,
@@ -940,7 +929,6 @@ struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos5250-gpio-ctrl1",
 	}, {
 		/* pin-controller instance 2 data */
 		.pin_banks	= exynos5250_pin_banks2,
@@ -948,7 +936,6 @@ struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos5250-gpio-ctrl2",
 	}, {
 		/* pin-controller instance 3 data */
 		.pin_banks	= exynos5250_pin_banks3,
@@ -956,7 +943,6 @@ struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
 		.eint_gpio_init = exynos_eint_gpio_init,
 		.suspend	= exynos_pinctrl_suspend,
 		.resume		= exynos_pinctrl_resume,
-		.label		= "exynos5250-gpio-ctrl3",
 	},
 };
 
@@ -1011,19 +997,16 @@ struct samsung_pin_ctrl exynos5260_pin_ctrl[] = {
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
 
@@ -1094,30 +1077,25 @@ struct samsung_pin_ctrl exynos5420_pin_ctrl[] = {
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
index 2b882320e8e9..f26595ee52d3 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -160,7 +160,6 @@ struct samsung_pin_bank {
  *	interrupts for the controller.
  * @eint_wkup_init: platform specific callback to setup the external wakeup
  *	interrupts for the controller.
- * @label: for debug information.
  */
 struct samsung_pin_ctrl {
 	struct samsung_pin_bank	*pin_banks;
@@ -173,8 +172,6 @@ struct samsung_pin_ctrl {
 	int		(*eint_wkup_init)(struct samsung_pinctrl_drv_data *);
 	void		(*suspend)(struct samsung_pinctrl_drv_data *);
 	void		(*resume)(struct samsung_pinctrl_drv_data *);
-
-	char		*label;
 };
 
 /**
-- 
2.1.1

