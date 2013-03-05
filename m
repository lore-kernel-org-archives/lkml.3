Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab3CESYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:24:33 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:43541 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3CESYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:24:31 -0500
MIME-Version: 1.0
In-Reply-To: <017801cde453$77b03eb0$6710bc10$@samsung.com>
References: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
	<1355399644-29417-2-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdaQ10CgoFXtk4EyqL4LWVpsdEAdrmy5R-_Rqm5fJdqS4A@mail.gmail.com>
	<CAJuYYwTZkzCXjowhKaJ253Oji07eDdEjMvNssyL1ThWtETswSQ@mail.gmail.com>
	<017801cde453$77b03eb0$6710bc10$@samsung.com>
Date: Tue, 5 Mar 2013 23:54:30 +0530
Message-ID: <CAJuYYwSXb2G=eO8H-cmBvrGFgKiL++ts_mWr+WdPgZypoy6nZg@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: exynos: add exynos5250 SoC specific data
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 December 2012 22:28, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Thomas Abraham wrote:
>>
>> Hi Linus,
>>
>> On 14 December 2012 21:21, Linus Walleij <linus.walleij@linaro.org> wrote:
>> > On Thu, Dec 13, 2012 at 12:54 PM, Thomas Abraham
>> > <thomas.abraham@linaro.org> wrote:
>> >
>> >> Add Samsung Exynos5250 SoC specific data to enable pinctrl support for
>> >> all platforms based on Exynos5250.
>> >>
>> >> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> >
>> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> >
>> > For this series, I guess you'll fix it through the Samsung tree?
>>
>> Thanks for your ack. Since there are patches to be prepared for
>> migrating the rest of Exynos5250 related code to the pinctrl
>> framework, it would be easier if this series goes through the Samsung
>> tree.
>>
> I applied this series, thanks.

This series has not made it into 3.9-rc1. So I will rebase this series
to 3.9-rc1 and post again.

Thanks,
Thomas.

>
> And I think, would be clear if the config could be changed like following.
>
> 8<----------------------------------------------------------------------
> From: Kukjin Kim <kgene.kim@samsung.com>
> Subject: [PATCH] pinctrl: exynos: change PINCTRL_EXYNOS option
>
> Since pinctrl-exynos can support exynos4 and exynos5 so changed
> the option name to PINCTRL_EXYNOS for more clarity.
>
> Cc: Thomas Abraham <Thomas.abraham@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 91d5b6f..e1f63e7 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -412,7 +412,7 @@ config MACH_EXYNOS4_DT
>         select CPU_EXYNOS4210
>         select HAVE_SAMSUNG_KEYPAD if INPUT_KEYBOARD
>         select PINCTRL
> -       select PINCTRL_EXYNOS4
> +       select PINCTRL_EXYNOS
>         select USE_OF
>         help
>           Machine support for Samsung Exynos4 machine with device tree
> enabled.
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index c31aeb0..f59feab 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -185,8 +185,8 @@ config PINCTRL_SAMSUNG
>         select PINMUX
>         select PINCONF
>
> -config PINCTRL_EXYNOS4
> -       bool "Pinctrl driver data for Exynos4 SoC"
> +config PINCTRL_EXYNOS
> +       bool "Pinctrl driver data for Samsung EXYNOS SoCs"
>         depends on OF && GPIOLIB
>         select PINCTRL_SAMSUNG
>
> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> index fc4606f..6e87e52 100644
> --- a/drivers/pinctrl/Makefile
> +++ b/drivers/pinctrl/Makefile
> @@ -36,7 +36,7 @@ obj-$(CONFIG_PINCTRL_TEGRA30) += pinctrl-tegra30.o
>  obj-$(CONFIG_PINCTRL_U300)     += pinctrl-u300.o
>  obj-$(CONFIG_PINCTRL_COH901)   += pinctrl-coh901.o
>  obj-$(CONFIG_PINCTRL_SAMSUNG)  += pinctrl-samsung.o
> -obj-$(CONFIG_PINCTRL_EXYNOS4)  += pinctrl-exynos.o
> +obj-$(CONFIG_PINCTRL_EXYNOS)   += pinctrl-exynos.o
>  obj-$(CONFIG_PINCTRL_EXYNOS5440)       += pinctrl-exynos5440.o
>  obj-$(CONFIG_PINCTRL_XWAY)     += pinctrl-xway.o
>  obj-$(CONFIG_PINCTRL_LANTIQ)   += pinctrl-lantiq.o
> 8<----------------------------------------------------------------------
>
> - Kukjin
>
