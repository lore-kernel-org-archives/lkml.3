Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3CVJwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:52:53 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:50007 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3CVJww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:52:52 -0400
Date: Fri, 22 Mar 2013 10:52:47 +0100
From: Mats Liljegren <liljegren.mats2@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130322095246.GG29378@enea.se>
References: <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
 <20130321171518.GW3637@linux.vnet.ibm.com>
 <0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
 <20130321185821.GF3637@linux.vnet.ibm.com>
 <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 21 Mar 2013, Paul E. McKenney wrote:
> 
> > > Yeah doing that right now but I'd like to see it handled without manual
> > > intervention.
> >
> > Given that RCU has no idea where you want them to run, some manual
> > intervention would most likely be required even if RCU spawned them
> > dynamically, right?
> 
> If rcuoXX is a SCHED_OTHER process/thread then the kernel will move it to
> another processor from the one running the SCHED_FIFO task. There would be
> no manual intervention required.
> 
> > So, again, removing scheduling-clock interrupts in more situations is
> > a good future enhancement.
> 
> The point here is that the check for a single runnable process is wrong
> because it accounts for tasks in all scheduling classes.
> 
> It would be better to check if there is only one runnable task in the
> highest scheduling class. That would work and defer the SCHED_OTHER kernel
> threads for the SCHED_FIFO thread.
> 
> I am wondering how you actually can get NOHZ to work right? There is
> always a kernel thread that is scheduled in a couple of ticks.

In my case I use 2 CPU PandaBoard where I use cpuset to create a
non-realtime domain for CPU0 and a real-time domain for CPU1. I then move
all kernel threads and IRQs to CPU0, leaving only the application specific
IRQ for CPU1. I then start a singe thread on CPU1.

I use a quite down-stripped version of Linux built using Yocto. I have run
the application for a minute and got 70-80 ticks, most (all?) occurring
during start and exit of the application. I use 100Hz ticks.

So personally I do get something by using full NOHZ in its current
incarnation. I'd like some better interrupt latency though, so disabling
 nohz-idle might be interesting for me. But that's another story...

-- Mats
