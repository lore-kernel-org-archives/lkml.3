Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaKCOne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:43:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53033 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbaKCOna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:43:30 -0500
Message-ID: <54579476.10702@ti.com>
Date: Mon, 3 Nov 2014 16:43:02 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: dra7-evm: Keep all VDD rails always-on
References: <1413902290-304-1-git-send-email-nm@ti.com>
In-Reply-To: <1413902290-304-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishant,

On 10/21/2014 05:38 PM, Nishanth Menon wrote:
> DRA7 Data Manual (SPRS857L - August 2014) section 4.1.1 states: "All
> unused power supply balls must be supplied with the voltages specified
> in the Section 5.2, Recommended Operating Conditions".
> 
> This implies that all unused voltage rails for Vayu can never be
> switched off even if the hardware blocks inside that voltage domain is
> unused. Switching off these unused rails may result in stability issues
> on other domains and increased leakage and power-on-hour impacts.
> 
> J6eco-evm dts file already considers this, however j6evm-dts file needs
> to be fixed to consider this constraint of the SoC.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Acked-by: Roger Quadros <rogerq@ti.com>

I'm assuming that vddshv8 (MMC1 power group) can be switched off.

cheers,
-roger

> ---
> 
> Patch is based on v3.18-rc1 tag.
> 
>  arch/arm/boot/dts/dra7-evm.dts |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
> index c6ce625..4f4c469 100644
> --- a/arch/arm/boot/dts/dra7-evm.dts
> +++ b/arch/arm/boot/dts/dra7-evm.dts
> @@ -201,6 +201,7 @@
>  					regulator-name = "smps45";
>  					regulator-min-microvolt = < 850000>;
>  					regulator-max-microvolt = <1150000>;
> +					regulator-always-on;
>  					regulator-boot-on;
>  				};
>  
> @@ -209,6 +210,7 @@
>  					regulator-name = "smps6";
>  					regulator-min-microvolt = <850000>;
>  					regulator-max-microvolt = <12500000>;
> +					regulator-always-on;
>  					regulator-boot-on;
>  				};
>  
> @@ -226,6 +228,7 @@
>  					regulator-name = "smps8";
>  					regulator-min-microvolt = < 850000>;
>  					regulator-max-microvolt = <1250000>;
> +					regulator-always-on;
>  					regulator-boot-on;
>  				};
>  
> @@ -252,6 +255,7 @@
>  					regulator-name = "ldo2";
>  					regulator-min-microvolt = <3300000>;
>  					regulator-max-microvolt = <3300000>;
> +					regulator-always-on;
>  					regulator-boot-on;
>  				};
>  
> @@ -269,6 +273,7 @@
>  					regulator-name = "ldo9";
>  					regulator-min-microvolt = <1050000>;
>  					regulator-max-microvolt = <1050000>;
> +					regulator-always-on;
>  					regulator-boot-on;
>  				};
>  
> 

