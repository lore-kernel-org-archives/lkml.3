Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab3FMPfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:35:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab3FMPfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:35:48 -0400
Date: Thu, 13 Jun 2013 11:20:59 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
Message-ID: <20130613152059.GA133453@redhat.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
 <1371045758-5296-5-git-send-email-fweisbec@gmail.com>
 <20130612170316.GO133453@redhat.com>
 <20130613131057.GA15997@somewhere>
 <20130613140207.GW133453@redhat.com>
 <20130613142210.GD16339@somewhere>
 <20130613144515.GX133453@redhat.com>
 <20130613145601.GE16339@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613145601.GE16339@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 04:56:03PM +0200, Frederic Weisbecker wrote:
> > > > Peter,
> > > > 
> > > > Where is this patch?
> > > 
> > > Which patch? The old version of the current one? It was part of a previous series
> > > that needed improvements so it hasn't been applied yet.
> > 
> > I guess I am confused.  I thought Peter said in an email awhile ago, that
> > he found Stephan's patch (that converted perf to use hrtimers) and applied
> > it to his tree.  Are you saying it was unapplied because it needed
> > improvements?
> 
> I think it doesn't completely remove the perf tick. Besides it doesn't really
> solve the problem since perf events will require periodic hrtimers to work,
> which still defeats the purpose of full dynticks.

I don't know enough about how full dynticks work to even present a
solution.  But currently I was working with the Red Hat performance team
to enhance perf to help our customers diagnose performance problems
easier.

My fear is anyone who uses full dynticks and has issues, can't use perf to
help diagnose their problems because it will change the dynamics of the
problem.  And with the current huge drop in performance in cpu_idle (as
compared to RHEL-6's 2.6.32 kernel) due to what seems to be miscalculated
c-states, one might have a hard time evaluating if full dynticks is doing
the right thing or not.

Then again perhaps full dynticks isn't useful for distros like RHEL.

That's why I was hoping to solve the underlying problem as opposed to
accepting patches like this which work around the symptoms.

Again, my knowledge of full dynticks is poor, so I have almost no idea of
the complexities surrounding the problem and how hard it is to even solve
it.

Cheers,
Don

