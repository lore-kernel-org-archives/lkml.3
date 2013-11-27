Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3K0LFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:05:15 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52619 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3K0LFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:05:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, wsa@the-dreams.de, linus.walleij@linaro.org,
        linux-sh@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH 02/03] pinctrl: sh-pfc: r7s72100 SCIF2 macro conversion
Date: Wed, 27 Nov 2013 12:02:02 +0100
Message-ID: <2205310.zYhAriYNC0@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131127080630.18384.55139.sendpatchset@w520>
References: <20131127080606.18384.45103.sendpatchset@w520> <20131127080630.18384.55139.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thank you for the patch.

On Wednesday 27 November 2013 17:06:30 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Convert from rather verbose description of single pin groups
> to making use of macros to describe one pin per line. The
> actual bulk of the SCIF2 description is kept in the SCIF2 macro.
> 
> Compresses the description of each pin from 9 to 1 line.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c |   64 +++++++++++++-----------------
>  1 file changed, 28 insertions(+), 36 deletions(-)
> 
> --- 0007/drivers/pinctrl/sh-pfc/pfc-r7s72100.c
> +++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c	2013-11-27 
14:19:24.000000000
> +0900 @@ -103,48 +103,40 @@ static struct sh_pfc_pin pinmux_pins[] =
>  	_P_ALL(_P_GPIO),
>  };
> 
> -/* - SCIF2 ------------------------------------------------------------- */
> -static const unsigned int scif2_txd_p3_0_pins[] = {
> -	/* TX */
> -	RZ_PORT_PIN(3, 0),
> -};
> -static const unsigned int scif2_txd_p3_0_mux[] = {
> -	P_3_0_MARK_FN6,
> -};
> -static const unsigned int scif2_txd_p3_1_pins[] = {
> -	/* TX */
> -	RZ_PORT_PIN(3, 1),
> -};
> -static const unsigned int scif2_txd_p3_1_mux[] = {
> -	P_3_1_MARK_FN4,
> -};
> -static const unsigned int scif2_rxd_p3_2_pins[] = {
> -	/* RX */
> -	RZ_PORT_PIN(3, 2),
> -};
> -static const unsigned int scif2_rxd_p3_2_mux[] = {
> -	P_3_2_MARK_FN4,
> -};
> -static const unsigned int scif2_clk_p3_0_pins[] = {
> -	/* SCK */
> -	RZ_PORT_PIN(3, 0),
> -};
> -static const unsigned int scif2_clk_p3_0_mux[] = {
> -	P_3_0_MARK_FN4,
> +#define __RZ_STR(pfx, hw, bank, pin, sfx)		\
> +	pfx##_##hw##_p##bank##_##pin####sfx
> +
> +#define RZ_PIN_AND_MUX(pfx, hw, bank, pin, fn)				\
> +static const unsigned int __RZ_STR(pfx, hw, bank, pin, _pins)[] = {	\
> +	RZ_PORT_PIN(bank, pin),						\
> +};									\
> +static const unsigned int __RZ_STR(pfx, hw, bank, pin, _mux)[] = {	\
> +	P_##bank##_##pin##_MARK_FN##fn,					\
>  };
> 
> +#define RZ_PMX_GRP(pfx, hw, bank, pin, fn) \
> +	SH_PFC_PIN_GROUP(pfx##_##hw##_p##bank##_##pin),
> +
> +#define __RZ_GPRS(x) #x
> +
> +#define RZ_GRPS(pfx, hw, bank, pin, fn) \
> +	__RZ_GPRS(pfx##_##hw##_p##bank##_##pin),

I believe the code would be more readable if you didn't abbreviate GRP and 
GRPS. I would use GROUP and GROUPS instead.

> +
> +
> +#define SCIF2(fn)			\
> +	fn(scif2, txd, 3, 0, 6)		\
> +	fn(scif2, txd, 3, 1, 4)		\
> +	fn(scif2, rxd, 3, 2, 4)		\
> +	fn(scif2, clk, 3, 0, 4)
> +
> +SCIF2(RZ_PIN_AND_MUX)
> +
>  static const struct sh_pfc_pin_group pinmux_groups[] = {
> -	SH_PFC_PIN_GROUP(scif2_txd_p3_0),
> -	SH_PFC_PIN_GROUP(scif2_txd_p3_1),
> -	SH_PFC_PIN_GROUP(scif2_rxd_p3_2),
> -	SH_PFC_PIN_GROUP(scif2_clk_p3_0),
> +	SCIF2(RZ_PMX_GRP)
>  };
> 
>  static const char * const scif2_groups[] = {
> -	"scif2_txd_p3_0",
> -	"scif2_txd_p3_1",
> -	"scif2_rxd_p3_2",
> -	"scif2_clk_p3_0",
> +	SCIF2(RZ_GRPS)
>  };
>  static const struct sh_pfc_function pinmux_functions[] = {
>  	SH_PFC_FUNCTION(scif2),

Once again it would help if I could access the datasheet.

-- 
Regards,

Laurent Pinchart

