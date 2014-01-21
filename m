Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaAUMUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:20:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56396 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaAUMUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:20:12 -0500
Date: Tue, 21 Jan 2014 13:20:10 +0100
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
Message-ID: <20140121122010.GB11893@amd.pavel.ucw.cz>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
 <20140120164926.GB23051@amd.pavel.ucw.cz>
 <20140120171010.GB29971@arm.com>
 <20140120181208.GC25439@amd.pavel.ucw.cz>
 <20140121114225.GC14830@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121114225.GC14830@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > That's a 1750mAs difference. There are of course other parts drawing
> > > current but simple things like the above really make a difference in the
> > > mobile space, both in terms of battery and thermal budget.
> > 
> > Aha, I noticed the values are now the other way around. [And notice
> > that if user _does_ lock/turn off the screen after the operation,
> > difference between power consumptions is factor of two. People do turn
> > off screens before putting phone back in pocket.]
> 
> It depends on the use-case, that's why the problem is so complicated.
> Race-to-idle may work well if just checking bus timetables but not if
> you are watching video or listening to music (the latter with screen
> off).

Exactly, it is complex. That's why it is important to get real
numbers, please.

And yes, if your _system_ has low power consumption in
active-at-low-frequency mode, race-to-idle may not be a win for you.

> > You are right that as long as user does _not_ wait for the computation
> > result, running at low frequency might make sense. That may be true on
> > cellphone so fast that all the actions are "instant". I have yet to
> > see such cellphone. That probably means that staying on low frequency
> > normally and going to high after cpu is busy for 100msec or so is
> > right thing: if cpu is busy for 100msec, it probably means user is
> > waiting for the result.
> 
> I'm talking about use-cases where a task (or multiple threads) are
> running and only loading the CPU partially (audio or video playback).
> Here you have an average number of instructions to execute per decoded
> frame in a certain time. Once the frame is decoded, the CPU can go idle,
> so you can choose whether to race to idle or run at lower frequency (and
> lower energy per the same number of frame decoding instructions) with
> less idle time. There are modern platforms where the latter behaviour is
> more efficient.

So, my Thinkpad X60 is not such platform. Early Athlon64 notebooks
_were_ such platforms. Can you provide example modern platform you are
talking about?

> I would really like race to idle to be true for all cases, it would
> simplify the kernel and we could just remove cpufreq, always running the
> CPUs at max frequency. But so far I don't see Intel ignoring this
> problem either, they keep developing a pstate driver which changes the
> P-states based on average CPU load.

Race-to-idle is win on all modern x86 systems, because they have high
power consumption even on low non-idle frequency, due to leakage. We
still keep P-states for cooling, for completeness and for older
systems.

> > But it depends on the numbers you did not tell us. I'm pretty sure
> > N900 does _not_ have 11% power consuption at 33% performance; I just
> > assumed so for sake of argument.
> > 
> > So, really, details are needed.
> 
> If that's the only issue to be addressed, I'm happy to ignore the
> frequency scaling initially and focus on idle. But since people still do
> frequency scaling and this would interfere with the scheduler, we have

I guess there are modern platforms and workloads where frequency
scaling makes sense. You only need to find one, and provide numbers
for it. Please.
       	   	     	     	      	      	      	      Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
