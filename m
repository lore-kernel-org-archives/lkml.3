Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab3IRMDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:03:54 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:54808 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3IRMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:03:52 -0400
Date: Wed, 18 Sep 2013 13:03:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, srinivas.kandagatla@st.com,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        stephen.gallimore@st.com, stuart.menefy@st.com,
        gabriel.fernandez@st.com, olivier.clergeaud@st.com
Subject: Re: [PATCH 2/4] ARM: STi: Supply I2C configuration to STiH416 SoC
Message-ID: <20130918120340.GF16984@lee--X1>
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com>
 <1379498483-4236-3-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379498483-4236-3-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch supplies I2C configuration to STiH416 SoC.
> 
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>  arch/arm/boot/dts/stih416-pinctrl.dtsi |   35 ++++++++++++++++++++
>  arch/arm/boot/dts/stih416.dtsi         |   57 ++++++++++++++++++++++++++++++++
>  2 files changed, 92 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi

I genuinely don't know the answer to this question, but are these
nodes identical to the ones you've just put in the stih415 DTSI file?
If so, I think it will be worth creating a stih41x DTSI rather than
duplicating lots of stuff unnecessarily.

> index 0f246c9..b29ff4b 100644
> --- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> @@ -97,6 +97,24 @@
>  					};
>  				};
>  			};
> +
> +			sbc_i2c0 {
> +				pinctrl_sbc_i2c0_default: sbc_i2c0-default {
> +					st,pins {
> +						sda = <&PIO4 6 ALT1 BIDIR>;
> +						scl = <&PIO4 5 ALT1 BIDIR>;
> +					};
> +				};
> +			};
> +
> +			sbc_i2c1 {
> +				pinctrl_sbc_i2c1_default: sbc_i2c1-default {
> +					st,pins {
> +						sda = <&PIO3 2 ALT2 BIDIR>;
> +						scl = <&PIO3 1 ALT2 BIDIR>;
> +					};
> +				};
> +			};
>  		};
>  
>  		pin-controller-front {
> @@ -175,6 +193,23 @@
>  				};
>  			};
>  
> +			i2c0 {
> +				pinctrl_i2c0_default: i2c0-default {
> +					st,pins {
> +						sda = <&PIO9 3 ALT1 BIDIR>;
> +						scl = <&PIO9 2 ALT1 BIDIR>;
> +					};
> +				};
> +			};
> +
> +			i2c1 {
> +				pinctrl_i2c1_default: i2c1-default {
> +					st,pins {
> +						sda = <&PIO12 1 ALT1 BIDIR>;
> +						scl = <&PIO12 0 ALT1 BIDIR>;
> +					};
> +				};
> +			};
>  		};
>  
>  		pin-controller-rear {
> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> index 1a0326e..8856470 100644
> --- a/arch/arm/boot/dts/stih416.dtsi
> +++ b/arch/arm/boot/dts/stih416.dtsi
> @@ -9,6 +9,7 @@
>  #include "stih41x.dtsi"
>  #include "stih416-clock.dtsi"
>  #include "stih416-pinctrl.dtsi"
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>  / {
>  	L2: cache-controller {
>  		compatible = "arm,pl310-cache";
> @@ -92,5 +93,61 @@
>  			pinctrl-0 	= <&pinctrl_sbc_serial1>;
>  			clocks          = <&CLK_SYSIN>;
>  		};
> +
> +		i2c0: i2c@fed40000{

Same issues here. I assume most of this is copy paste.

> +			compatible	= "st,comms-i2c";
> +			status		= "disabled";
> +			reg		= <0xfed40000 0x110>;
> +			interrupts	=  <GIC_SPI 187 IRQ_TYPE_EDGE_RISING>;
> +			clocks		= <&CLK_S_ICN_REG_0>;
> +			clock-frequency = <400000>;
> +			pinctrl-names	= "default";
> +			pinctrl-0	= <&pinctrl_i2c0_default>;
> +			st,glitches;
> +			st,glitch-clk	= <500>;
> +			st,glitch-dat	= <500>;
> +		};
> +
> +		i2c1: i2c@fed41000{
> +			compatible	= "st,comms-i2c";
> +			status		= "disabled";
> +			reg		= <0xfed41000 0x110>;
> +			interrupts	=  <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
> +			clocks		= <&CLK_S_ICN_REG_0>;
> +			clock-frequency = <400000>;
> +			pinctrl-names	= "default";
> +			pinctrl-0	= <&pinctrl_i2c1_default>;
> +			st,glitches;
> +			st,glitch-clk	= <500>;
> +			st,glitch-dat	= <500>;
> +		};
> +
> +		sbc_i2c0: i2c@fe540000{
> +			compatible	= "st,comms-i2c";
> +			status		= "disabled";
> +			reg		= <0xfe540000 0x110>;
> +			interrupts	=  <GIC_SPI 206 IRQ_TYPE_EDGE_RISING>;
> +			clocks		= <&CLK_SYSIN>;
> +			clock-frequency = <400000>;
> +			pinctrl-names	= "default";
> +			pinctrl-0	= <&pinctrl_sbc_i2c0_default>;
> +			st,glitches;
> +			st,glitch-clk	= <500>;
> +			st,glitch-dat	= <500>;
> +		};
> +
> +		sbc_i2c1: i2c@fe541000{
> +			compatible	= "st,comms-i2c";
> +			status		= "disabled";
> +			reg		= <0xfe541000 0x110>;
> +			interrupts	=  <GIC_SPI 207 IRQ_TYPE_EDGE_RISING>;
> +			clocks		= <&CLK_SYSIN>;
> +			clock-frequency = <400000>;
> +			pinctrl-names	= "default";
> +			pinctrl-0	= <&pinctrl_sbc_i2c1_default>;
> +			st,glitches;
> +			st,glitch-clk	= <500>;
> +			st,glitch-dat	= <500>;
> +		};
>  	};
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
