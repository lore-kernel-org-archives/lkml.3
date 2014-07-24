Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935075AbaGXXbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:31:14 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40261 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934568AbaGXXbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:31:12 -0400
Message-ID: <53D1973A.9060907@samsung.com>
Date: Fri, 25 Jul 2014 08:31:06 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Abraham <ta.omasab@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] ARM: dts: add CPU nodes for Exynos4 SoCs
References: <1444042.RbiCcg7JnP@amdc1032>
In-Reply-To: <1444042.RbiCcg7JnP@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/14 22:57, Bartlomiej Zolnierkiewicz wrote:
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
> Signed-off-by: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
> ---
> Based on next-20140717 branch of linux-next tree +
> - [PATCH 2/6] ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
>    http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32811.html
> - [PATCH] irqchip: gic: Fix core ID calculation when topology is read from DT
>    http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34277.html
>
> v2:
> - match the unit-address with the reg
>
>   arch/arm/boot/dts/exynos4210.dtsi | 17 +++++++++++++++++
>   arch/arm/boot/dts/exynos4212.dtsi | 17 +++++++++++++++++
>   arch/arm/boot/dts/exynos4412.dtsi | 29 +++++++++++++++++++++++++++++
>   3 files changed, 63 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
> index ee3001f..bc2b444 100644
> --- a/arch/arm/boot/dts/exynos4210.dtsi
> +++ b/arch/arm/boot/dts/exynos4210.dtsi
> @@ -31,6 +31,23 @@
>   		pinctrl2 =&pinctrl_2;
>   	};
>
> +	cpus {
> +		#address-cells =<1>;
> +		#size-cells =<0>;
> +
> +		cpu@900 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg =<0x900>;
> +		};
> +
> +		cpu@901 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg =<0x901>;
> +		};
> +	};
> +
>   	sysram@02020000 {
>   		compatible = "mmio-sram";
>   		reg =<0x02020000 0x20000>;
> diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
> index 3c00e6e..dd0a43e 100644
> --- a/arch/arm/boot/dts/exynos4212.dtsi
> +++ b/arch/arm/boot/dts/exynos4212.dtsi
> @@ -22,6 +22,23 @@
>   / {
>   	compatible = "samsung,exynos4212", "samsung,exynos4";
>
> +	cpus {
> +		#address-cells =<1>;
> +		#size-cells =<0>;
> +
> +		cpu@A00 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg =<0xA00>;
> +		};
> +
> +		cpu@A01 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg =<0xA01>;
> +		};
> +	};
> +
>   	combiner: interrupt-controller@10440000 {
>   		samsung,combiner-nr =<18>;
>   	};
> diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
> index c42a3e1..435a722 100644
> --- a/arch/arm/boot/dts/exynos4412.dtsi
> +++ b/arch/arm/boot/dts/exynos4412.dtsi
> @@ -22,6 +22,35 @@
>   / {
>   	compatible = "samsung,exynos4412", "samsung,exynos4";
>
> +	cpus {
> +		#address-cells =<1>;
> +		#size-cells =<0>;
> +
> +		cpu@A00 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg =<0xA00>;
> +		};
> +
> +		cpu@A01 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg =<0xA01>;
> +		};
> +
> +		cpu@A02 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg =<0xA02>;
> +		};
> +
> +		cpu@A03 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a9";
> +			reg =<0xA03>;
> +		};
> +	};
> +
>   	combiner: interrupt-controller@10440000 {
>   		samsung,combiner-nr =<20>;
>   	};

OK, I'm fine on this, will apply.

Thanks,
Kukjin
