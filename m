Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaKFRIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:08:09 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:56580 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaKFRIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:08:05 -0500
Date: Thu, 6 Nov 2014 18:04:56 +0100
From: Johan Hovold <johan@kernel.org>
To: Nix <nix@esperi.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Paul Martin <pm@debian.org>,
        Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141106170456.GC26196@localhost>
References: <20141014083432.GB7958@localhost>
 <871tq04fiy.fsf@spindle.srvr.nix>
 <20141022101458.GK2113@localhost>
 <87y4s8yv38.fsf@spindle.srvr.nix>
 <20141024111442.GA19377@localhost>
 <87d298i3y9.fsf@spindle.srvr.nix>
 <20141105115643.GR31358@localhost>
 <87vbmtbrx2.fsf@spindle.srvr.nix>
 <20141105181454.GW31358@localhost>
 <877fz8bfs6.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877fz8bfs6.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 01:49:13PM +0000, Nix wrote:
> On 5 Nov 2014, Johan Hovold told this:
> > On Wed, Nov 05, 2014 at 03:14:49PM +0000, Nix wrote:

> > Could you try two more things (too make sure line control is really the
> > culprit):
> >
> > 1. If you clear HUPCL in ekeyd so that the lines are never lowered, does
> > that fix the stability issue?
> 
> Definitely not. I got a hang after the first reboot out of an afflicted
> kernel, when using a HUPCLless ekeyd. Weird. (I guess they're lowered on
> reboot anyway?)

It's actually only the timings related to the control-lines being raised
on open that has changed, so this would seem consistent with that.

> > 2. Can you verify that the patch below works? Did I use the correct
> > VID/PID? Could you provide "lsusb -v" output (for the capability flags)
> > as well?
> 
> The VID/PID are right.
> 
> The patch seems to work. I tested against the usb testing tree directly,
> since that was easier than adjusting it to apply against 3.16. Sixteen
> reboots, no failures, looks to be fixed.

Great, thanks for testing.

> > Note that the patch is against the usb-linus branch of the usb tree,
> 
> OK. (I presume this is gregkh's tree, not yours?)

Yes, Greg's tree, could have been more clear about that.

> > which also contains another fix which could affect this device
> > (set_termios will now be called an extra time on every open). You also
> > need this one, which have not yet been applied:
> >
> > 	http://marc.info/?l=linux-usb&m=141520959813505&w=2
> 
> It had been applied by the time I tested this :)

Greg is fast. :)

Thanks for tracking this down. That bisect cannot have been fun given
the low failure rate (sometimes only one in ten reboots?).

Johan
