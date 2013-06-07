Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab3FGVxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 17:53:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:48785 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab3FGVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 17:53:29 -0400
Date: Fri, 7 Jun 2013 23:53:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Tobias Waldekranz <tobias@waldekranz.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] timekeeping: handle epoch roll-over (2038) on 32-bit
 systems
In-Reply-To: <51ACE8AE.2090809@linaro.org>
Message-ID: <alpine.LFD.2.02.1306072308040.24812@ionos>
References: <CAFaRD2FP0rrQstV1GszP_URO+cZZuQdyRxOYUEmA+5BvopUAvQ@mail.gmail.com> <alpine.LFD.2.02.1306031622520.2905@ionos> <51ACE8AE.2090809@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013, John Stultz wrote:
> On 06/03/2013 07:34 AM, Thomas Gleixner wrote:
> > Though even if we fix that we still need to twist our brains around
> > the timespec/timeval based user space interfaces. That's going to be
> > the way more interesting challenge.
> 
> I'm curious if there are any there other ideas that folks are considering?

Honestly, we have almost 25 years ahead of us to solve that. So why
hurry? If Tobias thinks that his embedded system of today needs to
survive 2038 without updating the kernel and all of userspace, then
all I can do is wish him good luck. Albeit we should not waste 25
years and run into another Y2K horror. :)

The only solid solution is to implement a new set of syscalls (and
there are not that many which are affected by this). The new syscalls
should use a nanosecond based scalar time value and get rid of the
timespec /timeval / time_t nonsense alltogether. That reduces the
number of new syscalls significantly.

That time value should be 64bit, also people might argue, that we are
creating a new issue for the year 2554, i.e 541 years from now. I
don't think we need to worry about that really. We have to leave our
grand-grand-grand..grandchildren (~20 generations from now) a few
unsolved problems!

The evil plan to make this happen looks like this:

    1) Convert the core code to u64 with a timespec based shadow
       infrastruture to avoid performance regressions in the first
       place.

    2) Add new u64 based syscalls

    3) Disable the timespec based shadow infrastructure five years
       from now to force all lazy buggers who ignored the new syscalls
       to fix their crap.

    4) Deprecate the old syscalls 10 years from now

    5) Remove the old syscalls 100 years from now so Linus won't hunt
       us for breaking userspace :)

Thanks,

	tglx

    





