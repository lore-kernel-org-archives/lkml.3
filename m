Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaHLKga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:36:30 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16745 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaHLKg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:36:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Aug 2014 03:27:19 -0700
Message-ID: <53E9EE58.3060408@nvidia.com>
Date: Tue, 12 Aug 2014 18:37:12 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 08/16] clk: tegra: Add Tegra124 DFLL clocksource platform
 driver
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com> <1405957142-19416-9-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1405957142-19416-9-git-send-email-ttynkkynen@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/21/2014 11:38 PM, Tuomas Tynkkynen wrote:
> Add basic platform driver support for the fast CPU cluster DFLL
> clocksource found on Tegra124 SoCs. This small driver selects the
> appropriate Tegra124-specific characterization data and integration
> code. It relies on the DFLL common code to do most of the work.
>
> diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
> index 47320ca..2f87188 100644
> --- a/drivers/clk/tegra/Makefile
> +++ b/drivers/clk/tegra/Makefile
> @@ -16,3 +16,5 @@ obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
>   obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
>   obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
>   obj-$(CONFIG_ARCH_TEGRA_124_SOC)	+= clk-tegra124.o
> +obj-$(CONFIG_ARCH_TEGRA_124_SOC)	+= clk-tegra124-dfll-fcpu.o
> +obj-y					+= cvb.o
> diff --git a/drivers/clk/tegra/clk-tegra124-dfll-fcpu.c b/drivers/clk/tegra/clk-tegra124-dfll-fcpu.c
> new file mode 100644
> index 0000000..f068360
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-tegra124-dfll-fcpu.c
...
> +	if (IS_ERR(cvb)) {
> +		pr_err("couldn't build OPP table: %ld\n", PTR_ERR(cvb));
> +		return PTR_ERR(cvb);
> +	}
> +
> +	soc.assert_dvco_reset = tegra124_clock_assert_dfll_dvco_reset,
> +	soc.deassert_dvco_reset = tegra124_clock_deassert_dfll_dvco_reset,
nit: Use semicolon instead at the end of the two lines above.


Thanks,
Vince

