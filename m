Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaKELMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:12:14 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:53281 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaKELMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:12:12 -0500
Date: Wed, 5 Nov 2014 11:12:05 +0000
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
Subject: Re: [PATCH v3] arm64: dts: exynos7: add support for cpuidle core
 power down
Message-ID: <20141105111205.GA21258@red-moon>
References: <1415182536-11613-1-git-send-email-k.chander@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415182536-11613-1-git-send-email-k.chander@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 10:15:36AM +0000, Chander Kashyap wrote:
> Exynos7 has core power down state where cores can be powered off independently.
> This patch adds support for this state.
> 
> Entry latency for the core power down is calculated as follows:
> 1. Time difference is measured between cpuidle entry and exit.
> 2. WFI is skipped measuring the time.
> 3. The time is averaged out for 100000 cpuidle transactions with varying load.
- entry-latency-us
	Usage: Required
	"Definition: u32 value representing worst case latency in microseconds
		     required to enter the idle state. ..."

Is that an average value in your opinion ? I am being pedantic, I know,
but we define bindings to be followed, not interpreted.

Thanks,
Lorenzo

> Exit latency and target residency are supplied as per HW team
> 
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
> +				entry-latency-us = <20>;
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
