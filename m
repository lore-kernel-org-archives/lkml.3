Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab3EFXCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:02:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55220 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417Ab3EFXCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:02:05 -0400
Date: Tue, 7 May 2013 01:01:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] timer changes for v3.10
Message-ID: <20130506230137.GA16801@amd.pavel.ucw.cz>
References: <20130430074322.GA20110@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430074322.GA20110@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  - suspend/resume enhancements by Feng Tang: on certain new Intel Atom 
>    processors (Penwell and Cloverview), there is a feature that the TSC 
>    won't stop in S3 state, so the TSC value won't be reset to 0 after
>    resume. This can be taken advantage of by the generic via the
>    CLOCK_SOURCE_SUSPEND_NONSTOP flag: instead of using the RTC to 
>    recover/approximate sleep time, the main (and precise) clocksource can
>    be used.

Ok, so for system time, we use three different timers:

1) RTC, while system is off

2) PIT, while system is running (plus TSC for parts of second)

3) TSC, while system is sleeping

Now. we have ntpd that is trying to compute "speed of clock", and
adjust accordingly (adjtimex). But will it still do the right thing
when we switch to different source during sleep?

And is the TSC even good enough? According to man page, PIT is not
precise enough, so we sync from RTC every 11 minutes. I'd imagine TSC
is even worse than that. Machine can stay is s2ram for weeks (for a
lot more if it is desktop and you do s2ram for powersaving). Also
temperature of CPU varies a lot between active and s2ram states. Is
TSC good enough?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
