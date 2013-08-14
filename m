Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab3HNQOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:14:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45547 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758463Ab3HNQOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:14:07 -0400
Date: Wed, 14 Aug 2013 12:14:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Brown <broonie@kernel.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
In-Reply-To: <20130814153906.GU6427@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308141209410.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Mark Brown wrote:

> On Wed, Aug 14, 2013 at 10:27:26AM -0400, Alan Stern wrote:
> > On Wed, 14 Aug 2013, Mark Brown wrote:
> 
> > > I'd expect that we're just looking at hooks around connection and
> > > disconnection here here - if we're looking at much more it seems like we
> > > must be doing something wrong.
> 
> > Connection and disconnection of what?
> 
> The device on the bus.
> 
> > In the example mentioned earlier, the GPIOs to power an on-board USB
> > hub would have to be initialized when the host controller was started.  
> > You wouldn't want to wait for the on-board hub to be detected, because
> > without those GPIOs set properly, it never would be discovered on the
> > USB bus.  Right?
> 
> Yes, so you'd want callbacks when the device actually appears and
> disappears.

No, no -- this is exactly the point I was trying to make.  The on-board
hub _won't_ appear on the USB bus until the GPIOs are set.  Therefore
the callback to set the GPIOs needs to be at a different place, not
when the device appears.

> > Perhaps the platform-level code would need to hook into the places
> > where the discoverable bus is registered and unregistered.
> 
> We'd need some way to get information to the drivers still, and to
> handle drivers that want to stop and start things.

Um...  What exactly does this mean?  It's so generic, it could apply to
anything under drivers/.  After all, what driver doesn't want to stop
and start things?

Alan Stern

