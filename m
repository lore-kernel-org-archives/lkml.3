Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaBUELj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:11:39 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50159 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaBUELh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:11:37 -0500
Date: Thu, 20 Feb 2014 20:11:34 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, anton@nomsg.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, akpm@linux-foundation.org
Subject: Re: [PATCH v3 5/6] timerfd: Add support for deferrable timers
Message-ID: <20140221041134.GA20564@teo>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
 <1392885633-7787-6-git-send-email-a.perevalov@samsung.com>
 <alpine.DEB.2.02.1402201152440.4468@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402201152440.4468@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 12:09:43PM +0100, Thomas Gleixner wrote:
> On Thu, 20 Feb 2014, Alexey Perevalov wrote:
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
> > 
> > The deferred timers are somewhat orthogonal to high-res external timers,
> > since the deferred timer is tied to the system load, not just to some
> > external decrementer source.
> 
> Again this changelog makes no sense. What's orthogonal to high-res
> timers and why are they external?

Not trying to defend the current series, just felt the need clarify this
one.

By orthogonal I meant that comparing to high resolution timers' use cases,
deferred timers can be super-low resolution, super inaccurate. We don't
know exactly when they will fire, all we know is something like "every 0.2
seconds, iff the system/user is doing something, otherwise don't bother."

As for external (my bad, shouldn't invent personal terminology): the
hrtimers are tied to some clock source (which is "external" to me), but
deferred timers are mostly tied to the system's activity.

Thanks,

Anton
