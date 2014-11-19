Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaKSDSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:18:52 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60180 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaKSDSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:18:50 -0500
Date: Wed, 19 Nov 2014 11:18:24 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Robin Gong <b38343@freescale.com>
Cc: kernel@pengutronix.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        smoch@web.de
Subject: Re: [PATCH 1/3] ARM: dts: imx6: add pm_power_off support for i.mx6
 chips
Message-ID: <20141119031823.GC27759@dragon>
References: <1415780439-29728-1-git-send-email-b38343@freescale.com>
 <1415780439-29728-2-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415780439-29728-2-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 04:20:37PM +0800, Robin Gong wrote:
> All chips of i.mx6 can be powered off by programming SNVS.
> For example :
> On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
> pmic ON/OFF pin, that will cause the whole PMIC powered off
> except VSNVS. And system can restart once PMIC_ON_REQ goes
> high by push POWRER key.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi |    4 ++++
>  arch/arm/boot/dts/imx6qdl.dtsi         |    6 ++++++
>  arch/arm/boot/dts/imx6sl-evk.dts       |    4 ++++
>  arch/arm/boot/dts/imx6sl.dtsi          |    6 ++++++
>  arch/arm/boot/dts/imx6sx-sdb.dts       |    4 ++++
>  arch/arm/boot/dts/imx6sx.dtsi          |    6 ++++++
>  6 files changed, 30 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> index 07fb302..ba12cc6 100644
> --- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> @@ -531,6 +531,10 @@
>  	status = "okay";
>  };
>  
> +&snvs-poweroff {
> +	status = "okay";
> +};
> +
>  &ssi2 {
>  	status = "okay";
>  };
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index c701af9..3a032d1 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -645,6 +645,12 @@
>  					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
>  						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
>  				};
> +
> +				snvs-poweroff: snvs-poweroff@38 {

I'm not sure if it's because my DTC version is too low or you didn't
test, the DTC reports error in label name 'snvs-poweroff'.  IIRC, hyphen
'-' cannot be used in label name, but underscore '_' can.

Shawn

> +					compatible = "fsl,sec-v4.0-poweroff";
> +					reg = <0x38 0x4>;
> +					status = "disabled";
> +				};
>  			};
>  
>  			epit1: epit@020d0000 { /* EPIT1 */
> diff --git a/arch/arm/boot/dts/imx6sl-evk.dts b/arch/arm/boot/dts/imx6sl-evk.dts
> index 3f9e041..dab588f 100644
> --- a/arch/arm/boot/dts/imx6sl-evk.dts
> +++ b/arch/arm/boot/dts/imx6sl-evk.dts
> @@ -488,6 +488,10 @@
>  	status = "okay";
>  };
>  
> +&snvs-poweroff {
> +	status = "okay";
> +};
> +
>  &ssi2 {
>  	status = "okay";
>  };
> diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
> index 505da9e..5e5ed07 100644
> --- a/arch/arm/boot/dts/imx6sl.dtsi
> +++ b/arch/arm/boot/dts/imx6sl.dtsi
> @@ -565,6 +565,12 @@
>  					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
>  						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
>  				};
> +
> +				snvs-poweroff: snvs-poweroff@38 {
> +					compatible = "fsl,sec-v4.0-poweroff";
> +					reg = <0x38 0x4>;
> +					status = "disabled";
> +				};
>  			};
>  
>  			epit1: epit@020d0000 {
> diff --git a/arch/arm/boot/dts/imx6sx-sdb.dts b/arch/arm/boot/dts/imx6sx-sdb.dts
> index a3980d9..78dc031 100644
> --- a/arch/arm/boot/dts/imx6sx-sdb.dts
> +++ b/arch/arm/boot/dts/imx6sx-sdb.dts
> @@ -251,6 +251,10 @@
>  	};
>  };
>  
> +&snvs-poweroff {
> +	status = "okay";
> +};
> +
>  &ssi2 {
>  	status = "okay";
>  };
> diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
> index f4b9da6..652be9f 100644
> --- a/arch/arm/boot/dts/imx6sx.dtsi
> +++ b/arch/arm/boot/dts/imx6sx.dtsi
> @@ -668,6 +668,12 @@
>  					reg = <0x34 0x58>;
>  					interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>, <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
>  				};
> +
> +				snvs-poweroff: snvs-poweroff@38 {
> +					compatible = "fsl,sec-v4.0-poweroff";
> +					reg = <0x38 0x4>;
> +					status = "disabled";
> +				};
>  			};
>  
>  			epit1: epit@020d0000 {
> -- 
> 1.7.9.5
> 
