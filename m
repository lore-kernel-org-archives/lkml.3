Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3EUFuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 01:50:00 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:3362
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533Ab3EUFtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 01:49:51 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 21 May 2013 13:49:33 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/6] ARM: dts: imx6q{dl}: fix the pin conflict between
 SPI and WEIM
Message-ID: <20130521054931.GF3080@S2101-09.ap.freescale.net>
References: <1369039742-10893-1-git-send-email-b32955@freescale.com>
 <1369039742-10893-3-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369039742-10893-3-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 04:48:58PM +0800, Huang Shijie wrote:
> In the imx6q-sabreauto and imx6dl-sabreauto boards,
> the pin MX6Q{DL}_PAD_EIM_D19 is used as a GPIO for SPI NOR, but
> it is used as a data pin for the WEIM NOR.
> 
> In order to fix the conflict, this patch removes the pin from the hog,
> and adds a new pinctrl item: pinctrl_ecspi1_2.
> 
> The SPI NOR selects this pinctrl_ecspi1_2 when it is enabled.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  arch/arm/boot/dts/imx6dl-sabreauto.dts   |    9 ++++++++-
>  arch/arm/boot/dts/imx6q-sabreauto.dts    |    9 ++++++++-
>  arch/arm/boot/dts/imx6qdl-sabreauto.dtsi |    2 +-
>  3 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6dl-sabreauto.dts b/arch/arm/boot/dts/imx6dl-sabreauto.dts
> index 60f3038..7695f70 100644
> --- a/arch/arm/boot/dts/imx6dl-sabreauto.dts
> +++ b/arch/arm/boot/dts/imx6dl-sabreauto.dts
> @@ -25,7 +25,14 @@
>  			fsl,pins = <
>  				MX6DL_PAD_NANDF_CS2__GPIO6_IO15 0x80000000
>  				MX6DL_PAD_SD2_DAT2__GPIO1_IO13  0x80000000
> -				MX6DL_PAD_EIM_D19__GPIO3_IO19 	0x80000000
> +			>;
> +		};
> +	};
> +
> +	ecspi1 {
> +		pinctrl_ecspi1_2: ecspi1grp-2 {

The naming sounds like another ecspi1 pin groups beside
pinctrl_ecspi1_1, both of which should be ecspi1 pin groups defined by
SoC.  Please encode the board name in there to suggest this is a board
specific pin setup for ecspi1, something like pinctrl_ecspi1_sabreauto.

Shawn

> +			fsl,pins = <
> +				MX6DL_PAD_EIM_D19__GPIO3_IO19  0x80000000
>  			>;
>  		};
>  	};
> diff --git a/arch/arm/boot/dts/imx6q-sabreauto.dts b/arch/arm/boot/dts/imx6q-sabreauto.dts
> index 9fb3e99..67a3a6b 100644
> --- a/arch/arm/boot/dts/imx6q-sabreauto.dts
> +++ b/arch/arm/boot/dts/imx6q-sabreauto.dts
> @@ -29,7 +29,14 @@
>  			fsl,pins = <
>  				MX6Q_PAD_NANDF_CS2__GPIO6_IO15 0x80000000
>  				MX6Q_PAD_SD2_DAT2__GPIO1_IO13  0x80000000
> -				MX6Q_PAD_EIM_D19__GPIO3_IO19   0x80000000
> +			>;
> +		};
> +	};
> +
> +	ecspi1 {
> +		pinctrl_ecspi1_2: ecspi1grp-2 {
> +			fsl,pins = <
> +				MX6Q_PAD_EIM_D19__GPIO3_IO19  0x80000000
>  			>;
>  		};
>  	};
> diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> index d6baa51..eb293f5 100644
> --- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> @@ -20,7 +20,7 @@
>  	fsl,spi-num-chipselects = <1>;
>  	cs-gpios = <&gpio3 19 0>;
>  	pinctrl-names = "default";
> -	pinctrl-0 = <&pinctrl_ecspi1_1>;
> +	pinctrl-0 = <&pinctrl_ecspi1_1 &pinctrl_ecspi1_2>;
>  	status = "disabled"; /* pin conflict with WEIM NOR */
>  
>  	flash: m25p80@0 {
> -- 
> 1.7.1
> 
> 

