Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbaCDU6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:58:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:37043 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364AbaCDU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:58:30 -0500
Date: Tue, 4 Mar 2014 21:58:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, Anton Vorontsov <anton@enomsg.org>,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v4 5/6] timerfd: Add support for deferrable timers
In-Reply-To: <530D5715.1050901@mit.edu>
Message-ID: <alpine.DEB.2.02.1403042153520.18573@ionos.tec.linutronix.de>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com> <1392913425-29369-6-git-send-email-a.perevalov@samsung.com> <530D5715.1050901@mit.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014, Andy Lutomirski wrote:
> On 02/20/2014 08:23 AM, Alexey Perevalov wrote:
> > From: Anton Vorontsov <anton@enomsg.org>
> > 
> > This patch implements a userland-side API for generic deferrable timers,
> > per linux/timer.h:
> > 
> >  * A deferrable timer will work normally when the system is busy, but
> >  * will not cause a CPU to come out of idle just to service it; instead,
> >  * the timer will be serviced when the CPU eventually wakes up with a
> >  * subsequent non-deferrable timer.
> > 
> > These timers are crucial for power saving, i.e. periodic tasks that want
> > to work in background when the system is under use, but don't want to
> > cause wakeups themselves.
> 
> Please don't.  This API sucks for all kinds of reasons:
> 
>  - Why is it a new kind of clock?

We made it a flag already.

>  - How deferrable is deferrable?

Deferrable is infinite.

>  - It adds new core code, which serves no purpose (the problem is
> already solved).

You wish and you're wrong.

    - Make this work with the timer_list stuff for arbitrary clock
      ids. No way we go back to the mess of CLOCK_REALTIME which we
      had before hrtimers

    - No way that we add a gazillion of extra code in timer related
      interfaces to distinguish between deferrable and non deferrable
      timers utilizing a different interface.

> On the other hand, if you added a fancier version of timerfd_settime
> that could explicitly set the slack value (or, equivalently, the
> earliest and latest allowable times), that could be quite useful.
> 
> It's often bugged me that timer slack is per-process.

That's a totally different issue. There is a world aside of timerfd
timers.

Thanks,

	tglx
