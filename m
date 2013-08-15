Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3HOUmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:42:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42383 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751079Ab3HOUmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:42:03 -0400
Date: Thu, 15 Aug 2013 16:42:01 -0400 (EDT)
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
In-Reply-To: <20130815193242.GF30073@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308151616440.905-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013, Mark Brown wrote:

> On Thu, Aug 15, 2013 at 01:55:18PM -0400, Alan Stern wrote:
> > On Thu, 15 Aug 2013, Mark Brown wrote:
> > > On Thu, Aug 15, 2013 at 10:42:00AM -0400, Alan Stern wrote:
> 
> > > To be honest I don't see how that helps much if you're going to handle
> > > the case where platform data is required to enumerate the device.  You
> > > need to know about the device prior to enumeration in order to get the
> > > platform data to the driver when it does enumerate and you can't
> > > enumerate it until you do that anyway.
> 
> > You're a little imprecise here.  Which driver do you mean?  The driver
> > that will ultimately bind to the device, or the driver that will
> > discover and enumerate it (which generally is bound to the device's
> > upstream parent)?  I'll assume the latter.
> 
> The driver that's binding to the device - obviously going through
> teaching all controller drivers about how to start up any random child
> device they might encounter is not going to be a good idea, this should
> be encapsulated in the child driver.

Okay.  Here's a restatement of what you wrote above:

	In the case where platform data is required to enumerate the
	device, you need to know about the device prior to enumeration.

Obviously true.

	You need to get the platform data to the driver when it does
	enumerate.

Not necessarily; see below.

> > Under what circumstances is platform data required to enumerate a
> > device on a discoverable bus?  We're assuming the platform has already
> > taken care of everything required to make the device appear on the bus
> > in the usual manner (such as bringing it to full power).  Can you give
> > an example where something more is needed?
> 
> Powering on the device is exactly the sort of thing I'm talking about
> here.

So something needs to power-on the device.  But what?  The driver that
enumerates it, or some other part of the kernel?

If some other part of the kernel takes care of this then you _don't_
have to get the platform data to the driver when it enumerates.

>  I'm not sure what you think "the platform" is here but it sounds
> awfully like the sort of random board specific bodge code that people
> currently use - something has got to know what's needed to get the
> device up and running and how to do it and the device driver seems like
> the sensible place to do that.

Just the reverse.  The driver should deal with things it knows about:  
how to discover and enumerate devices on its bus.  It should not
contain anything platform-specific.  Adding this in would be a
logistical nightmare -- you'd have to stuff power-on procedures for all
sorts of different platforms into this one poor driver!

> I think I completely misunderstood what you mean by powering up on
> initial use.  If you're saying that we should have some platform code
> for doing this I don't think that's a scalable solution.

How can it be avoided?  The powering-up operation is platform-specific.  
By definition, whatever code carries out the operation is platform
code.

Alan Stern

