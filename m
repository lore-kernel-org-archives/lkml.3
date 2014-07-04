Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbaGDRth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:49:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48632 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759771AbaGDRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:15 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-34-53b6e90d48bc
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 17/19] gpio: samsung: Remove legacy support of S5PV210
Date: Fri, 04 Jul 2014 19:48:17 +0200
Message-id: <1404496099-26708-18-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4ZV3el9uCDZ7PsbL4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i1a4/jA5cHr9/TWL02Dnr
	LrvHplWdbB6bl9R7XDnRxOrRt2UVo8f2a/OYPT5vkgvgiOKySUnNySxLLdK3S+DKuPt1FUtB
	u3HFnCXb2RoY56l1MXJwSAiYSBz/ldTFyAlkiklcuLeeDcQWEljKKPG3XR3C7mOSuL6PG8Rm
	E1CT+NzwCKxGREBV4nPbAnaQMcwCt5kkWoVBwsICbhL3D7xhBLFZgEpeTO9gAbF5BZwlnvx/
	xAqxSk6id9sbZhCbEyg+cd0FJohVThJ//s9nmcDIu4CRYRWjaGppckFxUnquoV5xYm5xaV66
	XnJ+7iZGSCB+2cG4+JjVIUYBDkYlHt7GFRuChVgTy4orcw8xSnAwK4nw/lm1LViINyWxsiq1
	KD++qDQntfgQIxMHp1QDo9Jk5pQw3QbhDz+naBRIVk2ZktURJ3r3nPM3+fh+O0bfmH/Zr+at
	3L6xeC933bS75r9OtC9746+07rbarY+7ttxkVvza7N6kWqy2sVHB+bxvkepD+ZdyubZnf+Uf
	32Z2ZEHxj9N2LsHTu8J3bMywCRELXyfHJ7dEXGqx8Xl10U+5Pq7zWheeU2Ipzkg01GIuKk4E
	AK0ibPoiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO support of S5PV210 SoC is now fully handled by pinctrl-samsung
driver making the old code in gpio-samsung driver unused. This patch
removes it which will also let us remove more code from arch subtree.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org
---
 drivers/gpio/gpio-samsung.c | 240 --------------------------------------------
 1 file changed, 240 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 7d4281e..27298fd 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -1169,234 +1169,9 @@ static struct samsung_gpio_chip s3c64xx_gpios_2bit[] = {
 #endif
 };
 
-/*
- * Followings are the gpio banks in S5PV210/S5PC110
- *
- * The 'config' member when left to NULL, is initialized to the default
- * structure samsung_gpio_cfgs[3] in the init function below.
- *
- * The 'base' member is also initialized in the init function below.
- * Note: The initialization of 'base' member of samsung_gpio_chip structure
- * uses the above macro and depends on the banks being listed in order here.
- */
-
-static struct samsung_gpio_chip s5pv210_gpios_4bit[] = {
-#ifdef CONFIG_CPU_S5PV210
-	{
-		.chip	= {
-			.base	= S5PV210_GPA0(0),
-			.ngpio	= S5PV210_GPIO_A0_NR,
-			.label	= "GPA0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPA1(0),
-			.ngpio	= S5PV210_GPIO_A1_NR,
-			.label	= "GPA1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPB(0),
-			.ngpio	= S5PV210_GPIO_B_NR,
-			.label	= "GPB",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPC0(0),
-			.ngpio	= S5PV210_GPIO_C0_NR,
-			.label	= "GPC0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPC1(0),
-			.ngpio	= S5PV210_GPIO_C1_NR,
-			.label	= "GPC1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPD0(0),
-			.ngpio	= S5PV210_GPIO_D0_NR,
-			.label	= "GPD0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPD1(0),
-			.ngpio	= S5PV210_GPIO_D1_NR,
-			.label	= "GPD1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPE0(0),
-			.ngpio	= S5PV210_GPIO_E0_NR,
-			.label	= "GPE0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPE1(0),
-			.ngpio	= S5PV210_GPIO_E1_NR,
-			.label	= "GPE1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPF0(0),
-			.ngpio	= S5PV210_GPIO_F0_NR,
-			.label	= "GPF0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPF1(0),
-			.ngpio	= S5PV210_GPIO_F1_NR,
-			.label	= "GPF1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPF2(0),
-			.ngpio	= S5PV210_GPIO_F2_NR,
-			.label	= "GPF2",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPF3(0),
-			.ngpio	= S5PV210_GPIO_F3_NR,
-			.label	= "GPF3",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPG0(0),
-			.ngpio	= S5PV210_GPIO_G0_NR,
-			.label	= "GPG0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPG1(0),
-			.ngpio	= S5PV210_GPIO_G1_NR,
-			.label	= "GPG1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPG2(0),
-			.ngpio	= S5PV210_GPIO_G2_NR,
-			.label	= "GPG2",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPG3(0),
-			.ngpio	= S5PV210_GPIO_G3_NR,
-			.label	= "GPG3",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPI(0),
-			.ngpio	= S5PV210_GPIO_I_NR,
-			.label	= "GPI",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ0(0),
-			.ngpio	= S5PV210_GPIO_J0_NR,
-			.label	= "GPJ0",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ1(0),
-			.ngpio	= S5PV210_GPIO_J1_NR,
-			.label	= "GPJ1",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ2(0),
-			.ngpio	= S5PV210_GPIO_J2_NR,
-			.label	= "GPJ2",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ3(0),
-			.ngpio	= S5PV210_GPIO_J3_NR,
-			.label	= "GPJ3",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_GPJ4(0),
-			.ngpio	= S5PV210_GPIO_J4_NR,
-			.label	= "GPJ4",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_MP01(0),
-			.ngpio	= S5PV210_GPIO_MP01_NR,
-			.label	= "MP01",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_MP02(0),
-			.ngpio	= S5PV210_GPIO_MP02_NR,
-			.label	= "MP02",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_MP03(0),
-			.ngpio	= S5PV210_GPIO_MP03_NR,
-			.label	= "MP03",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_MP04(0),
-			.ngpio	= S5PV210_GPIO_MP04_NR,
-			.label	= "MP04",
-		},
-	}, {
-		.chip	= {
-			.base	= S5PV210_MP05(0),
-			.ngpio	= S5PV210_GPIO_MP05_NR,
-			.label	= "MP05",
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC00),
-		.irq_base = IRQ_EINT(0),
-		.chip	= {
-			.base	= S5PV210_GPH0(0),
-			.ngpio	= S5PV210_GPIO_H0_NR,
-			.label	= "GPH0",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC20),
-		.irq_base = IRQ_EINT(8),
-		.chip	= {
-			.base	= S5PV210_GPH1(0),
-			.ngpio	= S5PV210_GPIO_H1_NR,
-			.label	= "GPH1",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC40),
-		.irq_base = IRQ_EINT(16),
-		.chip	= {
-			.base	= S5PV210_GPH2(0),
-			.ngpio	= S5PV210_GPIO_H2_NR,
-			.label	= "GPH2",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	}, {
-		.base	= (S5P_VA_GPIO + 0xC60),
-		.irq_base = IRQ_EINT(24),
-		.chip	= {
-			.base	= S5PV210_GPH3(0),
-			.ngpio	= S5PV210_GPIO_H3_NR,
-			.label	= "GPH3",
-			.to_irq = samsung_gpiolib_to_irq,
-		},
-	},
-#endif
-};
-
 /* TODO: cleanup soc_is_* */
 static __init int samsung_gpiolib_init(void)
 {
-	struct samsung_gpio_chip *chip;
-	int i, nr_chips;
-	int group = 0;
-
 	/*
 	 * Currently there are two drivers that can provide GPIO support for
 	 * Samsung SoCs. For device tree enabled platforms, the new
@@ -1420,21 +1195,6 @@ static __init int samsung_gpiolib_init(void)
 				S3C64XX_VA_GPIO);
 		samsung_gpiolib_add_4bit2_chips(s3c64xx_gpios_4bit2,
 				ARRAY_SIZE(s3c64xx_gpios_4bit2));
-	} else if (soc_is_s5pv210()) {
-		group = 0;
-		chip = s5pv210_gpios_4bit;
-		nr_chips = ARRAY_SIZE(s5pv210_gpios_4bit);
-
-		for (i = 0; i < nr_chips; i++, chip++) {
-			if (!chip->config) {
-				chip->config = &samsung_gpio_cfgs[3];
-				chip->group = group++;
-			}
-		}
-		samsung_gpiolib_add_4bit_chips(s5pv210_gpios_4bit, nr_chips, S5P_VA_GPIO);
-#if defined(CONFIG_CPU_S5PV210) && defined(CONFIG_S5P_GPIO_INT)
-		s5p_register_gpioint_bank(IRQ_GPIOINT, 0, S5P_GPIOINT_GROUP_MAXNR);
-#endif
 	} else {
 		WARN(1, "Unknown SoC in gpio-samsung, no GPIOs added\n");
 		return -ENODEV;
-- 
1.9.3

