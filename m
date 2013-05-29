Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935064Ab3E2HJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:09:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52448 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3E2HJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:09:41 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-df-51a5a9b235af
Date: Wed, 29 May 2013 09:09:02 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
Message-id: <20130529090902.66c29c26@amdc308.digital.local>
In-reply-to: <CAKohpon8CScv_GgXL4eTvKqPo1oC67TujMH4WdOQCit7jz+FeQ@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <2272781.tC3OqoQmKI@vostro.rjw.lan>
 <20130528152625.1b7833e5@amdc308.digital.local>
 <76114024.UaPHgm94jK@vostro.rjw.lan>
 <CAKohpon8CScv_GgXL4eTvKqPo1oC67TujMH4WdOQCit7jz+FeQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jAd1NK5cGGuw/YWTxtOkHu8W8z7IW
	nWefMFu8ecRtcXnXHDaLz71HGC1uN65gs+hf2Mtk0XHkG7PFxq8eDlwed67tYfNYN+0ts0ff
	llWMHo8WtzB6fN4kF8AaxWWTkpqTWZZapG+XwJWxbc9R9oLbahXX1mU1MG6U62Lk5JAQMJHY
	uPIQM4QtJnHh3nq2LkYuDiGBRYwSHYcuMYIkhATamSQOtvKA2CwCqhILdu8Da2AT0JP4fPcp
	E4gtIuArsWjRZiaQZmaBbmaJMwffgiWEBdIl/m3rArN5BawlVi56ADaUUyBY4s7HR4wQ2/qY
	JKbcv8MKkuAXkJRo//cD6iQ7iXOfNrBDNAtK/Jh8jwXEZhbQkti8rYkVwpaX2LzmLfMERsFZ
	SMpmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzguHgmtYNxZYPFIUYBDkYl
	Hl6GX0sChVgTy4orcw8xSnAwK4nwpgouDRTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBI
	ID2xJDU7NbUgtQgmy8TBKdXAaLtqa1RSeZrSPuOr5nElQrs0l3psu+8UXrXhUf7Z2PYN9zj1
	t1/7demu7fazeoIPy651ODYd3anQmsYyTb3inlySvYy4sraQ9SpRPo7eT6HNs5/JtB/rDrtk
	cPNM3yk2na+sst/La5Ke3E19ZOb6v3vrx3evfspffy3xOmhlRFMSh3z9rI5kJZbijERDLeai
	4kQAfoUAPIcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh, Rafael,

> On 29 May 2013 03:18, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, May 28, 2013 03:26:25 PM Lukasz Majewski wrote:
> >> Hi Viresh, Rafael,
> >>
> >> > On Tuesday, May 28, 2013 03:14:26 PM Viresh Kumar wrote:
> 
> >> > I'm not sure about that.  On x86 boost will be used with all
> >> > governors if enabled (as currently defined in acpi-cpufreq).
> >>
> >> All governors can benefit from the overclocking code.
> 
> Yeah.
> 
> >> > Also it looks like this depends on the driver too, because if the
> >> > driver doesn't have "turbo" frequencies, the governor won't be
> >> > able use "turbo" anyway.
> 
> Yes.
> 
> >> > So first, it would make sense to use a per-driver "boost"
> >> > attribute indicating whether or not the given driver should
> >> > present any "turbo" frequencies to the governor.
> 
> @Lukasz: So, you need to add another field in struct cpufreq_driver,
> which will be called "turbo_mode" or something better.

This is my intention - to extend cpufreq_driver structure. When
turbo_mode=1, then we will export knobs to sysfs.

For ARM, it is also convenient to define proper attribute at device
tree, per-board source file. It will be parsed at cpufreq driver and
set turbo_mode accordingly.

> 
> >> Now I'm using a device tree's cpufreq section (defined at
> >> exynos4412-redwood.dts) with overclocking = "okay" attribute
> >> defined. Then, on this basis, we could decide at cpufreq init time
> >> if we will export any overclocking related sysfs entries (or init
> >> overclocking at all). It would assure clearer code.
> >
> > Well, what about users?  Don't you want them to be able to decide
> > whether or not to use "turbo"?
> 
> I believe Lukasz was saying that we can have two levels of enabling
> it.. Firstly the driver can say if it supports turbo_mode or not and
> so will register cpufreq_driver with appropriate parameters..
> 
> Now if turbo_mode == true, then sysfs entry will be created by cpufreq
> core which users can enable/disable...
> 
Yes, this is the point. Sorry for blur description.

> And this is what I had in mind too.
> 
> >> I think that global cpufreq device tree attribute shall be defined.
> >
> > What do you mean by "device tree attribute"?  If you mean FDTs as
> > used by ARM for system configuration description, that wouldn't be
> > portable, because DTs aren't used for that on the (majority of) x86
> > systems.
> 
> So, drivers should pass correct value in boost_mode in struct
> cpufreq_driver. They get it from DT or is hard coded doesn't matter
> at all to the core. But yes getting a single name for DT bindings
> would be good. We should use the same name at that place too:
> turbo_mode
> 

Yes, this is my goal. For prototype (on which I'm now working) I've
used overclock attribute. But, I will change its name to turbo_mode. 

> >> The overclocking will be an integral part of the cpufreq framework.
> >
> > Well, to be precise, I was thinking about moving the management of
> > the /sys/devices/system/cpu/cpufreq/boost attribute from
> > acpi-cpufreq to the code so that other drivers may use it too.
> > Does that make sense to you?
> 
> Obviously yes. The sysfs related code from acpi-cpufreq should be
> moved to cpufreq.c and will be functional once cpufreq_driver has
> boost_mode set as true.

I also agree. Moreover, I think that there should be only one set of
"boost" sysfs entries either it is supported by HW (Intel) or SW (ARM).

I can think of two "basic" one: 
- max_turbo_freq (ro)
- turbo_mode/boost (rw)

But I cannot figure out where those entries shall be finally placed [*]:
- /sys/devices/system/cpu/cpuX/cpufreq/

or 

- /sys/devices/system/cpu/cpufreq/boost

Second option would be better, if we assume that boost is a global
option - as at Intel (I might be wrong here...) and ARM exynos4 SoC.

On the other hand first option would be used with systems, where
per-core (or core sets) frequency setting is possible (b.L, Snapdragon
S4)

> 
> >> > Second, I'm not sure if an additional knob for the governor is
> >> > necessary.  It may just use the turbo frequencies if available
> >> > (and if the governor cannot use them, it simply won't use them).
> >>
> >> I cannot agree. It is welcome to be able to enable/disable the
> >> feature when needed. Turbo frequencies shall not be "available"
> >> for use all the time.
> 
> Yes, you can disable that from userspace once your driver said: "I
> support turbo mode"..

To sum up - the idea is as follow:

1. cpufreq_driver exports turbo_mode=1 when it supports overclocking
(this support can be hardcoded or read from device tree)

2. Then proper entries are exported to sysfs.

3. User via sysfs (at [*]) can enable/disable the feature on demand 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
