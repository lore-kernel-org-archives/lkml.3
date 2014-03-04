Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaCDWLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:11:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:37572 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaCDWLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:11:14 -0500
Date: Tue, 4 Mar 2014 23:11:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Alexey Perevalov <a.perevalov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, cw00.choi@samsung.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v4 5/6] timerfd: Add support for deferrable timers
In-Reply-To: <CALCETrVsmXjkC28pTSCfywTZCeHVcfvyFvHAXubEJ7=TRoEmPQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403042254550.18573@ionos.tec.linutronix.de>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com> <1392913425-29369-6-git-send-email-a.perevalov@samsung.com> <530D5715.1050901@mit.edu> <alpine.DEB.2.02.1403042153520.18573@ionos.tec.linutronix.de>
 <CALCETrVsmXjkC28pTSCfywTZCeHVcfvyFvHAXubEJ7=TRoEmPQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Andy Lutomirski wrote:

> On Tue, Mar 4, 2014 at 12:58 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 25 Feb 2014, Andy Lutomirski wrote:
> >> On the other hand, if you added a fancier version of timerfd_settime
> >> that could explicitly set the slack value (or, equivalently, the
> >> earliest and latest allowable times), that could be quite useful.
> >>
> >> It's often bugged me that timer slack is per-process.
> >
> > That's a totally different issue. There is a world aside of timerfd
> > timers.
> 
> This is a patch to add deferrable support *to timerfd*.  I'm asking

There is a new patch series which adds deferrable support to all timer
related interfaces which have a flags field. And that's the only
sensible solution right now.

We do no add another random special case syscall for timerfd just
because timerfd is linux specific.

No, we want to support that stuff right now with the existing
interfaces as we have to revisit all of the timer related interfaces
in the near future anyway due to the Y2038 issue.

And your idea of per thread slack is completely bogus. If we want to
make the slack value usefull then it needs to be done per timer and
not per thread/process.

But we cannot do that right now as we cannot whip up severl dozen of
new syscalls just because we want to add slack/deferrable whatever
properties.

Once we agree on a solution to the Y2038 issue on 32bit with a unified
32/64 bit syscall interface which simply gets rid of the timespec/val
nonsense and takes a simple u64 nsec value we can add the slack
property to that without any further inconvenience.

Thanks,

	tglx

