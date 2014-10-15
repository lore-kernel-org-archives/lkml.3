Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaJOOJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:09:52 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60841 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaJOOJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:09:50 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: rockchip: add I2S controllers for rk3066 and rk3188
Date: Wed, 15 Oct 2014 16:07:55 +0200
Message-ID: <5010451.G368NqnOYK@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1413274597-15788-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1413274597-15788-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julien,

Am Dienstag, 14. Oktober 2014, 10:16:37 schrieb Julien CHAUVEAU:
> Add the I2S/PCM controller nodes and pin controls for rk3066 and rk3188.
> 
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>

I've added the patch to my wip dts branch on github - which will move to 
kernel.org after -rc1

> ---

In the future for v2 and onwards patches, please provide a changelog in the 
comment section (after the "---"), so people can see what changed, like:

changes since v1:
- declare i2s nodes separately on rk3066 and rk3188 as the controllers differ

This doesn't get into the kernel itself, but is helpful for people reviewing 
the patch.

>  arch/arm/boot/dts/rk3066a.dtsi | 81
> ++++++++++++++++++++++++++++++++++++++++++ arch/arm/boot/dts/rk3188.dtsi  |
> 26 ++++++++++++++
>  2 files changed, 107 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
> index ad9c2db..d75b01a 100644
> --- a/arch/arm/boot/dts/rk3066a.dtsi
> +++ b/arch/arm/boot/dts/rk3066a.dtsi
> @@ -53,6 +53,51 @@
>  		};
>  	};
> 
> +	i2s0: i2s@10118000 {
> +		compatible = "rockchip,rk3066-i2s";
> +		reg = <0x10118000 0x2000>;
> +		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2s0_bus>;
> +		dmas = <&dmac1_s 4>, <&dmac1_s 5>;
> +		dma-names = "tx", "rx";
> +		clock-names = "i2s_hclk", "i2s_clk";
> +		clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
> +		status = "disabled";
> +	};
> +
> +	i2s1: i2s@1011a000 {
> +		compatible = "rockchip,rk3066-i2s";
> +		reg = <0x1011a000 0x2000>;
> +		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2s1_bus>;
> +		dmas = <&dmac1_s 6>, <&dmac1_s 7>;
> +		dma-names = "tx", "rx";
> +		clock-names = "i2s_hclk", "i2s_clk";
> +		clocks = <&cru HCLK_I2S1>, <&cru SCLK_I2S1>;
> +		status = "disabled";
> +	};
> +
> +	i2s2: i2s@1011c000 {
> +		compatible = "rockchip,rk3066-i2s";
> +		reg = <0x1011c000 0x2000>;
> +		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2s2_bus>;
> +		dmas = <&dmac1_s 9>, <&dmac1_s 10>;
> +		dma-names = "tx", "rx";
> +		clock-names = "i2s_hclk", "i2s_clk";
> +		clocks = <&cru HCLK_I2S2>, <&cru SCLK_I2S2>;
> +		status = "disabled";
> +	};
> +
>  	cru: clock-controller@20000000 {
>  		compatible = "rockchip,rk3066a-cru";
>  		reg = <0x20000000 0x1000>;
> @@ -405,6 +450,42 @@
>  						<RK_GPIO3 20 RK_FUNC_1 &pcfg_pull_default>;
>  			};
>  		};
> +
> +		i2s0 {
> +			i2s0_bus: i2s0-bus {
> +				rockchip,pins = <RK_GPIO0 7 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 8 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 9 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 10 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 11 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 12 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 13 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 14 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 15 RK_FUNC_1 &pcfg_pull_default>;
> +			};
> +		};
> +
> +		i2s1 {
> +			i2s1_bus: i2s1-bus {
> +				rockchip,pins = <RK_GPIO0 16 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 17 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 18 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 19 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 20 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 21 RK_FUNC_1 &pcfg_pull_default>;
> +			};
> +		};
> +
> +		i2s2 {
> +			i2s2_bus: i2s2-bus {
> +				rockchip,pins = <RK_GPIO0 24 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 25 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 26 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 27 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 28 RK_FUNC_1 &pcfg_pull_default>,
> +						<RK_GPIO0 29 RK_FUNC_1 &pcfg_pull_default>;
> +			};
> +		};
>  	};
>  };
> 
> diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
> index ddaada7..fa3665a 100644
> --- a/arch/arm/boot/dts/rk3188.dtsi
> +++ b/arch/arm/boot/dts/rk3188.dtsi
> @@ -65,6 +65,21 @@
>  		};
>  	};
> 
> +	i2s0: i2s@1011a000 {
> +		compatible = "rockchip,rk3188-i2s", "rockchip,rk3066-i2s";
> +		reg = <0x1011a000 0x2000>;
> +		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&i2s0_bus>;
> +		dmas = <&dmac1_s 6>, <&dmac1_s 7>;
> +		dma-names = "tx", "rx";
> +		clock-names = "i2s_hclk", "i2s_clk";
> +		clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
> +		status = "disabled";
> +	};
> +
>  	cru: clock-controller@20000000 {
>  		compatible = "rockchip,rk3188-cru";
>  		reg = <0x20000000 0x1000>;
> @@ -395,6 +410,17 @@
>  						<RK_GPIO3 20 RK_FUNC_1 &pcfg_pull_none>;
>  			};
>  		};
> +
> +		i2s0 {
> +			i2s0_bus: i2s0-bus {
> +				rockchip,pins = <RK_GPIO1 16 RK_FUNC_1 &pcfg_pull_none>,
> +						<RK_GPIO1 17 RK_FUNC_1 &pcfg_pull_none>,
> +						<RK_GPIO1 18 RK_FUNC_1 &pcfg_pull_none>,
> +						<RK_GPIO1 19 RK_FUNC_1 &pcfg_pull_none>,
> +						<RK_GPIO1 20 RK_FUNC_1 &pcfg_pull_none>,
> +						<RK_GPIO1 21 RK_FUNC_1 &pcfg_pull_none>;
> +			};
> +		};
>  	};
>  };
