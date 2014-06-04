Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaFDQCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:02:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14234 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751129AbaFDQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:02:35 -0400
Date: Wed, 4 Jun 2014 17:02:30 +0100
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
Message-ID: <20140604160230.GS29593@e103034-lin>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
 <20140603115015.GZ11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603115015.GZ11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 12:50:15PM +0100, Peter Zijlstra wrote:
> On Fri, May 23, 2014 at 07:16:33PM +0100, Morten Rasmussen wrote:
> > +static struct capacity_state cap_states_cluster_a7[] = {
> > +	/* Cluster only power */
> > +	 { .cap =  358, .power = 2967, }, /*  350 MHz */
> > +	 { .cap =  410, .power = 2792, }, /*  400 MHz */
> > +	 { .cap =  512, .power = 2810, }, /*  500 MHz */
> > +	 { .cap =  614, .power = 2815, }, /*  600 MHz */
> > +	 { .cap =  717, .power = 2919, }, /*  700 MHz */
> > +	 { .cap =  819, .power = 2847, }, /*  800 MHz */
> > +	 { .cap =  922, .power = 3917, }, /*  900 MHz */
> > +	 { .cap = 1024, .power = 4905, }, /* 1000 MHz */
> > +	};
> 
> So one thing I remember was that we spoke about restricting this to
> frequency levels where the voltage changed.
> 
> Because voltage jumps were the biggest factor to energy usage.
> 
> Any word on that?

Since we don't drive P-state changes from the scheduler, I think we
could leave out P-states from the table without too much trouble. Good
point.

TC2 is an early development platform and somewhat different from what
you find in end user products. TC2 actually uses the same voltage for
all states except the highest 2-3 states. That is not typical. The
voltage is typically slightly different for each state, however, the
difference get bigger for higher P-states. We could probably get away
with representing multiple states as one in the energy model if the
voltage change is minimal.
