Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaJ1A0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:26:05 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49634 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaJ1A0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:26:01 -0400
Date: Mon, 27 Oct 2014 17:25:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v14 4/5] ARM: dts: add main Thermal info to rk3288
Message-ID: <20141028002555.GH7594@dtor-ws>
References: <1414377588-2237-1-git-send-email-caesar.wang@rock-chips.com>
 <1414377588-2237-5-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414377588-2237-5-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:39:47AM +0800, Caesar Wang wrote:
> This patch is depend on rk3288-thermal.dtsi,or
> it will compile error.
> 
> If for some reason we are unable to shut it down
> in orderly fashion (kernel is stuck holding a lock or
> similar), then hardware TSHUT will reset it.
> 
> If the temperature over a period of time High,over 125C
> the resulting TSHUT gave CRU module,let it reset
> the entire chip,or via GPIO give PMIC.
> 
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
>  arch/arm/boot/dts/rk3288.dtsi | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index cb18bb4..85855a6 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -15,6 +15,7 @@
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>  #include <dt-bindings/pinctrl/rockchip.h>
>  #include <dt-bindings/clock/rk3288-cru.h>
> +#include <dt-bindings/thermal/thermal.h>
>  #include "skeleton.dtsi"
>  
>  / {
> @@ -66,6 +67,7 @@
>  				 216000  900000
>  				 126000  900000
>  			>;
> +			#cooling-cells = <2>; /* min followed by max */
>  			clock-latency = <40000>;
>  			clocks = <&cru ARMCLK>;
>  		};
> @@ -346,6 +348,23 @@
>  		status = "disabled";
>  	};
>  
> +	thermal-zones {
> +		#include "rk3288-thermal.dtsi"
> +	};
> +
> +	tsadc: tsadc@ff280000 {
> +		compatible = "rockchip,rk3288-tsadc";
> +		reg = <0xff280000 0x100>;
> +		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
> +		clock-names = "tsadc", "apb_pclk";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&otp_out>;
> +		#thermal-sensor-cells = <1>;
> +		hw-shut-temp = <125000>;
> +		status = "disabled";
> +	};
> +
>  	usb_host0_ehci: usb@ff500000 {
>  		compatible = "generic-ehci";
>  		reg = <0xff500000 0x100>;
> @@ -965,6 +984,12 @@
>  			};
>  		};
>  
> +		tsadc {
> +			otp_out: otp-out {
> +				rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_none>;
> +			};
> +		};
> +
>  		pwm0 {
>  			pwm0_pin: pwm0-pin {
>  				rockchip,pins = <7 0 RK_FUNC_1 &pcfg_pull_none>;
> -- 
> 1.9.1
> 
> 

-- 
Dmitry
