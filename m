Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab3EBMai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:30:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35268 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab3EBMaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:30:35 -0400
Date: Thu, 2 May 2013 14:30:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Colin Cross <ccross@android.com>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] drivers: power: Add watchdog timer to catch
 drivers which lockup during suspend.
Message-ID: <20130502123033.GC22618@amd.pavel.ucw.cz>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
 <20130501003058.GB20042@amd.pavel.ucw.cz>
 <CAMbhsRQkYFvOzDDn4zmbZAEsVs6iSy4mPVq5w=MzQ7p9STBDew@mail.gmail.com>
 <20130501105630.GA22552@amd.pavel.ucw.cz>
 <CAMbhsRTtYSLpAmB0hsanBH3ez4bm8BgbcH1xEBQsZSj4dc069g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRTtYSLpAmB0hsanBH3ez4bm8BgbcH1xEBQsZSj4dc069g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > do BUG which
> >> >    dumps stack of current task
> >> >    kills current task
> >> >
> >> > Current task may very well be idle task; in such case you kill the
> >> > machine. Sounds like you should be doing something else, like kill -9
> >> > instead of BUG()?
> >>
> >> Not much else you can do, you are stuck part way into suspend with a
> >> driver's suspend callback half executed.  All userspace tasks are
> >> frozen, and the suspend task is blocked indefinitely.
> >
> > Yes, there's better option. Attempt killing the [a]suspend task,
> > instead of killing the current task.
> 
> That will leave you in a completely undefined state.  If you just kill
> the task, you are likely to kill the synchronous suspend task, which
> is the task that would resume your drivers and unfreeze tasks.  That
> will leave you with no userspace tasks running, and much of your
> hardware suspended.  How is that a useful result?  If you somehow

So instead you kill random task? (BUG() from timer kills pretty much
random task, right?)

If you want to do panic(), do panic().
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
