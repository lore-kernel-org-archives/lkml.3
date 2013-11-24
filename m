Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3KXV2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 16:28:14 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:43916 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3KXV2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 16:28:11 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when populating interrupts
To: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20131123015034.GP10023@atomide.com>
References: <20131123004334.GJ10023@atomide.com> <20131123005509.GJ16735@ n2100.arm.linux.org.uk> <20131123010850.GN10023@atomide.com> < 20131123011515.GO10023@atomide.com> <20131123015034.GP10023@atomide.com>
Date: Sun, 24 Nov 2013 21:27:57 +0000
Message-Id: <20131124212757.7D224C402A3@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 17:50:35 -0800, Tony Lindgren <tony@atomide.com> wrote:
> * Tony Lindgren <tony@atomide.com> [131122 17:16]:
> > * Tony Lindgren <tony@atomide.com> [131122 17:09]:
> > > * Russell King - ARM Linux <linux@arm.linux.org.uk> [131122 16:56]:
> > > > On Fri, Nov 22, 2013 at 04:43:35PM -0800, Tony Lindgren wrote:
> > > > > +		/* See of_device_resource_notify for populating interrupts */
> > > > > +		for (i = 0; i < num_irq; i++, res++) {
> > > > > +			res->flags = IORESOURCE_IRQ;
> > > > > +			res->start = -EPROBE_DEFER;
> > > > > +			res->end = -EPROBE_DEFER;
> > > > 
> > > > NAK.  Definitely a bad idea to start introducing magic values other into
> > > > resources.  Please don't do this.
> > > 
> > > Do you have any better ideas on how to sort out this issue then?
> > 
> > I guess we could allocate all the resources lazily here, I'll take a look
> > at that.
> 
> Here's a version that allocates the resources lazily with the notifier.
> Seems to boot, need to play with it a bit more though to make sure we're
> not overwriting resources for any legacy devices.

Blurg. Using a notifier really feels like we don't have a good handle on
a reasonable solution yet. Basically it means we're hooking into the
driver core without /looking/ like we're hooking into the driver core. I
don't think this is any better, but I don't have a better suggestion at
the moment.   :-(

g.

