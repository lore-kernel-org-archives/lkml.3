Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaHDKL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:11:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbaHDKL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:11:56 -0400
Message-ID: <53DF5C64.1040609@redhat.com>
Date: Mon, 04 Aug 2014 06:11:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lenny Szubowicz <lszubowi@redhat.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com> <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com> <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com> <53DAE592.2030909@codeaurora.org> <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <53DBE764.8050109@redhat.com> <53DBEC27.7050803@codeaurora.org> <53DBEDE7.90400@redhat.com> <53DBF08C.3020703@codeaurora.org> <53DC05C7.5000507@codeaurora.org>
In-Reply-To: <53DC05C7.5000507@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/01/2014 05:25 PM, Saravana Kannan wrote:
> On 08/01/2014 12:54 PM, Stephen Boyd wrote:
>> On 08/01/14 12:43, Prarit Bhargava wrote:
>>>
>>> On 08/01/2014 03:36 PM, Stephen Boyd wrote:
>>>> On 08/01/14 12:15, Prarit Bhargava wrote:
>>>>> On 08/01/2014 01:18 PM, Stephen Boyd wrote:
>>>>>> On 08/01/14 03:27, Prarit Bhargava wrote:
>>>>>>> Can you send me the test and the trace of the deadlock?  I'm not creating
>>>>>>> it with:
>>>>>>>
>>>>>> This was with conservative as the default, and switching to ondemand
>>>>>>
>>>>>> # cd /sys/devices/system/cpu/cpu2/cpufreq
>>>>>> # ls
>>>>>> affected_cpus                  scaling_available_governors
>>>>>> conservative                   scaling_cur_freq
>>>>>> cpuinfo_cur_freq               scaling_driver
>>>>>> cpuinfo_max_freq               scaling_governor
>>>>>> cpuinfo_min_freq               scaling_max_freq
>>>>>> cpuinfo_transition_latency     scaling_min_freq
>>>>>> related_cpus                   scaling_setspeed
>>>>>> scaling_available_frequencies  stats
>>>>>> # cat conservative/down_threshold
>>>>>> 20
>>>>>> # echo ondemand > scaling_governor
>>>>> Thanks Stephen,
>>>>>
>>>>> There's obviously a difference in our .configs.  I have a global conservative
>>>>> directory, ie) /sys/devices/system/cpu/cpufreq/conservative instead of a
>>>>> per-cpu
>>>>> governor file.
>>>>>
>>>>> ie) what are your .config options for CPUFREQ?
>>>>>
>>>>> Mine are:
>>>>>
>>>>> #
>>>>> # CPU Frequency scaling
>>>>> #
>>>>> CONFIG_CPU_FREQ=y
>>>>> CONFIG_CPU_FREQ_GOV_COMMON=y
>>>>> CONFIG_CPU_FREQ_STAT=m
>>>>> CONFIG_CPU_FREQ_STAT_DETAILS=y
>>>>> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
>>>>> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
>>>>> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
>>>>> CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
>>>>> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
>>>>> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
>>>>> CONFIG_CPU_FREQ_GOV_USERSPACE=y
>>>>> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
>>>>> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
>>>>>
>>>>> Is there some other config option I have to set?
>>>> I have the same options. The difference is that my driver has a governor
>>>> per policy. That's set with the CPUFREQ_HAVE_GOVERNOR_PER_POLICY flag.
>>>> If I remove that flag I can't trigger the lockdep splat anymore with
>>>> this sequence and your patch.
>>> I see -- so you're seeing this on arm then?  If so, let me know so I can reserve
>>> one to work on :)
>>>
>>
>> I only have ARM to test on. You can set this flag in your cpufreq driver
>> if you have independently scaling CPU frequencies, so it isn't
>> necessarily an ARM thing.
>>
> 
> Sorry, forgot to mention this in the earlier email. But yeah, this is a totally
> SW feature. You should be able to enable this flag in your driver.

Thanks Saravana, I'll get back to this today.  I'm also going to try to track
down an ARM server as well.

I'll get back to everyone in a bit.

P.

> 
> -Saravana
> 
