Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaKWBbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 20:31:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaKWBbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 20:31:38 -0500
Message-ID: <547138F3.3040502@suse.de>
Date: Sun, 23 Nov 2014 02:31:31 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?6rmA7ZWZ7KO8?= <ruppi.kim@hardkernel.com>
CC: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Humberto Naves <hsnaves@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Johann Pfefferl <johann.pfefferl@siemens.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] ARM: dts: exynos5410: Add ODROID-XU LEDs
References: <1416687984-3546-1-git-send-email-afaerber@suse.de> <1416687984-3546-6-git-send-email-afaerber@suse.de>
In-Reply-To: <1416687984-3546-6-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hakjoo,

Am 22.11.2014 um 21:26 schrieb Andreas Färber:
> Signed-off-by: Hakjoo Kim <ruppi.kim@hardkernel.com>

Sorry, I was too quick here: Only the previous two patches got signed
off by you, plus the last one on your 3.14 branch. Are you able to sign
off all patches authored by you there? (An email reply indicating the
Signed-off-by should do, if updating the branch is too much work.)

Thanks,
Andreas

> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
> v1 -> v2:
> * Filled in Sob from Hakjoo Kim
> 
>  arch/arm/boot/dts/exynos5410-odroidxu.dts | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5410-odroidxu.dts b/arch/arm/boot/dts/exynos5410-odroidxu.dts
> index 97310bb727e2..b02cd3ab7b38 100644
> --- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
> +++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
> @@ -15,6 +15,7 @@
>  
>  /dts-v1/;
>  #include "exynos5410.dtsi"
> +#include <dt-bindings/gpio/gpio.h>
>  / {
>  	model = "ODROID-XU based on EXYNOS5410";
>  	compatible = "hardkernel,odroid-xu", "samsung,exynos5410", "samsung,exynos5";
> @@ -39,6 +40,30 @@
>  		reg = <0x02037000 0x1000>;
>  	};
>  
> +	leds {
> +		compatible = "gpio-leds";
> +
> +		blue {
> +			label = "blue:heartbeat";
> +			gpios = <&gpb2 2 GPIO_ACTIVE_HIGH>;
> +			default-state = "off";
> +			linux,default-trigger = "heartbeat";
> +		};
> +
> +		green {
> +			label = "green:activity";
> +			gpios = <&gpb2 1 GPIO_ACTIVE_HIGH>;
> +			default-state = "off";
> +			linux,default-trigger = "mmc0";
> +		};
> +
> +		red {
> +			label = "red:activity";
> +			gpios = <&gpx2 3 GPIO_ACTIVE_HIGH>;
> +			default-state = "off";
> +			linux,default-trigger = "mmc1";
> +		};
> +	};
>  };
>  
>  &mmc_0 {
> 


-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
