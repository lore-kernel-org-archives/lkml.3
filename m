Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3HMBEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:04:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48344 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756485Ab3HMBEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:04:01 -0400
Date: Mon, 12 Aug 2013 21:04:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mark Brown <broonie@kernel.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
In-Reply-To: <20130812214017.GH6427@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308122100300.26587-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013, Mark Brown wrote:

> On Mon, Aug 12, 2013 at 01:50:07PM -0700, Greg Kroah-Hartman wrote:
> > On Mon, Aug 12, 2013 at 12:23:44PM +0100, Mark Brown wrote:
> 
> > > I don't think they're bus specific - the main issue with a lot of this
> > > is that they're outside the infrastructure that the bus standardises so
> > > we should have a general way of understanding this.  There will be bits
> > > where the bus needs to get involved but the overall pattern is generic.
> 
> > The "pattern" is generic, yes, we've been dealing with that for well
> > over a decade now (pci hotplug controllers are "out of line" and control
> > when/if a PCI is device is added/removed.)
> 
> > I'd argue that each bus needs special logic to handle this, just like
> > PCI hotplug did it with their hotplug controller logic.  Due to the
> > nature of this type of thing, it's all out-of-line hardware that is
> > custom to each device type / bus.
> 
> I agree that the bus will need some logic to handle this and I also
> think Stephen is right that there are going to be some common patterns
> for some device classes.  However I do think that this is a common
> problem for pretty much all buses so we should be factoring out as much
> as possible from the buses so they only have to deal with their bit of
> things.  Most of the stuff that's worrying me is not anything the bus
> should have any idea about beyond tunnelling the data to the device.

In theory, the matching of device IDs can be done in the driver core, 
provided the IDs are assigned based on the bus topology (as is the 
case for USB).  But what should happen when there's a match?

The bus code would need hooks installed wherever the platform wants to 
do something extra.  This could end up growing to a lot of hooks.  How 
can the whole thing be done in a reasonable fashion?

Alan Stern

