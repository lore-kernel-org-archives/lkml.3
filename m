Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3ILQQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:16:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56787 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3ILQQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:16:47 -0400
Message-ID: <5231E8BE.7080009@ti.com>
Date: Thu, 12 Sep 2013 11:15:58 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>
CC: <linux-kernel@vger.kernel.org>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH 1/4] arm: bone: dts: add CD for mmc1
References: <1379000532-27376-1-git-send-email-koen@dominion.thruhere.net> <1379000532-27376-2-git-send-email-koen@dominion.thruhere.net>
In-Reply-To: <1379000532-27376-2-git-send-email-koen@dominion.thruhere.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nitpick minor comment:
$subject: ARM: dts: am335x-bone: add card detect for mmc1

btw, please use V3 in $subject next time. --subject-prefix "PATCH V3"
when generating patch should do the job.

On 09/12/2013 10:42 AM, Koen Kooi wrote:
> From: Alexander Holler <holler@ahsoftware.de>
> 
> This enables the use of MMC cards even when no card was inserted at boot.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
> ---
> 
> Changes since v2:
> 	None, again a simple repost
> 
> Changes since v1:
> 	None, simple repost
> 
>  arch/arm/boot/dts/am335x-bone-common.dtsi | 14 ++++++++++++++
>  arch/arm/boot/dts/am335x-bone.dts         |  4 ----
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
> index 2f66ded..ced256c 100644
> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
> @@ -107,6 +107,11 @@
>  				0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
>  			>;
>  		};

An EOL here would be nice to separate the nodes.

> +		mmc1_pins: pinmux_mmc1_pins {
> +			pinctrl-single,pins = <
> +				0x160 (PIN_INPUT | MUX_MODE7) /* GPIO0_6 */
> +			>;
> +		};
>  	};
>  
>  	ocp {
> @@ -260,3 +265,12 @@
>  	pinctrl-0 = <&davinci_mdio_default>;
>  	pinctrl-1 = <&davinci_mdio_sleep>;
>  };
> +
> +&mmc1 {
> +	status = "okay";
> +	vmmc-supply = <&ldo3_reg>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&mmc1_pins>;
> +	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
> +	cd-inverted;
> +};
> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
> index d5f43fe..d34469c 100644
> --- a/arch/arm/boot/dts/am335x-bone.dts
> +++ b/arch/arm/boot/dts/am335x-bone.dts
> @@ -16,7 +16,3 @@
>  	regulator-always-on;
>  };
>  
> -&mmc1 {
> -	status = "okay";
> -	vmmc-supply = <&ldo3_reg>;
> -};
> 


-- 
Regards,
Nishanth Menon
