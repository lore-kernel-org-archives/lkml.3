Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3LQQHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:07:47 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:59348 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3LQQHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:07:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, wsa@the-dreams.de, linus.walleij@linaro.org,
        linux-sh@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH 04/05 v2] pinctrl: sh-pfc: r7s72100 SCIF support
Date: Tue, 17 Dec 2013 17:08:05 +0100
Message-ID: <1746928.Q6f1iPMsKL@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131217023823.24573.98585.sendpatchset@w520>
References: <20131217023745.24573.3660.sendpatchset@w520> <20131217023823.24573.98585.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thank you for the patch.

On Tuesday 17 December 2013 11:38:23 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add support for SCIF functions SCK, TXD, RXD, CTS and RTS to the
> r7s72100 PINCTRL code. There are two possible pins that can be used
> for TXD (Port 3 Pin 0 Function 6 and Port 3 Pin 1 Function 4) and
> because of that are pins broken out into separate functions.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c |  158 ++++++++++++++++++++++++++++++
>  1 file changed, 158 insertions(+)
> 
> --- 0006/drivers/pinctrl/sh-pfc/pfc-r7s72100.c
> +++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c	2013-12-17 
01:09:20.000000000
> +0900 @@ -117,12 +117,170 @@ static const unsigned int __RZ_STR(pfx,
>  #define RZ_GROUPS(pfx, hw, bank, pin, fn) \
>  	__RZ_GROUPS(pfx##_##hw##_p##bank##_##pin),
> 
> +#define SCIF0(fn)			\
> +	fn(scif0, clk, 2, 13, 6)	\
> +	fn(scif0, txd, 2, 14, 6)	\
> +	fn(scif0, rxd, 2, 15, 6)	\
> +	fn(scif0, clk, 4, 8, 7)		\
> +	fn(scif0, txd, 4, 9, 7)		\
> +	fn(scif0, rxd, 4, 10, 7)	\
> +	fn(scif0, clk, 6, 8, 5)		\
> +	fn(scif0, txd, 6, 9, 5)		\
> +	fn(scif0, rxd, 6, 10, 5)

The SCIF0 SCK, TXD and RXD pins are grouped together with three options to 
choose from. Unlike the PFC devices we support so far, the driver allows 
picking pins individually. This allows greater flexibility, at the cost of a 
more verbose PFC DT node.

I assume that this is correct, but could you please confirm that the SoC 
really allows picking pins individually (for instance using P2.14 as SCIF0 TXD 
together with P6.10 as SCIF0 RXD) ?

I also wonder whether other currently supported SoCs wouldn't happen to also 
support picking pins from different groups, even though they name the groups 
differently.

> +
> +#define SCIF1(fn)			\
> +	fn(scif1, cts, 2, 3, 6)		\
> +	fn(scif1, clk, 2, 4, 6)		\
> +	fn(scif1, txd, 2, 5, 6)		\
> +	fn(scif1, rxd, 2, 6, 6)		\
> +	fn(scif1, rts, 2, 7, 6)		\
> +	fn(scif1, clk, 4, 11, 7)	\
> +	fn(scif1, txd, 4, 12, 7)	\
> +	fn(scif1, rxd, 4, 13, 7)	\
> +	fn(scif1, clk, 6, 11, 5)	\
> +	fn(scif1, txd, 6, 12, 5)	\
> +	fn(scif1, rxd, 6, 13, 5)	\
> +	fn(scif1, clk, 9, 2, 4)		\
> +	fn(scif1, txd, 9, 3, 4)		\
> +	fn(scif1, rxd, 9, 4, 4)		\
> +	fn(scif1, cts, 9, 5, 4)		\
> +	fn(scif1, rts, 9, 6, 4)
> +
> +#define SCIF2(fn)			\
> +	fn(scif2, clk, 3, 0, 4)		\
> +	fn(scif2, txd, 3, 1, 4)		\
> +	fn(scif2, rxd, 3, 2, 4)		\
> +	fn(scif2, txd, 3, 0, 6)		\
> +	fn(scif2, clk, 4, 1, 5)		\
> +	fn(scif2, txd, 4, 2, 5)		\
> +	fn(scif2, rxd, 4, 3, 5)		\
> +	fn(scif2, txd, 4, 14, 7)	\
> +	fn(scif2, rxd, 4, 15, 7)	\
> +	fn(scif2, txd, 6, 2, 7)		\
> +	fn(scif2, rxd, 6, 3, 7)		\
> +	fn(scif2, clk, 8, 3, 7)		\
> +	fn(scif2, rxd, 8, 4, 7)		\
> +	fn(scif2, txd, 8, 6, 7)
> +
> +#define SCIF3(fn)			\
> +	fn(scif3, clk, 3, 4, 7)		\
> +	fn(scif3, txd, 3, 5, 7)		\
> +	fn(scif3, rxd, 3, 6, 7)		\
> +	fn(scif3, clk, 5, 2, 5)		\
> +	fn(scif3, txd, 5, 3, 5)		\
> +	fn(scif3, rxd, 5, 4, 5)		\
> +	fn(scif3, rxd, 6, 0, 7)		\
> +	fn(scif3, txd, 6, 1, 7)		\
> +	fn(scif3, txd, 8, 8, 7)		\
> +	fn(scif3, rxd, 8, 9, 7)
> +
> +#define SCIF4(fn)			\
> +	fn(scif4, txd, 5, 0, 5)		\
> +	fn(scif4, rxd, 5, 1, 5)		\
> +	fn(scif4, clk, 7, 0, 4)		\
> +	fn(scif4, txd, 7, 1, 4)		\
> +	fn(scif4, rxd, 7, 2, 4)		\
> +	fn(scif4, txd, 8, 14, 7)	\
> +	fn(scif4, rxd, 8, 15, 7)
> +
> +#define SCIF5(fn)			\
> +	fn(scif5, cts, 6, 3, 5)		\
> +	fn(scif5, rts, 6, 4, 5)		\
> +	fn(scif5, clk, 6, 5, 5)		\
> +	fn(scif5, txd, 6, 6, 5)		\
> +	fn(scif5, rxd, 6, 7, 5)		\
> +	fn(scif5, cts, 7, 15, 4)	\
> +	fn(scif5, clk, 8, 0, 4)		\
> +	fn(scif5, txd, 8, 1, 4)		\
> +	fn(scif5, rxd, 8, 2, 4)		\
> +	fn(scif5, rts, 8, 3, 4)		\
> +	fn(scif5, rxd, 8, 11, 5)	\
> +	fn(scif5, clk, 8, 12, 5)	\
> +	fn(scif5, txd, 8, 13, 5)	\
> +	fn(scif5, cts, 11, 7, 3)	\
> +	fn(scif5, rts, 11, 8, 3)	\
> +	fn(scif5, clk, 11, 9, 3)	\
> +	fn(scif5, txd, 11, 10, 3)	\
> +	fn(scif5, rxd, 11, 11, 3)
> +
> +#define SCIF6(fn)			\
> +	fn(scif6, txd, 5, 6, 5)		\
> +	fn(scif6, rxd, 5, 7, 5)		\
> +	fn(scif6, clk, 6, 13, 4)	\
> +	fn(scif6, txd, 6, 14, 4)	\
> +	fn(scif6, rxd, 6, 15, 4)	\
> +	fn(scif6, clk, 11, 0, 4)	\
> +	fn(scif6, txd, 11, 1, 4)	\
> +	fn(scif6, rxd, 11, 2, 4)
> +
> +#define SCIF7(fn)			\
> +	fn(scif7, clk, 7, 3, 4)		\
> +	fn(scif7, txd, 7, 4, 4)		\
> +	fn(scif7, rxd, 7, 5, 4)		\
> +	fn(scif7, cts, 7, 6, 4)		\
> +	fn(scif7, rts, 7, 7, 4)
> +
> +SCIF0(RZ_PIN_AND_MUX)
> +SCIF1(RZ_PIN_AND_MUX)
> +SCIF2(RZ_PIN_AND_MUX)
> +SCIF3(RZ_PIN_AND_MUX)
> +SCIF4(RZ_PIN_AND_MUX)
> +SCIF5(RZ_PIN_AND_MUX)
> +SCIF6(RZ_PIN_AND_MUX)
> +SCIF7(RZ_PIN_AND_MUX)
> +
>  static const struct sh_pfc_pin_group pinmux_groups[] = {
> +	SCIF0(RZ_PMX_GROUP)
> +	SCIF1(RZ_PMX_GROUP)
> +	SCIF2(RZ_PMX_GROUP)
> +	SCIF3(RZ_PMX_GROUP)
> +	SCIF4(RZ_PMX_GROUP)
> +	SCIF5(RZ_PMX_GROUP)
> +	SCIF6(RZ_PMX_GROUP)
> +	SCIF7(RZ_PMX_GROUP)
> +};
> +
> +static const char * const scif0_groups[] = {
> +	SCIF0(RZ_GROUPS)
> +};
> +
> +static const char * const scif1_groups[] = {
> +	SCIF1(RZ_GROUPS)
>  };
> 
>  static const char * const scif2_groups[] = {
> +	SCIF2(RZ_GROUPS)
> +};
> +
> +static const char * const scif3_groups[] = {
> +	SCIF3(RZ_GROUPS)
> +};
> +
> +static const char * const scif4_groups[] = {
> +	SCIF4(RZ_GROUPS)
> +};
> +
> +static const char * const scif5_groups[] = {
> +	SCIF5(RZ_GROUPS)
> +};
> +
> +static const char * const scif6_groups[] = {
> +	SCIF6(RZ_GROUPS)
>  };
> +
> +static const char * const scif7_groups[] = {
> +	SCIF7(RZ_GROUPS)
> +};
> +
>  static const struct sh_pfc_function pinmux_functions[] = {
> +	SH_PFC_FUNCTION(scif0),
> +	SH_PFC_FUNCTION(scif1),
> +	SH_PFC_FUNCTION(scif2),
> +	SH_PFC_FUNCTION(scif3),
> +	SH_PFC_FUNCTION(scif4),
> +	SH_PFC_FUNCTION(scif5),
> +	SH_PFC_FUNCTION(scif6),
> +	SH_PFC_FUNCTION(scif7),
>  };
> 
>  #define PFC_REG(idx, name, reg)						\
-- 
Regards,

Laurent Pinchart

