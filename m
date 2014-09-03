Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaICVO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:14:56 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:56991 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbaICVOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:14:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: sh-pfc: rename confusing pinmux ops variable
Date: Thu, 04 Sep 2014 00:14:49 +0300
Message-ID: <1591463.JEteqGINz8@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1409745112-13652-1-git-send-email-linus.walleij@linaro.org>
References: <1409745112-13652-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Thank you for the patch.

On Wednesday 03 September 2014 13:51:52 Linus Walleij wrote:
> The vtable named *pinmux_ops in the affected files are not really
> about pin multiplexing, but a struct related to some PFC-specific
> operations, inclusing pin config (bias setting). Rename the variable
> so as to avoid confusions.
> 
> Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>

> ---
>  drivers/pinctrl/sh-pfc/pfc-r8a73a4.c | 4 ++--
>  drivers/pinctrl/sh-pfc/pfc-r8a7740.c | 4 ++--
>  drivers/pinctrl/sh-pfc/pfc-sh7372.c  | 4 ++--
>  drivers/pinctrl/sh-pfc/pfc-sh73a0.c  | 4 ++--
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a73a4.c
> b/drivers/pinctrl/sh-pfc/pfc-r8a73a4.c index ce9fb7aa8ba3..280a56f97786
> 100644
> --- a/drivers/pinctrl/sh-pfc/pfc-r8a73a4.c
> +++ b/drivers/pinctrl/sh-pfc/pfc-r8a73a4.c
> @@ -2717,14 +2717,14 @@ static void r8a73a4_pinmux_set_bias(struct sh_pfc
> *pfc, unsigned int pin, iowrite8(value, addr);
>  }
> 
> -static const struct sh_pfc_soc_operations r8a73a4_pinmux_ops = {
> +static const struct sh_pfc_soc_operations r8a73a4_pfc_ops = {
>  	.get_bias = r8a73a4_pinmux_get_bias,
>  	.set_bias = r8a73a4_pinmux_set_bias,
>  };
> 
>  const struct sh_pfc_soc_info r8a73a4_pinmux_info = {
>  	.name		= "r8a73a4_pfc",
> -	.ops		= &r8a73a4_pinmux_ops,
> +	.ops		= &r8a73a4_pfc_ops,
> 
>  	.input = { PINMUX_INPUT_BEGIN, PINMUX_INPUT_END },
>  	.output = { PINMUX_OUTPUT_BEGIN, PINMUX_OUTPUT_END },
> diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
> b/drivers/pinctrl/sh-pfc/pfc-r8a7740.c index e4c1ef477053..b486e9d20cc2
> 100644
> --- a/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
> +++ b/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
> @@ -3752,14 +3752,14 @@ static void r8a7740_pinmux_set_bias(struct sh_pfc
> *pfc, unsigned int pin, iowrite8(value, addr);
>  }
> 
> -static const struct sh_pfc_soc_operations r8a7740_pinmux_ops = {
> +static const struct sh_pfc_soc_operations r8a7740_pfc_ops = {
>  	.get_bias = r8a7740_pinmux_get_bias,
>  	.set_bias = r8a7740_pinmux_set_bias,
>  };
> 
>  const struct sh_pfc_soc_info r8a7740_pinmux_info = {
>  	.name		= "r8a7740_pfc",
> -	.ops		= &r8a7740_pinmux_ops,
> +	.ops		= &r8a7740_pfc_ops,
> 
>  	.input		= { PINMUX_INPUT_BEGIN,
>  			    PINMUX_INPUT_END },
> diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7372.c
> b/drivers/pinctrl/sh-pfc/pfc-sh7372.c index d9158b3b2919..8211f66a2f68
> 100644
> --- a/drivers/pinctrl/sh-pfc/pfc-sh7372.c
> +++ b/drivers/pinctrl/sh-pfc/pfc-sh7372.c
> @@ -2614,14 +2614,14 @@ static void sh7372_pinmux_set_bias(struct sh_pfc
> *pfc, unsigned int pin, iowrite8(value, addr);
>  }
> 
> -static const struct sh_pfc_soc_operations sh7372_pinmux_ops = {
> +static const struct sh_pfc_soc_operations sh7372_pfc_ops = {
>  	.get_bias = sh7372_pinmux_get_bias,
>  	.set_bias = sh7372_pinmux_set_bias,
>  };
> 
>  const struct sh_pfc_soc_info sh7372_pinmux_info = {
>  	.name = "sh7372_pfc",
> -	.ops = &sh7372_pinmux_ops,
> +	.ops = &sh7372_pfc_ops,
> 
>  	.input = { PINMUX_INPUT_BEGIN, PINMUX_INPUT_END },
>  	.output = { PINMUX_OUTPUT_BEGIN, PINMUX_OUTPUT_END },
> diff --git a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
> b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c index 0bd8f4401b42..2dd8fd524a80
> 100644
> --- a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
> +++ b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
> @@ -3856,7 +3856,7 @@ static int sh73a0_pinmux_soc_init(struct sh_pfc *pfc)
>  	return 0;
>  }
> 
> -static const struct sh_pfc_soc_operations sh73a0_pinmux_ops = {
> +static const struct sh_pfc_soc_operations sh73a0_pfc_ops = {
>  	.init = sh73a0_pinmux_soc_init,
>  	.get_bias = sh73a0_pinmux_get_bias,
>  	.set_bias = sh73a0_pinmux_set_bias,
> @@ -3864,7 +3864,7 @@ static const struct sh_pfc_soc_operations
> sh73a0_pinmux_ops = {
> 
>  const struct sh_pfc_soc_info sh73a0_pinmux_info = {
>  	.name = "sh73a0_pfc",
> -	.ops = &sh73a0_pinmux_ops,
> +	.ops = &sh73a0_pfc_ops,
> 
>  	.input = { PINMUX_INPUT_BEGIN, PINMUX_INPUT_END },
>  	.output = { PINMUX_OUTPUT_BEGIN, PINMUX_OUTPUT_END },

-- 
Regards,

Laurent Pinchart

