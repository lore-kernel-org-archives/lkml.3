Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3IKKMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:12:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52950 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab3IKKMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:12:06 -0400
Message-ID: <523040B5.60407@ti.com>
Date: Wed, 11 Sep 2013 15:36:45 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>
CC: <linux-omap@vger.kernel.org>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] am335x-boneblack: add eMMC DT entry
References: <1378879946-13037-1-git-send-email-koen@dominion.thruhere.net> <1378879946-13037-3-git-send-email-koen@dominion.thruhere.net>
In-Reply-To: <1378879946-13037-3-git-send-email-koen@dominion.thruhere.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 September 2013 11:42 AM, Koen Kooi wrote:
> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
> ---
>  arch/arm/boot/dts/am335x-bone-common.dtsi |  7 +++++++
>  arch/arm/boot/dts/am335x-boneblack.dts    | 15 +++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
> index ced256c..9c61fef 100644
> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
> @@ -241,6 +241,13 @@
>  			regulator-always-on;
>  		};
>  	};
> +
> +	vmmcsd_fixed: fixedregulator@0 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "vmmcsd_fixed";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +	};
>  };
>  
>  &cpsw_emac0 {
> diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
> index 197cadf..c09947a 100644
> --- a/arch/arm/boot/dts/am335x-boneblack.dts
> +++ b/arch/arm/boot/dts/am335x-boneblack.dts
> @@ -15,3 +15,18 @@
>  	regulator-max-microvolt = <1800000>;
>  	regulator-always-on;
>  };
> +
> +&mmc1 { 
> +	vmmc-supply = <&vmmcsd_fixed>;
> +};
> +
> +&mmc2 { 
> +	vmmc-supply = <&vmmcsd_fixed>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&emmc_pins>;
> +	bus-width = <8>;
> +	ti,non-removable;

There is a standard binding available for this: "non-removable"
There should not be a need to introduce a TI specific binding for this
(I know this is not your fault).

I will send a patch to change the existing .dts files and update the
driver - can you drop this line for now so we don't introduce more
incompatibilities? I can send a patch adding "non-removable" to this
node as part of my clean-up series.

Thanks,
Sekhar

