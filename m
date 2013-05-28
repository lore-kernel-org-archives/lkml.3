Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab3E1N1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:27:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18875 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922Ab3E1N05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:26:57 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-ba-51a4b0a0e39b
Date: Tue, 28 May 2013 15:26:25 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
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
Message-id: <20130528152625.1b7833e5@amdc308.digital.local>
In-reply-to: <2272781.tC3OqoQmKI@vostro.rjw.lan>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <20130528084035.13afa583@amdc308.digital.local>
 <CAKohpo=6Tk3NmcJw_fqnePu_skHKNB0rFBOUzEsCDyeLqxg4xA@mail.gmail.com>
 <2272781.tC3OqoQmKI@vostro.rjw.lan>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t9jAd0FG5YEGrR1SFs8bfrBbjHvs6xF
	59knzBZvHnFbXN41h83ic+8RRovbjSvYLPoX9jJZdBz5xmyx8auHA5fHnWt72DzWTXvL7NG3
	ZRWjx6PFLYwenzfJBbBGcdmkpOZklqUW6dslcGU83LaLqeCTTMWOze9YGxivi3UxcnJICJhI
	LL6wmBnCFpO4cG89WxcjF4eQwCJGiQ23DrBDOO1MEvObbjOBVLEIqErM+DGFEcRmE9CT+Hz3
	KVhcRMBXYu3jy4wgDcwC3cwSZw6+BUsIC6RL/NvWBWbzClhLfL3RxAJicwoYSLRtmswKseE5
	o8SzpZ1gCX4BSYn2fz+gbrKTOPdpAztEs6DEj8n3wGqYBbQkNm9rYoWw5SU2r3nLPIFRcBaS
	sllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzg2nknvYFzVYHGIUYCDUYmH
	d0L24kAh1sSy4srcQ4wSHMxKIryXVi4JFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEgg
	PbEkNTs1tSC1CCbLxMEp1cDoePtblUHT5V0/Hy3/7p51/ndXYbt9ytJtHwJ3hK5fpFz4v+iq
	fnru3wdr+w79a7DbLS1wf9Jcveln18zbmxZR4WkaKPmirLutqkN21uzyb/VMcm/+i293XbL3
	vVOCUx6LtO9GpTI3sVw+ef72wrd7Ok/PqZqY5FjyW5ApVlyB5SPjs+2n5pUrsRRnJBpqMRcV
	JwIASnKsz4kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh, Rafael,

> On Tuesday, May 28, 2013 03:14:26 PM Viresh Kumar wrote:
> > On 28 May 2013 12:10, Lukasz Majewski <l.majewski@samsung.com>
> > wrote:
> > > On 27 May 2013 17:30, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > <manually added by viresh>
> > >> On Monday, May 27, 2013 06:54:49 PM Viresh Kumar wrote:
> > >> > On 27 May 2013 17:30, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> I was talking about /sys/devices/system/cpu/cpufreq/boost that
> > >> appears to have been added by commit 615b730 (acpi-cpufreq: Add
> > >> support for disabling dynamic overclocking).
> > >>
> > >> That's in acpi-cpufreq, but since that setting seems to be
> > >> generally useful, it may be a good idea to move it to the core
> > >> somehow.
> > 
> > Problem is in breaking existing cpufreq userspace for this driver.
> > Is this allowed?
> > 
> > > I think that Viresh wanted to add "boost" option to
> > > /sys/devices/system/cpu/cpuX/cpufreq/ to be able to control boost
> > > at separate cores (policies).
> > >
> > > The localization, which you have proposed:
> > > /sys/devices/system/cpu/cpufreq/boost
> > >
> > > implies, that boost is a global feature (enabled for all cores
> > > and for all available policies).
> > >
> > > Which approach shall be used then?
> > 
> > We can use: get_governor_parent_kobj() to get the best location
> > for boost. But I had some other issues in mind:
> > - boost is governor dependent.. i.e. It is only required for
> > ondemand governor (And LAB if it makes it to mainline :) ).. Other
> > governors doesn't need it. So, it would be better to add it in
> > governor's directory.
> 


> I'm not sure about that.  On x86 boost will be used with all
> governors if enabled (as currently defined in acpi-cpufreq).

All governors can benefit from the overclocking code.


> 
> Also it looks like this depends on the driver too, because if the
> driver doesn't have "turbo" frequencies, the governor won't be able
> use "turbo" anyway.
> 

Rafael is correct here. The overclocking framework depends on
cpufreq_driver (exynos-cpufreq in my case) to switch to overclocked
frequency.


> > - This will break existing users of acpi-cpufreq driver.
> > 
> > @Rafael: Please suggest what to do here.
> 
> So first, it would make sense to use a per-driver "boost" attribute
> indicating whether or not the given driver should present any "turbo"
> frequencies to the governor.

Now I'm using a device tree's cpufreq section (defined at
exynos4412-redwood.dts) with overclocking = "okay" attribute defined.
Then, on this basis, we could decide at cpufreq init time if we will
export any overclocking related sysfs entries (or init overclocking at
all). It would assure clearer code.


>  That'd work along the lines of the
> acpi-cpufreq "boost", but I don't think that the global_boost
> attribute should be created by the driver (it'd be better if the
> driver provided methods to the core for handling that).

I think that global cpufreq device tree attribute shall be defined. The
overclocking will be an integral part of the cpufreq framework.

> 
> Second, I'm not sure if an additional knob for the governor is
> necessary.  It may just use the turbo frequencies if available (and
> if the governor cannot use them, it simply won't use them).

I cannot agree. It is welcome to be able to enable/disable the feature
when needed. Turbo frequencies shall not be "available" for use all the
time. For me this situation is far more dangerous.

> 
> Thanks,
> Rafael
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
