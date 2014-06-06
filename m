Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaFFNDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:03:52 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45509 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750759AbaFFNDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:03:50 -0400
Date: Fri, 6 Jun 2014 14:03:52 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140606130352.GU29593@e103034-lin>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
 <20140603115015.GZ11096@twins.programming.kicks-ass.net>
 <20140604160230.GS29593@e103034-lin>
 <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 06:27:12PM +0100, Peter Zijlstra wrote:
> On Wed, Jun 04, 2014 at 05:02:30PM +0100, Morten Rasmussen wrote:
> > On Tue, Jun 03, 2014 at 12:50:15PM +0100, Peter Zijlstra wrote:
> > > On Fri, May 23, 2014 at 07:16:33PM +0100, Morten Rasmussen wrote:
> > > > +static struct capacity_state cap_states_cluster_a7[] = {
> > > > +	/* Cluster only power */
> > > > +	 { .cap =  358, .power = 2967, }, /*  350 MHz */
> > > > +	 { .cap =  410, .power = 2792, }, /*  400 MHz */
> > > > +	 { .cap =  512, .power = 2810, }, /*  500 MHz */
> > > > +	 { .cap =  614, .power = 2815, }, /*  600 MHz */
> > > > +	 { .cap =  717, .power = 2919, }, /*  700 MHz */
> > > > +	 { .cap =  819, .power = 2847, }, /*  800 MHz */
> > > > +	 { .cap =  922, .power = 3917, }, /*  900 MHz */
> > > > +	 { .cap = 1024, .power = 4905, }, /* 1000 MHz */
> > > > +	};

[...]

> > TC2 is an early development platform and somewhat different from what
> > you find in end user products. TC2 actually uses the same voltage for
> > all states except the highest 2-3 states. That is not typical. The
> > voltage is typically slightly different for each state, however, the
> > difference get bigger for higher P-states. We could probably get away
> > with representing multiple states as one in the energy model if the
> > voltage change is minimal.
> 
> So while I don't mind the full table, esp. if its fairly easy to
> generate using that tool you spoke about, I just wondered if it made
> sense to somewhat reduce it.
> 
> Now that I look at the actual .power values, you can indeed see that all
> except the last two are pretty much similar in power usage.
> 
> On that, is that fluctuation measurement noise, or is that stable?

It would make sense to reduce it for this particular platform. In fact
it is questionable whether we should use frequencies below 800 MHz at
all. On TC2 the voltage is same for 800 MHz and below and it seems that
leakage (static) power is dominating the power consumption. Since the
power is almost constant in the range 350 to 800 MHz energy-efficiency
(performance/watt ~ cap/power) is actually getting *better* as we run
faster until we get to 800 MHz. Beyond 800 MHz energy-efficiency goes
down due to increased voltages.

The proposed platform energy model is an extremely simplified view of
the platform. The numbers are pretty much the raw data normalized and
averaged as appropriate. I haven't tweaked them in any way to make them
look more perfect. So, the small variations (within 4%) may be
measurement noise and the fact I model something complex with a simple
model.
