Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbaGRQ0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:26:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43448 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761787AbaGRQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:26:13 -0400
Date: Fri, 18 Jul 2014 17:18:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] ARM: dts: add CPU nodes for Exynos4 SoCs
Message-ID: <20140718161803.GC16376@leverpostej>
References: <1863399.9O2S91ZvEO@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1863399.9O2S91ZvEO@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 05:00:02PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Recent patch by Tomasz Figa ("irqchip: gic: Fix core ID calculation
> when topology is read from DT") fixed GIC driver to filter cluster ID
> from values returned by cpu_logical_map() for SoCs having registers
> mapped without per-CPU banking making it is possible to add CPU nodes
> for Exynos4 SoCs.  In case of Exynos SoCs these CPU nodes are also
> required by future changes adding initialization of cpuidle states in
> Exynos cpuidle driver through DT.
> 
> Tested on Origen board (Exynos4210 SoC) and Trats2 (Exynos4412 SoC).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> Based on next-20140717 branch of linux-next tree +
> - [PATCH 2/6] ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
>   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32811.html
> - [PATCH] irqchip: gic: Fix core ID calculation when topology is read from DT
>   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34277.html
> 
>  arch/arm/boot/dts/exynos4210.dtsi | 17 +++++++++++++++++
>  arch/arm/boot/dts/exynos4212.dtsi | 17 +++++++++++++++++
>  arch/arm/boot/dts/exynos4412.dtsi | 29 +++++++++++++++++++++++++++++
>  3 files changed, 63 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
> index ee3001f..b99fc83 100644
> --- a/arch/arm/boot/dts/exynos4210.dtsi
> +++ b/arch/arm/boot/dts/exynos4210.dtsi
> @@ -31,6 +31,23 @@
>  		pinctrl2 = &pinctrl_2;
>  	};
>  
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0x900>;
> +		};

Please match the unit-address with the reg (e.g. this should be
cpu@900).

Please do this for all the other CPU nodes.

Thanks,
Mark.

> +
> +		cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0x901>;
> +		};
> +	};
> +
>  	sysram@02020000 {
>  		compatible = "mmio-sram";
>  		reg = <0x02020000 0x20000>;
> diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
> index 3c00e6e..484a2da 100644
> --- a/arch/arm/boot/dts/exynos4212.dtsi
> +++ b/arch/arm/boot/dts/exynos4212.dtsi
> @@ -22,6 +22,23 @@
>  / {
>  	compatible = "samsung,exynos4212", "samsung,exynos4";
>  
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xA00>;
> +		};
> +
> +		cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xA01>;
> +		};
> +	};
> +
>  	combiner: interrupt-controller@10440000 {
>  		samsung,combiner-nr = <18>;
>  	};
> diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
> index c42a3e1..89f4743 100644
> --- a/arch/arm/boot/dts/exynos4412.dtsi
> +++ b/arch/arm/boot/dts/exynos4412.dtsi
> @@ -22,6 +22,35 @@
>  / {
>  	compatible = "samsung,exynos4412", "samsung,exynos4";
>  
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xA00>;
> +		};
> +
> +		cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xA01>;
> +		};
> +
> +		cpu@2 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xA02>;
> +		};
> +
> +		cpu@3 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg = <0xA03>;
> +		};
> +	};
> +
>  	combiner: interrupt-controller@10440000 {
>  		samsung,combiner-nr = <20>;
>  	};
> -- 
> 1.8.2.3
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
