Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaDZJvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 05:51:54 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50489 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaDZJvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 05:51:50 -0400
Message-ID: <535B81B0.8020302@gmail.com>
Date: Sat, 26 Apr 2014 11:51:44 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        linus.walleij@linaro.org
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] ARM: dts: berlin: add the pinctrl node and muxing
 setup for uarts
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com> <1398268276-9696-8-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1398268276-9696-8-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 05:51 PM, Antoine Ténart wrote:
> The uart0 pinmux configuration is in the dtsi because uart0 will always
> use uart0-pmux to work, no other possibility. Same thing for uart1.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  arch/arm/boot/dts/berlin2.dtsi   | 24 ++++++++++++++++++++++++
>  arch/arm/boot/dts/berlin2cd.dtsi | 17 +++++++++++++++++
>  arch/arm/boot/dts/berlin2q.dtsi  | 24 ++++++++++++++++++++++++
>  3 files changed, 65 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> index 56a1af2f1052..9a13891c38a3 100644
> --- a/arch/arm/boot/dts/berlin2.dtsi
> +++ b/arch/arm/boot/dts/berlin2.dtsi
> @@ -176,6 +176,11 @@
>  			};
>  		};
>  
> +		soc_pinctrl: pin-controller@ea0000 {
> +			compatible = "marvell,berlin2-soc-pinctrl";
> +			reg = <0xea0000 0x4c>;
> +		};
> +
>  		apb@fc0000 {
>  			compatible = "simple-bus";
>  			#address-cells = <1>;
> @@ -184,6 +189,21 @@
>  			ranges = <0 0xfc0000 0x10000>;
>  			interrupt-parent = <&sic>;
>  
> +			sm_pinctrl: pin-controller@0000 {
> +				compatible = "marvell,berlin2-sysmgr-pinctrl";
> +				reg = <0x0000 0x44>;
> +
> +				uart0_pmux: uart0-pmux {
> +					marvell,groups = "GSM4";
> +					marvell,function = "uart0";
> +				};
> +
> +				uart1_pmux: uart1-pmux {
> +					marvell,groups = "GSM5";
> +					marvell,function = "uart1";
> +				};

There is three uarts in BG2, we have the node already. Please add

uart2_pmux: uart2-pmux {
	marvell,groups = "GSM3";
	marvell,function = "uart2";
};

here and in the corresponding node:

pinctrl-0 = <&uart2_pmux>;
pinctrl-names = "default";

Sebastian

> +			};
> +
>  			uart0: serial@9000 {
>  				compatible = "snps,dw-apb-uart";
>  				reg = <0x9000 0x100>;
> @@ -191,6 +211,8 @@
>  				reg-io-width = <1>;
>  				interrupts = <8>;
>  				clocks = <&smclk>;
> +				pinctrl-0 = <&uart0_pmux>;
> +				pinctrl-names = "default";
>  				status = "disabled";
>  			};
>  
> @@ -201,6 +223,8 @@
>  				reg-io-width = <1>;
>  				interrupts = <9>;
>  				clocks = <&smclk>;
> +				pinctrl-0 = <&uart1_pmux>;
> +				pinctrl-names = "default";
>  				status = "disabled";
>  			};
>  
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index 094968c27533..a802d3fe5da6 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -169,6 +169,11 @@
>  			};
>  		};
>  
> +		soc_pinctrl: pin-controller@ae0000 {
> +			compatible = "marvell,berlin2cd-soc-pinctrl";
> +			reg = <0xea0000 0x4c>;
> +		};
> +
>  		apb@fc0000 {
>  			compatible = "simple-bus";
>  			#address-cells = <1>;
> @@ -177,6 +182,16 @@
>  			ranges = <0 0xfc0000 0x10000>;
>  			interrupt-parent = <&sic>;
>  
> +			sm_pinctrl: pin-controller@0000 {
> +				compatible = "marvell,berlin2cd-sysmgr-pinctrl";
> +				reg = <0x0000 0x44>;
> +
> +				uart0_pmux: uart0-pmux {
> +					marvell,groups = "G6";
> +					marvell,function = "uart0";
> +				};
> +			};
> +
>  			uart0: serial@9000 {
>  				compatible = "snps,dw-apb-uart";
>  				reg = <0x9000 0x100>;
> @@ -184,6 +199,8 @@
>  				reg-io-width = <1>;
>  				interrupts = <8>;
>  				clocks = <&smclk>;
> +				pinctrl-0 = <&uart0_pmux>;
> +				pinctrl-names = "default";
>  				status = "disabled";
>  			};
>  
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 07452a7483fa..734debbf072f 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -183,6 +183,11 @@
>  			};
>  		};
>  
> +		soc_pinctrl: pin-controller@ea0000 {
> +			compatible = "marvell,berlin2q-soc-pinctrl";
> +			reg = <0xea0000 0x4c>;
> +		};
> +
>  		apb@fc0000 {
>  			compatible = "simple-bus";
>  			#address-cells = <1>;
> @@ -198,6 +203,8 @@
>  				interrupts = <8>;
>  				clocks = <&smclk>;
>  				reg-shift = <2>;
> +				pinctrl-0 = <&uart0_pmux>;
> +				pinctrl-names = "default";
>  				status = "disabled";
>  			};
>  
> @@ -208,9 +215,26 @@
>  				interrupts = <9>;
>  				clocks = <&smclk>;
>  				reg-shift = <2>;
> +				pinctrl-0 = <&uart1_pmux>;
> +				pinctrl-names = "default";
>  				status = "disabled";
>  			};
>  
> +			sm_pinctrl: pin-controller@d000 {
> +				compatible = "marvell,berlin2q-sysmgr-pinctrl";
> +				reg = <0xd000 0x44>;
> +
> +				uart0_pmux: uart0-pmux {
> +					marvell,groups = "GSM12";
> +					marvell,function = "uart0";
> +				};
> +
> +				uart1_pmux: uart1-pmux {
> +					marvell,groups = "GSM14";
> +					marvell,function = "uart1";
> +				};
> +			};
> +
>  			sic: interrupt-controller@e000 {
>  				compatible = "snps,dw-apb-ictl";
>  				reg = <0xe000 0x30>;
> 

