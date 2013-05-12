Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3ELAGD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 20:06:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48963 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3ELAGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 20:06:01 -0400
Date: Sun, 12 May 2013 02:05:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Colin Cross <ccross@android.com>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCHv2 2/2] PM: compile-time configuration of device
 suspend/resume watchdogs.
Message-ID: <20130512000559.GA22567@amd.pavel.ucw.cz>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
 <1368221329-1841-3-git-send-email-zoran.markovic@linaro.org>
 <20130511092807.GB10045@amd.pavel.ucw.cz>
 <CAMbhsRTcB6U5ctxWUy2ODOCGaYd_NdYZvWyxCOqcHiZPKGAv5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRTcB6U5ctxWUy2ODOCGaYd_NdYZvWyxCOqcHiZPKGAv5w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Power management debug option to configure device suspend/resume watchdogs.
> >> Available options are:
> >>   1. Enable/disable the feature.
> >>   2. Select triggered watchdog action between:
> >>         - system panic (default)
> >>         - dump stacktrace
> >>         - log event
> >>   3. Select timeout value for the watchdog(s).
> >
> > People disliked the previous behaviour, so you add 10 config
> > options... with different behaviours. Also 1 second timeout is not
> > acceptable for endusers (will break the system), so it should not be
> > offered. In fact, remove that option, too. People doing that kind of
> > debugging can modify the sources, right?
> 
> Greg KH asked for more configurable options.  I agree this may be a
> little too far (I would replace the action choice with a simple "panic
> on timeout?"), but its better than it was before.  Also, a 1 second
> timeout is perfectly reasonable, especially if you configure it to
> dump a stack trace but not panic.  Mobile devices normally finish
> suspending within a few hundred ms.

For stack dump, yes that's ok.

Maybe it ends up less ugly if it will be runtime-configurable?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
