Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaFGCwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 22:52:53 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:47511 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaFGCwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 22:52:51 -0400
Date: Fri, 6 Jun 2014 22:52:49 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
In-Reply-To: <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.11.1406062242360.25775@knanqh.ubzr>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com> <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com> <20140603115015.GZ11096@twins.programming.kicks-ass.net> <20140604160230.GS29593@e103034-lin>
 <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Peter Zijlstra wrote:

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
> > > 
> > > So one thing I remember was that we spoke about restricting this to
> > > frequency levels where the voltage changed.
> > > 
> > > Because voltage jumps were the biggest factor to energy usage.
> > > 
> > > Any word on that?
> > 
> > Since we don't drive P-state changes from the scheduler, I think we
> > could leave out P-states from the table without too much trouble. Good
> > point.
> 
> Well, we eventually want to go there I think.

People within Linaro have initial code for this.  Should be posted as an 
RFC soon.

> Although we still needed
> to come up with something for Intel, because I'm not at all sure how all
> that works.

Our initial code reuse whatever existing platform specific cpufreq 
drivers.  The idea is to bypass the cpufreq governors.

If Intel hardware doesn't provide/allow much control here then the 
platform driver should already tell the cpufreq core (and by extension 
the scheduler) about the extent of what can be done.


Nicolas
