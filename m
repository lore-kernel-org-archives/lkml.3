Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937710Ab3DIKhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:37:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16138 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935514Ab3DIKh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:37:28 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-83-5163ef66c07b
Date: Tue, 09 Apr 2013 12:37:19 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC PATCH 0/2] cpufreq: Introduce LAB cpufreq governor.
Message-id: <20130409123719.7399d5ad@amdc308.digital.local>
In-reply-to: <CAOh2x=nPJa0GReiN=OHLG=m4Gq51F=4VppdaQL20xi-aUa8x2Q@mail.gmail.com>
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAOh2x=nPJa0GReiN=OHLG=m4Gq51F=4VppdaQL20xi-aUa8x2Q@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t9jQd2098mBBtc2WVk8bfrBbnH9y3NW
	i86zT5gtzja9Ybe4vGsOm8Xn3iOMFmuP3GW3uN24gs2if2Evk8WMyS/ZLDZ+9XDg9rhzbQ+b
	R9+WVYwejxa3MHp83iQXwBLFZZOSmpNZllqkb5fAlXHg5xOmgn71itsTvzM3MDbIdzFyckgI
	mEj8mNnIDmGLSVy4t54NxBYSmM4o8WuVUxcjF5DdziSx5u5MVpAEi4CqxPJDl8GK2AT0JD7f
	fcrUxcjBISKgJfHyZipIPbPADmaJzoX3wGqEBVwl+vZfYQSxeQWsJW6e+wQ2h1MgWGL+mSXs
	EAv6GSWezDnJApLgF5CUaP/3gxniIjuJc582sEM0C0r8mHwPrIYZaNnmbU2sELa8xOY1b5kn
	MArOQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx8Yz6R2MqxosDjEK
	cDAq8fBeeJIUKMSaWFZcmXuIUYKDWUmEt+VOcqAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt
	1oFCAumJJanZqakFqUUwWSYOTqkGRusGn+8xa9/Ebrv7WkNFJNxDL4Dt3Xrj62nFk06byO6O
	3MFx2O+11WuWQycUgxxlun56HJw245xLeylDrfjOF5IXGi9fSmb7Jrluq7c2j8mxe3/2HVnX
	8yhnw8bOTcXqRntjH5j8Os+pzy3LNV/M4nbwtiWiN3keK0k3u4QlPd6s1aq683GjphJLcUai
	oRZzUXEiAIIGnfSJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

First of all I'd like to apologize for a late response.
Please find my comments below. 

> On Mon, Apr 1, 2013 at 1:54 PM, Jonghwa Lee
> <jonghwa3.lee@samsung.com> wrote:
> > <<Purpose>>
> >  One of the problem of ondemand is that it considers the most busy
> > cpu only while doesn't care how many cpu is in busy state at the
> > moment. This may results in unnecessary power consumption, and it'll
> > be critical for the system having limited power source.
> >
> >  To get the best energy efficiency, LAB governor considers not only
> > idle time but also the number of idle cpus. It primarily focuses on
> > supplying adequate performance to users within the limited resource.
> > It checks the number of idle cpus then controls the maximum
> > frequency dynamically. And it also applies different frequency
> > increasing level depends on that information. In simple terms the
> > less the number of busy cpus, the better performance will be given.
> >  In addition, stable system's power consumption in the busy state
> > can be achieved also with using LAB governor. This will help to
> > manage and estimate power consumption in certain system.
> 
> Hi Jonghwa,
> 
> First of all, i should accept that i haven't got to the minute details
> about your
> patch until now but have done a broad review of it.
> 
> There are many things that i am concerned about:
> - I don't want an additional governor to be added to cpufreq unless
> there is a very very strong reason for it. See what happened to
> earlier attempts:
> 
> https://lkml.org/lkml/2012/2/7/504
> 
> But it doesn't mean you can't get it in. :)
> 
> - What the real logic behind your patchset: I haven't got it
> completely with your
> mails. So what you said is:
> 
>   - The lesser the number of busy cpus: you want to run at higher
> freqs
>   - The more the number of busy cpus: you want to run at lower freqs
> 
> But the basic idea i had about this stuff was: The more the number of
> busy cpus, the more loaded the system is, otherwise scheduler wouldn't
> have used so many cpus and so there is need to run at higher frequency
> rather than a lower one. Which would save power in a sense.. Finish
> work early and let most of the cpus enter idle state as early as
> possible. But with your solution we would run at lower frequencies
> and so these cpus will take longer to get into idle state again. This
> will really kill lot of power.

Our approach is a bit different than cpufreq_ondemand one. Ondemand
takes the per CPU idle time, then on that basis calculates per cpu load.
The next step is to choose the highest load and then use this value to
properly scale frequency.

On the other hand LAB tries to model different behavior:

As a first step we applied Vincent Guittot's "pack small tasks" [*]
patch to improve "race to idle" behavior:
http://article.gmane.org/gmane.linux.kernel/1371435/match=sched+pack+small+tasks	

Afterwards, we decided to investigate different approach for power
governing:

Use the number of sleeping CPUs (not the maximal per-CPU load) to
change frequency. We thereof depend on [*] to "pack" as many tasks to
CPU as possible and allow other to sleep. 
On this basis we can increase (even overclock) frequency (when other
CPUs sleep) to improve performance of the only running CPU. 

Contrary, when all cores are heavily loaded, we decided to reduce
frequency by around 30%. With this approach user experience recution is
still acceptable (with much less power consumption).
When system is "idle" - only small background tasks are running, the
frequency is reduced to minimum. 

To sum up:

Different approach (number of idle CPUs) is used by us to control
ondemand governor. We also heavily depend on [*] patch set.

> 
> Think about it.
> 
> - In case you need some sort of support on this use case, why
> replicate ondemand governor again by creating another governor. I
> have had some hard time removing the amount of redundancy inside
> governors and you are again going towards that direction. Modifying
> ondemand governor for this response would be a better option.

We have only posted the "RFC" so, we are open for suggestions. 

At cpufreq_governor.c file the dbs_check_cpu function is responsible
for calculating the maximal load (among CPUs). I think that we could
also count the number of sleeping CPUs (as the average of time
accumulated data). Then we could pass this data to newly written
function (e.g. lab_check_cpu) defined at cpufreq_ondemand.c (and
pointed to by gov_check_cpu).

This would require change to dbs_check_cpu function and extending
ONDEMAND governor by lab_check_cpu() function.

> 
> - You haven't rebased of latest code from linux-next :)
> 

We have posted this "RFC" patch mainly for discussion, and I think it
fits its purpose :-).



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
