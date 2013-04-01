Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab3DAUbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:31:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34619 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab3DAUbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:31:38 -0400
Date: Mon, 1 Apr 2013 22:31:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
Message-ID: <20130401203136.GA2543@amd.pavel.ucw.cz>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <50FD48B6.9010202@intel.com>
 <20130330181451.GF28947@amd.pavel.ucw.cz>
 <5159C4AE.2050504@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5159C4AE.2050504@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>On some new Intel Atom processors (Penwell and Cloverview), there is
> >>>a feature that the TSC won't stop S3, say the TSC value won't be
> >>>reset to 0 after resume. This feature makes TSC a more reliable
> >>>clocksource and could benefit the timekeeping code during system
> >>>suspend/resume cycles.
> >>>
> >>>The enabling efforts include adding new flags for this feature,
> >>>modifying clocksource.c and timekeeping.c to support and utilizing
> >>>it.
> >>>
> >>>One remaining question is inside the timekeeping_resume(), we don't
> >>>know if it is called by resuming from suspend(s2ram) or from
> >>>hibernate(s2disk), as there is no easy way to check it currently.
> >>>But it doesn't hurt as these Penwell/Cloverview platforms only have
> >>>S3 state, and no S4.
> >>>
> >>>Please help to review them, thanks!
> >>The patches look reasonable to me.
> >Not sure... what are advantages? TSC is high resolution, but not
> >exactly precise time source... and this only makes resume more
> >complex.
> Providing sub-second granularity for suspend time measurement is a
> pretty compelling use, which greatly reduces time error across
> suspend/resume.

Certainly for short sleeps. Is TSC actually precise enough to keep
precise time for hours? I thought TSC sucked at precision.

> I agree that the code logic is more complex, but the TSC path should
> be a good bit faster then hitting the CMOS.

You are right here.

> There is the open concern that given their history, x86 designers
> will find yet another way to break the TSC in some future chip and
> we'll end up with non-stop TSCs that run at different frequencies in
> suspend or some other such nonsense. But we'll just have to detect
> that and disable functionality where appropriate, much as we do with
> the TSC now.

Ok.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
