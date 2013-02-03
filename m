Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab3BCA3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 19:29:08 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:59554 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3BCA3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 19:29:06 -0500
MIME-Version: 1.0
In-Reply-To: <1359816246-3979-2-git-send-email-acourbot@nvidia.com>
References: <1359816246-3979-1-git-send-email-acourbot@nvidia.com>
	<1359816246-3979-2-git-send-email-acourbot@nvidia.com>
Date: Sun, 3 Feb 2013 08:29:03 +0800
Message-ID: <CAN1soZxOX24QCYOTXmVOmNGu-+ShUPaBScxh38C=p7-v_2OZnw@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm: pxa: tosa: do not use gpiochip_reserve()
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Dirk Opfer <dirk@opfer-online.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arch@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 10:44 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> GPIO address space reservation during early platform initialization is
> not needed anymore for Tosa. Remove the calls to gpiochip_reserve()
> which is due to be removed.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  arch/arm/mach-pxa/tosa.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
> index 9e7998d..3d91d2e 100644
> --- a/arch/arm/mach-pxa/tosa.c
> +++ b/arch/arm/mach-pxa/tosa.c
> @@ -927,8 +927,6 @@ static void tosa_restart(char mode, const char *cmd)
>
>  static void __init tosa_init(void)
>  {
> -       int dummy;
> -
>         pxa2xx_mfp_config(ARRAY_AND_SIZE(tosa_pin_config));
>
>         pxa_set_ffuart_info(NULL);
> @@ -947,10 +945,6 @@ static void __init tosa_init(void)
>         /* enable batt_fault */
>         PMCR = 0x01;
>
> -       dummy = gpiochip_reserve(TOSA_SCOOP_GPIO_BASE, 12);
> -       dummy = gpiochip_reserve(TOSA_SCOOP_JC_GPIO_BASE, 12);
> -       dummy = gpiochip_reserve(TOSA_TC6393XB_GPIO_BASE, 16);
> -
>         pxa_set_mci_info(&tosa_mci_platform_data);
>         pxa_set_ficp_info(&tosa_ficp_platform_data);
>         pxa_set_i2c_info(NULL);
> --
> 1.8.1.1
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Linus,

Could you help to merge this patch into your gpio git tree? I think
that both of them should go through one git tree.

Regards
Haojian
