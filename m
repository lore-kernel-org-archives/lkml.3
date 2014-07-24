Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbaGXANo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:13:44 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51174 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362AbaGXANl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:13:41 -0400
MIME-Version: 1.0
In-Reply-To: <53D00A47.7050203@nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
	<1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
	<CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>
	<53CFA33F.6030307@nvidia.com>
	<CAKohponLh66Ubr6=wY2OZCCrK11KZDj=DmXXqXsGGTHSG45wpA@mail.gmail.com>
	<53D00A47.7050203@nvidia.com>
Date: Thu, 24 Jul 2014 05:43:40 +0530
Message-ID: <CAKohponsS8WJy4qBa=3em9AcxfpfLZR_mx4Ln8N3Q_gBaf52NA@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 July 2014 00:47, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> It's this:
>
> +static int tegra124_cpufreq_probe(struct platform_device *pdev)
> +{
> [...]
> +
> +       dfll_clk = of_clk_get_by_name(cpu_dev->of_node, "dfll");
> +       if (IS_ERR(dfll_clk)) {
> +               ret = PTR_ERR(dfll_clk);
> +               goto out_put_cpu_clk;
> +       }

This would search for clocks passed via DT, right? Why would we
get EPROBE_DEFER for that? Sorry for the stupid question.

--
viresh
