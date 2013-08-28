Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3H1Mrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:47:36 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65429 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3H1Mre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:47:34 -0400
MIME-Version: 1.0
In-Reply-To: <1377595171-31116-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377595171-31116-1-git-send-email-m.krawczuk@partner.samsung.com>
Date: Wed, 28 Aug 2013 14:47:33 +0200
Message-ID: <CACRpkdbeHte_GNYh_5uMzM64yqhm2qmm1=N=3sv69Lo+_Z_QvA@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: Add s5pv210 support to pinctrl-exynos
From: Linus Walleij <linus.walleij@linaro.org>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:19 AM, Mateusz Krawczuk
<m.krawczuk@partner.samsung.com> wrote:

> This patch implements pinctrl for s5pv210 and adds required device tree bindings.
>
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>

Bindings is something you add in Documentation/devicetree/bindings,
so atleast alter the commit message. This merely *uses* some
device tree bindings.

Yours,
Linus Walleij

> ---
>  drivers/pinctrl/Kconfig           |  2 +-
>  drivers/pinctrl/pinctrl-exynos.c  | 58 +++++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/pinctrl-samsung.c |  3 +-
>  drivers/pinctrl/pinctrl-samsung.h |  1 +
>  4 files changed, 62 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index bdb1a87..ffe4b49 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -252,7 +252,7 @@ config PINCTRL_SAMSUNG
>
>  config PINCTRL_EXYNOS
>         bool "Pinctrl driver data for Samsung EXYNOS SoCs other than 5440"
> -       depends on OF && GPIOLIB && ARCH_EXYNOS
> +       depends on OF && GPIOLIB && (ARCH_EXYNOS || ARCH_S5PV210)
>         select PINCTRL_SAMSUNG
>
>  config PINCTRL_EXYNOS5440
> diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
> index a74b3cb..fc3e1d7 100644
> --- a/drivers/pinctrl/pinctrl-exynos.c
> +++ b/drivers/pinctrl/pinctrl-exynos.c
> @@ -660,6 +660,64 @@ static void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)
>                         exynos_pinctrl_resume_bank(drvdata, bank);
>  }
>
> +/* pin banks of s5pv210 pin-controller */
> +static struct samsung_pin_bank s5pv210_pin_banks0[] = {
> +       EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
> +       EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
> +       EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
> +       EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
> +       EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
> +       EXYNOS_PIN_BANK_EINTG(4, 0x0A0, "gpd0", 0x14),
> +       EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpd1", 0x18),
> +       EXYNOS_PIN_BANK_EINTG(5, 0x0E0, "gpe0", 0x1c),
> +       EXYNOS_PIN_BANK_EINTG(8, 0x100, "gpe1", 0x20),
> +       EXYNOS_PIN_BANK_EINTG(6, 0x120, "gpf0", 0x24),
> +       EXYNOS_PIN_BANK_EINTG(8, 0x140, "gpf1", 0x28),
> +       EXYNOS_PIN_BANK_EINTG(8, 0x160, "gpf2", 0x2c),
> +       EXYNOS_PIN_BANK_EINTG(8, 0x180, "gpf3", 0x30),
> +       EXYNOS_PIN_BANK_EINTG(7, 0x1A0, "gpg0", 0x34),
> +       EXYNOS_PIN_BANK_EINTG(7, 0x1C0, "gpg1", 0x38),
> +       EXYNOS_PIN_BANK_EINTG(7, 0x1E0, "gpg2", 0x3c),
> +       EXYNOS_PIN_BANK_EINTG(7, 0x200, "gpg3", 0x40),
> +       EXYNOS_PIN_BANK_EINTN(7, 0x220, "gpgi"),
> +       EXYNOS_PIN_BANK_EINTG(8, 0x240, "gpj0", 0x44),
> +       EXYNOS_PIN_BANK_EINTG(6, 0x260, "gpj1", 0x48),
> +       EXYNOS_PIN_BANK_EINTG(8, 0x280, "gpj2", 0x4c),
> +       EXYNOS_PIN_BANK_EINTG(8, 0x2A0, "gpj3", 0x50),
> +       EXYNOS_PIN_BANK_EINTG(5, 0x2C0, "gpj4", 0x54),
> +       EXYNOS_PIN_BANK_EINTN(8, 0x2E0, "mp01"),
> +       EXYNOS_PIN_BANK_EINTN(4, 0x300, "mp02"),
> +       EXYNOS_PIN_BANK_EINTN(8, 0x320, "mp03"),
> +       EXYNOS_PIN_BANK_EINTN(8, 0x340, "mp04"),
> +       EXYNOS_PIN_BANK_EINTN(8, 0x360, "mp05"),
> +       EXYNOS_PIN_BANK_EINTN(8, 0x300, "mp06"),
> +       EXYNOS_PIN_BANK_EINTN(8, 0x320, "mp07"),
> +       EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gph0", 0x00),
> +       EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gph1", 0x04),
> +       EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gph2", 0x08),
> +       EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gph3", 0x0c),
> +};
> +
> +struct samsung_pin_ctrl s5pv210_pin_ctrl[] = {
> +       {
> +               /* pin-controller instance 0 data */
> +               .pin_banks      = s5pv210_pin_banks0,
> +               .nr_banks       = ARRAY_SIZE(s5pv210_pin_banks0),
> +               .geint_con      = EXYNOS_GPIO_ECON_OFFSET,
> +               .geint_mask     = EXYNOS_GPIO_EMASK_OFFSET,
> +               .geint_pend     = EXYNOS_GPIO_EPEND_OFFSET,
> +               .weint_con      = EXYNOS_WKUP_ECON_OFFSET,
> +               .weint_mask     = EXYNOS_WKUP_EMASK_OFFSET,
> +               .weint_pend     = EXYNOS_WKUP_EPEND_OFFSET,
> +               .svc            = EXYNOS_SVC_OFFSET,
> +               .eint_gpio_init = exynos_eint_gpio_init,
> +               .eint_wkup_init = exynos_eint_wkup_init,
> +               .suspend        = exynos_pinctrl_suspend,
> +               .resume         = exynos_pinctrl_resume,
> +               .label          = "s5pv210-gpio-ctrl0",
> +       },
> +};
> +
>  /* pin banks of exynos4210 pin-controller 0 */
>  static struct samsung_pin_bank exynos4210_pin_banks0[] = {
>         EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
> index 439f2ef..f14b379 100644
> --- a/drivers/pinctrl/pinctrl-samsung.c
> +++ b/drivers/pinctrl/pinctrl-samsung.c
> @@ -878,7 +878,6 @@ static struct samsung_pin_ctrl *samsung_pinctrl_get_soc_data(
>         }
>         match = of_match_node(samsung_pinctrl_dt_match, node);
>         ctrl = (struct samsung_pin_ctrl *)match->data + id;
> -
>         bank = ctrl->pin_banks;
>         for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
>                 spin_lock_init(&bank->slock);
> @@ -1113,6 +1112,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
>                 .data = (void *)exynos5250_pin_ctrl },
>         { .compatible = "samsung,exynos5420-pinctrl",
>                 .data = (void *)exynos5420_pin_ctrl },
> +       { .compatible = "samsung,s5pv210-pinctrl",
> +               .data = (void *)s5pv210_pin_ctrl },
>  #endif
>  #ifdef CONFIG_PINCTRL_S3C64XX
>         { .compatible = "samsung,s3c64xx-pinctrl",
> diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
> index 11bb75b..30622d9 100644
> --- a/drivers/pinctrl/pinctrl-samsung.h
> +++ b/drivers/pinctrl/pinctrl-samsung.h
> @@ -260,5 +260,6 @@ extern struct samsung_pin_ctrl s3c2412_pin_ctrl[];
>  extern struct samsung_pin_ctrl s3c2416_pin_ctrl[];
>  extern struct samsung_pin_ctrl s3c2440_pin_ctrl[];
>  extern struct samsung_pin_ctrl s3c2450_pin_ctrl[];
> +extern struct samsung_pin_ctrl s5pv210_pin_ctrl[];
>
>  #endif /* __PINCTRL_SAMSUNG_H */
> --
> 1.8.1.2
>
