Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaESVOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:14:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55397 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750852AbaESVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:14:10 -0400
Date: Mon, 19 May 2014 23:13:33 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/10] ARM: dts: berlin: convert BG2 to DT clock nodes
Message-ID: <20140519211333.GS29318@piout.net>
References: <1400517811-24668-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1400517811-24668-10-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400517811-24668-10-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/2014 at 18:43:30 +0200, Sebastian Hesselbarth wrote :
> This converts Berlin BG2 SoC dtsi to make use of the new DT clock
> nodes for Berlin SoCs. While at it, also fix up twdclk which is
> running at cpuclk/3 instead of sysclk.
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
>  arch/arm/boot/dts/berlin2.dtsi | 56 +++++++++++++++++-------------------------
>  1 file changed, 23 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> index 57cadd31f4e1..591d4b8c1c2b 100644
> --- a/arch/arm/boot/dts/berlin2.dtsi
> +++ b/arch/arm/boot/dts/berlin2.dtsi
> @@ -12,6 +12,7 @@
>   */
>  
>  #include "skeleton.dtsi"
> +#include <dt-bindings/clock/berlin2.h>
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>  
>  / {
> @@ -37,24 +38,10 @@
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
> -			clock-frequency = <100000000>;
> -		};
> -
> -		sysclk: system-clock {
> -			compatible = "fixed-clock";
> -			#clock-cells = <0>;
> -			clock-frequency = <400000000>;
> -		};
> +	refclk: oscillator {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <25000000>;
>  	};
>  
>  	soc {
> @@ -88,7 +75,7 @@
>  			compatible = "arm,cortex-a9-twd-timer";
>  			reg = <0xad0600 0x20>;
>  			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> -			clocks = <&sysclk>;
> +			clocks = <&chip CLKID_TWD>;
>  		};
>  
>  		apb@e80000 {
> @@ -175,7 +162,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c00 0x14>;
>  				interrupts = <8>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "okay";
>  			};
> @@ -184,7 +171,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c14 0x14>;
>  				interrupts = <9>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "okay";
>  			};
> @@ -193,7 +180,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c28 0x14>;
>  				interrupts = <10>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -202,7 +189,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c3c 0x14>;
>  				interrupts = <11>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -211,7 +198,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c50 0x14>;
>  				interrupts = <12>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -220,7 +207,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c64 0x14>;
>  				interrupts = <13>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -229,7 +216,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c78 0x14>;
>  				interrupts = <14>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -238,7 +225,7 @@
>  				compatible = "snps,dw-apb-timer";
>  				reg = <0x2c8c 0x14>;
>  				interrupts = <15>;
> -				clocks = <&cfgclk>;
> +				clocks = <&chip CLKID_CFG>;
>  				clock-names = "timer";
>  				status = "disabled";
>  			};
> @@ -253,9 +240,12 @@
>  			};
>  		};
>  
> -		generic-regs@ea0184 {
> -			compatible = "marvell,berlin-generic-regs", "syscon";
> -			reg = <0xea0184 0x10>;
> +		chip: chip-control@ea0000 {
> +			compatible = "marvell,berlin2-chip-ctrl";
> +			#clock-cells = <1>;
> +			reg = <0xea0000 0x400>;
> +			clocks = <&refclk>;
> +			clock-names = "refclk";
>  		};
>  
>  		apb@fc0000 {
> @@ -305,7 +295,7 @@
>  				reg-shift = <2>;
>  				reg-io-width = <1>;
>  				interrupts = <8>;
> -				clocks = <&smclk>;
> +				clocks = <&refclk>;
>  				status = "disabled";
>  			};
>  
> @@ -315,7 +305,7 @@
>  				reg-shift = <2>;
>  				reg-io-width = <1>;
>  				interrupts = <9>;
> -				clocks = <&smclk>;
> +				clocks = <&refclk>;
>  				status = "disabled";
>  			};
>  
> @@ -325,7 +315,7 @@
>  				reg-shift = <2>;
>  				reg-io-width = <1>;
>  				interrupts = <10>;
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
