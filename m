Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaDOTer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:34:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42701 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751335AbaDOTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:34:45 -0400
Date: Tue, 15 Apr 2014 15:34:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: linux-usb <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <andreas.brief@rohde-schwarz.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
In-Reply-To: <1397589265.21892.11.camel@vger.seibold.net>
Message-ID: <Pine.LNX.4.44L0.1404151521200.1310-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Stefani Seibold wrote:

> > So two devices failed to initialize after the drivers were rebound: 3-4 
> > and 2-2.  We know that 3-4 was the mass-storage device, but I can't 
> > tell from this log what 2-2 was.  
> > 
> 
> 2-2 is a custom HID device which handles the front panel and the rotary
> knop.

A custom device?  Maybe it's not behaving the way it should.

> Both of this devices are connect thru a HUB.

No.  You can tell from the device paths.  3-4 is the device plugged
directly into port 4 of the host controller for bus 3.  Similarly, 2-2
is the device plugged directly into port 2 of the host controller for
bus 2.

A good example of a device connected through a hub is the Rohde&Schwarz 
FrontPanel USB Keyboard, 1-2.2.  This means it is plugged into port 2 
of the hub that is plugged into port 2 of the host controller for bus 
1.

Also, the fact that these two devices are on different buses means that 
they can't be connected to the same hub.  If they were, they would both 
be on the same bus as that hub.

> An other PPC board which
> nearly the same HW does not have this HUB and this can handle the USB
> bus without any problem.
> 
> So i think the HUB is the reason.

Under the circumstances, I don't see how it could be.

> Sorry, the HW is soldered on the board.

If you think there is a bad hub, can you remove it and re-solder the 
other components?

Unfortunately, your environment isn't very suitable for testing.  You 
can't attach the hardware to a different computer, you can't use any 
test equipment, and you can't even try out different kernel versions.

All together, the odds of solving this problem aren't good.

> Right, but i would prefer a solution for this. Since it works perfectly
> in kernel 3.4 i don't think it is a hardware issue.

Maybe yes, maybe no.  Without the ability to perform detailed tests, we 
can't tell.

What happens if you run the unbind/rebind test under 3.4?

Alan Stern

