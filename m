Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465Ab3EXKcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:32:53 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:37238 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760434Ab3EXKct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <519F40D8.7040500@linaro.org>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
	<20130522122700.104ca5cd@amdc308.digital.local>
	<CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
	<20130522164453.29cd3a7d@amdc308.digital.local>
	<20130524075640.0a5b80ff@amdc308.digital.local>
	<CAKohpoksymD76rDvg_+PwU7r3JXp1oydHBbJE4-y6TBHOomZHg@mail.gmail.com>
	<20130524103007.7bb206ee@amdc308.digital.local>
	<CAKohponbX7u_k9ZYQ7KyBeyKh93Qu+niGZj60t9c1n+AmaA6pg@mail.gmail.com>
	<519F2D89.5030602@linaro.org>
	<CAKohpom+wsGj=1nurNtoiRaZCD7KRbx0BO+tNXpoqO+FmmzehA@mail.gmail.com>
	<519F40D8.7040500@linaro.org>
Date: Fri, 24 May 2013 16:02:48 +0530
Message-ID: <CAKohponamvV4FXicVq_SG-4Bdi34ODxpqum1KV60LsnoCu3Qog@mail.gmail.com>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "Rafael J. Wysocky" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 May 2013 15:58, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> On 05/24/2013 11:13 AM, Viresh Kumar wrote:

>> Consider how will we achieve it for big LITTLE.. We know we can
>> go to overdrive only for a single core in big but for two cores in
>> LITTLE at the same time.. So, we need that in the location I just
>> mentioned...
>
> I thought the constraints should be hardcoded in the driver and only one
> option is exposed to the userspace. If the user sets
> ondemand|performance + boost, then the exynos's or b.L's drivers know
> when they can go to boost (1x core, 1x big core, 2x little core, ...).

Cpufreq Drivers don't take a decision on cpu frequency. They just provide
a mechanism to cpufreq core.. Decision must come from governor all the
time.

>> I didn't get it completely.. So, with the options I gave user can only
>> say.. boost if required and only when few cores are active. User
>> can't just set max freq continuously if he wishes..
>
> Ok, may be I misunderstood. You suggested to define 'overdrive_cores'
> where the user can setup when to overdrive a core. If the user set an
> incorrect value, IIUC, the thermal value can go beyond the thermal limit
> and break the board. I am just worried this option is dangerous.

Yes.. if we set 4 at that place.. 4 cores may run together in overdrive
mode. And that is risky :) ... Maybe a max limit from driver will be another
option along with this.
