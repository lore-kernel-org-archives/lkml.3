Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3IFSWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:22:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35026 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3IFSWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:22:44 -0400
Message-ID: <522A1D3A.8000301@ti.com>
Date: Fri, 6 Sep 2013 13:21:46 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] arm: dts: am33xx: Add mmc nodes for am33xx platform
References: <1378455712-17379-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1378455712-17379-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 09/06/2013 03:21 AM, George Cherian wrote:
> Add mmc nodes for am33xx platforms
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
> Verified after applying [1] and [2]
> [1] - [PATCH v4 0/6] dma: edma: Support scatter-lists of any length - https://lkml.org/lkml/2013/8/29/466
> [2] - [PATCH v2] ARM: dts: add AM33XX EDMA support - https://lkml.org/lkml/2013/8/26/57

Thanks for the verification.

But, this patch should not be applied on its own as it a part of a bigger patch
I had submitted earlier that includes DTS for other derivative boards and
bindings Documentation. [3] That's the one to be applied and should be applied
only after the above patches are merged. I will resubmit this later again once
pending EDMA changes are merged. Thanks.

[3] https://lkml.org/lkml/2013/6/25/781

Regards,

-Joel
>  arch/arm/boot/dts/am33xx.dtsi | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index b0badff..1df512d 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -236,6 +236,41 @@
>  			status = "disabled";
>  		};
>  
> +		mmc1: mmc@48061000 {
> +			compatible = "ti,omap4-hsmmc";
> +			reg = <0x48060000 0x1000>;
> +			interrupts = <64>;
> +			ti,hwmods = "mmc1";
> +			ti,dual-volt;
> +			ti,needs-special-reset;
> +			ti,needs-special-hs-handling;
> +			dmas = <&edma 24
> +				&edma 25>;
> +			dma-names = "tx", "rx";
> +			status = "disabled";
> +		};
> +
> +		mmc2: mmc@481d8000 {
> +			compatible = "ti,omap4-hsmmc";
> +			reg = <0x481d8000 0x1000>;
> +			interrupts = <28>;
> +			ti,hwmods = "mmc2";
> +			ti,needs-special-reset;
> +			dmas = <&edma 2
> +				&edma 3>;
> +			dma-names = "tx", "rx";
> +			status = "disabled";
> +		};
> +
> +		mmc3: mmc@47810000 {
> +			compatible = "ti,omap4-hsmmc";
> +			reg = <0x47810000 0x1000>;
> +			interrupts = <29>;
> +			ti,hwmods = "mmc3";
> +			ti,needs-special-reset;
> +			status = "disabled";
> +		};
> +
>  		wdt2: wdt@44e35000 {
>  			compatible = "ti,omap3-wdt";
>  			ti,hwmods = "wd_timer2";
> 

