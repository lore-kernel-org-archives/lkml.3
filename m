Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaDOMow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:44:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54780 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbaDOMoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:44:46 -0400
Date: Tue, 15 Apr 2014 14:44:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 2/3] idle: store the idle state the cpu is
Message-ID: <20140415124437.GO13658@twins.programming.kicks-ass.net>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
 <1396009796-31598-3-git-send-email-daniel.lezcano@linaro.org>
 <20140415124330.GK11182@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415124330.GK11182@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 02:43:30PM +0200, Peter Zijlstra wrote:
> On Fri, Mar 28, 2014 at 01:29:55PM +0100, Daniel Lezcano wrote:
> > @@ -143,6 +145,10 @@ static int cpuidle_idle_call(void)
> >  			if (!ret) {
> >  				trace_cpu_idle_rcuidle(next_state, dev->cpu);
> >  
> > +				*power = &drv->states[next_state].power;
> > +
> > +				wmb();
> > +
> 
> I very much suspect you meant: smp_wmb(), as I don't see the hardware
> reading that pointer, therefore UP wouldn't care. Also, any and all
> barriers should come with a comment that describes the data ordering and
> points to the matchin barriers.

Furthermore, this patch fails to describe the life-time rules of the
object placed there. Can the objected pointed to ever disappear?
