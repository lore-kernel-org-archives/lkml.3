Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3FZQfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:35:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42360 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab3FZQfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:35:02 -0400
Message-ID: <51CB17F2.5060504@ti.com>
Date: Wed, 26 Jun 2013 22:03:54 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Joel A Fernandes <agnel.joel@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>, Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/5] ARM: dts: am33xx: Add interrupts and memory resources
 for MMC
References: <1372209888-6649-1-git-send-email-joelagnel@ti.com>
In-Reply-To: <1372209888-6649-1-git-send-email-joelagnel@ti.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

On Wednesday 26 June 2013 06:54 AM, Joel A Fernandes wrote:
> From: Joel A Fernandes <agnel.joel@gmail.com>
>
> HWMOD irq entries for MMC were removed. We provide the same from DT for MMC.
>
> This fixes issue where memory resource could not be found during probe.
> Also, added the reg-offset property to account for the offset from start.
>
> Signed-off-by: Joel A Fernandes <agnel.joel@gmail.com>
> ---
>   arch/arm/boot/dts/am33xx.dtsi |   12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 119f8a9..e0a5741 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -237,6 +237,10 @@
>   			dmas = <&edma 24
>   				&edma 25>;
>   			dma-names = "tx", "rx";
> +			interrupts = <64>;
> +			interrupt-parent = <&intc>;
> +			reg = <0x48060000 0x1000>;
> +			reg-offset = <0x100>;
>   			status = "disabled";
>   		};
>
> @@ -247,6 +251,10 @@
>   			dmas = <&edma 2
>   				&edma 3>;
>   			dma-names = "tx", "rx";
> +			interrupts = <24>;

s/24/28

> +			interrupt-parent = <&intc>;
> +			reg = <0x481d8000 0x1000>;
> +			reg-offset = <0x100>;
>   			status = "disabled";
>   		};
>
> @@ -254,6 +262,10 @@
>   			compatible = "ti,omap3-hsmmc";

compatible should be ti,omap4-hsmmc since omap4 hsmmc IP is re-used in am33xx
and reg-offset property is not needed.
combine this patch with 2/5 ARM: dts: add AM33XX MMC support and please add
your signed-off to that patch.

>   			ti,hwmods = "mmc3";
>   			ti,needs-special-reset;
> +			interrupts = <25>;

s/25/29

> +			interrupt-parent = <&intc>;
> +			reg = <0x47810000 0x1000>;
> +			reg-offset = <0x100>;
>   			status = "disabled";
>   		};
>
>
