Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaGDNHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:07:45 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38050 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaGDNHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <1400236840.20342.30.camel@x220>
References: <1400236840.20342.30.camel@x220>
Date: Fri, 4 Jul 2014 21:07:42 +0800
Message-ID: <CAN1soZwfVHvwtn80=J4S2FsiypHGadrGbznTH_5ju5pTR3tv4g@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: fix typo 'CONFIG_SPI_PXA2XX_MASTER'
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 6:40 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> CONFIG_SPI_PXA2XX_MASTER was used were it was surely meant to use
> CONFIG_SPI_PXA2XX_MODULE. Use the IS_ENABLED() macro here, as it guards
> against typos like this one.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested, and (hardware) testing for the modular case might be needed.
> This typo was introduced in v2.6.28.
>
>  arch/arm/mach-pxa/corgi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
> index 57d60542f982..ccff8d82cc27 100644
> --- a/arch/arm/mach-pxa/corgi.c
> +++ b/arch/arm/mach-pxa/corgi.c
> @@ -513,7 +513,7 @@ static struct pxa2xx_udc_mach_info udc_info __initdata = {
>         .gpio_pullup            = CORGI_GPIO_USB_PULLUP,
>  };
>
> -#if defined(CONFIG_SPI_PXA2XX) || defined(CONFIG_SPI_PXA2XX_MASTER)
> +#if IS_ENABLED(CONFIG_SPI_PXA2XX)
>  static struct pxa2xx_spi_master corgi_spi_info = {
>         .num_chipselect = 3,
>  };
> --
> 1.9.0
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
