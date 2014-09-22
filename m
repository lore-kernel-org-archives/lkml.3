Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaIVOgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:36:04 -0400
Received: from gloria.sntech.de ([95.129.55.99]:44230 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbaIVOgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:36:00 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jianqun <jay.xu@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH v2] ARM: dts: add rk3288 i2s controller
Date: Mon, 22 Sep 2014 16:35:27 +0200
Message-ID: <2576845.mbFzWJ2q3T@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1410519295-18980-1-git-send-email-jay.xu@rock-chips.com>
References: <1410509511-16667-1-git-send-email-jay.xu@rock-chips.com> <1410519295-18980-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 12. September 2014, 18:54:55 schrieb Jianqun:
> Add dt for rk3288 i2s controller, since i2s clock pins and data pins
> default to be GPIO, this patch also add pinctrl to mux them.
> 
> Tested on RK3288 board.
> 
> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>

I've added this to my tree.

> ---
> change since v1:
> - move i2s relate codes later in order by CPU address map
> 
>  arch/arm/boot/dts/rk3288.dtsi | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 5950b0a..5b17718 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -271,6 +271,21 @@
>  		status = "disabled";
>  	};
> 
> +	i2s: i2s@ff890000 {
> +		compatible = "rockchip,rk3288-i2s", "rockchip,rk3066-i2s";
> +		reg = <0xff890000 0x10000>;
> +		interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		dmas = <&dmac_bus_s 0>, <&dmac_bus_s 1>;
> +		dma-names = "tx", "rx";
> +		clock-names = "i2s_hclk", "i2s_clk";
> +		clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2s0_clk>;
> +		status = "disabled";
> +	};
> +
>  	gic: interrupt-controller@ffc01000 {
>  		compatible = "arm,gic-400";
>  		interrupt-controller;
> @@ -463,6 +478,17 @@
>  			};
>  		};
> 
> +		i2s0 {
> +			i2s0_clk: i2s0_clk {
> +				rockchip,pins = <6 0 RK_FUNC_1 &pcfg_pull_none>,
> +						<6 1 RK_FUNC_1 &pcfg_pull_none>,
> +						<6 2 RK_FUNC_1 &pcfg_pull_none>,
> +						<6 3 RK_FUNC_1 &pcfg_pull_none>,
> +						<6 4 RK_FUNC_1 &pcfg_pull_none>,
> +						<6 8 RK_FUNC_1 &pcfg_pull_none>;
> +			};
> +		};
> +
>  		sdmmc {
>  			sdmmc_clk: sdmmc-clk {
>  				rockchip,pins = <6 20 RK_FUNC_1 &pcfg_pull_none>;

