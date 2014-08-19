Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaHSToJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 15:44:09 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18591 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaHSToH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:44:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Aug 2014 12:34:29 -0700
Message-ID: <53F3A900.8010805@nvidia.com>
Date: Tue, 19 Aug 2014 22:44:00 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
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
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 13/15] cpufreq: Add cpufreq driver for Tegra124
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>	<1408419205-10048-14-git-send-email-tuomas.tynkkynen@iki.fi> <CAKohpokQOALPH13Ykz4nTBOby8J1X6_F30LNKz=gsC4wN3=3vg@mail.gmail.com>
In-Reply-To: <CAKohpokQOALPH13Ykz4nTBOby8J1X6_F30LNKz=gsC4wN3=3vg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/14 08:55, Viresh Kumar wrote:
> On 19 August 2014 09:03, Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi> wrote:
>>  - use 'select GENERIC_CPUFREQ_CPU0', not depends
> 
> Bad :(
> 
> It *has* to be a depends here, its not optional. That was outcome of the
> chat we had last time, if I remember it well..

Okay, I misread that conversation then.

>> ---
> 
> You don't need to add these --- here, just add a blank line and git
> will take care of things for you :)

There's actually a (mis-?)feature in git format-patch: a literal '---'
line in a commit message won't be escaped, so the patch notes can be
written in the commit message directly so the patch files don't need
to be modified by hand.

>>  drivers/cpufreq/Kconfig.arm        |   8 ++
>>  drivers/cpufreq/Makefile           |   1 +
>>  drivers/cpufreq/tegra124-cpufreq.c | 206 +++++++++++++++++++++++++++++++++++++
>>  3 files changed, 215 insertions(+)
>>  create mode 100644 drivers/cpufreq/tegra124-cpufreq.c
>>
[...]
>> +static int tegra124_cpufreq_probe(struct platform_device *pdev)
>> +{
> 
>> +       priv->vdd_cpu_reg = regulator_get(get_cpu_device(0), "vdd-cpu");
> 
> get_cpu_device() can fail as well, and so you may want to check its return
> value as well..
> 

Oh, right.

>> +static int __init tegra_cpufreq_init(void)
>> +{
>> +       int ret;
>> +       struct platform_device *pdev;
>> +
>> +       if (!of_match_machine(soc_of_matches))
>> +               return -ENODEV;
> 
> You may want to add a comment here on why you chose to add another layer
> of platform device/driver.. i.e. to catch -EPROBE_DEFER from clk-APIs..
>

Yes, a good idea.

-- 
nvpublic
