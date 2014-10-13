Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaJMXTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 19:19:07 -0400
Received: from gloria.sntech.de ([95.129.55.99]:46103 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbaJMXTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 19:19:03 -0400
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
Subject: Re: [PATCH] ARM: dts: rockchip: add I2S controllers for rk3066 and rk3188
Date: Tue, 14 Oct 2014 01:18:43 +0200
Message-ID: <2160726.VoB23RZ6vO@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1413208265-20372-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1413208265-20372-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julien,

Am Montag, 13. Oktober 2014, 15:51:04 schrieb Julien CHAUVEAU:
> Add the I2S/PCM controller nodes and pin controls for rk3066 and rk3188.
> 
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
> ---
>  arch/arm/boot/dts/rk3066a.dtsi | 51
> ++++++++++++++++++++++++++++++++++++++++++ arch/arm/boot/dts/rk3188.dtsi  |
> 16 +++++++++++++
>  arch/arm/boot/dts/rk3xxx.dtsi  | 39 ++++++++++++++++++++++++++++++++
>  3 files changed, 106 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
> index ad9c2db..7c4cd86 100644
> --- a/arch/arm/boot/dts/rk3066a.dtsi
> +++ b/arch/arm/boot/dts/rk3066a.dtsi
> @@ -405,6 +405,42 @@
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
> @@ -473,6 +509,21 @@
>  	pinctrl-0 = <&spi1_clk &spi1_tx &spi1_rx &spi1_cs0>;
>  };
> 
> +&i2s0 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&i2s0_bus>;
> +};
> +
> +&i2s1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&i2s1_bus>;
> +};
> +
> +&i2s2 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&i2s2_bus>;
> +};
> +
>  &uart0 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&uart0_xfer>;
> diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
> index ddaada7..04ef487 100644
> --- a/arch/arm/boot/dts/rk3188.dtsi
> +++ b/arch/arm/boot/dts/rk3188.dtsi
> @@ -395,6 +395,17 @@
>  						<RK_GPIO3 20 RK_FUNC_1 &pcfg_pull_none>;
>  			};
>  		};
> +
> +		i2s1 {
> +			i2s1_bus: i2s1-bus {

rk3188 only has one i2s controller, so this should be i2s0

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
> 
> @@ -472,6 +483,11 @@
>  	pinctrl-0 = <&spi1_clk &spi1_tx &spi1_rx &spi1_cs0>;
>  };
> 
> +&i2s1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&i2s1_bus>;
> +};
> +
>  &uart0 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&uart0_xfer>;
> diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
> index 499468d..75b7982 100644
> --- a/arch/arm/boot/dts/rk3xxx.dtsi
> +++ b/arch/arm/boot/dts/rk3xxx.dtsi
> @@ -112,6 +112,45 @@
>  		      <0x1013c100 0x0100>;
>  	};
> 
> +	i2s0: i2s@10118000 {
> +		compatible = "rockchip,rk3066-i2s";
> +		reg = <0x10118000 0x2000>;
> +		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
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
> +		dmas = <&dmac1_s 9>, <&dmac1_s 10>;
> +		dma-names = "tx", "rx";
> +		clock-names = "i2s_hclk", "i2s_clk";
> +		clocks = <&cru HCLK_I2S2>, <&cru SCLK_I2S2>;
> +		status = "disabled";
> +	};
> +

As stated above, rk3188 only has one i2s controller at all, so this block of 
the 3 i2s controllers should move to rk3066a.dtsi and rk3188.dtsi should get 
its own, like

+	i2s0: i2s@1011a000 {
+		compatible = "rockchip,rk3066-i2s";
+		reg = <0x1011a000 0x2000>;
+		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		dmas = <&dmac1_s 6>, <&dmac1_s 7>;
+		dma-names = "tx", "rx";
+		clock-names = "i2s_hclk", "i2s_clk";
+		clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
+		status = "disabled";
+	};

Especially as the clock for the one i2s controller of the rk3188 is of course 
labeled xCLK_I2S0.

Also, please sort device nodes by their address when adding them to the dtsi 
files.


Thanks
Heiko


>  	uart0: serial@10124000 {
>  		compatible = "snps,dw-apb-uart";
>  		reg = <0x10124000 0x400>;

