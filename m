Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936716Ab3DJIpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:45:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32361 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936323Ab3DJIpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:45:01 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-1d-5165268c19d0
Date: Wed, 10 Apr 2013 10:44:52 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
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
Subject: Re: [RFC PATCH 0/2] cpufreq: Introduce LAB cpufreq governor.
Message-id: <20130410104452.661902af@amdc308.digital.local>
In-reply-to: <CAKfTPtD6MK9ogq7mOijSxLSsH0n65Xra48XfRSB3DFs35GT=2g@mail.gmail.com>
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAOh2x=nPJa0GReiN=OHLG=m4Gq51F=4VppdaQL20xi-aUa8x2Q@mail.gmail.com>
 <20130409123719.7399d5ad@amdc308.digital.local>
 <CAKohpomL-mdx6DdFiGwJzDSeWr6Gw-_F4T-D-Jz9TNH5MSgjbw@mail.gmail.com>
 <20130409184440.4cd87c1b@amdc308.digital.local>
 <CAKfTPtD6MK9ogq7mOijSxLSsH0n65Xra48XfRSB3DFs35GT=2g@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9jAd0etdRAg4XTNC2eNv1gt7j+5Tmr
	RefZJ8wWZ5vesFtc3jWHzeJz7xFGi7VH7rJb3G5cwWbRv7CXyWLG5JdsFh1HvjFbbPzq4cDj
	cefaHjaPvi2rGD0eLW5h9Pi8SS6AJYrLJiU1J7MstUjfLoEr4+LXCUwFz3UqpmyXamBsV+5i
	5OSQEDCRmHNrCROELSZx4d56ti5GLg4hgUWMEhtvHmOBcNqZJB5MWsIGUsUioCrRtHglK4jN
	JqAn8fnuU7BuEQEDiZ8fPzGD2MwC/5kl5u4wA7GFBVwl+vZfYQSxeQWsJb4s/AI2h1MgWKJ9
	Sx8jxIJGZok3C2ezgCT4BSQl2v/9YIY4yU7i3KcN7BDNghI/Jt9jgVigJbF5WxMrhK0t8eTd
	BdYJjIKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBUfJMegfjqgaL
	Q4wCHIxKPLwLDFMChVgTy4orcw8xSnAwK4nw3vwOFOJNSaysSi3Kjy8qzUktPsQozcGiJM57
	sNU6UEggPbEkNTs1tSC1CCbLxMEJDHSlOKcfDk037h7488tcdULa/Rt2k/vPvTX4ky62l8HT
	XyNE8U4asxvntwmHnEMf9X2y6J52sv5MTpi4fGZW5fnp4V59TN9jW+MtguPvMZtd2Wyd+2NO
	sF4O7/Hwv7ZdvmxfLy0Mux63OsxfwpLPQ2dywsrds6cpnF+av+bb9yfbuNKEHVPCbiuxFGck
	GmoxFxUnAgAD2XB+jgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

> 
> 
> On Tuesday, 9 April 2013, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> > Hi Viresh and Vincent,
> >
> >> On 9 April 2013 16:07, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> >> >> On Mon, Apr 1, 2013 at 1:54 PM, Jonghwa Lee
> >> > Our approach is a bit different than cpufreq_ondemand one.
> >> > Ondemand takes the per CPU idle time, then on that basis
> >> > calculates per cpu load. The next step is to choose the highest
> >> > load and then use this value to properly scale frequency.
> >> >
> >> > On the other hand LAB tries to model different behavior:
> >> >
> >> > As a first step we applied Vincent Guittot's "pack small
> >> > tasks" [*] patch to improve "race to idle" behavior:
> >> > http://article.gmane.org/gmane.linux.kernel/1371435/match=sched+pack+small+tasks
> >>
> >> Luckily he is part of my team :)
> >>
> >> http://www.linaro.org/linux-on-arm/meet-the-team/power-management
> >>
> >> BTW, he is using ondemand governor for all his work.
> >>
> >> > Afterwards, we decided to investigate different approach for
> >> > power governing:
> >> >
> >> > Use the number of sleeping CPUs (not the maximal per-CPU load) to
> >> > change frequency. We thereof depend on [*] to "pack" as many
> >> > tasks to CPU as possible and allow other to sleep.
> >>
> >> He packs only small tasks.
> >
> > What's about packing not only small tasks? I will investigate the
> > possibility to aggressively pack (even with a cost of performance
> > degradation) as many tasks as possible to a single CPU.
> 
> Hi Lukasz,
> 
> I've got same comment on my current patch and I'm preparing a new
> version that can pack tasks more agressively based on the same buddy
> mecanism. This will be done at the cost of performance of course.

Can you share your development tree?

> 
> 
> >
> > It seems a good idea for a power consumption reduction.
> 
> In fact, it's not always true and depends several inputs like the
> number of tasks that run simultaneously

In my understanding, we can try to couple (affine) maximal number of
task with a CPU. Performance shall decrease, but we will avoid costs of
tasks migration. 

If I remember correctly, I've asked you about some testbench/test
program for scheduler evaluation. I assume that nothing has changed and
there isn't any "common" set of scheduler tests?

> 
> >
> >> And if there are many small tasks we are
> >> packing, then load must be high and so ondemand gov will increase
> >> freq.
> >
> > This is of course true for "packing" all tasks to a single CPU. If
> > we stay at the power consumption envelope, we can even overclock the
> > frequency.
> >
> > But what if other - lets say 3 CPUs - are under heavy workload?
> > Ondemand will switch frequency to maximum, and as Jonghwa pointed
> > out this can cause dangerous temperature increase.
> 
> IIUC, your main concern is to stay in a power consumption budget to
> not over heat and have to face the side effect of high temperature
> like a decrease of power efficiency. So your governor modifies the
> max frequency based on the number of running/idle CPU
Yes, this is correct.

> to have an
> almost stable power consumtpion ?

>From our observation it seems, that for 3 or 4 running CPUs under heavy
load we see much more power consumption reduction.

To put it in another way - ondemand would increase frequency to max for
all 4 CPUs. On the other hand, if user experience drops to the
acceptable level we can reduce power consumption. 

Reducing frequency and CPU voltage (by DVS) causes as a side effect,
that temperature stays at acceptable level.

> 
> Have you also looked at the power clamp driver that have similar
> target ?

I might be wrong here, but in my opinion the power clamp driver is a bit
different:

1. It is dedicated to Intel SoCs, which provide special set of
registers (i.e. MSR_PKG_Cx_RESIDENCY [*]), which forces a processor to
enter certain C state for a given duration. Idle duration is calculated
by per CPU set of high priority kthreads (which also program [*]
registers). 

2. ARM SoCs don't have such infrastructure, so we depend on SW here.
Scheduler has to remove tasks from a particular CPU and "execute" on
it the idle_task.
Moreover at Exynos4 thermal control loop depends on SW, since we can
only read SoC temperature via TMU (Thermal Management Unit) block.


Correct me again, but it seems to me that on ARM we can use CPU hotplug
(which as Tomas Glexner stated recently is going to be "refactored" :-)
) or "ask" scheduler to use smallest possible number of CPUs and enter C
state for idling CPUs.



> 
> 
> Vincent
> 
> >
> >>
> >> > Contrary, when all cores are heavily loaded, we decided to reduce
> >> > frequency by around 30%. With this approach user experience
> >> > recution is still acceptable (with much less power consumption).
> >>
> >> Don't know.. running many cpus at lower freq for long duration will
> >> probably take more power than running them at high freq for short
> >> duration and making system idle again.
> >>
> >> > We have posted this "RFC" patch mainly for discussion, and I
> >> > think it fits its purpose :-).
> >>
> >> Yes, no issues with your RFC idea.. its perfect..
> >>
> >> @Vincent: Can you please follow this thread a bit and tell us what
> >> your views are?
> >>
> >> --
> >> viresh
> >
> >
> >
> > --
> > Best regards,
> >
> > Lukasz Majewski
> >
> > Samsung R&D Poland (SRPOL) | Linux Platform Group
> >


-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
