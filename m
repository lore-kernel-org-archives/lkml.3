Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3KGPci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:32:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40398 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754599Ab3KGPce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:32:34 -0500
Date: Thu, 7 Nov 2013 10:32:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that
 are NOTATTACHED
In-Reply-To: <CAODwPW8j2wGGgH_HjuXuH=95jd_B1iqWeifoT89xgJoEZRvphw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1311071026480.1401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Julius Werner wrote:

> > What if the device is in USB_STATE_SUSPENDED?
> 
> I'm not sure that is possible at that point in hub_events(), I don't
> know of a way that could lead to this situation. I could still add the
> check just to be sure if you want it, though.

I don't know either.  But Sarah has said that ports can spontaneously
go into Compliance Mode for no apparent reason.  If that can happen,
maybe it can happen while the port is in U3 and the device is
suspended.  In such cases, though, you'd need to do a reset-resume
rather than a simple reset.

> > Not at all.  If a device is unplugged, its state changes to NOTATTACHED
> > before the driver is unbound.  During that time, the driver will see
> > all its URBs failing, so it may very well try to reset the device.
> > (For example, usbhid behaves like this.)  That isn't a bug.
> 
> Oh, okay, I wasn't quite sure how that plays together. Would you think
> it's still valuable to print it out (maybe as dev_info() instead of
> dev_warn()) instead of just silently ignoring the reset request? It
> would have certainly been useful for me to find this problem faster,
> but I can take it out again if you think it would result in too much
> noise.

I think keeping dev_dbg() is best.  If you're searching for the
solution to a problem, you should have debugging enabled and so you
ought to see the message.

Alan Stern

