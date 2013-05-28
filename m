Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab3E1Gk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:40:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16170 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab3E1Gkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:40:55 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-36-51a451758384
Date: Tue, 28 May 2013 08:40:35 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
Message-id: <20130528084035.13afa583@amdc308.digital.local>
In-reply-to: <41528879.GuKxJgVhIe@vostro.rjw.lan>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <8856294.KaD55h4g0a@vostro.rjw.lan>
 <CAKohpom4sSwJG7r67+aNMjAdr7CToAqCbdcbd+vSCTEQkiTkcg@mail.gmail.com>
 <41528879.GuKxJgVhIe@vostro.rjw.lan>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jAd3SwCWBBveOW1o8bfrBbjHvs6xF
	59knzBZvHnFbXN41h83ic+8RRovbjSvYLPoX9jJZdBz5xmyx8auHA5fHnWt72DzWTXvL7NG3
	ZRWjx6PFLYwenzfJBbBGcdmkpOZklqUW6dslcGVMuCpVsICn4uPab0wNjMc5uxg5OSQETCSm
	rDrIBmGLSVy4tx7I5uIQEljEKPFnehczhNPOJPH14FkmkCoWAVWJe9NOMoPYbAJ6Ep/vPgWL
	iwDFtzz5zw7SwCywlVni0o1ORpCEsEC6xL9tXWBFvALWEovOb2QBsTkFDCVudB2A2nCHUWLK
	iv1gRfwCkhLt/34wQ9xkJ3Hu0wZ2iGZBiR+T74E1MwtoSWze1sQKYctLbF7zlnkCo+AsJGWz
	kJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwZDyT3sG4qsHiEKMAB6MSD++E
	7MWBQqyJZcWVuYcYJTiYlUR4RfyXBArxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5Y
	kpqdmlqQWgSTZeLglGpgLLnu9XddzSbJYwdN9+beDzDL19KV2sPlpnYxikv/z84pSQdWtd9s
	4EzInec3nfn+q38Rdxbwq5rdX7Tfo0D0z22PFcE6yWaNq39HnJl15oD1yslvD3MYp2rfXNTX
	sSf3lHWxYZ2Gnte15uyWdStuNb3YGeW3Pd78isBGxesVbw67pX5N7ZzfpsRSnJFoqMVcVJwI
	AI6q/QyIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> On Monday, May 27, 2013 06:54:49 PM Viresh Kumar wrote:
> > On 27 May 2013 17:30, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > Well, this really looks like software turbo modes, so let's call
> > > them "TURBO" instead of "OVERDRIVE"
> > 
> > Yes, it looks better.
> > 
> > > and I seem to remember having a switch for
> > > disabling/enabling turbo modes already.
> > 
> > This was added in intel_pstate driver and shows up in
> > /sys/devices/system/cpu/cpufreq/ directory..
> > 
> > But this feature belongs to a governor instance and so
> > will be present inside governor directory..
> > 
> > Specially for big LITTLE we want it to be per policy
> > specific. So may need to add a new one.
> 
> I was talking about /sys/devices/system/cpu/cpufreq/boost that
> appears to have been added by commit 615b730 (acpi-cpufreq: Add
> support for disabling dynamic overclocking).
> 
> That's in acpi-cpufreq, but since that setting seems to be generally
> useful, it may be a good idea to move it to the core somehow.

I think that Viresh wanted to add "boost" option to 
/sys/devices/system/cpu/cpuX/cpufreq/ to be able to control boost
at separate cores (policies).

The localization, which you have proposed:
/sys/devices/system/cpu/cpufreq/boost

implies, that boost is a global feature (enabled for all cores and for
all available policies).

Which approach shall be used then? 


> 
> Thanks,
> Rafael
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
