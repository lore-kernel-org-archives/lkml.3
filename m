Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaFGHaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 03:30:35 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37356 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaFGHaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 03:30:19 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 7/7] OF/ACPI/I2C: Add generic match function for the
 aforementioned systems
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <20140606123653.GP24240@lee--X1>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
	<1401883796-17841-8-git-send-email-lee.jones@linaro.org>
	<20140605103009.85BE4C40A4D@trevor.secretlab.ca>
	<20140605103709.GE19550@lee--X1>
	<CACxGe6vLuKygv0E7yq42qe-Lh+nMZ1wrL7PW_TAeoz55wz9q8A@mail.gmail.com>
	<20140605155509.GH24240@lee--X1> <20140606102446.GK2520@sirena.org.uk>
	<20140606123653.GP24240@lee--X1>
Date: Sat, 07 Jun 2014 00:42:53 +0100
Message-Id: <20140606234253.A4E25C427F0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 13:36:53 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 06 Jun 2014, Mark Brown wrote:
> 
> > On Thu, Jun 05, 2014 at 04:55:09PM +0100, Lee Jones wrote:
> > > On Thu, 05 Jun 2014, Grant Likely wrote:
> > 
> > > > I still think the way to do it is to emulate the missing i2c_device_id
> > > > when calling the drivers .probe() hook by having a temporary copy on
> > > > the stack and filling it with data from the OF or ACPI table....
> > 
> > > That's the opposite of what I'm trying to achieve.  I'm trying to get
> > > rid of unused i2c_device_id tables, rather than reinforce their
> > > mandatory existence.  I think an i2c_of_match_device() with knowledge
> > > of how to match via pure DT principles (of_node/compatible) and a
> > > fall-back, which is able to match on a provided of_device_id table
> > > alone i.e. without the requirement of an existing of_node.
> > 
> > > I've also been mulling over the idea of removing the second probe()
> > > parameter, as suggested by Wolfram.  However, this has quite deep
> > > ramifications which would require a great deal of driver adaptions.
> > 
> > If you're going to do that another option is to refactor the probe()
> > function to take the driver_data as an argument and then have the core
> > pass that from whatever table it matched from rather than the entire
> > i2c_device_id structure.  That way the driver just needs to supply all
> > the ID tables mapping binding information to whatever it needs and the
> > core can pass in the driver data from whatever table it matched against.
> 
> Unfortunately this means we're back to the aforementioned typing
> issue.  For struct {platform,i2c,spi,acpi,etc}_device_id the driver
> data is a kernel ulong but the of_device_id's driver data attribute is
> a void*.

We're actually okay there. Each subsystem defines it's own convention
about what those values mean. ulong and void* are the same size and
every user I've seen stuffs the same data into the data field of both
tables.

> I've just started work on a migration over to a new probe().  I don't
> think it's all that much work, but if there are any objections I'd
> prefer to hear them now rather than waste any time.

I have no problem with that approach.

> I propose to convert a couple of drivers, one which doesn't use the
> driver_data and one that does, but is DT only and send them for
> review.  See if Wolfram et. al like the method.
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

