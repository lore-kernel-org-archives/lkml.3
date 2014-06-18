Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaFRP4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:56:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56906 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbaFRP4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:56:09 -0400
Message-ID: <53A1B677.9010909@ti.com>
Date: Wed, 18 Jun 2014 10:55:35 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, Benoit Cousson <bcousson@baylibre.com>
CC: <robh+dt@kernel.org>, <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, <r.sricharan@ti.com>,
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] arm: dts: am4372: let boards enable RTC and Watchdog
References: <1403106200-777-1-git-send-email-balbi@ti.com> <1403106200-777-2-git-send-email-balbi@ti.com>
In-Reply-To: <1403106200-777-2-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$subject - ARM: dts:

On 06/18/2014 10:43 AM, Felipe Balbi wrote:
> by providing phandles to rtc and wdt nodes, we can
> let boards enable rtc and wdt as necessary.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  arch/arm/boot/dts/am4372.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index 49fa596..e3830d4 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -270,7 +270,7 @@
>  			ti,hwmods = "counter_32k";
>  		};
>  
> -		rtc@44e3e000 {
> +		rtc: rtc@44e3e000 {
>  			compatible = "ti,am4372-rtc","ti,da830-rtc";
>  			reg = <0x44e3e000 0x1000>;
>  			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH
> @@ -279,7 +279,7 @@
>  			status = "disabled";
>  		};
>  
> -		wdt@44e35000 {
> +		wdt: wdt@44e35000 {
>  			compatible = "ti,am4372-wdt","ti,omap3-wdt";
>  			reg = <0x44e35000 0x1000>;
>  			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
> 
we might want to fix up any other similar nodes in dtsi as well, no?

examples:
cpu@0
dispc@4832a400

Might also be nice to have Fixes: to point out which commit was being
fixed, no?

-- 
Regards,
Nishanth Menon
