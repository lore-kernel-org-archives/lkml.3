Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3BDLBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:01:10 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:39750 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3BDLBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:01:07 -0500
Date: Mon, 4 Feb 2013 12:01:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] sched/rt:  add a tuning knob to allow changing
 SCHED_RR timeslice
Message-ID: <20130204110101.GC24173@gmail.com>
References: <20130131135242.1b77b841@redhat.com>
 <20130203111025.GC11739@gmail.com>
 <20130203185709.GA22826@gmail.com>
 <20130203200316.63c15a79@riff.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130203200316.63c15a79@riff.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> On Sun, 3 Feb 2013 19:57:09 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > The first patch looks good, I've applied it.
> > 
> > I've skipped this one after all, as it sometimes generates:
> > 
> > include/linux/sched/sysctl.h:108:41: warning: ???struct signal_struct??? declared inside parameter list [enabled by default]
> > 
> > Sometimes doesn't built kernel/sched/auto_group.c. So those bits 
> > probably want to move into a separate sched/auto_group.h header 
> > or so.
> > 
> > But, more fundamentally, I think sched.h should not include the 
> > new sched/sysctl.h file. The whole point is to move out bits 
> > from sched.h and decouple them from sched.h - to shrink sched.h 
> > in the long run.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Ahh, you wanted to not only reduce the size of sched.h you 
> want to reduce the amount of code it brings in.

Yeah - I wanted your series to kick-start the ambitious project 
of splitting up the mega-monolithic sched.h include file - 
without anyone noticing. Now my plan is busted.

Many good people scared away from this daunting project in the 
past one or two decades, but they were chicken!

> I'll go back to the drawing board. I'll pull the relevant code 
> from sysctl.h into auto_group.h, then I'll remove the include 
> in sched.h. Then I'll track down all the build failures from 
> the above :).

As long as a few common config combinations work fine I can help 
out with tracking down weird config failures and can also fix 
them - in fact I almost managed to fix your previous series when 
I noticed that include/sched/ is still included in sched.h. (the 
price I paid for not looking closely enough before applying the 
patches.)

Thanks,

	Ingo
