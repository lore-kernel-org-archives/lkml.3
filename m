Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaGWHVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:21:48 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:57699 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbaGWHVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
	<1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
Date: Wed, 23 Jul 2014 12:51:43 +0530
Message-ID: <CAMf-jSkOF3qN=GSju=tsMp5SBUo+TqNQOROnirr=N_zz7Ca43Q@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pm@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 9:09 PM, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> Add a new cpufreq driver for Tegra124. Instead of using the PLLX as

<snip>

> +
> +static int tegra124_cpu_switch_to_dfll(void)
> +{
> +       struct clk *original_cpu_clk_parent;
> +       unsigned long rate;
> +       struct dev_pm_opp *opp;
> +       int ret;
> +
> +       rate = clk_get_rate(cpu_clk);
> +       opp = dev_pm_opp_find_freq_ceil(cpu_dev, &rate);
> +       if (IS_ERR(opp))
> +               return PTR_ERR(opp);
> +
> +       ret = clk_set_rate(dfll_clk, rate);
> +       if (ret)
> +               return ret;
> +
> +       original_cpu_clk_parent = clk_get_parent(cpu_clk);
> +       clk_set_parent(cpu_clk, pllp_clk);

Needs return check.

> +       if (ret)
> +               return ret;
Which 'ret' is being checked here? nothing is assigned here. May be
fixing previous comment will fix this.

> +
> +       ret = clk_prepare_enable(dfll_clk);

<snip>

> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
