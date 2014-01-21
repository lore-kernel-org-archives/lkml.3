Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaAUMbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:31:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58457 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaAUMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:31:22 -0500
Date: Tue, 21 Jan 2014 13:31:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [11/11] system 1: Saving energy using DVFS
Message-ID: <20140121123120.GC11893@amd.pavel.ucw.cz>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
 <20140120163254.GA23051@amd.pavel.ucw.cz>
 <20140121121429.GB19029@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121121429.GB19029@e103034-lin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Performance is frequency (~instruction issue rate) and
> > > energy/instruction is the energy cost of executing one (or a fixed
> > > number of instructions) at that level of performance (frequency). For
> > > this example, it costs 2.7x more energy per instruction to increase the
> > > performance from 1.0 to 3.0 (3x). That is, the amount of work
> > > (instructions) that can be done on one battery charge is reduced by 2.7x
> > > (~63%) if you run as fast as possible (3.0) compared to running at
> > > slowest frequency (1.0).
> > 
> > This very heavily depends on what you count to the total energy,
> > right? And it is very hard to argue with you before you anonymized
> > your numbers.
> 
> Just to clarify, the numbers above are cpu only as already stated in the
> linux-pm thread referenced in the cover letter. We do of course need to
> consider the total energy (cpu, gpu and memory at least) when verifying
> whether any optimization does save energy or not.

Yes.

> As already discussed, battery power is suitable for this purpose on end
> product form factor systems. However, for development hardware that
> might be quite different (extra onboard devices and such).

Is the behavior of current production hardware significantly different
from secret development boards you have? I don't think so. So can we
get measurements on real production hardware?

> > Anyway, you assuming modern system, low frequency should be cca
> > 0.5GHz, with high cca 1.5GHz. Do you claim that operation on 1.5GHz
> > takes 9x the power of 0.5GHz operation?
> 
> On this particular platform, increasing the frequency by 3x increases
> power by 8.1x.

Lets call your plaform TopSecret.

_CPU_ power. If your DRAM eats as much power as the CPU on that
platform, and enters low-power mode when CPU does, race-to-idle is
still a win.

> > > To save energy, the higher frequencies should be avoided and only used
> > > when the application performance requirements can not be satisfied
> > > otherwise (e.g. spread tasks across more cpus if possible).
> > 
> > This is in very steep contrast with race-to-idle on the PCs.
> 
> I think Catalin already covered why race-to-idle isn't always the best
> idea elsewhere in this thread. Basically, it is wasting a lot of energy
> in use-cases like audio and video playback. I have provided descriptions
> of these use-cases as part of this set of emails.

That's the problem. He demonstrated that on platform TopSecret
race-to-idle is not good idea, assuming CPU and display are the only
parts eating power. But that's not true even on TopSecret platform.

So, at the very least, we need to know ammount of power taken by CPU
idle/active and DRAM idle/active.

> > Can we talk specific machine, please? You are talking Android all the
> > time, so pick one cellphone you care about, and provide real numbers...
> 
> As Catalin already said, there is a number of reason why we can't share
> absolute numbers publicly. I think the numbers I posted give a pretty
> good picture of the trade-offs involved in frequency scaling on a modern
> ARM Soc. 

Unfortunately, as explained above, numbers for TopSecret are not
useful. And that should be reason to re-do the measurements on some
non-secret machine.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
