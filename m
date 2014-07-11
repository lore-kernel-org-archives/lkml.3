Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaGKOOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:14:17 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18251 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaGKOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:14:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 Jul 2014 07:03:17 -0700
Message-ID: <53BFF132.3020700@nvidia.com>
Date: Fri, 11 Jul 2014 17:14:10 +0300
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
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 12/13] cpufreq: Add cpufreq driver for Tegra124
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>	<1405028569-14253-13-git-send-email-ttynkkynen@nvidia.com> <CAKohpom9ORXFiUU4=V+CxgN0ZOFLMEhEjHiU8HsYUYDybNXgHQ@mail.gmail.com>
In-Reply-To: <CAKohpom9ORXFiUU4=V+CxgN0ZOFLMEhEjHiU8HsYUYDybNXgHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/14 07:35, Viresh Kumar wrote:
> Hi Tuomas,
>
> On 11 July 2014 03:12, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
>> Add a new cpufreq driver for Tegra124. Instead of using the PLLX as
>> the CPU clocksource, switch immediately to the DFLL. It allows the use
>> of higher clock rates, and will automatically scale the CPU voltage as
>> well. We also rely on the DFLL driver to determine the CPU clock
>> frequencies that the chip supports, so that we can directly build a
>> cpufreq table with the OPP library helper dev_pm_opp_init_cpufreq_table.
>>
>> This driver is a completely independent of the old cpufreq driver
>> (tegra-cpufreq), which is only used on Tegra20.
>>
>> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>
> Please reuse cpufreq-cpu0 instead of adding a new driver. Similar
> is being adopted by all platforms now: krait, mvebu, etc..
>

Sure, I can do the CPU clock parent change first and then instantiate 
the cpufreq-cpu0 driver, like highbank-cpufreq. That'll depend on the 
patch 'cpufreq: cpu0: OPPs can be populated at runtime' from your 
'Extend support beyond CPU0' series though, any idea when that patch 
will land in?


-- 
nvpublic
