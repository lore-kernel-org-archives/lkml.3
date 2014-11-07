Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaKGL7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:59:06 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:54461 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaKGL6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:58:49 -0500
Date: Fri, 7 Nov 2014 11:58:45 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Chander Kashyap <k.chander@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>
Subject: Re: [PATCH v4] arm64: dts: exynos7: add support for cpuidle core
 power down
Message-ID: <20141107115845.GA2062@red-moon>
References: <1415193331-14790-1-git-send-email-k.chander@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415193331-14790-1-git-send-email-k.chander@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 01:15:31PM +0000, Chander Kashyap wrote:
> Exynos7 has core power down state where cores can be powered off independently.

"...has a core power down idle state..."

> This patch adds support for this state.

"...for this idle state."

> Entry latency for the core power down is calculated as follows:
> 1. Time difference is measured between cpuidle entry and exit.
> 2. WFI is skipped for measuring the time.
> 3. Select the worst case time in the set of 100000 cpuidle transactions,
>    with varying load.
> 
> Exit latency and target residency are supplied as per HW team

"Exit latency and min residency values are supplied by the HW team."

Target residency is a kernel naming scheme, non-existent in the idle state
bindings.

Please take time to write proper commit logs, thanks.

> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> ---
> This patch has following dependencies:
> 	- [PATCH v5 0/8] arch: arm64: Enable support for Samsung Exynos7 SoC
> 		http://www.spinics.net/lists/linux-samsung-soc/msg37047.html
> Changes in v2:
> 	- Moved the cpu-idle-state property after reg property
> 	- removed the status property.
> 
> Changes in v3:
> 	- Added the Entry latency calculation in commit message.
> Changes in v4:
> 	- Corrected the commit message.
> 	- Corrected the entry latency value.
> 
>  arch/arm64/boot/dts/exynos/exynos7.dtsi |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> index 50ae936..444dde1 100644
> --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
> +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> @@ -37,6 +37,7 @@
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			enable-method = "psci";

enable-method should be after reg, it is not an ordering issues added
by this patch but I still do not like that.

Other than that, please take some time to rewrite the commit log and
ask to fix the ordering above, you can add my:

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

>  			reg = <0x0>;
> +			cpu-idle-states = <&CPU_SLEEP>;
>  		};
>  
>  		cpu@1 {
> @@ -44,6 +45,7 @@
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			enable-method = "psci";
>  			reg = <0x1>;
> +			cpu-idle-states = <&CPU_SLEEP>;
>  		};
>  
>  		cpu@2 {
> @@ -51,6 +53,7 @@
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			enable-method = "psci";
>  			reg = <0x2>;
> +			cpu-idle-states = <&CPU_SLEEP>;
>  		};
>  
>  		cpu@3 {
> @@ -58,6 +61,20 @@
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			enable-method = "psci";
>  			reg = <0x3>;
> +			cpu-idle-states = <&CPU_SLEEP>;
> +		};
> +
> +		idle-states {
> +			entry-method = "arm,psci";
> +
> +			CPU_SLEEP: cpu-sleep {
> +				compatible = "arm,idle-state";
> +				local-timer-stop;
> +				arm,psci-suspend-param = <0x0010000>;
> +				entry-latency-us = <34>;
> +				exit-latency-us = <150>;
> +				min-residency-us = <2100>;
> +			};
>  		};
>  	};
>  
> -- 
> 1.7.9.5
> 
> 
