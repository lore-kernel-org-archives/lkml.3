Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaATTPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:15:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54960 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaATTPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:15:49 -0500
Date: Mon, 20 Jan 2014 20:15:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [11/11] system 1: Saving energy using DVFS
Message-ID: <20140120191546.GA26780@amd.pavel.ucw.cz>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
 <20140120164926.GB23051@amd.pavel.ucw.cz>
 <20140120171010.GB29971@arm.com>
 <20140120171752.GC29971@arm.com>
 <20140120174745.GA25439@amd.pavel.ucw.cz>
 <20140120180322.GI29971@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120180322.GI29971@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-01-20 18:03:22, Catalin Marinas wrote:
> On Mon, Jan 20, 2014 at 05:47:45PM +0000, Pavel Machek wrote:
> > On Mon 2014-01-20 17:17:52, Catalin Marinas wrote:
> > > On Mon, Jan 20, 2014 at 05:10:29PM +0000, Catalin Marinas wrote:
> > > > On Mon, Jan 20, 2014 at 04:49:26PM +0000, Pavel Machek wrote:
> > > > > > To save energy, the higher frequencies should be avoided and only used
> > > > > > when the application performance requirements can not be satisfied
> > > > > > otherwise (e.g. spread tasks across more cpus if possible).
> > > > > 
> > > > > I argue this is untrue for any task where user waits for its
> > > > > completion with screen on. (And that's quite important subset).
> > > > > 
> > > > > Lets take Nokia n900 as an example. 
> > > > > 
> > > > > (source http://wiki.maemo.org/N900_Hardware_Power_Consumption)
> > > > > 
> > > > > Sleeping CPU: 2mA
> > > > > Screen on: 230mA
> > > > > CPU loaded: 250mA
> > > > > 
> > > > > Now, lets believe your numbers and pretend system can operate at 33%
> > > > > of speed with 11% power consumption.
> > > > > 
> > > > > Lets take task that takes 10 seconds on max frequency:
> > > > > 
> > > > >       ~ 10s * 470mA     	     	    = 4700mAs
> > > > > 
> > > > > You suggest running at 33% speed, instead; that means 30 seconds on
> > > > > low requency.
> > > > > 
> > > > > CPU on low: 25mA (assumed).
> > > > > 
> > > > >      ~ 30s * 255mA			    = 7650mAs
> > > > > 
> > > > > Hmm. So race to idle is good thing on Intel machines, and it is good
> > > > > thing on ARM design I have access to.
> > > > 
> > > > Race to idle doesn't mean that the screen goes off as well. Let's say
> > > > the screen stays on for 1 min and the CPU needs to be running for 10s
> > > > over this minute, in the first case you have:
> > > > 
> > > > 	10s & 250mA + 60s * 230mA = 16300mAs
> > > > 
> > > > in the second case you have:
> > > > 
> > > > 	30s * 25mA + 60s * 230mA = 14550mAs
> > > > 
> > > > That's a 1750mAs difference. There are of course other parts drawing
> > > > current but simple things like the above really make a difference in the
> > > > mobile space, both in terms of battery and thermal budget.
> > > 
> > > BTW, the proper way to calculate this is to use the energy rather than
> > > current x time. This would be J = Ohm * A^2 * s = V^2 / Ohm * s (so the
> > > impact of the current is even bigger).
> > 
> > You are claiming that energy is proportional to current squared?
> > 
> > I stand by numbers. Energy is proportional to values I quoted,
> > provided constant voltage.
> 
> The big advantage of frequency scaling is that you can scale down the
> voltage, making the power proportional to the voltage squared (or
> current squared for a constant resistance).

I was talking battery voltage; so multiple my numbers by 3.6V and
you'll get Joules.

Yes, I know how voltage scaling works, thats why you can get 11% power
consumption for 33% of work done, thank you.

But no, my cell phone is not pure resistor, that's why your quotation
of Ohm's law surprised me.

Can you point out problem with my numbers or not?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
