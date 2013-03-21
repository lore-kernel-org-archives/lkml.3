Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3CUR0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:26:35 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43269 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3CUR0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:26:34 -0400
Date: Thu, 21 Mar 2013 10:18:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130321171806.GX3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
 <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <1363825631.6345.45.camel@gandalf.local.home>
 <514B2B03.4030301@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514B2B03.4030301@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032117-7408-0000-0000-00000E0B4A28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 08:45:07AM -0700, Arjan van de Ven wrote:
> On 3/20/2013 5:27 PM, Steven Rostedt wrote:
> >I'm not sure I would recommend idle=poll either. It would certainly
> >work, but it goes to the other extreme. You think NO_HZ=n drains a
> >battery? Try idle=poll.
> 
> 
> do not ever use idle=poll on anything production.. really bad idea.
> 
> if you temporary cannot cope with the latency, you can use the PMQOS system
> to limit (including going all the way to idle=poll).
> but using idle=poll completely is very nasty for the hardware.
> 
> In addition we should document that idle=poll will cost you peak performance,
> possibly quite a bit.
> 
> the same is true for the kernel paramter to some extend; it's there to work around
> broken bioses/hardware/etc; if you have a latency/runtime requirement, it's much better
> to use PMQOS for this from userspace.

Thank you for the info, Arjan!  Does the following capture the tradeoffs?

o	Dyntick-idle slows transitions to and from idle slightly.
	In practice, this has not been a problem except for the most
	aggressive real-time workloads, which have the option of disabling
	dyntick-idle mode, an option that most of them take.  However,
	some workloads will no doubt want to use adaptive ticks to
	eliminate scheduling-clock-tick latencies.  Here are some
	options for these workloads:

	o	Use PMQOS from userspace to inform the kernel of your
		latency requirements (preferred).

	o	Use the "idle=mwait" boot parameter.

	o	Use the "intel_idle.max_cstate=" to limit the maximum
		depth C-state depth.

	o	Use the "idle=poll" boot parameter.  However, please note
		that use of this parameter can cause your CPU to overheat,
		which may cause thermal throttling to degrade your
		latencies --and that this degradation can be even worse
		than that of dyntick-idle.

							Thanx, Paul

