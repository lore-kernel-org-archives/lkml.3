Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab3EXIvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:51:35 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:49509 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956Ab3EXIvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:51:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130524103007.7bb206ee@amdc308.digital.local>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
	<20130522122700.104ca5cd@amdc308.digital.local>
	<CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
	<20130522164453.29cd3a7d@amdc308.digital.local>
	<20130524075640.0a5b80ff@amdc308.digital.local>
	<CAKohpoksymD76rDvg_+PwU7r3JXp1oydHBbJE4-y6TBHOomZHg@mail.gmail.com>
	<20130524103007.7bb206ee@amdc308.digital.local>
Date: Fri, 24 May 2013 14:21:30 +0530
Message-ID: <CAKohponbX7u_k9ZYQ7KyBeyKh93Qu+niGZj60t9c1n+AmaA6pg@mail.gmail.com>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 May 2013 14:00, Lukasz Majewski <l.majewski@samsung.com> wrote:
> The overclock frequency (1.5 GHz) is possible to set as an ordinary,
> available frequency (policy->max) for ondemand.
>
> Unfortunately with our load patterns, this frequency rapidly increases
> internal chip temperature (chip goes out of available power/thermal
> dissipation range), and consumes extra power when not needed.
>
> The core idea with overclock is to increase ("boost") the frequency
> when conditions allow to do it (for example load is affined to a single
> core, other are idle). Then we will not exceed power/thermal budget, but
> increase performance (and even save power).
>
>
> Overclocking is efficiently utilized by LAB, which relies on a number of
> idle cpus. Thus, we can easily asses if we can enable it.
>
> I also foresee potential use of overclocking, when scheduler will take a
> major role of power saver for mobile (ARM) linux. Since it will try to
> pack as much tasks as possible to a single core - it will need a
> framework/API to "boost" their execution.

Okay.. so its exactly what I thought the reason would be.

What I would have done if I was in your place is:

Add following sysfs tunables to ondemand governor:

- overdrive_freq: We will go over this frequency only when
number of busy cores is <= overdrive_cores..
For your case it will be 1.4 GHz

- overdrive_cores: We will enable overdrive frequencies only if no. of
busy cores is <= overdrive_cores. Zero by default (So, that this feature
is disabled by default) and 1 for your case.

And your driver will include all the available frequencies in the freq
table.

I hope this will be the most generic solution to your problem..

What do you say?

--
viresh
