Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaKYJ4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:56:19 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:48019 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaKYJ4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:56:17 -0500
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: eddie.cai@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <ac1275fa68a6276692d8039b249b97bd>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <54745229.2040503@rock-chips.com>
Date: Tue, 25 Nov 2014 17:55:53 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Roger Chen <roger.chen@rock-chips.com>, heiko@sntech.de
CC: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        mark.yao@rock-chips.com, eddie.cai@rock-chips.com
Subject: Re: [PATCH 3/4] GMAC: dts: add gmac info for rk3288
References: <1416906536-26158-1-git-send-email-roger.chen@rock-chips.com>
In-Reply-To: <1416906536-26158-1-git-send-email-roger.chen@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

The Subject should use below prefix:
ARM: dts: rockchip: add gmac info for rk3288

On 11/25/2014 05:08 PM, Roger Chen wrote:
> add gmac info in rk3288.dtsi for GMAC driver
>
> Signed-off-by: Roger Chen <roger.chen@rock-chips.com>
> ---
>   arch/arm/boot/dts/rk3288.dtsi |   59 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 59 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 0f50d5d..949675d 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -137,6 +137,13 @@
>   		#clock-cells = <0>;
>   	};
>   
> +	ext_gmac: external-gmac-clock {
> +		compatible = "fixed-clock";
> +		clock-frequency = <125000000>;
> +		clock-output-names = "ext_gmac";
> +		#clock-cells = <0>;
> +	};
> +
I'm not sure Heiko will happy with both add the new clock source and
gmac node in these patch.

>   	timer {
>   		compatible = "arm,armv7-timer";
>   		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
> @@ -490,6 +497,25 @@
>   		reg = <0xff740000 0x1000>;
>   	};
>   
> +	gmac: eth@ff290000 {
> +		compatible = "rockchip,rk3288-gmac";
> +		reg = <0xff290000 0x10000>;
> +		interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;  /*irq=59*/
> +		interrupt-names = "macirq";
> +		rockchip,grf = <&grf>;
> +		clocks = <&cru SCLK_MAC>, <&cru SCLK_MAC_PLL>,
> +			<&cru SCLK_MAC_RX>, <&cru SCLK_MAC_TX>,
> +			<&cru SCLK_MACREF>, <&cru SCLK_MACREF_OUT>,
> +			<&cru ACLK_GMAC>, <&cru PCLK_GMAC>;
> +		clock-names = "stmmaceth", "clk_mac_pll",
> +			"mac_clk_rx", "mac_clk_tx",
> +			"clk_mac_ref", "clk_mac_refout",
> +			"aclk_mac", "pclk_mac";
> +		phy-mode = "rgmii";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&rgmii_pin /*&rmii_pin*/>;
> +	};
> +
The controller dts node should be sort by the base address, I'm sure 
this is in a
wrong place.

- Kever
>   	cru: clock-controller@ff760000 {
>   		compatible = "rockchip,rk3288-cru";
>   		reg = <0xff760000 0x1000>;
> @@ -1040,5 +1066,38 @@
>   				rockchip,pins = <7 23 3 &pcfg_pull_none>;
>   			};
>   		};
> +
> +		gmac {
> +			rgmii_pin: rgmii-pins {
> +				rockchip,pins = <3 30 3 &pcfg_pull_none>,
> +						<3 31 3 &pcfg_pull_none>,
> +						<3 26 3 &pcfg_pull_none>,
> +						<3 27 3 &pcfg_pull_none>,
> +						<3 28 3 &pcfg_pull_none>,
> +						<3 29 3 &pcfg_pull_none>,
> +						<3 24 3 &pcfg_pull_none>,
> +						<3 25 3 &pcfg_pull_none>,
> +						<4 0 3 &pcfg_pull_none>,
> +						<4 5 3 &pcfg_pull_none>,
> +						<4 6 3 &pcfg_pull_none>,
> +						<4 9 3 &pcfg_pull_none>,
> +						<4 4 3 &pcfg_pull_none>,
> +						<4 1 3 &pcfg_pull_none>,
> +						<4 3 3 &pcfg_pull_none>;
> +			};
> +
> +			rmii_pin: rmii-pins {
> +				rockchip,pins = <3 30 3 &pcfg_pull_none>,
> +						<3 31 3 &pcfg_pull_none>,
> +						<3 28 3 &pcfg_pull_none>,
> +						<3 29 3 &pcfg_pull_none>,
> +						<4 0 3 &pcfg_pull_none>,
> +						<4 5 3 &pcfg_pull_none>,
> +						<4 4 3 &pcfg_pull_none>,
> +						<4 1 3 &pcfg_pull_none>,
> +						<4 2 3 &pcfg_pull_none>,
> +						<4 3 3 &pcfg_pull_none>;
> +			};
> +		};
>   	};
>   };

