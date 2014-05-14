Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaENP6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:58:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42882 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaENP6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:58:00 -0400
Date: Wed, 14 May 2014 17:57:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc: regression in suspend
Message-ID: <20140514155759.GB9723@amd.pavel.ucw.cz>
References: <20140513160926.GA3621@amd.pavel.ucw.cz>
 <20140513163734.GA4602@amd.pavel.ucw.cz>
 <20140513214155.GA5087@amd.pavel.ucw.cz>
 <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-05-14 14:39:19, Jiri Kosina wrote:
> On Tue, 13 May 2014, Pavel Machek wrote:
> 
> > > > There seems to be regression in 3.15 w.r.t. suspend to ram and suspend
> > > > to disk.
> > > > 
> > > > Resume sometiems works, but often, system is half-usable, with "what
> > > > do you want to do suspend/hibernate" dialog staying on screen.
> > > > 
> > > > I did echo disk > /sys/power/state, and echo never returned to the
> > > > shell prompt. (X was not really working, either.)
> > > > 
> > > > It is still there on 3.15.0-rc3+. I'll update to rc5 now.
> > > 
> > > 3.15.0-rc5+ seems to behave a bit better. Lets see if it reappears.
> > 
> > It did. 
> 
> So it might in the end of the day the same thing as I have reported in 
> 
> 	https://bugs.freedesktop.org/show_bug.cgi?id=76554
> 
> which is not 100% reproducible either (although with newer kernels it's 
> *much* more reproducible for me than with older).
> 
> > It worked few times on -rc5, but then I rebooted and problem 
> > re-appeared.
> 
> If you could capture dmesg of the resume where X fails to resume properly 
> to see whether you have i915 ring initialization errors there as well?

I did dmesg and I believe I would have noticed "*ERROR*" there.. but
I'll of course capture the buffer when it happens. 

Note that X do work somehow after resume (I can't switch virtual
desktops and dialog is stuck on screen, but it is not complete
failure). I can do ctrl-alt-f1 and get to useful prompt.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
