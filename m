Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935906Ab3DJG4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:56:34 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:54838 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3DJG4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:56:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfTPtD6MK9ogq7mOijSxLSsH0n65Xra48XfRSB3DFs35GT=2g@mail.gmail.com>
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAOh2x=nPJa0GReiN=OHLG=m4Gq51F=4VppdaQL20xi-aUa8x2Q@mail.gmail.com>
	<20130409123719.7399d5ad@amdc308.digital.local>
	<CAKohpomL-mdx6DdFiGwJzDSeWr6Gw-_F4T-D-Jz9TNH5MSgjbw@mail.gmail.com>
	<20130409184440.4cd87c1b@amdc308.digital.local>
	<CAKfTPtD6MK9ogq7mOijSxLSsH0n65Xra48XfRSB3DFs35GT=2g@mail.gmail.com>
Date: Wed, 10 Apr 2013 08:56:31 +0200
Message-ID: <CAKfTPtBvcUfyMTFC3tNb=MyfEODXjo8MTOrqi2MjUmFnnPZCow@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] cpufreq: Introduce LAB cpufreq governor.
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2013 20:52, Vincent Guittot <vincent.guittot@linaro.org> wrote:
>
>
> On Tuesday, 9 April 2013, Lukasz Majewski <l.majewski@samsung.com> wrote:
>> Hi Viresh and Vincent,
>>
>>> On 9 April 2013 16:07, Lukasz Majewski <l.majewski@samsung.com> wrote:
>>> >> On Mon, Apr 1, 2013 at 1:54 PM, Jonghwa Lee
>>> > Our approach is a bit different than cpufreq_ondemand one. Ondemand
>>> > takes the per CPU idle time, then on that basis calculates per cpu
>>> > load. The next step is to choose the highest load and then use this
>>> > value to properly scale frequency.
>>> >
>>> > On the other hand LAB tries to model different behavior:
>>> >
>>> > As a first step we applied Vincent Guittot's "pack small tasks" [*]
>>> > patch to improve "race to idle" behavior:
>>> >
>>> > http://article.gmane.org/gmane.linux.kernel/1371435/match=sched+pack+small+tasks
>>>
>>> Luckily he is part of my team :)
>>>
>>> http://www.linaro.org/linux-on-arm/meet-the-team/power-management
>>>
>>> BTW, he is using ondemand governor for all his work.
>>>
>>> > Afterwards, we decided to investigate different approach for power
>>> > governing:
>>> >
>>> > Use the number of sleeping CPUs (not the maximal per-CPU load) to
>>> > change frequency. We thereof depend on [*] to "pack" as many tasks
>>> > to CPU as possible and allow other to sleep.
>>>
>>> He packs only small tasks.
>>
>> What's about packing not only small tasks? I will investigate the
>> possibility to aggressively pack (even with a cost of performance
>> degradation) as many tasks as possible to a single CPU.
>
> Hi Lukasz,
>
> I've got same comment on my current patch and I'm preparing a new version
> that can pack tasks more agressively based on the same buddy mecanism. This
> will be done at the cost of performance of course.
>
>
>
>>
>> It seems a good idea for a power consumption reduction.
>
> In fact, it's not always true and depends several inputs like the number of
> tasks that run simultaneously
>
>
>>
>>> And if there are many small tasks we are
>>> packing, then load must be high and so ondemand gov will increase
>>> freq.
>>
>> This is of course true for "packing" all tasks to a single CPU. If we
>> stay at the power consumption envelope, we can even overclock the
>> frequency.
>>
>> But what if other - lets say 3 CPUs - are under heavy workload?
>> Ondemand will switch frequency to maximum, and as Jonghwa pointed out
>> this can cause dangerous temperature increase.
>
> IIUC, your main concern is to stay in a power consumption budget to not over
> heat and have to face the side effect of high temperature like a decrease of
> power efficiency. So your governor modifies the max frequency based on the
> number of running/idle CPU to have an almost stable power consumtpion ?
>
> Have you also looked at the power clamp driver that have similar target ?
>
>
> Vincent
>
>
>>
>>>
>>> > Contrary, when all cores are heavily loaded, we decided to reduce
>>> > frequency by around 30%. With this approach user experience
>>> > recution is still acceptable (with much less power consumption).
>>>
>>> Don't know.. running many cpus at lower freq for long duration will
>>> probably take more power than running them at high freq for short
>>> duration and making system idle again.
>>>
>>> > We have posted this "RFC" patch mainly for discussion, and I think
>>> > it fits its purpose :-).
>>>
>>> Yes, no issues with your RFC idea.. its perfect..
>>>
>>> @Vincent: Can you please follow this thread a bit and tell us what
>>> your views are?
>>>
>>> --
>>> viresh
>>
>>
>>
>> --
>> Best regards,
>>
>> Lukasz Majewski
>>
>> Samsung R&D Poland (SRPOL) | Linux Platform Group
>>
