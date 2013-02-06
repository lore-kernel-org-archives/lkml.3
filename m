Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3BFKIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:08:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55075 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3BFKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:08:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpokFCAqdoeBoMJ3Jzh05x8wUg4kfo+XirxUjw=2_4_0wJA@mail.gmail.com>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<CAKohpomK1jZMy=mQJFysbdeXZAuzWJ3gcStA+imYHouGfmcgLw@mail.gmail.com>
	<CAKohpokFCAqdoeBoMJ3Jzh05x8wUg4kfo+XirxUjw=2_4_0wJA@mail.gmail.com>
Date: Wed, 6 Feb 2013 15:38:49 +0530
Message-ID: <CAP245DUMnSMSoXo2JoMu1CgNROQ2YT7kd7e9svWoZ_EG2QLi+Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, Borislav Petkov <bp@alien8.de>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 3:28 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 5 February 2013 21:51, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> commit 15b5548c9ccfb8088270f7574710d9d67edfe33b
>> Author: Viresh Kumar <viresh.kumar@linaro.org>
>> Date:   Tue Feb 5 21:29:05 2013 +0530
>>
>>     cpufreq: Make governors directory sysfs location based on
>> have_multiple_policies
>>
>>     Until now directory for governors tunables was getting created in
>>     cpu/cpufreq/<gov-name>. With the introduction of following patch:
>>     "cpufreq: governor: Implement per policy instances of governors"
>>
>>     this directory would be created in
>> cpu/cpu<num>/cpufreq/<gov-name>. This might
>>     break userspace of existing platforms. Lets do this change only
>> for platforms
>>     which need support for multiple policies and thus above mentioned patch.
>>
>>     From now on, such platforms would be require to do following from
>> their init()
>>     routines:
>>
>>         policy->have_multiple_policies = true;
>>
>>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/cpufreq/cpufreq_governor.c |  2 +-
>>  include/linux/cpufreq.h            | 14 ++++++++++++++
>>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> Hi Rafael,
>
> Because this patch was quite big (317 insertions(+), 238 deletions(-)), i was
> planning a detailed self review to capture any mistakes and luckily i found
> one for above patch :)
>
> diff --git a/drivers/cpufreq/cpufreq_governor.c
> b/drivers/cpufreq/cpufreq_governor.c
> index 41ee86f..fe037c0 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -342,7 +342,8 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>                 mutex_lock(&dbs_data->mutex);
>                 mutex_destroy(&cpu_cdbs->timer_mutex);
>
> -               sysfs_remove_group(&policy->kobj, dbs_data->cdata->attr_group);
> +               sysfs_remove_group(get_governor_parent_kobj(policy),
> +                               dbs_data->cdata->attr_group);
>                 if (dbs_data->cdata->governor == GOV_CONSERVATIVE)
>                         cpufreq_unregister_notifier(cs_ops->notifier_block,
>                                         CPUFREQ_TRANSITION_NOTIFIER);
>
> I have pushed the complete patchset here:
>
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-updates
>

Viresh, perhaps you should ask Stephen Rothwell to pull in your tree
to get some more testing before Rafael pulls it in for 3.10?
