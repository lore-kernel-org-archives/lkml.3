Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab3C3SOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 14:14:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35357 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab3C3SOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 14:14:54 -0400
Date: Sat, 30 Mar 2013 19:14:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
Message-ID: <20130330181451.GF28947@amd.pavel.ucw.cz>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <50FD48B6.9010202@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FD48B6.9010202@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >On some new Intel Atom processors (Penwell and Cloverview), there is
> >a feature that the TSC won't stop S3, say the TSC value won't be
> >reset to 0 after resume. This feature makes TSC a more reliable
> >clocksource and could benefit the timekeeping code during system
> >suspend/resume cycles.
> >
> >The enabling efforts include adding new flags for this feature,
> >modifying clocksource.c and timekeeping.c to support and utilizing
> >it.
> >
> >One remaining question is inside the timekeeping_resume(), we don't
> >know if it is called by resuming from suspend(s2ram) or from
> >hibernate(s2disk), as there is no easy way to check it currently.
> >But it doesn't hurt as these Penwell/Cloverview platforms only have
> >S3 state, and no S4.
> >
> >Please help to review them, thanks!
> 
> The patches look reasonable to me.

Not sure... what are advantages? TSC is high resolution, but not
exactly precise time source... and this only makes resume more
complex.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
