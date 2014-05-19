Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaESVKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:10:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55353 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751106AbaESVK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:10:28 -0400
Date: Mon, 19 May 2014 23:07:36 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/10] ARM: dts: berlin: convert BG2CD to DT clock
 nodes
Message-ID: <20140519210736.GR29318@piout.net>
References: <1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1400517811-24668-9-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400517811-24668-9-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/2014 at 18:43:29 +0200, Sebastian Hesselbarth wrote :
> This converts Berlin BG2CD SoC dtsi to make use of the new DT clock
> nodes for Berlin SoCs. Also add a binding include to ease core clock
> references.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
> Changelog:
> v1->v2:
> - adapt to new single chip control node and compatible
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: Jisheng Zhang <jszhang@marvell.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/berlin2cd.dtsi | 53 ++++++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index 6eb1bdae23ac..1385caa6d029 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -12,6 +12,7 @@
>   */
>  
>  #include "skeleton.dtsi"
> +#include <dt-bindings/clock/berlin2.h>
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>  
>  / {
> @@ -30,24 +31,10 @@
>  		};
>  	};
>  
> -	clocks {
> -		smclk: sysmgr-clock {
> -			compatible = "fixed-clock";
> -			#clock-cells = <0>;
> -			clock-frequency = <25000000>;
> -		};
> -
> -		cfgclk: cfg-clock {
> -			compatible = "fixed-clock";
> -			#clock-cells = <0>;
> -			clock-frequency = <75000000>;
> -		};
> -
> -		sysclk: system-clock {
> -			compatible = "fixed-clock";
> -			#clock-cells = <0>;
> -			clock-frequency = <300000000>;
> -		};
> +	refclk: oscillator {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <25000000>;
>  	};
>  
>  	soc {
> @@ -76,7 +63,7 @@
>  			compatible = "arm,cortex-a9-twd-timer";
>  			reg = <0xad0600 0x20>;
>  			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> -			clocks = <&sysclk>;
> +			clocks = <&chip CLKID_TWD>;
>  		};
>  
>  		apb@e80000 {
> @@ -163,7 +150,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c00 0x14>;
>  				interrupts = <8>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "okay";
>  			};
> @@ -172,7 +159,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c14 0x14>;
>  				interrupts = <9>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "okay";
>  			};
> @@ -181,7 +168,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c28 0x14>;
>  				interrupts = <10>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -190,7 +177,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c3c 0x14>;
>  				interrupts = <11>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -199,7 +186,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c50 0x14>;
>  				interrupts = <12>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -208,7 +195,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c64 0x14>;
>  				interrupts = <13>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -217,7 +204,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c78 0x14>;
>  				interrupts = <14>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -226,7 +213,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c8c 0x14>;
>  				interrupts = <15>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -241,6 +228,14 @@
>  			};
>  		};
>  
> +		chip: chip-control@ea0000 {
> +			compatible = "marvell,berlin2cd-chip-ctrl";
> +			#clock-cells = <1>;
> +			reg = <0xea0000 0x400>;
> +			clocks = <&refclk>;
> +			clock-names = "refclk";
> +		};
> +
>  		apb@fc0000 {
>  			compatible = "simple-bus";
>  			#address-cells = <1>;
> @@ -285,7 +280,7 @@
>  				reg-shift = <2>;
>  				reg-io-width = <1>;
>  				interrupts = <8>;
> -				clocks = <&smclk>;
> +				clocks = <&refclk>;
>  				status = "disabled";
>  			};
>  
> @@ -295,7 +290,7 @@
>  				reg-shift = <2>;
>  				reg-io-width = <1>;
>  				interrupts = <9>;
> -				clocks = <&smclk>;
> +				clocks = <&refclk>;
>  				status = "disabled";
>  			};
>  
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
