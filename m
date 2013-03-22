Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3CVTZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:25:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36453 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab3CVTZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:25:47 -0400
Date: Fri, 22 Mar 2013 12:25:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, geoff@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130322192515.GU3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <1363825631.6345.45.camel@gandalf.local.home>
 <514B2B03.4030301@linux.intel.com>
 <20130321171806.GX3637@linux.vnet.ibm.com>
 <514B464A.50700@linux.intel.com>
 <20130321180218.GA3637@linux.vnet.ibm.com>
 <87wqszb7r0.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqszb7r0.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032219-3620-0000-0000-000001BD1758
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 11:37:55AM -0700, Kevin Hilman wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > On Thu, Mar 21, 2013 at 10:41:30AM -0700, Arjan van de Ven wrote:
> >> On 3/21/2013 10:18 AM, Paul E. McKenney wrote:
> >> >	o	Use the "idle=poll" boot parameter.  However, please note
> >> >		that use of this parameter can cause your CPU to overheat,
> >> >		which may cause thermal throttling to degrade your
> >> >		latencies --and that this degradation can be even worse
> >> >		than that of dyntick-idle.
> >> 
> >> it also disables (effectively) Turbo Mode on Intel cpus... which can
> >> cost you a serious percentage of performance
> >
> > Thank you, added!  Please see below for the updated list.
> >
> > 							Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> > o	Dyntick-idle slows transitions to and from idle slightly.
> > 	In practice, this has not been a problem except for the most
> > 	aggressive real-time workloads, which have the option of disabling
> > 	dyntick-idle mode, an option that most of them take.  However,
> > 	some workloads will no doubt want to use adaptive ticks to
> > 	eliminate scheduling-clock-tick latencies.  Here are some
> > 	options for these workloads:
> >
> > 	a.	Use PMQOS from userspace to inform the kernel of your
> > 		latency requirements (preferred).
> 
> This is not only the preferred approach, but the *only* approach
> available on non-x86 systems.  Perhaps the others should be marked as
> x86-only?

Good point, added that.

							Thanx, Paul

> Kevin
> 
> > 	b.	Use the "idle=mwait" boot parameter.
> >
> > 	c.	Use the "intel_idle.max_cstate=" to limit the maximum
> > 		depth C-state depth.
> >
> > 	d.	Use the "idle=poll" boot parameter.  However, please note
> > 		that use of this parameter can cause your CPU to overheat,
> > 		which may cause thermal throttling to degrade your
> > 		latencies -- and that this degradation can be even worse
> > 		than that of dyntick-idle.  Furthermore, this parameter
> > 		effectively disables Turbo Mode on Intel CPUs, which
> > 		can significantly reduce maximum performance.
> 

