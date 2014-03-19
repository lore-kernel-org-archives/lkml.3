Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923AbaCSMZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:25:49 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:51462 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbaCSMZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:25:12 -0400
Message-ID: <53298D9F.7060205@gmail.com>
Date: Wed, 19 Mar 2014 13:29:19 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] ARM: dts: berlin2q: add the Marvell Armada 1500
 pro
References: <1395153167-21029-1-git-send-email-antoine.tenart@free-electrons.com> <1395153167-21029-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1395153167-21029-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 03:32 PM, Antoine Ténart wrote:
> Adds initial support for the Marvell Armada 1500 pro (BG2Q) SoC (Berlin family).
> The SoC has nodes for cpu, l2 cache controller, interrupt controllers, local
> timer, apb timers and uarts for now.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2q.dtsi | 224 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 224 insertions(+)
>   create mode 100644 arch/arm/boot/dts/berlin2q.dtsi
>
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> new file mode 100644
> index 000000000000..aa90c273fdf2
> --- /dev/null
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
[...]
> +	smclk: sysmgr-clock {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <25000000>;
> +	};
[...]
> +		apb@fc0000 {
> +			compatible = "simple-bus";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +
> +			ranges = <0 0xfc0000 0x10000>;
> +			interrupt-parent = <&sic>;
> +
> +			uart0: uart@9000 {
> +				compatible = "snps,dw-apb-uart";
> +				reg = <0x9000 0x100>;
> +				interrupt-parent = <&sic>;
> +				interrupts = <8>;
> +				clock-frequency = <25000000>;
> +				reg-shift = <2>;
> +				status = "disabled";
> +			};
> +
> +			uart1: uart@a000 {
> +				compatible = "snps,dw-apb-uart";
> +				reg = <0xa000 0x100>;
> +				interrupt-parent = <&sic>;
> +				interrupts = <9>;
> +				clock-frequency = <25000000>;
> +				reg-shift = <2>;
> +				status = "disabled";
> +			};

Antoine,

I have tentatively applied this to berlin/dt with a small fixup we
discussed on IRC:

uart0/uart1 clock-frequency = <foo>; replaced by clocks = <&smclk>;

For now, as I don't have a non-github repo yet, you'll find the
branches on:

https://github.com/shesselba/linux-berlin.git

There is also a for-next branch that will become be part of linux/next
as soon as I figured out how to request it being pulled.

Sebastian

