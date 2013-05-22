Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3EVMGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:06:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29899 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab3EVMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:06:08 -0400
X-AuditID: cbfee61b-b7f0d6d00000450a-f5-519cb4ae17b2
Date: Wed, 22 May 2013 14:05:50 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3] LAB: Support for Legacy Application Booster governor
Message-id: <20130522140550.3fa3b4b3@amdc308.digital.local>
In-reply-to: <CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
 <20130522122700.104ca5cd@amdc308.digital.local>
 <CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jQd11W+YEGqy4IWXxtOkHu8W8z7IW
	nWefMFu8ecRtcXnXHDaLz71HGC1uN65gs+hf2Mtk0XHkG7PFxq8eDlwed67tYfNYN+0ts0ff
	llWMHo8WtzB6fN4kF8AaxWWTkpqTWZZapG+XwJXxetV2loLjAhWTdnxgamDs5O1i5OSQEDCR
	+HX/MzOELSZx4d56ti5GLg4hgemMEg/nnABLCAm0M0nMfc3RxcjBwSKgKnHpVzVImE1AT+Lz
	3adMIGERAS2JlzdTQVqZBS4wSZy6NAssLizgJ3FkuSNIOa+AtcSk7Q+ZQGxOgWCJw+cvMUOs
	6mCSWLColxEkwS8gKdH+7wfUPXYS5z5tYIdoFpT4MfkeC4jNDLRr87YmVghbXmLzmrfMExgF
	ZyEpm4WkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPimfQOxlUNFocYBTgY
	lXh4H9TODhRiTSwrrsw9xCjBwawkwqsQNCdQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutA
	IYH0xJLU7NTUgtQimCwTB6dUA6Pt8uNNpc4Mjofivzirmsff8NoqUnQjeOtNm69qPfvmi9xs
	K0g8X7yg+fXC/7GHvlywzU8wXl4kc3HX6WKGBe5nVnzm3Dz1Im/dJ67bvD52VUZfDaIZSo2X
	Lyv4vHhd4s799c9Klru1rigtKdlcfVOx82JG098Kn8af4k5bmja+M52ZP1X3cboSS3FGoqEW
	c1FxIgBWsilRhQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 22 May 2013 15:57, Lukasz Majewski <l.majewski@samsung.com> wrote:
> >> On 3 May 2013 19:37, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> 
> > I think, that overclocking support is crucial here. As you pointed
> > out
> > - ondemand and conservative benefit from it. Therefore, I would urge
> >   for its mainline acceptance.
> >
> > (code for reference)
> > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> >
> > In this RFC (patch 1/3), I've decided to put the burden of
> > overclocking support to platform code (cpufreq/exynos-cpufreq.c and
> > cpufreq/exynos4x12-cpufreq.c).
> >
> > Those changes aren't intrusive for other boards/archs. Moreover
> > overclocking is closely related to processor clocking/power
> > dissipation capabilities, so SoC specific code is a good place for
> > it.
> >
> >
> > What DO need a broad acceptance is the overclocking API proposed at:
> > include/linux/cpufreq.h
> >
> > This introduces interface to which others will be bind. It
> > shouldn't be difficult to implement overclocking at other SoCs (as
> > it was proposed for Exynos).
> >
> > Feedback is welcome, since I might have overlooked oddities present
> > at other SoCs.
> 
> Hi..
> 
> I am not talking about the minute details here... for example I
> didn't like the way overclocking support is implemented... It has to
> be a bit more framework oriented then driver...

Presented implementation is only RFC. As I've written, I'm open for
suggestion.

> 
> What I am thinking right now is if it is worth to add both the
> features you are trying. i.e. overclocking and LAB..
> 
> So, requested you to give some figures... of ondemand with and without
> overclocking... 

I will provide test results for ondemand with overclocking enabled and
disabled. Thanks for clarification on this matter.

> Leave LAB for now...

Seems fair. One step on a time. Lets focus on overclocking.

> 
> Then we can give LAB a try with above...



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
