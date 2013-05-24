Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab3EXJN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:13:57 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41276 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760088Ab3EXJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:13:54 -0400
MIME-Version: 1.0
In-Reply-To: <519F2D89.5030602@linaro.org>
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
Date: Fri, 24 May 2013 14:43:53 +0530
Message-ID: <CAKohpom+wsGj=1nurNtoiRaZCD7KRbx0BO+tNXpoqO+FmmzehA@mail.gmail.com>
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

On 24 May 2013 14:36, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> I agree with Viresh, a new governor is not necessary here for that.

Their patchset had two parts.. One is LAB and other is overclocking.
We are trying to solve overclocking for which they never wanted a
new governor. :)

> There is the /sys/devices/system/cpufreq/boost option existing for x86
> platform, why do not reuse it ? It is supposed to do exactly what you
> want to achieve.

The problem is that it was added at the wrong place.. It should have
been at cpu/cpuX/cpufreq/boost...

Consider how will we achieve it for big LITTLE.. We know we can
go to overdrive only for a single core in big but for two cores in
LITTLE at the same time.. So, we need that in the location I just
mentioned...

Over that.. I believe it is governor specific too.. It shouldn't be part
of conservative as it should be conservative rather then aggressive :)

> IMO, the logic of boosting one core when the other are idle should be in
> the driver itself and certainly not setup by the user, except if we
> consider acceptable the user can burn its board ... :)

I didn't get it completely.. So, with the options I gave user can only
say.. boost if required and only when few cores are active. User
can't just set max freq continuously if he wishes..
