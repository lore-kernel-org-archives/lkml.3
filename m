Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaALObZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 09:31:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:10696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaALObU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 09:31:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,647,1384329600"; 
   d="scan'208";a="457502601"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>
CC: "wni@nvidia.com" <wni@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: RE: [PATCHv5 05/20] cpufreq: cpufreq-cpu0: add dt node parsing for
 cooling device properties
Thread-Topic: [PATCHv5 05/20] cpufreq: cpufreq-cpu0: add dt node parsing for
 cooling device properties
Thread-Index: AQHO3+AMmIms2oOLdEmq97DUtvxZUJqBhPQg
Date: Sun, 12 Jan 2014 14:31:06 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B909263011C9A19@SHSMSX101.ccr.corp.intel.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <1384285582-16933-6-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1384285582-16933-6-git-send-email-eduardo.valentin@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
> Sent: Wednesday, November 13, 2013 3:46 AM
> To: swarren@wwwdotorg.org; pawel.moll@arm.com; mark.rutland@arm.com;
> ian.campbell@citrix.com; rob.herring@calxeda.com; linux@roeck-us.net;
> Zhang, Rui
> Cc: wni@nvidia.com; grant.likely@linaro.org; R, Durgadoss; linux-
> pm@vger.kernel.org; devicetree@vger.kernel.org; lm-sensors@lm-
> sensors.org; linux-kernel@vger.kernel.org; Eduardo Valentin; Rafael J.
> Wysocki; Viresh Kumar; cpufreq@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org
> Subject: [PATCHv5 05/20] cpufreq: cpufreq-cpu0: add dt node parsing for
> cooling device properties
> Importance: High
> 
> This patch changes the cpufreq-cpu0 driver to consider if a cpu needs
> cooling (with cpufreq). In case the cooling is needed, the cpu0 device
> tree node needs to be properly configured with cooling device
> properties.
> 
> In case these properties are present,, the driver will load a cpufreq
> cooling device in the system. The cpufreq-cpu0 driver is not interested
> in determining how the system should be using the cooling device. The
> driver is responsible only of loading the cooling device.
> 
> Describing how the cooling device will be used can be accomplished by
> setting up a thermal zone that references and is composed by the
> cpufreq cooling device.
> 
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt         |  7 +++++++
>  drivers/cpufreq/Kconfig                                  |  2 +-
>  drivers/cpufreq/cpufreq-cpu0.c                           | 16
> ++++++++++++++++
>  3 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> index 051f764..f055515 100644
> --- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> @@ -15,6 +15,10 @@ Optional properties:
>  - clock-latency: Specify the possible maximum transition latency for
> clock,
>    in unit of nanoseconds.
>  - voltage-tolerance: Specify the CPU voltage tolerance in percentage.
> +- #cooling-cells:
> +- cooling-min-level:
> +- cooling-max-level:
> +     Please refer to
> Documentation/devicetree/bindings/thermal/thermal.txt.
> 
>  Examples:
> 
> @@ -33,6 +37,9 @@ cpus {
>  			198000  850000
>  		>;
>  		clock-latency = <61036>; /* two CLK32 periods */
> +		#cooling-cells = <2>;
> +		cooling-min-level = <0>;
> +		cooling-max-level = <2>;
>  	};
> 
>  	cpu@1 {
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig index
> 534fcb8..fc1e9a5 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -186,7 +186,7 @@ config CPU_FREQ_GOV_CONSERVATIVE
> 
>  config GENERIC_CPUFREQ_CPU0
>  	tristate "Generic CPU0 cpufreq driver"
> -	depends on HAVE_CLK && REGULATOR && PM_OPP && OF
> +	depends on HAVE_CLK && REGULATOR && PM_OPP && OF && THERMAL &&
> +CPU_THERMAL

config: make ARCH=arm multi_v7_defconfig
All warnings:
warning: (ARM_HIGHBANK_CPUFREQ) selects GENERIC_CPUFREQ_CPU0 which 
has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && 
HAVE_CLK && REGULATOR && PM_OPP && OF && THERMAL && CPU_THERMAL)

I think you need to select THERMAL and CPU_THERMAL instead, right?

Thanks,
rui
>  	select CPU_FREQ_TABLE
>  	help
>  	  This adds a generic cpufreq driver for CPU0 frequency
> management.
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-
> cpu0.c index c522a95..568aaf3 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -13,7 +13,9 @@
> 
>  #include <linux/clk.h>
>  #include <linux/cpu.h>
> +#include <linux/cpu_cooling.h>
>  #include <linux/cpufreq.h>
> +#include <linux/cpumask.h>
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> @@ -21,6 +23,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
> +#include <linux/thermal.h>
> 
>  static unsigned int transition_latency;  static unsigned int
> voltage_tolerance; /* in percentage */ @@ -29,6 +32,7 @@ static struct
> device *cpu_dev;  static struct clk *cpu_clk;  static struct regulator
> *cpu_reg;  static struct cpufreq_frequency_table *freq_table;
> +static struct thermal_cooling_device *cdev;
> 
>  static int cpu0_verify_speed(struct cpufreq_policy *policy)  { @@ -
> 260,6 +264,17 @@ static int cpu0_cpufreq_probe(struct platform_device
> *pdev)
>  		goto out_free_table;
>  	}
> 
> +	/*
> +	 * For now, just loading the cooling device;
> +	 * thermal DT code takes care of matching them.
> +	 */
> +	if (of_find_property(np, "#cooling-cells", NULL)) {
> +		cdev = of_cpufreq_cooling_register(np, cpu_present_mask);
> +		if (IS_ERR(cdev))
> +			pr_err("running cpufreq without cooling
> device: %ld\n",
> +			       PTR_ERR(cdev));
> +	}
> +
>  	of_node_put(np);
>  	return 0;
> 
> @@ -272,6 +287,7 @@ out_put_node:
> 
>  static int cpu0_cpufreq_remove(struct platform_device *pdev)  {
> +	cpufreq_cooling_unregister(cdev);
>  	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
>  	opp_free_cpufreq_table(cpu_dev, &freq_table);
> 
> --
> 1.8.2.1.342.gfa7285d

