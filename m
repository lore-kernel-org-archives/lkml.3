Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab3EGVbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:31:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58504 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3EGVbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:31:46 -0400
Date: Tue, 7 May 2013 23:31:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Feng Tang <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
Message-ID: <20130507213142.GA10061@amd.pavel.ucw.cz>
References: <20130430074322.GA20110@gmail.com>
 <20130506230137.GA16801@amd.pavel.ucw.cz>
 <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com>
 <20130507023853.GA2945@feng-snb>
 <20130507065348.GF17705@gmail.com>
 <51892560.7090202@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51892560.7090202@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-05-07 09:01:36, John Stultz wrote:
> On 05/06/2013 11:53 PM, Ingo Molnar wrote:
> >* Feng Tang <feng.tang@intel.com> wrote:
> >
> >>>is even worse than that. Machine can stay is s2ram for weeks (for a
> >>>lot more if it is desktop and you do s2ram for powersaving). Also
> >>>temperature of CPU varies a lot between active and s2ram states. Is
> >>>TSC good enough?
> >>Yes, I think it is relatively precise. Per our test, system time backed
> >>by the S3 non stop TSC only has 1 second drift after 4 days running
> >>(with mixed running and S3 states). And before using this feature, we've
> >>seen many time drift problems due to the RTC HW or system FW with our
> >>platforms.
> >Nice result ...
> >
> >Is that with NTP running?
> >
> >Without NTP, the TSC fast-calibration on bootup is not (expected to be)
> >nearly as precise as the 1:345600 precision you've measured.
> 
> We also do refined calibration now on the TSC asynchronously over a
> period of seconds at boot up that gives us much better accuracy then
> the fast calibration. This helps provide much more consistent
> boot-to-boot TSC frequencies.

On android (and this is targetted at android, right?) system is going
to suspend basically as soon as it boots. Will refined calibration
have enough time to do its job?

And... reason for all this is that RTC has one second granularity when
accessed naively. But surely we could poll RTC X times a second,
getting error down by factor of X?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
