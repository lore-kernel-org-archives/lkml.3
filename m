Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaJOJAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:00:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42371 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaJOJAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:00:10 -0400
Date: Wed, 15 Oct 2014 10:00:47 +0100
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
Subject: Re: [PATCH] arm64: dts: exynos7: add support for cpuidle core power
 down
Message-ID: <20141015090047.GA26484@red-moon>
References: <1413354920-20165-1-git-send-email-k.chander@samsung.com>
MIME-Version: 1.0
In-Reply-To: <1413354920-20165-1-git-send-email-k.chander@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 Oct 2014 09:00:05.0251 (UTC) FILETIME=[6989E530:01CFE856]
X-MC-Unique: 114101510000715401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 07:35:20AM +0100, Chander Kashyap wrote:
> Exynos7 has core power down state where cores can be powered off independently.
> This patch adds support for this state.

Please tell us more about the idle-state values you are adding, in particular
entry, exit latencies and min-residency values.

> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> ---
> This patch has following dependencies:
> 	- [PATCH v5 0/8] arch: arm64: Enable support for Samsung Exynos7 SoC
> 		http://www.spinics.net/lists/linux-samsung-soc/msg37047.html
> 	- [PATCH v9 0/8] ARM generic idle states
> 		http://permalink.gmane.org/gmane.linux.power-management.general/49224

Series above was merged, so dependency is stale.

>  arch/arm64/boot/dts/exynos/exynos7.dtsi |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> index ce221ac..8e0a034 100644
> --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
> +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> @@ -36,6 +36,7 @@
>  			device_type = "cpu";
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			enable-method = "psci";
> +			cpu-idle-states = <&CPU_SLEEP>;

I would add cpu-idle-states phandle after the reg property, as defined
in the idle states bindings.

>  			reg = <0x0>;
>  		};
>  
> @@ -43,6 +44,7 @@
>  			device_type = "cpu";
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			enable-method = "psci";
> +			cpu-idle-states = <&CPU_SLEEP>;
>  			reg = <0x1>;
>  		};
>  
> @@ -50,6 +52,7 @@
>  			device_type = "cpu";
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			enable-method = "psci";
> +			cpu-idle-states = <&CPU_SLEEP>;
>  			reg = <0x2>;
>  		};
>  
> @@ -57,8 +60,23 @@
>  			device_type = "cpu";
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			enable-method = "psci";
> +			cpu-idle-states = <&CPU_SLEEP>;
>  			reg = <0x3>;
>  		};
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
> +				status = "enabled";

status ? This is not a documented property. If you need it please explain
why, define its bindings and we can see how to accommodate it.

Thank you,
Lorenzo

> +			};
> +		};
>  	};
>  
>  	psci {
> -- 
> 1.7.9.5
> 
> 

