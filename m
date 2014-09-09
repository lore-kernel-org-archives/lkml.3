Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaIILfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:35:25 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47852 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbaIILfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:35:23 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: rui.zhang@intel.com, edubezval@gmail.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com, dianders@chromium.org,
        dtor@chromium.org, zyw@rock-chips.com, addy.ke@rock-chips.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH v4 3/4] ARM: dts: add main Thermal info to rk3288
Date: Tue, 09 Sep 2014 13:37:31 +0200
Message-ID: <3426113.Zcq8V2S7cg@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1409710239-19941-4-git-send-email-caesar.wang@rock-chips.com>
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com> <1409710239-19941-4-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. September 2014, 10:10:38 schrieb Caesar Wang:
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 36be7bb..3d672e3 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -224,6 +224,17 @@
>  		status = "disabled";
>  	};
> 
> +	tsadc: tsadc@ff280000 {

please keep the list of nodes sorted by register address. So when looking at 
my v3.18-next/dts branch, it should be after uart4: serial@ff1c0000 and before 
usb_host0_ehci: usb@ff500000 .


> +		compatible = "rockchip,rk3288-tsadc";
> +		reg = <0xff280000 0x100>;
> +		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
> +		clock-names = "tsadc", "apb_pclk";
> +		pinctrl-names = "default";
> +		pinctrl-1 = <&tsadc_int>;
> +		status = "disabled";
> +	};
> +
>  	/* NOTE: ohci@ff520000 doesn't actually work on hardware */
> 
>  	usb_hsic: usb@ff5c0000 {
> @@ -611,5 +622,12 @@
>  				rockchip,pins = <5 15 3 &pcfg_pull_none>;
>  			};
>  		};
> +
> +		tsadc {
> +			tsadc_int: tsadc-int {
> +				rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_up>;
> +			};
> +		};

After looking this up in the schematics I see that this is the 
overtemperature-protection output pin ... labeled OTP_OUT.
So I'd think the pinconfig should reflect this pin-name, especially as tsadc-int 
suggests, that this would be an interrupt leading into the tsadc, while in 
fact it is an output to a separate circuit.


Heiko
