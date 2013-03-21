Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3CUS3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:29:25 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53968 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3CUS3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:29:24 -0400
Date: Thu, 21 Mar 2013 11:26:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        zhong@linux.vnet.ibm.com, khilman@linaro.org, geoff@infradead.org,
        tglx@linutronix.de, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130321182630.GD3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
 <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <1363825631.6345.45.camel@gandalf.local.home>
 <CAFTL4hxRDxQV0e15QvRy1rXhsn6_ZsbmWFROxJ60UgcCr_DTXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxRDxQV0e15QvRy1rXhsn6_ZsbmWFROxJ60UgcCr_DTXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032118-4834-0000-0000-000004EE00AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 07:01:01PM +0100, Frederic Weisbecker wrote:
> 2013/3/21 Steven Rostedt <rostedt@goodmis.org>:
> > [ Added Arjan in case he as anything to add about the idle=poll below ]
> >
> >
> > On Wed, 2013-03-20 at 16:55 -0700, Paul E. McKenney wrote:
> >> On Wed, Mar 20, 2013 at 07:32:18PM -0400, Steven Rostedt wrote:
> >> > Not a comment on this document, but on the implementation. As idle NO_HZ
> >> > can hurt RT, but RT would want to have full NO_HZ, it's a shame that you
> >> > can't have both (no idle but full). As we only care about not letting
> >> > the CPU go into deep sleep, I wonder if it wouldn't be too hard to add
> >> > something that keeps idle from going into nohz mode. Hmm, I think there
> >> > may be an option to keep the CPU from going too deep into sleep. That
> >> > may be a better approach.
> >>
> >> Would the combination of CONFIG_NO_HZ=y, CONFIG_NO_HZ_FULL=y, and
> >> idle=poll do the trick in this case?
> >
> > I'm not sure I would recommend idle=poll either. It would certainly
> > work, but it goes to the other extreme. You think NO_HZ=n drains a
> > battery? Try idle=poll.
> >
> > Looking at Documentation/kernel-parameters.txt, it looks like idle=mwait
> > may be better. It states that performance is the same as idle=poll (if
> > supported).
> >
> > Also there's a kernel parameter for x86 called intel_idle.max_cstate=X.
> >
> > As idle=poll will most likely run the processor very hot and you will
> > need to add more electricity not only for the computer but also for the
> > A/C, it would be nice to still have the CPU sleep, but just at a shallow
> > (fast wakeup) state.
> >
> > Perhaps Arjan can add some input here?
> 
> But I note that it's an interesting usecase. May be we'll want to make
> CONFIG_NO_HZ_FULL (or whatever it's going to be called) not depend on
> CONFIG_NO_HZ_IDLE in the long.
> 
> We'll see.
> 
> Also, just a guess, but on dynticks-idle may be wakeup from deep CPU
> sleep state is not the only latency source. Reprogramming the timer
> tick on idle exit may be another one? Not sure how fast it is to write
> to the clock device. I supect it's not that free. So probably you
> would like to get rid of the entire dynticks-idle infrastructure for
> real time.

Agreed, and the first known-issues bullet calls that possibility out.

							Thanx, Paul

