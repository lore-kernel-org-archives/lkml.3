Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbbADKSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 05:18:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39918 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADKSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 05:18:51 -0500
Date: Sun, 4 Jan 2015 11:18:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: NeilBrown <neilb@suse.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
Message-ID: <20150104101847.GA6122@amd>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215943.4127.24792.stgit@notabene.brown>
 <20141228142010.GA3922@amd>
 <20150103103357.2406fc23@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150103103357.2406fc23@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +Optional child node:
> > > +- a platform device listed as a child node will be probed and
> > > +  powered-on whenever the tty is in use (open).
> > > +
> > >  Example:
> > >  
> > >  	uart@80230000 {
> > 

> But some line disciplines don't really want the char_dev.
> N_MOUSE wants a serio device.
> N_HCI wants an HCI device
> N_GSM07010 wants 63 different tty char_devs.
> N_IRDA and N_PPP ultimately want a net_dev.
> etc.
> 
> It would be really nice if the uart would register the line disciple as a
> child device, then the line discipline would register whatever it wants.

Yes.

> N_HCI activates (registers the hci dev) on HCIUARTSETPROTO ioctl.  A child
>   device would need a way to specify the protocol I resume.
> N_MOUSE activates on a 'read' on the tty - and deactivates when the read
>   completes.
> N_GSM0710 activates immediately that the ldisc is activated, as does N_IRDA
> N_PPP seems to want a PPPIOCNEWUNIT ioctl to fully register.
> 
> Doing any of these in a driver for a uart slave device would certainly be
> possible.  I wonder if it is something we really want to do in the kernel
> though.  What is the gain over providing sufficient information in the
> KOBJ_ADD uevent so that udev can do the required work in user-space?

Consistency. If you have bluetooth on USB, it automatically works,
without userspace help. If we have mouse on USB, it automatically
works, etc...

> However I do like the idea of having the UART probe the child instead of
> registering a tty.  It could pass the tty_operations structure to the child,
> and the child could then register a tty with a slightly different
> tty_operations structure, allowing it to capture any operations that it wants
> to capture (such as open/close).
> I might try coding that and see what it looks like...

Lets have a look...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
