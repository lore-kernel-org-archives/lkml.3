Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381Ab3FTMfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:35:06 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:48155 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3FTMfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:35:04 -0400
Date: Thu, 20 Jun 2013 14:34:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] timekeeping: handle epoch roll-over (2038) on 32-bit
 systems
Message-ID: <20130620123459.GA17359@gmail.com>
References: <CAFaRD2FP0rrQstV1GszP_URO+cZZuQdyRxOYUEmA+5BvopUAvQ@mail.gmail.com>
 <alpine.LFD.2.02.1306031622520.2905@ionos>
 <51ACE8AE.2090809@linaro.org>
 <alpine.LFD.2.02.1306072308040.24812@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1306072308040.24812@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 3 Jun 2013, John Stultz wrote:
> > On 06/03/2013 07:34 AM, Thomas Gleixner wrote:
> > > Though even if we fix that we still need to twist our brains around
> > > the timespec/timeval based user space interfaces. That's going to be
> > > the way more interesting challenge.
> > 
> > I'm curious if there are any there other ideas that folks are considering?
> 
> Honestly, we have almost 25 years ahead of us to solve that. So why
> hurry? If Tobias thinks that his embedded system of today needs to
> survive 2038 without updating the kernel and all of userspace, then
> all I can do is wish him good luck. Albeit we should not waste 25
> years and run into another Y2K horror. :)
> 
> The only solid solution is to implement a new set of syscalls (and
> there are not that many which are affected by this). The new syscalls
> should use a nanosecond based scalar time value and get rid of the
> timespec /timeval / time_t nonsense alltogether. That reduces the
> number of new syscalls significantly.
> 
> That time value should be 64bit, also people might argue, that we are
> creating a new issue for the year 2554, i.e 541 years from now. I
> don't think we need to worry about that really. We have to leave our
> grand-grand-grand..grandchildren (~20 generations from now) a few
> unsolved problems!
> 
> The evil plan to make this happen looks like this:
> 
>     1) Convert the core code to u64 with a timespec based shadow
>        infrastruture to avoid performance regressions in the first
>        place.
> 
>     2) Add new u64 based syscalls
> 
>     3) Disable the timespec based shadow infrastructure five years
>        from now to force all lazy buggers who ignored the new syscalls
>        to fix their crap.
> 
>     4) Deprecate the old syscalls 10 years from now
> 
>     5) Remove the old syscalls 100 years from now so Linus won't hunt
>        us for breaking userspace :)

50 years from now should be enough for most of us - beyond that there will 
be no hunting, only haunting ... ;-)

Thanks,

	Ingo
