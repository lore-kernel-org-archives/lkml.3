Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbaD2Kt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:49:57 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:16058 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933543AbaD2Ktz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:49:55 -0400
Date: Tue, 29 Apr 2014 11:50:02 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Message-ID: <20140429105002.GG2639@e103034-lin>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
 <15044031.LGKXdkz8J7@vostro.rjw.lan>
 <20140426061744.GB1944@gmail.com>
 <1586415.tT6O0p7OWR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586415.tT6O0p7OWR@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 02:23:24PM +0100, Rafael J. Wysocki wrote:
> Still, I have a rather fundamental problem with the notion that performance
> and energy efficiency are essentially at odds with each other, because quite
> often they aren't.  What is good for performance is often good for energy
> efficiency as well (like when it may be better to do a certain amount of work
> quickly and then go idle instead of slowing down and taking more time to do
> the work, because that time may turn out to be so long that energy used for
> doing the work will actually be greater).  So while I'm all for acting on power
> events, I'm also for being rather careful with that.

As I wrote in my other reply in this thread, IMO we should distinguish
between objectives and methods to optimize for objectives. Performance
and energy efficiency are different objectives, but some methods might
be useful for optimizing for both (such as race to idle in some
scenarios on some platforms). Tuning knobs and power events shouldn't be
assumed to directly control specific scheduling decisions, for example
whether to race to idle or not. They should only mean that the scheduler
should optimize for a specific goal. For example, a specific
energy/performance trade-off.

> Moreover, in fact performance and energy efficiency are not the only factors
> that need to be taken into account, there also is the maximum power draw (ie.
> the rate of using energy) that can be sustained.  Arguably, all three of them
> always matter, regardless of whether or not the system is on battery.
> 
> People often mentally translate energy efficiency into battery life, because
> that's probably the most obvious case, but in fact it generally translates into
> the cost of doing work (in therms of money or other things).  Going to battery
> means something like "energy is now more valuable to me", but there may be other
> events meaning the same (for example, energy may be cheaper in the night etc).
> So it looks like we need a global mechanism to represent the current relative
> value of energy to the user and to update it whenever something like "we're on
> battery now" happens (other subsystems would benefit from that too IMO).
> 
> The same applies to the maximum sustainable power draw limit more or less.
> While it generally changes between "on battery" and "on AC power", it may also
> depend on other factors like the capacity of the available power supply for a
> data center.

I haven't given maximum power draw much thought, but it is a third
objective independent of energy efficiency even though methods for
improving energy efficiency (such as disabling expensive DVFS states)
might be useful for this as well.
