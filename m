Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3EXLVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:21:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63067 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3EXLVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:21:05 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-ad-519f4d1fcc1b
Date: Fri, 24 May 2013 13:20:36 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
Message-id: <20130524132036.7e7d5ffe@amdc308.digital.local>
In-reply-to: <CAKohponbX7u_k9ZYQ7KyBeyKh93Qu+niGZj60t9c1n+AmaA6pg@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
 <20130522122700.104ca5cd@amdc308.digital.local>
 <CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
 <20130522164453.29cd3a7d@amdc308.digital.local>
 <20130524075640.0a5b80ff@amdc308.digital.local>
 <CAKohpoksymD76rDvg_+PwU7r3JXp1oydHBbJE4-y6TBHOomZHg@mail.gmail.com>
 <20130524103007.7bb206ee@amdc308.digital.local>
 <CAKohponbX7u_k9ZYQ7KyBeyKh93Qu+niGZj60t9c1n+AmaA6pg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jAV153/mBBlcP8Fs8bfrBbjHvs6xF
	59knzBZvHnFbXN41h83ic+8RRovbjSvYLPoX9jJZdBz5xmyx8auHA5fHnWt72DzWTXvL7NG3
	ZRWjx6PFLYwenzfJBbBGcdmkpOZklqUW6dslcGXM6tcqmC5T8fx0SQPjMrEuRk4OCQETibcz
	vzBC2GISF+6tZ+ti5OIQEljEKPH5Tw8LhNPOJLH++lRmkCoWAVWJKz8/soHYbAJ6Ep/vPmXq
	YuTgEBHQknh5MxWknlngApPEqUuzmEBqhAXSJf5t6wKzeQWsJZ6fnsQKYnMKBEucPn6TGWLB
	GhaJU++fghXxC0hKtP/7wQxxkp3EuU8b2CGaBSV+TL7HAmIzAy3bvK2JFcKWl9i85i3zBEbB
	WUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Kh4Jr2DcVWDxSFGAQ5G
	JR7eGTrzAoVYE8uKK3MPMUpwMCuJ8M7imx8oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3Wg
	kEB6YklqdmpqQWoRTJaJg1OqgVF6GW/7dKNPjWp7VoplrTkt2dct/MN/f/jxbUbsVbeDNrSW
	LFnTI6Y0JeFdwLW3v/77TXj7uS5h+4G1H/QnXV/0uOio78eplxSl5vez7837rTBHMPfZZqc5
	dcnF+iJ7Tz1qWnde1Yv52uKdH/e++9lxXPegcHLhTu3DX/WetfGYzJ+uWTx36YmLSizFGYmG
	WsxFxYkArPQYOoYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 24 May 2013 14:00, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > The overclock frequency (1.5 GHz) is possible to set as an ordinary,
> > available frequency (policy->max) for ondemand.
> >
> > Unfortunately with our load patterns, this frequency rapidly
> > increases internal chip temperature (chip goes out of available
> > power/thermal dissipation range), and consumes extra power when not
> > needed.
> >
> > The core idea with overclock is to increase ("boost") the frequency
> > when conditions allow to do it (for example load is affined to a
> > single core, other are idle). Then we will not exceed power/thermal
> > budget, but increase performance (and even save power).
> >
> >
> > Overclocking is efficiently utilized by LAB, which relies on a
> > number of idle cpus. Thus, we can easily asses if we can enable it.
> >
> > I also foresee potential use of overclocking, when scheduler will
> > take a major role of power saver for mobile (ARM) linux. Since it
> > will try to pack as much tasks as possible to a single core - it
> > will need a framework/API to "boost" their execution.
> 
> Okay.. so its exactly what I thought the reason would be.
> 
> What I would have done if I was in your place is:
> 
> Add following sysfs tunables to ondemand governor:
> 
> - overdrive_freq: We will go over this frequency only when
> number of busy cores is <= overdrive_cores..
> For your case it will be 1.4 GHz
> 
> - overdrive_cores: We will enable overdrive frequencies only if no. of
> busy cores is <= overdrive_cores. Zero by default (So, that this
> feature is disabled by default) and 1 for your case.
> 
> And your driver will include all the available frequencies in the freq
> table.

This is not safe IMHO to add permanently overclocked frequency to the
freq table. Since, for example, thermal framework also asks for
reference to this table. 

The idea beneath overclocking is to add "dangerous" frequency to the
frequency table only when necessary (and remove it when not needed). 

In this way, the thermal framework (as it is done at our platform) will
decrease the frequency (according to thermal governor :-) ) to safe
level.



Overclocking is disabled in 2 ways (at our setup): 
- thermal framework is here to help us
- lab governor disables the overclocking when favorable conditions are
  gone.

One more remark - enabling tb_en_over_clk at sysfs (echo 1
> /sys/devices/system/cpu/cpu0/cpufreq/tb_en_over_clk)
adds overclock frequency to frequency table and updates policy. 

It doesn't switch frequency to overclock value. This switching is done
only when proper conditions are in place (in ondemand or LAB). 

> 
> I hope this will be the most generic solution to your problem..
> 
> What do you say?

Another issue is the current ondemand implementation:

It choose the highest load of all running cpus. This is not optimal in
terms of power consumption at multicore SoCs.

This is the ondemand legacy API (lb_check_cpu(int cpu, unsigned int
load_freq)).

I'm afraid, that ondemand would get polluted by the attempt to
implement LAB's logic into it.

In the end we would have "ondemand", which based on a runtime flag
value uses maximal load of a single processor, or counts number of
idle cpus (and filter them) to switch frequency.

To avoid such clash, we have decided to develop new governor with
minimal changes to core.

Such approach keeps logic clear.



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
