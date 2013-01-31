Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3AaLZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:25:16 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45075 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3AaLZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:25:12 -0500
Date: Thu, 31 Jan 2013 12:25:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: move scheduler sysctl bits into dedicated
 header file
Message-ID: <20130131112508.GC4587@gmail.com>
References: <20130128143120.1b60bfb6@redhat.com>
 <87vcagv808.fsf@sejong.aot.lge.com>
 <20130129115743.0f9e67dc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129115743.0f9e67dc@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> On Tue, 29 Jan 2013 15:05:43 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > Hi Clark,
> > 
> > On Mon, 28 Jan 2013 14:31:20 -0600, Clark Williams wrote:
> > > Move all the scheduler sysctl-related bits out of include/linux/sched.h
> > > into a new file include/linux/sched_sysctl.h.
> > >
> > > Signed-off-by: Clark Williams <williams@redhat.com>
> > > ---
> > [snip]
> > > diff --git a/include/linux/sched_sysctl.h b/include/linux/sched_sysctl.h
> > > new file mode 100644
> > > index 0000000..912adab
> > > --- /dev/null
> > > +++ b/include/linux/sched_sysctl.h
> > > @@ -0,0 +1,121 @@
> > > +#ifndef _SCHED_SYSCTL_H
> > > +#define _SCHED_SYSCTL_H
> > > +
> > > +
> > > +/* provide a home for sysctl scheduler tuning knobs */
> > > +
> > > +/*
> > > + * default timeslice is 100 msecs (used only for SCHED_RR tasks).
> > > + * Timeslices get refilled after they expire.
> > > + */
> > > +#define RR_TIMESLICE		(100 * HZ / 1000)
> > 
> > It seems this line came from sched.h but I can't find that part
> > deleted.
> > 
> 
> Arggghh! I reorganized the commits and didn't remove 
> RR_TIMESLICE when I moved it. I'm surprised it compiled.
> 
> I can generate a new patchset or let Ingo just remove it from 
> sched.h.

Please generate a new patch-set.

Mind also changing the placement of the new file a bit? Could 
you create a new include/linux/sched/ directory, and put a new 
sysctl.h into it?

That way further sched.h splitups will populate 
include/linux/sched/ nicely.

Agreed?

Thanks,

	Ingo
