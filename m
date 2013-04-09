Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936674Ab3DIMCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:02:15 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54985 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936558Ab3DIMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:02:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130409123719.7399d5ad@amdc308.digital.local>
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAOh2x=nPJa0GReiN=OHLG=m4Gq51F=4VppdaQL20xi-aUa8x2Q@mail.gmail.com>
	<20130409123719.7399d5ad@amdc308.digital.local>
Date: Tue, 9 Apr 2013 17:32:08 +0530
Message-ID: <CAKohpomL-mdx6DdFiGwJzDSeWr6Gw-_F4T-D-Jz9TNH5MSgjbw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] cpufreq: Introduce LAB cpufreq governor.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2013 16:07, Lukasz Majewski <l.majewski@samsung.com> wrote:
>> On Mon, Apr 1, 2013 at 1:54 PM, Jonghwa Lee
> Our approach is a bit different than cpufreq_ondemand one. Ondemand
> takes the per CPU idle time, then on that basis calculates per cpu load.
> The next step is to choose the highest load and then use this value to
> properly scale frequency.
>
> On the other hand LAB tries to model different behavior:
>
> As a first step we applied Vincent Guittot's "pack small tasks" [*]
> patch to improve "race to idle" behavior:
> http://article.gmane.org/gmane.linux.kernel/1371435/match=sched+pack+small+tasks

Luckily he is part of my team :)

http://www.linaro.org/linux-on-arm/meet-the-team/power-management

BTW, he is using ondemand governor for all his work.

> Afterwards, we decided to investigate different approach for power
> governing:
>
> Use the number of sleeping CPUs (not the maximal per-CPU load) to
> change frequency. We thereof depend on [*] to "pack" as many tasks to
> CPU as possible and allow other to sleep.

He packs only small tasks. And if there are many small tasks we are
packing, then load must be high and so ondemand gov will increase freq.

> Contrary, when all cores are heavily loaded, we decided to reduce
> frequency by around 30%. With this approach user experience recution is
> still acceptable (with much less power consumption).

Don't know.. running many cpus at lower freq for long duration will probably
take more power than running them at high freq for short duration and making
system idle again.

> We have posted this "RFC" patch mainly for discussion, and I think it
> fits its purpose :-).

Yes, no issues with your RFC idea.. its perfect..

@Vincent: Can you please follow this thread a bit and tell us what your views
are?

--
viresh
