Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981Ab3HNO13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:27:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45468 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759901Ab3HNO11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:27:27 -0400
Date: Wed, 14 Aug 2013 10:27:26 -0400 (EDT)
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
In-Reply-To: <20130814113848.GP6427@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308141023150.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Mark Brown wrote:

> On Mon, Aug 12, 2013 at 09:04:00PM -0400, Alan Stern wrote:
> 
> > The bus code would need hooks installed wherever the platform wants to 
> > do something extra.  This could end up growing to a lot of hooks.  How 
> > can the whole thing be done in a reasonable fashion?
> 
> I'd expect that we're just looking at hooks around connection and
> disconnection here here - if we're looking at much more it seems like we
> must be doing something wrong.

Connection and disconnection of what?

In the example mentioned earlier, the GPIOs to power an on-board USB
hub would have to be initialized when the host controller was started.  
You wouldn't want to wait for the on-board hub to be detected, because
without those GPIOs set properly, it never would be discovered on the
USB bus.  Right?

Perhaps the platform-level code would need to hook into the places
where the discoverable bus is registered and unregistered.

Alan Stern

