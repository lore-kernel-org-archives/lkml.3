Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaDOJXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:23:12 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:62971 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaDOJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:23:08 -0400
Message-ID: <534CFA77.9030108@gmail.com>
Date: Tue, 15 Apr 2014 11:23:03 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: berlin: add GPIO nodes for the BG2Q
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com> <1397549245-3338-3-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1397549245-3338-3-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 10:07 AM, Antoine Ténart wrote:
> The Marvell Berlin BG2Q has 6 GPIO ports compatible with the snps,dw-apb-gpio
> driver. This patch add the corresponding device tree nodes.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2q.dtsi | 102 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 102 insertions(+)
>
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index e6e556055dfc..b2625f896bc5 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -109,6 +109,78 @@
>   			ranges = <0 0xe80000 0x10000>;
>   			interrupt-parent = <&aic>;
>
> +			gpio0: gpio@0400 {
> +				compatible = "snps,dw-apb-gpio";
> +				reg = <0x0400 0x400>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				porta: gpio-controller@0 {

ePAPR recommended name is even more generic, i.e. "gpio". If
that clashed in any way with other numbered names, I suggest
to rename to "gpio-port" as actually the controller is the
parent node and this represents one port (in the nomenclature
of DW-APB-GPIO).

> +					compatible = "snps,dw-apb-gpio-port";
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					snps,nr-gpios = <32>;

32 gpio pins for each of the 6 GPIO controllers? Either BG2Q is a GPIO
beast or it is a mistake :P

Can you please double-check?

I am fine with using nr-gpios property now, but I guess BG2Q also
has that CONFIG[1,2] registers to actually read out the features
synthesized in? If I find some time, I'll prepare a patch for
dw-apb-gpio to exploit that (optional) information instead of
using nr-gpios.

Otherwise,

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> +					reg = <0>;
> +					interrupt-controller;
> +					#interrupt-cells = <2>;
> +					interrupts = <0>;
> +				};
> +			};
> +
> +			gpio1: gpio@0800 {
> +				compatible = "snps,dw-apb-gpio";
> +				reg = <0x0800 0x400>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				portb: gpio-controller@1 {
> +					compatible = "snps,dw-apb-gpio-port";
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					snps,nr-gpios = <32>;
> +					reg = <0>;
> +					interrupt-controller;
> +					#interrupt-cells = <2>;
> +					interrupts = <1>;
> +				};
> +			};
> +
> +			gpio2: gpio@0c00 {
> +				compatible = "snps,dw-apb-gpio";
> +				reg = <0x0c00 0x400>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				portc: gpio-controller@2 {
> +					compatible = "snps,dw-apb-gpio-port";
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					snps,nr-gpios = <32>;
> +					reg = <0>;
> +					interrupt-controller;
> +					#interrupt-cells = <2>;
> +					interrupts = <2>;
> +				};
> +			};
> +
> +			gpio3: gpio@1000 {
> +				compatible = "snps,dw-apb-gpio";
> +				reg = <0x1000 0x400>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				portd: gpio-controller@3 {
> +					compatible = "snps,dw-apb-gpio-port";
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					snps,nr-gpios = <32>;
> +					reg = <0>;
> +					interrupt-controller;
> +					#interrupt-cells = <2>;
> +					interrupts = <3>;
> +				};
> +			};
> +
>   			timer0: timer@2c00 {
>   				compatible = "snps,dw-apb-timer";
>   				reg = <0x2c00 0x14>;
> @@ -181,6 +253,36 @@
>   				interrupt-parent = <&gic>;
>   				interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
>   			};
> +
> +			gpio4: gpio@5000 {
> +				compatible = "snps,dw-apb-gpio";
> +				reg = <0x5000 0x400>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				porte: gpio-controller@4 {
> +					compatible = "snps,dw-apb-gpio-port";
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					snps,nr-gpios = <32>;
> +					reg = <0>;
> +				};
> +			};
> +
> +			gpio5: gpio@c000 {
> +				compatible = "snps,dw-apb-gpio";
> +				reg = <0xc000 0x400>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				portf: gpio-controller@5 {
> +					compatible = "snps,dw-apb-gpio-port";
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					snps,nr-gpios = <32>;
> +					reg = <0>;
> +				};
> +			};
>   		};
>
>   		pinctrl: pinctrl@0 {
>

