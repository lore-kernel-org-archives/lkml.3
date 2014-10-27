Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaJ0J2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:28:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48059 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaJ0J2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:28:10 -0400
Date: Mon, 27 Oct 2014 10:28:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141027092804.GB9807@amd>
References: <1413881397.30379.7.camel@hadess.net>
 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
 <1413911644.30379.12.camel@hadess.net>
 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
 <1413914978.30379.14.camel@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413914978.30379.14.camel@hadess.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I suspect wakeup type reporting is maybe not the best way to go about
> > this, since there may be a number of causes for wakeups and they can
> > arrive closely together in different orders, which can result in
> > races.
> > 
> > For instance, if the machine suspends, and sets an alarm to be woken
> > up at midnight to do a backup, if the user resumes their laptop at
> > 11:59:59, should the backup still proceed at midnight?
> 
> No. And I would expect that we would get a wake up type of "power
> button" or "lid open" in this case.

I believe you should really use "is lid opened or AC or dock
connected" to determine if it was automatic resume or not. It should
work better and you can actually do it today.

> >   For mobile
> > devices this is an expected design point, but for off-the-shelf
> > laptops with big fans and exhaust vents, I'm not sure how safe this
> > would be, so you may need to constrain this functionality somehow (or
> > look to see if a enforced low-power resume is possible).
> 
> I think that we won't know whether it's a problem until the point that
> somebody actually implements it.

Kernel does not stop you at this point, right?

Suspend-to-partition is also doable today (see suspend.sf.net), or you
can just swapon before starting. You can take it off the list, I
believe.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
