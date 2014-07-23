Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbaGWTRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:17:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13507 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaGWTRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:17:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 23 Jul 2014 12:09:37 -0700
Message-ID: <53D00A47.7050203@nvidia.com>
Date: Wed, 23 Jul 2014 22:17:27 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
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
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>	<1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>	<CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>	<53CFA33F.6030307@nvidia.com> <CAKohponLh66Ubr6=wY2OZCCrK11KZDj=DmXXqXsGGTHSG45wpA@mail.gmail.com>
In-Reply-To: <CAKohponLh66Ubr6=wY2OZCCrK11KZDj=DmXXqXsGGTHSG45wpA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/07/14 19:50, Viresh Kumar wrote:
> On 23 July 2014 17:27, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
>> The platform device is required for the deferred probe that can happen if the
>> DFLL driver hasn't initialized yet, and module_init() callbacks don't seem to
>> respect -EPROBE_DEFER.
> 
> Oh, which call in this file will return EPROBE_DEFER? I couldn't make out
> which one will depend on DFLL driver.
> 

It's this:

+static int tegra124_cpufreq_probe(struct platform_device *pdev)
+{
[...]
+
+	dfll_clk = of_clk_get_by_name(cpu_dev->of_node, "dfll");
+	if (IS_ERR(dfll_clk)) {
+		ret = PTR_ERR(dfll_clk);
+		goto out_put_cpu_clk;
+	}

-- 
nvpublic
