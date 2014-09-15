Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaIOJoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:44:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50760 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaIOJoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:44:13 -0400
Message-ID: <1410774073.3314.1.camel@pengutronix.de>
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
From: Lucas Stach <l.stach@pengutronix.de>
To: Robin Gong <b38343@freescale.com>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 11:41:13 +0200
In-Reply-To: <1410327012-31185-1-git-send-email-b38343@freescale.com>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 10.09.2014, 13:30 +0800 schrieb Robin Gong:
> There is one weird data in rxfifo after one full rx/tx transfer
> done sometimes. It looks a design issue and hard to workaround
> totally, so disable dma functhion here. And will re-enable it
> once the root cause found.
> 
Sorry, I'm late to this as Shawn seems to already have picked up this
patch, but this isn't the right way to fix the problem.

We made it clear at kernel summit last year that we try to not break
existing DTs as booting a new kernel with an old DT is a valid use case.
While you don't strictly violate this rule what you do here is only
fixing systems booting with a new DT while leaving others broken.

If you are working around a hardware problem please disable DMA support
in the driver. This will also allow you to enable it again, if you find
another workaround without touching the DT again.

So this patch gets a NAK from me.

> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  arch/arm/boot/dts/imx6q.dtsi   | 20 ++++++++++++++++++++
>  arch/arm/boot/dts/imx6qdl.dtsi |  8 --------
>  2 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> index e9f3646..8d5d33b 100644
> --- a/arch/arm/boot/dts/imx6q.dtsi
> +++ b/arch/arm/boot/dts/imx6q.dtsi
> @@ -291,6 +291,26 @@
>  	};
>  };
>  
> +&ecspi1 {
> +	dmas = <&sdma 3 7 1>, <&sdma 4 7 2>;
> +	dma-names = "rx", "tx";
> +};
> +
> +&ecspi2 {
> +	dmas = <&sdma 5 7 1>, <&sdma 6 7 2>;
> +	dma-names = "rx", "tx";
> +};
> +
> +&ecspi3 {
> +	dmas = <&sdma 7 7 1>, <&sdma 8 7 2>;
> +	dma-names = "rx", "tx";
> +};
> +
> +&ecspi4 {
> +	dmas = <&sdma 9 7 1>, <&sdma 10 7 2>;
> +	dma-names = "rx", "tx";
> +};
> +
>  &mipi_dsi {
>  	port@2 {
>  		reg = <2>;
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index 70d7207..f696546 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -210,8 +210,6 @@
>  					clocks = <&clks IMX6QDL_CLK_ECSPI1>,
>  						 <&clks IMX6QDL_CLK_ECSPI1>;
>  					clock-names = "ipg", "per";
> -					dmas = <&sdma 3 7 1>, <&sdma 4 7 2>;
> -					dma-names = "rx", "tx";
>  					status = "disabled";
>  				};
>  
> @@ -224,8 +222,6 @@
>  					clocks = <&clks IMX6QDL_CLK_ECSPI2>,
>  						 <&clks IMX6QDL_CLK_ECSPI2>;
>  					clock-names = "ipg", "per";
> -					dmas = <&sdma 5 7 1>, <&sdma 6 7 2>;
> -					dma-names = "rx", "tx";
>  					status = "disabled";
>  				};
>  
> @@ -238,8 +234,6 @@
>  					clocks = <&clks IMX6QDL_CLK_ECSPI3>,
>  						 <&clks IMX6QDL_CLK_ECSPI3>;
>  					clock-names = "ipg", "per";
> -					dmas = <&sdma 7 7 1>, <&sdma 8 7 2>;
> -					dma-names = "rx", "tx";
>  					status = "disabled";
>  				};
>  
> @@ -252,8 +246,6 @@
>  					clocks = <&clks IMX6QDL_CLK_ECSPI4>,
>  						 <&clks IMX6QDL_CLK_ECSPI4>;
>  					clock-names = "ipg", "per";
> -					dmas = <&sdma 9 7 1>, <&sdma 10 7 2>;
> -					dma-names = "rx", "tx";
>  					status = "disabled";
>  				};
>  

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

