Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaBJMrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:47:39 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:39133 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaBJMre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:47:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/7] pinctrl: sh-pfc: r8a7790: Add QSPI pin groups
Date: Mon, 10 Feb 2014 13:48:36 +0100
Message-ID: <8438484.DB7cn7tjVR@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392029254-15400-2-git-send-email-geert@linux-m68k.org>
References: <1392029254-15400-1-git-send-email-geert@linux-m68k.org> <1392029254-15400-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Monday 10 February 2014 11:47:27 Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> A QSPI function set consists of 3 groups:
>   - qspi_ctrl (2 control wires)
>   - qspi_data2 (2 data wires, for Single/Dual SPI)
>   - qspi_data4 (4 data wires, for Quad SPI)
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/pinctrl/sh-pfc/pfc-r8a7790.c |   33 +++++++++++++++++++++++++++++++
> 1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
> b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c index c381ae63c508..bc9ced3ccd58
> 100644
> --- a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
> +++ b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
> @@ -2389,6 +2389,29 @@ static const unsigned int msiof3_tx_pins[] = {
>  static const unsigned int msiof3_tx_mux[] = {
>  	MSIOF3_TXD_MARK,
>  };
> +/* - QSPI -------------------------------------------------------------- */
> +static const unsigned int qspi_ctrl_pins[] = {
> +	/* SPCLK, SSL */
> +	RCAR_GP_PIN(1, 4), RCAR_GP_PIN(1, 9),
> +};
> +static const unsigned int qspi_ctrl_mux[] = {
> +	SPCLK_MARK, SSL_MARK,
> +};
> +static const unsigned int qspi_data2_pins[] = {
> +	/* MOSI_IO0, MISO_IO1 */
> +	RCAR_GP_PIN(1, 5), RCAR_GP_PIN(1, 6),
> +};
> +static const unsigned int qspi_data2_mux[] = {
> +	MOSI_IO0_MARK, MISO_IO1_MARK,
> +};
> +static const unsigned int qspi_data4_pins[] = {
> +	/* MOSI_IO0, MISO_IO1, IO2, IO3 */
> +	RCAR_GP_PIN(1, 5), RCAR_GP_PIN(1, 6), RCAR_GP_PIN(1, 7),
> +	RCAR_GP_PIN(1, 8),
> +};
> +static const unsigned int qspi_data4_mux[] = {
> +	MOSI_IO0_MARK, MISO_IO1_MARK, IO2_MARK, IO3_MARK,
> +};
>  /* - SCIF0 ------------------------------------------------------------- */
> static const unsigned int scif0_data_pins[] = {
>  	/* RX, TX */
> @@ -3671,6 +3694,9 @@ static const struct sh_pfc_pin_group pinmux_groups[] =
> { SH_PFC_PIN_GROUP(msiof3_ss2),
>  	SH_PFC_PIN_GROUP(msiof3_rx),
>  	SH_PFC_PIN_GROUP(msiof3_tx),
> +	SH_PFC_PIN_GROUP(qspi_ctrl),
> +	SH_PFC_PIN_GROUP(qspi_data2),
> +	SH_PFC_PIN_GROUP(qspi_data4),
>  	SH_PFC_PIN_GROUP(scif0_data),
>  	SH_PFC_PIN_GROUP(scif0_clk),
>  	SH_PFC_PIN_GROUP(scif0_ctrl),
> @@ -3970,6 +3996,12 @@ static const char * const msiof3_groups[] = {
>  	"msiof3_tx",
>  };
> 
> +static const char * const qspi_groups[] = {
> +	"qspi_ctrl",
> +	"qspi_data2",
> +	"qspi_data4",
> +};
> +
>  static const char * const scif0_groups[] = {
>  	"scif0_data",
>  	"scif0_clk",
> @@ -4212,6 +4244,7 @@ static const struct sh_pfc_function pinmux_functions[]
> = { SH_PFC_FUNCTION(msiof0),
>  	SH_PFC_FUNCTION(msiof1),
>  	SH_PFC_FUNCTION(msiof2),
> +	SH_PFC_FUNCTION(qspi),
>  	SH_PFC_FUNCTION(msiof3),

I believe qspi comes after msiof3 :-)

Apart from that the patch looks good.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	SH_PFC_FUNCTION(scif0),
>  	SH_PFC_FUNCTION(scif1),

-- 
Regards,

Laurent Pinchart

