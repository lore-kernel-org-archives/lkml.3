Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3CYJmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:42:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49471 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab3CYJmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:42:10 -0400
Message-ID: <51501BD5.2070807@ti.com>
Date: Mon, 25 Mar 2013 15:11:41 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <arvind.chauhan@arm.com>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, <linux-sh@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpufreq: drivers: Remove unnecessary assignments
 of policy-> members
References: <2ece6d9fe8dfb6882a1c83a1cb2404bacc40b22d.1364138740.git.viresh.kumar@linaro.org> <07b96c5b68470001197445fb3d28786ad9acdbe0.1364138740.git.viresh.kumar@linaro.org> <51500C81.7040307@ti.com> <CAKohpomTt-ajNeh-OwV9X-HNBddJzL=JB+ggFY0msmsuZabvjA@mail.gmail.com>
In-Reply-To: <CAKohpomTt-ajNeh-OwV9X-HNBddJzL=JB+ggFY0msmsuZabvjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2013 2:15 PM, Viresh Kumar wrote:
> On 25 March 2013 14:06, Sekhar Nori <nsekhar@ti.com> wrote:
>> There is a line in the code a little above the ones you deleted that
>> also sets these same variables. I guess you were relying on that line to
>> set policy->cur, but that also sets policy->{min, max} which can be
>> cleaned up.
> 
> This code is rather confusing or wrong, this was the state of code before
> this patch:
> 
> 	policy->cur = policy->min = policy->max = davinci_getspeed(0);
> 
> 	if (freq_table) {
> 		result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
> 		if (!result)
> 			cpufreq_frequency_table_get_attr(freq_table,
> 							policy->cpu);
> 	} else {
> 		policy->cpuinfo.min_freq = policy->min;
> 		policy->cpuinfo.max_freq = policy->max;
> 	}
> 
>         policy->min = policy->cpuinfo.min_freq;
>         policy->max = policy->cpuinfo.max_freq;
>         policy->cur = davinci_getspeed(0);
> 
> 
> The tricky part is if/else, where if don't return error if
> cpufreq_frequency_table_cpuinfo() fails. We want to set ->min[max]
> and cpuinfo.min[max] always. And i can see this code not doing that for some
> case even with my patch.
> 
> Possible scenarios:
> 1. Valid freq_table: My patch + what you suggested is required.
> 2. Invalid freq_table: We never set cpuinfo.min[max] with or without my patch
> 3. No freq_table: Only my patch is required.
> 
> If i do what you suggested then 2 and 3 would fail... If you want to
> return error
> in case cpufreq_frequency_table_cpuinfo(), then i can fix it properly.

So down in the cpufreq driver probe below, we bail out if freq_table is
not provided. So all this checking for freq_table in the code you pasted
above is superfluous. If you can clean that part up and add checking for
cpufreq_frequency_table_cpuinfo() as you proposed, I will be glad to
test it out ;)

Thanks,
Sekhar
