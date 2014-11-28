Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaK1LuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:50:09 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57304 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaK1LuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:50:07 -0500
Date: Fri, 28 Nov 2014 11:50:02 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Olof Johansson <olof@lixom.net>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: ARM: Fix the Generic Timers interrupt active
 level description
Message-ID: <20141128115002.GZ828@e106497-lin.cambridge.arm.com>
References: <1417099005-18638-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
In-Reply-To: <1417099005-18638-1-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 28 Nov 2014 11:50:03.0771 (UTC) FILETIME=[72818CB0:01D00B01]
X-MC-Unique: 114112811500506401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 02:36:45PM +0000, Liviu Dudau wrote:
> The Cortex-A5x TRM states in paragraph "9.2 Generic Timer functional
> description" that generic timers provide an active-LOW interrupt
> output. Fix the device trees to correctly describe this.
> 
> While doing this update the CPU mask to match the number of described
> CPUs as well.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

arm-soc maintainers: Please discard my v2 patch as it proved to be the wrong fix.
This patch should still be considered for inclusion for v3.19 as it fixes the
arm64 DT files.

Marc, care to Ack this patch?

Best regards,
Liviu

> ---
> 
> Arnd, Olof: This is on top of linux-next/master as it patches the Juno
> as well as all the other ARM DTs.
> 
>  arch/arm64/boot/dts/arm/foundation-v8.dts  | 8 ++++----
>  arch/arm64/boot/dts/arm/juno.dts           | 8 ++++----
>  arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts | 8 ++++----
>  3 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/arm/foundation-v8.dts b/arch/arm64/boot/dts/arm/foundation-v8.dts
> index 4a06090..27f3296 100644
> --- a/arch/arm64/boot/dts/arm/foundation-v8.dts
> +++ b/arch/arm64/boot/dts/arm/foundation-v8.dts
> @@ -78,10 +78,10 @@
>  
>  	timer {
>  		compatible = "arm,armv8-timer";
> -		interrupts = <1 13 0xff01>,
> -			     <1 14 0xff01>,
> -			     <1 11 0xff01>,
> -			     <1 10 0xff01>;
> +		interrupts = <1 13 0xf08>,
> +			     <1 14 0xf08>,
> +			     <1 11 0xf08>,
> +			     <1 10 0xf08>;
>  		clock-frequency = <100000000>;
>  	};
>  
> diff --git a/arch/arm64/boot/dts/arm/juno.dts b/arch/arm64/boot/dts/arm/juno.dts
> index 097ecc4..cb3073e 100644
> --- a/arch/arm64/boot/dts/arm/juno.dts
> +++ b/arch/arm64/boot/dts/arm/juno.dts
> @@ -98,10 +98,10 @@
>  
>  	timer {
>  		compatible = "arm,armv8-timer";
> -		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> -			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> -			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> -			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>;
> +		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_LOW)>,
> +			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_LOW)>,
> +			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_LOW)>,
> +			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_LOW)>;
>  	};
>  
>  	pmu {
> diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts b/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
> index 572005e..efc59b3 100644
> --- a/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
> +++ b/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
> @@ -81,10 +81,10 @@
>  
>  	timer {
>  		compatible = "arm,armv8-timer";
> -		interrupts = <1 13 0xff01>,
> -			     <1 14 0xff01>,
> -			     <1 11 0xff01>,
> -			     <1 10 0xff01>;
> +		interrupts = <1 13 0xf08>,
> +			     <1 14 0xf08>,
> +			     <1 11 0xf08>,
> +			     <1 10 0xf08>;
>  		clock-frequency = <100000000>;
>  	};
>  
> -- 
> 2.1.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

