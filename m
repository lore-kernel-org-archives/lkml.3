Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3EHKzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:55:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3EHKzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:55:44 -0400
Date: Wed, 8 May 2013 12:55:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Feng Tang <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
Message-ID: <20130508105542.GA22703@amd.pavel.ucw.cz>
References: <20130430074322.GA20110@gmail.com>
 <20130506230137.GA16801@amd.pavel.ucw.cz>
 <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com>
 <20130507023853.GA2945@feng-snb>
 <20130507065348.GF17705@gmail.com>
 <51892560.7090202@linaro.org>
 <20130507213142.GA10061@amd.pavel.ucw.cz>
 <51897497.7040806@linaro.org>
 <20130507215151.GB10061@amd.pavel.ucw.cz>
 <20130508064419.GA5378@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508064419.GA5378@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Sorry. You seem to not like the merged change, but I guess I'm not
> > > quite sure what exactly your objection is here.
> > 
> > I'm not exactly sure what my objections are.
> > 
> > TSC was not designed for long-term precise timekeeping. [...]
> 
> The TSC is just a 64-bit counter that can be read very cheaply.
> 
> If the TSC is _implemented_ precisely in hardware and is kept in sync over 
> CPUs then it's obviously fit for long-term precise timekeeping from that 
> point on.

Yes. But the clock for TSC is not being generated in CPU (right?) and
AFAICT, the code said "if the CPU is new enough, assume TSC is good
timesource". You need good clock for good timesource.

> > [...] but some people suspend their machines for longer than that. Plus 
> > I wonder how it will interfere with /etc/adjtime.
> 
> If it's precise then why should it interfere?
> 
> The history of the TSC being problematic can be ignored the moment CPU 
> makers fix it completely - and apparently that is happening...

AFAICT we normally use RTC/PIT during runtime. If we switch to TSC
during suspend, surely /etc/adjtime will be confused. (RTC has its own
timesource, so it is unlikely to have same error as TSC).
								Pavel  
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
