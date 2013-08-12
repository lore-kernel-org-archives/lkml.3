Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3HLBxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 21:53:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54363 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755312Ab3HLBxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 21:53:03 -0400
Date: Sun, 11 Aug 2013 21:53:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mark Brown <broonie@kernel.org>
cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
In-Reply-To: <20130811190826.GH6427@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308112146410.29546-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Aug 2013, Mark Brown wrote:

> Looking at the enumerable buses in the kernel I don't see any which have
> real support for any kind of registration of devices prior to their
> enumeration.  Similarly currently all the DT bindings in the kernel I've
> been able to notice cover only non-enumerable buses.  This generally
> makes sense where enumerable buses are used in standard fashions since
> the binding would be at best redundant and at worst inaccurate.  However
> there are often corner cases in embedded systems where hardware has been
> hooked up outside of the normal enumeration mechanisms, for example with
> software power control or extra signals wired.
> 
> One example that's bugging me right now is that on the Insignal Arndale
> platform there's a USB hub connected to one of the USB ports on the SoC
> (not as a PHY, it seems we also need the internal PHY running to talk to
> the device).  The hub needs to be "plugged" into the SoC after the SoC
> USB controller has started with some GPIOs so we need to tell the system
> that the hub exists and needs to be synchronised with the USB controller.

On the surface, this seems like a particularly simple case.  Why wait 
until the SoC's USB controller has started?  Why not "plug in" the hub 
via the GPIOs right from the beginning?

> Another case that's going to be problematic once it's in mainline is
> Slimbus - this is a bus used in some embedded audio subsystems which is
> enumerable in a similar manner to USB but where the devices on the bus
> are normally powered up only on demand (causing them to hotplug when
> used and unplug when idle) and have at least interrupt lines wired to
> the SoC using a normal interrupt outside the enumerable bus.

That is indeed more difficult, because it requires geniune cooperation 
between the bus and platform subsystems.

> I know there's been some discussion of this topic but do we have any
> general consensus on how to handle such things both from a Linux driver
> model point of view and from a DT/ACPI point of view?

The discussion involved some sort of pattern matching based on the
device name and the bus, but nothing was ever settled.

Alan Stern

