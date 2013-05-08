Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3EHTt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:49:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53734 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3EHTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:49:25 -0400
Date: Wed, 8 May 2013 21:49:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Feng Tang <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
Message-ID: <20130508194923.GA30896@amd.pavel.ucw.cz>
References: <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com>
 <20130507023853.GA2945@feng-snb>
 <20130507065348.GF17705@gmail.com>
 <51892560.7090202@linaro.org>
 <20130507213142.GA10061@amd.pavel.ucw.cz>
 <51897497.7040806@linaro.org>
 <20130507215151.GB10061@amd.pavel.ucw.cz>
 <20130508064419.GA5378@gmail.com>
 <20130508105542.GA22703@amd.pavel.ucw.cz>
 <alpine.LFD.2.02.1305081626110.2863@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305081626110.2863@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > [...] but some people suspend their machines for longer than that. Plus 
> > > > I wonder how it will interfere with /etc/adjtime.
> > > 
> > > If it's precise then why should it interfere?
> > > 
> > > The history of the TSC being problematic can be ignored the moment CPU 
> > > makers fix it completely - and apparently that is happening...
> > 
> > AFAICT we normally use RTC/PIT during runtime. If we switch to TSC
> 
> No, we do NOT use RTC/PIT during runtime. That's the worst choice one
> could make. If TSC is non frequency constant or affected by C-States
> we use HPET or PM-Timer, and we only ever use the PIT if nothing else
> is available.
> 
> RTC is not used at all for timekeeping. RTC is only used at system
> start and when we resume and the TSC stopped during that time, which
> is true for hibernation even on Haswell and newer.

Ok, that was part I was missing.

> > during suspend, surely /etc/adjtime will be confused. (RTC has its own
> > timesource, so it is unlikely to have same error as TSC).
> 
> Nothing gets confused. It's all handled proper in the core code and
> the clock source drivers.

Ok, so this patch means that we will use
TSC(runtime)+TSC(s2ram). That's improvement over
TSC(runtime)+RTC(s2ram). 

[I still wonder how adjtime is going to work in
TSC(runtime)+RTC(s2disk) case; surely TSC has different drift than
RTC, and so adjtime will have fun trying to estimate the drift... but
that's not new problem and not affected by that patch.]

Ok, thanks for explanation, and sorry it took me so long.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
