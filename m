Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3LQQBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:01:24 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:59314 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3LQQBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:01:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, wsa@the-dreams.de, horms@verge.net.au
Subject: Re: [PATCH 03/05 v2] pinctrl: sh-pfc: r7s72100 single pin macros
Date: Tue, 17 Dec 2013 17:01:41 +0100
Message-ID: <4641687.OeSyoZmW7s@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131217023814.24573.91649.sendpatchset@w520>
References: <20131217023745.24573.3660.sendpatchset@w520> <20131217023814.24573.91649.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thank you for the patches.

On Tuesday 17 December 2013 11:38:14 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Introduce macros that allow description of one pin per line.
> Compared to the other ways of doing this, using this style
> we can compresses the description of each pin from 9 to 1 line.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  This patch uses RZ_PMX_GROUP and RZ_GROUPS, thanks Laurent!
> 
>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> --- 0003/drivers/pinctrl/sh-pfc/pfc-r7s72100.c
> +++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c	2013-12-16 
19:14:30.000000000
> +0900 @@ -98,9 +98,30 @@ static struct sh_pfc_pin pinmux_pins[] =
> 
>  #define RZ_PORT_PIN(bank, pin) (((bank) * 16) + (pin))
> 
> +#define __RZ_STR(pfx, hw, bank, pin, sfx)		\
> +	pfx##_##hw##_p##bank##_##pin####sfx

Do you mean s/####sfx/##sfx/ ?

> +
> +#define RZ_PIN_AND_MUX(pfx, hw, bank, pin, fn)				\
> +static const unsigned int __RZ_STR(pfx, hw, bank, pin, _pins)[] = {	\
> +	RZ_PORT_PIN(bank, pin),						\
> +};									\
> +static const unsigned int __RZ_STR(pfx, hw, bank, pin, _mux)[] = {	\
> +	P_##bank##_##pin##_MARK_FN##fn,					\
> +};

I would have preferred keeping the trailing semicolon (and comma in the 
RZ_GROUPS macro) out of the macro, but that won't be possible as the 
RZ_PIN_AND_MUX and RZ_GROUPS macros are used as arguments to the SCIF macros 
in the next patch.

> +
> +#define RZ_PMX_GROUP(pfx, hw, bank, pin, fn) \
> +	SH_PFC_PIN_GROUP(pfx##_##hw##_p##bank##_##pin),
> +
> +#define __RZ_GROUPS(x) #x

Can't you replace __RZ_GROUPS() by __stringify() ?

> +#define RZ_GROUPS(pfx, hw, bank, pin, fn) \
> +	__RZ_GROUPS(pfx##_##hw##_p##bank##_##pin),
> +
>  static const struct sh_pfc_pin_group pinmux_groups[] = {
>  };
> 
> +static const char * const scif2_groups[] = {
> +};

I think this should be part of patch 04/05.

>  static const struct sh_pfc_function pinmux_functions[] = {
>  };

-- 
Regards,

Laurent Pinchart

