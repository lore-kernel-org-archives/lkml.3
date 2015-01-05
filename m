Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbbAENn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:43:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46810 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbbAENn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:43:26 -0500
Date: Mon, 5 Jan 2015 14:43:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: NeilBrown <neilb@suse.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
Message-ID: <20150105134323.GA27863@amd>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215943.4127.24792.stgit@notabene.brown>
 <20141228142010.GA3922@amd>
 <20150103103357.2406fc23@notabene.brown>
 <20150104101847.GA6122@amd>
 <20150105200936.2ba8f596@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105200936.2ba8f596@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > N_HCI activates (registers the hci dev) on HCIUARTSETPROTO ioctl.  A child
> > >   device would need a way to specify the protocol I resume.
> > > N_MOUSE activates on a 'read' on the tty - and deactivates when the read
> > >   completes.
> > > N_GSM0710 activates immediately that the ldisc is activated, as does N_IRDA
> > > N_PPP seems to want a PPPIOCNEWUNIT ioctl to fully register.
> > > 
> > > Doing any of these in a driver for a uart slave device would certainly be
> > > possible.  I wonder if it is something we really want to do in the kernel
> > > though.  What is the gain over providing sufficient information in the
> > > KOBJ_ADD uevent so that udev can do the required work in user-space?
> > 
> > Consistency. If you have bluetooth on USB, it automatically works,
> > without userspace help. If we have mouse on USB, it automatically
> > works, etc...
> 
> My point is: why is the kernel/userspace distinction important?  As long as
> it "automatically works", does it really matter where the code is?

For some cases, it does, as "devices needed during boot". Someone is
going to attach keyboard or something powermanagement related, sooner
or later.

> We can put a little bit of code in the kernel (to report the details of the
> attached device) and a little bit of code in udev (to run hciattach) and it
> will still be automatic.

Of course, that's also possible. There will be parameters such as
speed / parity / flow control that will need to be passed, and
userland will still see /dev/ttySX device that it perhaps does not
need to see.

And there will be problems with devices such as bcm2048 on Nokia,
which is connected by a serial line and (interrupt capable) GPIO lines
and clocks. Rather than extending hciattach to pass the neccessary
GPIO/clock information and extending udev to pass GPIO/clock
information to hciattach (and extending kernel to pass it to udev and
accept from hciattach), it makes sense to just do it internally.
									Pavel
									


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
