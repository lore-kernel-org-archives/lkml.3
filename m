Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbbAZLFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:05:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36390 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbbAZLFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:05:18 -0500
Date: Mon, 26 Jan 2015 12:05:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Change behaviour when tracing ... nasty trap (was Re: [PATCH]
 PM/Trace: get rid of synchronous resume limit during PM trace)
Message-ID: <20150126110516.GA2028@amd>
References: <54C5CB77.4000109@linux.intel.com>
 <20150126102352.GA1758@amd>
 <27240C0AC20F114CBF8149A2696CBE4A01F1AD6A@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01F1AD6A@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2015-01-26 10:39:04, Liu, Chuansheng wrote:
> Hello Pavel,
> 
> > > There are some kind of dependency between devices in some
> > > hardware platforms. So, asynchronous resuming devices may
> > > hang system due to wrong resume order. As a result, should
> > > not fore synchronously resuming devices during tracing
> > > PM events.
> > >
> > > Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> > > ---
> > >  drivers/base/power/main.c    |    3 +--
> > >  include/linux/resume-trace.h |    7 -------
> > >  2 files changed, 1 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > > index 9717d5f..5df148b 100644
> > > --- a/drivers/base/power/main.c
> > > +++ b/drivers/base/power/main.c
> > > @@ -517,8 +517,7 @@ static int device_resume_noirq(struct device *dev,
> > pm_message_t state, bool asyn
> > >
> > >  static bool is_async(struct device *dev)
> > >  {
> > > -	return dev->power.async_suspend && pm_async_enabled
> > > -		&& !pm_trace_is_enabled();
> > > +	return dev->power.async_suspend && pm_async_enabled;
> > >  }
> > >
> > 
> > Actually... whoever did the original patch was evil person. Changing
> > behaviour when tracing is requested is evil, evil, evil. Git blame
> > tells me
> > 
> > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> > 
> > went to the dark side.
> 
> Although I didn't get where is something wrong, but the is_async() is not created by my commit,
> it is from commit (PM: Start asynchronous resume threads upfront), I just moved it ahead.
> 
> And like other phases, I added it into resum/suspend_noirq()...

I see, blame blamed wrong person. It looks like Rafael is evil:

commit 97df8c12995c5bac73e3bfeea4c5be155c1f4401
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Jan 23 22:25:31 2010 +0100

    PM: Start asynchronous resume threads upfront

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
