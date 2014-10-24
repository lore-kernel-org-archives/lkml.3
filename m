Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbaJXLRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:17:48 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:61273 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaJXLRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:17:46 -0400
Date: Fri, 24 Oct 2014 13:14:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Nix <nix@esperi.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Paul Martin <pm@debian.org>,
        Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141024111442.GA19377@localhost>
References: <874mwnosz1.fsf@spindle.srvr.nix>
 <871tqe2zqt.fsf_-_@spindle.srvr.nix>
 <20141011195108.GA8275@thinkpad.nowster.org.uk>
 <87y4smz1l0.fsf@spindle.srvr.nix>
 <20141012185845.GB2786@localhost>
 <878uklynq9.fsf@spindle.srvr.nix>
 <20141014083432.GB7958@localhost>
 <871tq04fiy.fsf@spindle.srvr.nix>
 <20141022101458.GK2113@localhost>
 <87y4s8yv38.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4s8yv38.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +CC: linux-usb ]

On Wed, Oct 22, 2014 at 04:36:59PM +0100, Nix wrote:
> On 22 Oct 2014, Johan Hovold outgrape:
> 
> > On Wed, Oct 22, 2014 at 10:31:17AM +0100, Nix wrote:
> >> On 14 Oct 2014, Johan Hovold verbalised:
> >> 
> >> > On Sun, Oct 12, 2014 at 10:36:30PM +0100, Nix wrote:
> >> >> I have checked: this code is being executed against a symlink that
> >> >> points to /dev/ttyACM0, and the tcsetattr() succeeds. (At least, it's
> >> >> succeeding on the kernel I'm running now, but of course that's 3.16.5
> >> >> with this commit reverted...)
> >> >
> >> > You could verify that by enabling debugging in the cdc-acm driver and
> >> > making sure that the corresponding control messages are indeed sent on
> >> > close.
> >> 
> >> I have a debugging dump at
> >> <http://www.esperi.org.uk/~nix/temporary/cdc-acm.log>; it's fairly
> >
> > What kernel were you using here? The log seems to suggest that it was
> > generated with the commit in question reverted.
> 
> Look now :) (the previous log is still there in cdc-acm-reverted.log.)

Unfortunately, it seems the logs are incomplete. There are lots of
entries missing (e.g. "acm_tty_install" when opening, but also some
"acm_submit_read_urb"), some of which were there in your first log.

Also you can disable the "acm_tty_write - count" output, which isn't
really useful here.

> This contains two boots -- one on which the USB key worked, and the next
> (with an identical kernel) with which the key was broken. (I'm not sure
> whether this problem happens at startup or shutdown time, so it seemed
> best to provide both.)

That's a good idea.

Is it only after reboot you've seen the device fail? What if you
physically disconnect and reconnect the device instead, or simply
repeatedly open and close it?

Johan
