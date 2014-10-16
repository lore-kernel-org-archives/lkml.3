Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaJPVxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:53:24 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60457 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaJPVxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:53:21 -0400
Date: Thu, 16 Oct 2014 14:53:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com,
        vladimir_zapolskiy@mentor.com
Subject: Re: [PATCH v11 4/5] ARM: dts: add main Thermal info to rk3288
Message-ID: <20141016215316.GA30009@dtor-ws>
References: <1413466301-25952-1-git-send-email-caesar.wang@rock-chips.com>
 <1413466301-25952-5-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413466301-25952-5-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On Thu, Oct 16, 2014 at 09:31:40PM +0800, Caesar Wang wrote:
> This patch is depend on rk3288-thermal.dtsi,or
> it will compile error.
> 
> If the temperature over a period of time High,over 120C
> the resulting TSHUT gave CRU module,let it reset
> the entire chip,or via GPIO give PMIC.
> 
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index cb18bb4..bf34111 100644
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
> @@ -346,6 +347,19 @@
>  		status = "disabled";
>  	};
>  
> +	tsadc: tsadc@ff280000 {
> +		compatible = "rockchip,rk3288-tsadc";
> +		reg = <0xff280000 0x100>;
> +		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
> +		clock-names = "tsadc", "apb_pclk";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&otp_out>;
> +		#thermal-sensor-cells = <1>;
> +		hw-shut-temp = <120000>;
> +		status = "disabled"

It looks like you are missing semicolon here.

> +	};
> +
>  	usb_host0_ehci: usb@ff500000 {
>  		compatible = "generic-ehci";
>  		reg = <0xff500000 0x100>;
> @@ -965,6 +979,12 @@
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
