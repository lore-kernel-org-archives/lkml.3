Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbbAGOij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:38:39 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:64922 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbbAGOii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:38:38 -0500
Message-ID: <54AD44E8.5000105@gmail.com>
Date: Wed, 07 Jan 2015 15:38:32 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Jisheng Zhang <jszhang@marvell.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, antoine.tenart@free-electrons.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ARM: dts: berlin: correct BG2Q's SM GPIO location.
References: <1419584281-4811-1-git-send-email-jszhang@marvell.com> <1419584281-4811-4-git-send-email-jszhang@marvell.com>
In-Reply-To: <1419584281-4811-4-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.12.2014 09:58, Jisheng Zhang wrote:
> The gpio4 and gpio5 are in 0xf7fc0000 apb which is located in the SM domain.
> This patch moves gpio4 and gpio5 to the correct location. This patch also
> renames them as the following to match the names we internally used in
> marvell:
> 	gpio4 -> sm_gpio1
> 	gpio5 -> sm_gpio0
> 	porte -> portf
> 	portf -> porte
>
> This also matches what we did for BG2 and BG2CD's SM GPIO.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Jisheng,

please do not add unrelated patches to an existing patch set.

Anyway, applied to berlin/fixes. It will also be Cc'd to stable
from 3.16 onwards due to the broken gpio base address.

Thanks!

Sebastian

> ---
>   arch/arm/boot/dts/berlin2q.dtsi | 60 ++++++++++++++++++++---------------------
>   1 file changed, 30 insertions(+), 30 deletions(-)
>
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 41a683f..f0ddbec 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -356,36 +356,6 @@
>   				interrupt-parent = <&gic>;
>   				interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
>   			};
> -
> -			gpio4: gpio@5000 {
> -				compatible = "snps,dw-apb-gpio";
> -				reg = <0x5000 0x400>;
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -
> -				porte: gpio-port@4 {
> -					compatible = "snps,dw-apb-gpio-port";
> -					gpio-controller;
> -					#gpio-cells = <2>;
> -					snps,nr-gpios = <32>;
> -					reg = <0>;
> -				};
> -			};
> -
> -			gpio5: gpio@c000 {
> -				compatible = "snps,dw-apb-gpio";
> -				reg = <0xc000 0x400>;
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -
> -				portf: gpio-port@5 {
> -					compatible = "snps,dw-apb-gpio-port";
> -					gpio-controller;
> -					#gpio-cells = <2>;
> -					snps,nr-gpios = <32>;
> -					reg = <0>;
> -				};
> -			};
>   		};
>
>   		chip: chip-control@ea0000 {
> @@ -474,6 +444,21 @@
>   			ranges = <0 0xfc0000 0x10000>;
>   			interrupt-parent = <&sic>;
>
> +			sm_gpio1: gpio@5000 {
> +				compatible = "snps,dw-apb-gpio";
> +				reg = <0x5000 0x400>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				portf: gpio-port@5 {
> +					compatible = "snps,dw-apb-gpio-port";
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					snps,nr-gpios = <32>;
> +					reg = <0>;
> +				};
> +			};
> +
>   			i2c2: i2c@7000 {
>   				compatible = "snps,designware-i2c";
>   				#address-cells = <1>;
> @@ -524,6 +509,21 @@
>   				status = "disabled";
>   			};
>
> +			sm_gpio0: gpio@c000 {
> +				compatible = "snps,dw-apb-gpio";
> +				reg = <0xc000 0x400>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				porte: gpio-port@4 {
> +					compatible = "snps,dw-apb-gpio-port";
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					snps,nr-gpios = <32>;
> +					reg = <0>;
> +				};
> +			};
> +
>   			sysctrl: pin-controller@d000 {
>   				compatible = "marvell,berlin2q-system-ctrl";
>   				reg = <0xd000 0x100>;
>

