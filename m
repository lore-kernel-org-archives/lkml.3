Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbbAWRxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:53:20 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:55107 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbbAWRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:53:19 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501222202420.5526@nanos>
References: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org>
	<1421928077-4698-3-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1501222202420.5526@nanos>
Date: Sat, 24 Jan 2015 01:53:18 +0800
Message-ID: <CADcy93UD1EHiHLsgCPjODZMu1fBpKhOXuN=4Egwu6gB2UZX0+w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] time: clocksource: Add a comment to CLOCK_SOURCE_SUSPEND_NONSTOP
From: Xunlei Pang <pang.xunlei@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 23 January 2015 at 05:07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 22 Jan 2015, Xunlei Pang wrote:
>> When doing timekeeping_resume(), if the nonstop clocksource
>> wraps back, "cycle_delta" will miss the wrap time.
>>
>> It's hard to determine the right CLOCKSOURCE_MASK(xxx) or
>> something to add code for inspecting such behavior, and we
>> don't have many existent nonstop clocksources, so just add
>> a comment to indicate that if have this flag set, people
>> are aware that this nonstop clocksource won't wrap back
>> during system suspend/resume.
>
> -ENOPARSE
>
> What has the CLOCKSOURCE_MASK() to do with this and why is the fact
> relevant, that we only have a few suspend_nonstop clock sources?

Before this, I tried to add some code to catch such problem at the
time of registering
the clocksource, like using the CLOCKSOURCE_MASK(), for example 64bit counter
will never wrap for us. But there may be other values like CLOCKSOURCE_MASK(56),
I just can't figure out exactly how to do this judge.

So, I think we can only add a comment to let the developer be aware of
this when registering
nonstop clocksource, that's what I want to express.

>
>> +
>> +/*
>> + * When setting this flag, you're also supposed to mean that it doesn't
>> + * wrap back during system suspend/resume. See timekeeping_resume().
>
> -ENOPARSE
>
> I guess what you want to say here is:
>
> /*
>  * clocksource continues to run during suspend and is guaranteed not to
>  * wrap around during long suspend periods.
>  */
>

Yes, this description is way better :-)

Thanks,
Xunlei
