Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966238Ab3E2NqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:46:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54896 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab3E2Np7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:45:59 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-39-51a60696db71
Date: Wed, 29 May 2013 15:45:23 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
Message-id: <20130529154523.60a3cb5b@amdc308.digital.local>
In-reply-to: <CAKohpo=xuasNEaOBajze2nGVX48_8AE+3eWwbmhXcG9r7PG+EA@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <2272781.tC3OqoQmKI@vostro.rjw.lan>
 <20130528152625.1b7833e5@amdc308.digital.local>
 <76114024.UaPHgm94jK@vostro.rjw.lan>
 <CAKohpon8CScv_GgXL4eTvKqPo1oC67TujMH4WdOQCit7jz+FeQ@mail.gmail.com>
 <20130529090902.66c29c26@amdc308.digital.local>
 <CAKohpo=xuasNEaOBajze2nGVX48_8AE+3eWwbmhXcG9r7PG+EA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQd1pbMsCDY62SFg8bfrBbjHvs6xF
	59knzBZvHnFbXN41h83ic+8RRovbjSvYLPoX9jJZdBz5xmyx8auHA5fHnWt72DzWTXvL7NG3
	ZRWjx6PFLYwenzfJBbBGcdmkpOZklqUW6dslcGX07nrPVvCbt+LaiSb2BsYXXF2MHBwSAiYS
	q2bFdDFyApliEhfurWfrYuTiEBKYzihx+ng3M4TTziQxY9NOZpAqFgFVieaL85hAbDYBPYnP
	d58ygQwSEdCSeHkzFaSeWWAds8S7g33sIDXCAukS/7Z1gdXwClhLnJqkDBLmFAiW2NjVzAo1
	n1nizMxfYPX8ApIS7f9+MENcZCdx7tMGsDivgKDEj8n3WEBsZqBdm7c1sULY8hKb17xlnsAo
	OAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwVz6R2MK5ssDjEKMDB
	qMTDy/BrSaAQa2JZcWXuIUYJDmYlEd5UwaWBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoH
	CgmkJ5akZqemFqQWwWSZODilGhgn7WRoV369+VHpEfftwntjUr+4zLp8qHRO15lFVZw2L1Lj
	jLwnLmL8HHO94f7kwAbHN0tdLe7p3vDamVNmudZ436RJ6nl9/4T3xWmtVHhd9PqjywMl/nWz
	HJZ9kcjr+di1easMi+SN5NV9r/ffY5u5u3Pq85KbD6XW5BdGr1tgdXTmx/KWfQefKLEUZyQa
	ajEXFScCADPrAGCGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 29 May 2013 12:39, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > I also agree. Moreover, I think that there should be only one set of
> > "boost" sysfs entries either it is supported by HW (Intel) or SW
> > (ARM).
> 
> Yes, you need to change acpi-cpufreq driver too to use this common
> infrastructure.

Ok, thanks for pointing out.

> 
> > I can think of two "basic" one:
> > - max_turbo_freq (ro)
> 
> This is surely per policy as two separate clusters can have separate
> values. And probably a better one would be scaling_boost_frequencies,
> that will list all boost frequencies.

Ok,

> 
> > - turbo_mode/boost (rw)
> 
> I am confused with these two names: boost and turbo.. Probably we
> should use a single name everywhere. Because acpi-cpufreq is already
> using boost, we might shift to that.
> 
> > - /sys/devices/system/cpu/cpufreq/boost
> 
> Obviously this one.
> 
> > On the other hand first option would be used with systems, where
> > per-core (or core sets) frequency setting is possible (b.L,
> > Snapdragon S4)
> 
> For now this feature would be enabled on all clusters and controlled
> by cpu/cpufreq/boost.

This will simplify considerably the driver code.

> 
> > To sum up - the idea is as follow:
> >
> > 1. cpufreq_driver exports turbo_mode=1 when it supports overclocking
> > (this support can be hardcoded or read from device tree)
> >
> > 2. Then proper entries are exported to sysfs.
> >
> > 3. User via sysfs (at [*]) can enable/disable the feature on demand
> 
> Bingo!!

Thanks for suggestions. I'm now working on a prototype code. I plan to
post it at the beginning of next week.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
