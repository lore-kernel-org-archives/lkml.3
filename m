Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3LQQRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:17:35 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:59430 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3LQQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:17:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, wsa@the-dreams.de, linus.walleij@linaro.org,
        linux-sh@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH 02/05 v2] pinctrl: sh-pfc: r7s72100 base support
Date: Tue, 17 Dec 2013 17:17:52 +0100
Message-ID: <1495224.jieznL8M7N@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131217023804.24573.82351.sendpatchset@w520>
References: <20131217023745.24573.3660.sendpatchset@w520> <20131217023804.24573.82351.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thank you for the patch.

On Tuesday 17 December 2013 11:38:04 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add r7s72100 PINCTRL support via sh-pfc V2. At this point the code
> provides enough support to allow use together with the gpio-rz
> driver. Incremental per-device patches will in the future be
> submitted on top of this base patch to allow PINCTRL enablement
> for each individual device.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  Changes since V1:
>  - Moved RZ_PORT_PIN() macro
>  - Make use of _GP_GPIO() for 16-bit bank support
>  - Updated _P_DATA() and _P_FN() to control PIPC
> 
>  Thanks to Laurent for the review.
> 
>  drivers/pinctrl/sh-pfc/Kconfig        |    5 +
>  drivers/pinctrl/sh-pfc/Makefile       |    1
>  drivers/pinctrl/sh-pfc/core.c         |    9 +
>  drivers/pinctrl/sh-pfc/core.h         |    1
>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c |  161 ++++++++++++++++++++++++++++++
>  5 files changed, 177 insertions(+)

[snip]

> --- /dev/null
> +++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c	2013-12-17
> 10:47:26.000000000 +0900
> @@ -0,0 +1,161 @@

[snip]

> +#define RZ_PORT_PIN(bank, pin) (((bank) * 16) + (pin))

Could you please move this macro to the next patch where it gets use d?

> +static const struct sh_pfc_pin_group pinmux_groups[] = {
> +};
> +
> +static const struct sh_pfc_function pinmux_functions[] = {
> +};
> +
> +#define PFC_REG(idx, name, reg)						\
> +	{ PINMUX_CFG_REG(__stringify(name), reg, 16, 1) {		\
> +		P_##idx##_15_##name##_0, P_##idx##_15_##name##_1,	\
> +		P_##idx##_14_##name##_0, P_##idx##_14_##name##_1,	\
> +		P_##idx##_13_##name##_0, P_##idx##_13_##name##_1,	\
> +		P_##idx##_12_##name##_0, P_##idx##_12_##name##_1,	\
> +		P_##idx##_11_##name##_0, P_##idx##_11_##name##_1,	\
> +		P_##idx##_10_##name##_0, P_##idx##_10_##name##_1,	\
> +		P_##idx##_9_##name##_0, P_##idx##_9_##name##_1,		\
> +		P_##idx##_8_##name##_0, P_##idx##_8_##name##_1,		\
> +		P_##idx##_7_##name##_0, P_##idx##_7_##name##_1,		\
> +		P_##idx##_6_##name##_0, P_##idx##_6_##name##_1,		\
> +		P_##idx##_5_##name##_0, P_##idx##_5_##name##_1,		\
> +		P_##idx##_4_##name##_0, P_##idx##_4_##name##_1,		\
> +		P_##idx##_3_##name##_0, P_##idx##_3_##name##_1,		\
> +		P_##idx##_2_##name##_0, P_##idx##_2_##name##_1,		\
> +		P_##idx##_1_##name##_0, P_##idx##_1_##name##_1,		\
> +		P_##idx##_0_##name##_0, P_##idx##_0_##name##_1 }	\
> +	}
> +
> +#define PFC_REGS(idx)						\
> +	PFC_REG(idx, PMC, (0xfcfe3400 + (idx * 4))),		\
> +	PFC_REG(idx, PFC, (0xfcfe3500 + (idx * 4))),		\
> +	PFC_REG(idx, PFCE, (0xfcfe3600 + (idx * 4))),		\
> +	PFC_REG(idx, PFCAE, (0xfcfe3a00 + (idx * 4))),		\
> +	PFC_REG(idx, PIBC, (0xfcfe7000 + (idx * 4))),		\
> +	PFC_REG(idx, PBDC, (0xfcfe7100 + (idx * 4))),		\
> +	PFC_REG(idx, PIPC, (0xfcfe7200 + (idx * 4)))
> +
> +static struct pinmux_cfg_reg pinmux_config_regs[] = {
> +	PFC_REGS(0), PFC_REGS(1), PFC_REGS(2), PFC_REGS(3),
> +	PFC_REGS(4), PFC_REGS(5), PFC_REGS(6), PFC_REGS(7),
> +	PFC_REGS(8), PFC_REGS(9), PFC_REGS(10), PFC_REGS(11),
> +	PFC_REG(12, PMC, 0xfcfe7b40),
> +	PFC_REG(12, PIBC, 0xfcfe7f00),
> +	{ },
> +};
> +
> +const struct sh_pfc_soc_info r7s72100_pinmux_info = {
> +	.name = "r7s72100_pfc",
> +
> +	.function = { PINMUX_FUNCTION_BEGIN, PINMUX_FUNCTION_END },
> +
> +	.pins = pinmux_pins,
> +	.nr_pins = ARRAY_SIZE(pinmux_pins),
> +	.groups = pinmux_groups,
> +	.nr_groups = ARRAY_SIZE(pinmux_groups),
> +	.functions = pinmux_functions,
> +	.nr_functions = ARRAY_SIZE(pinmux_functions),
> +
> +	.cfg_regs = pinmux_config_regs,
> +
> +	.gpio_data = pinmux_data,
> +	.gpio_data_size = ARRAY_SIZE(pinmux_data),
> +};

-- 
Regards,

Laurent Pinchart

