Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3HANMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:12:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab3HANMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:12:17 -0400
Date: Thu, 1 Aug 2013 21:11:17 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_cpu_timers: fix timer never expires when
 executes clock_nanosleep
Message-ID: <20130801131117.GK6721@zhudong.nay.redhat.com>
References: <20130801101018.GJ6721@zhudong.nay.redhat.com>
 <20130801113049.GB7334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801113049.GB7334@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislaw,

Thansk for your info.

On Thu, Aug 01, 2013 at 01:30:50PM +0200, Stanislaw Gruszka wrote:
> Hi Dong Zhu
> 
> On Thu, Aug 01, 2013 at 06:10:19PM +0800, Dong Zhu wrote:
> > diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> > index c7f31aa..cc03290 100644
> > --- a/kernel/posix-cpu-timers.c
> > +++ b/kernel/posix-cpu-timers.c
> > @@ -1413,9 +1413,9 @@ static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
> >  	/*
> >  	 * Diagnose required errors first.
> >  	 */
> > -	if (CPUCLOCK_PERTHREAD(which_clock) &&
> > -	    (CPUCLOCK_PID(which_clock) == 0 ||
> > -	     CPUCLOCK_PID(which_clock) == current->pid))
> > +	if (CPUCLOCK_PID(which_clock) == current->pid ||
> > +	    (CPUCLOCK_PERTHREAD(which_clock) &&
> > +	     CPUCLOCK_PID(which_clock) == 0))
> >  		return -EINVAL;
> 
> Nope, this is wrong. We have to allow own pid process clock, because it
> can be used correctly on multi-threaded processes. Own tid thread clock

Yes, you are right, I really neglected this point.

> has no sense and we correctly return -EINVAL in such case.

> 
> We could possibly add check for own pid together with check if process 
> consist of one thread, but that is too complicated IMHO especially
> taking into account that threads on the process can be destroyed and
> created dynamically.
> 

Agree, really so complicated.

-- 
Best Regards,
Dong Zhu
