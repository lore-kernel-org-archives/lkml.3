Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbaGOXwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:52:24 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64733 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760654AbaGOXwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:52:21 -0400
Message-ID: <53C5BEAD.7080605@samsung.com>
Date: Wed, 16 Jul 2014 08:52:13 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 17/19] gpio: samsung: Remove legacy support of S5PV210
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com> <1404496099-26708-18-git-send-email-t.figa@samsung.com>
In-Reply-To: <1404496099-26708-18-git-send-email-t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/14 02:48, Tomasz Figa wrote:
> GPIO support of S5PV210 SoC is now fully handled by pinctrl-samsung
> driver making the old code in gpio-samsung driver unused. This patch
> removes it which will also let us remove more code from arch subtree.
>
> Signed-off-by: Tomasz Figa<t.figa@samsung.com>
> Cc: Linus Walleij<linus.walleij@linaro.org>

Hi Linus,

I've applied this in samsung tree for 3.17 if you have any comments, 
please kindly let me know.

Thanks,
Kukjin

> Cc: Alexandre Courbot<gnurou@gmail.com>
> Cc: linux-gpio@vger.kernel.org
> ---
>   drivers/gpio/gpio-samsung.c | 240 --------------------------------------------
>   1 file changed, 240 deletions(-)
>
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index 7d4281e..27298fd 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -1169,234 +1169,9 @@ static struct samsung_gpio_chip s3c64xx_gpios_2bit[] = {
>   #endif
>   };
>
> -/*
> - * Followings are the gpio banks in S5PV210/S5PC110
> - *
> - * The 'config' member when left to NULL, is initialized to the default
> - * structure samsung_gpio_cfgs[3] in the init function below.
> - *
> - * The 'base' member is also initialized in the init function below.
> - * Note: The initialization of 'base' member of samsung_gpio_chip structure
> - * uses the above macro and depends on the banks being listed in order here.
> - */
> -
> -static struct samsung_gpio_chip s5pv210_gpios_4bit[] = {
> -#ifdef CONFIG_CPU_S5PV210
> -	{
> -		.chip	= {
> -			.base	= S5PV210_GPA0(0),
> -			.ngpio	= S5PV210_GPIO_A0_NR,
> -			.label	= "GPA0",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPA1(0),
> -			.ngpio	= S5PV210_GPIO_A1_NR,
> -			.label	= "GPA1",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPB(0),
> -			.ngpio	= S5PV210_GPIO_B_NR,
> -			.label	= "GPB",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPC0(0),
> -			.ngpio	= S5PV210_GPIO_C0_NR,
> -			.label	= "GPC0",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPC1(0),
> -			.ngpio	= S5PV210_GPIO_C1_NR,
> -			.label	= "GPC1",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPD0(0),
> -			.ngpio	= S5PV210_GPIO_D0_NR,
> -			.label	= "GPD0",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPD1(0),
> -			.ngpio	= S5PV210_GPIO_D1_NR,
> -			.label	= "GPD1",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPE0(0),
> -			.ngpio	= S5PV210_GPIO_E0_NR,
> -			.label	= "GPE0",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPE1(0),
> -			.ngpio	= S5PV210_GPIO_E1_NR,
> -			.label	= "GPE1",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPF0(0),
> -			.ngpio	= S5PV210_GPIO_F0_NR,
> -			.label	= "GPF0",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPF1(0),
> -			.ngpio	= S5PV210_GPIO_F1_NR,
> -			.label	= "GPF1",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPF2(0),
> -			.ngpio	= S5PV210_GPIO_F2_NR,
> -			.label	= "GPF2",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPF3(0),
> -			.ngpio	= S5PV210_GPIO_F3_NR,
> -			.label	= "GPF3",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPG0(0),
> -			.ngpio	= S5PV210_GPIO_G0_NR,
> -			.label	= "GPG0",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPG1(0),
> -			.ngpio	= S5PV210_GPIO_G1_NR,
> -			.label	= "GPG1",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPG2(0),
> -			.ngpio	= S5PV210_GPIO_G2_NR,
> -			.label	= "GPG2",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPG3(0),
> -			.ngpio	= S5PV210_GPIO_G3_NR,
> -			.label	= "GPG3",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPI(0),
> -			.ngpio	= S5PV210_GPIO_I_NR,
> -			.label	= "GPI",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPJ0(0),
> -			.ngpio	= S5PV210_GPIO_J0_NR,
> -			.label	= "GPJ0",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPJ1(0),
> -			.ngpio	= S5PV210_GPIO_J1_NR,
> -			.label	= "GPJ1",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPJ2(0),
> -			.ngpio	= S5PV210_GPIO_J2_NR,
> -			.label	= "GPJ2",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPJ3(0),
> -			.ngpio	= S5PV210_GPIO_J3_NR,
> -			.label	= "GPJ3",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_GPJ4(0),
> -			.ngpio	= S5PV210_GPIO_J4_NR,
> -			.label	= "GPJ4",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_MP01(0),
> -			.ngpio	= S5PV210_GPIO_MP01_NR,
> -			.label	= "MP01",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_MP02(0),
> -			.ngpio	= S5PV210_GPIO_MP02_NR,
> -			.label	= "MP02",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_MP03(0),
> -			.ngpio	= S5PV210_GPIO_MP03_NR,
> -			.label	= "MP03",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_MP04(0),
> -			.ngpio	= S5PV210_GPIO_MP04_NR,
> -			.label	= "MP04",
> -		},
> -	}, {
> -		.chip	= {
> -			.base	= S5PV210_MP05(0),
> -			.ngpio	= S5PV210_GPIO_MP05_NR,
> -			.label	= "MP05",
> -		},
> -	}, {
> -		.base	= (S5P_VA_GPIO + 0xC00),
> -		.irq_base = IRQ_EINT(0),
> -		.chip	= {
> -			.base	= S5PV210_GPH0(0),
> -			.ngpio	= S5PV210_GPIO_H0_NR,
> -			.label	= "GPH0",
> -			.to_irq = samsung_gpiolib_to_irq,
> -		},
> -	}, {
> -		.base	= (S5P_VA_GPIO + 0xC20),
> -		.irq_base = IRQ_EINT(8),
> -		.chip	= {
> -			.base	= S5PV210_GPH1(0),
> -			.ngpio	= S5PV210_GPIO_H1_NR,
> -			.label	= "GPH1",
> -			.to_irq = samsung_gpiolib_to_irq,
> -		},
> -	}, {
> -		.base	= (S5P_VA_GPIO + 0xC40),
> -		.irq_base = IRQ_EINT(16),
> -		.chip	= {
> -			.base	= S5PV210_GPH2(0),
> -			.ngpio	= S5PV210_GPIO_H2_NR,
> -			.label	= "GPH2",
> -			.to_irq = samsung_gpiolib_to_irq,
> -		},
> -	}, {
> -		.base	= (S5P_VA_GPIO + 0xC60),
> -		.irq_base = IRQ_EINT(24),
> -		.chip	= {
> -			.base	= S5PV210_GPH3(0),
> -			.ngpio	= S5PV210_GPIO_H3_NR,
> -			.label	= "GPH3",
> -			.to_irq = samsung_gpiolib_to_irq,
> -		},
> -	},
> -#endif
> -};
> -
>   /* TODO: cleanup soc_is_* */
>   static __init int samsung_gpiolib_init(void)
>   {
> -	struct samsung_gpio_chip *chip;
> -	int i, nr_chips;
> -	int group = 0;
> -
>   	/*
>   	 * Currently there are two drivers that can provide GPIO support for
>   	 * Samsung SoCs. For device tree enabled platforms, the new
> @@ -1420,21 +1195,6 @@ static __init int samsung_gpiolib_init(void)
>   				S3C64XX_VA_GPIO);
>   		samsung_gpiolib_add_4bit2_chips(s3c64xx_gpios_4bit2,
>   				ARRAY_SIZE(s3c64xx_gpios_4bit2));
> -	} else if (soc_is_s5pv210()) {
> -		group = 0;
> -		chip = s5pv210_gpios_4bit;
> -		nr_chips = ARRAY_SIZE(s5pv210_gpios_4bit);
> -
> -		for (i = 0; i<  nr_chips; i++, chip++) {
> -			if (!chip->config) {
> -				chip->config =&samsung_gpio_cfgs[3];
> -				chip->group = group++;
> -			}
> -		}
> -		samsung_gpiolib_add_4bit_chips(s5pv210_gpios_4bit, nr_chips, S5P_VA_GPIO);
> -#if defined(CONFIG_CPU_S5PV210)&&  defined(CONFIG_S5P_GPIO_INT)
> -		s5p_register_gpioint_bank(IRQ_GPIOINT, 0, S5P_GPIOINT_GROUP_MAXNR);
> -#endif
>   	} else {
>   		WARN(1, "Unknown SoC in gpio-samsung, no GPIOs added\n");
>   		return -ENODEV;
