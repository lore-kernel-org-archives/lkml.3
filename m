Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaJ0Oca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:32:30 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53958 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaJ0Oc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:32:26 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414420292.30379.55.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 27 Oct 2014 15:31:32 +0100
In-Reply-To: <20141027092804.GB9807@amd>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	 <1413914978.30379.14.camel@hadess.net> <20141027092804.GB9807@amd>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 10:28 +0100, Pavel Machek wrote:
> Hi!
> 
> > > I suspect wakeup type reporting is maybe not the best way to go about
> > > this, since there may be a number of causes for wakeups and they can
> > > arrive closely together in different orders, which can result in
> > > races.
> > > 
> > > For instance, if the machine suspends, and sets an alarm to be woken
> > > up at midnight to do a backup, if the user resumes their laptop at
> > > 11:59:59, should the backup still proceed at midnight?
> > 
> > No. And I would expect that we would get a wake up type of "power
> > button" or "lid open" in this case.
> 
> I believe you should really use "is lid opened or AC or dock
> connected" to determine if it was automatic resume or not. It should
> work better and you can actually do it today.

There's no LID or docks on a tablet.

> > >   For mobile
> > > devices this is an expected design point, but for off-the-shelf
> > > laptops with big fans and exhaust vents, I'm not sure how safe this
> > > would be, so you may need to constrain this functionality somehow (or
> > > look to see if a enforced low-power resume is possible).
> > 
> > I think that we won't know whether it's a problem until the point that
> > somebody actually implements it.
> 
> Kernel does not stop you at this point, right?
> 
> Suspend-to-partition is also doable today (see suspend.sf.net),

Is it perfect? Because no releases in 3 years kind of scares me.

>  or you
> can just swapon before starting. You can take it off the list, I
> believe.

Or we could create a new filesystem type that isn't swap, that isn't
used by swap at all, but could be created by distributions' installers.
Then I wouldn't need to hope that the swap didn't start being used in
between me enabling it, and the suspend actually occurring (making it
impossible to disable afterwards).

