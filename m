Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaFEPzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:55:23 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:32793 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaFEPzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:55:16 -0400
Date: Thu, 5 Jun 2014 16:55:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 7/7] OF/ACPI/I2C: Add generic match function for the
 aforementioned systems
Message-ID: <20140605155509.GH24240@lee--X1>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <1401883796-17841-8-git-send-email-lee.jones@linaro.org>
 <20140605103009.85BE4C40A4D@trevor.secretlab.ca>
 <20140605103709.GE19550@lee--X1>
 <CACxGe6vLuKygv0E7yq42qe-Lh+nMZ1wrL7PW_TAeoz55wz9q8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6vLuKygv0E7yq42qe-Lh+nMZ1wrL7PW_TAeoz55wz9q8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014, Grant Likely wrote:
> On Thu, Jun 5, 2014 at 11:37 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Thu, 05 Jun 2014, Grant Likely wrote:
> >
> >> On Wed,  4 Jun 2014 13:09:56 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> >> > Currently this is a helper function for the I2C subsystem to aid the
> >> > matching of non-standard compatible strings and devices which use DT
> >> > and/or ACPI, but do not supply any nodes (see: [1] Method 4).  However,
> >> > it has been made more generic as it can be used to only make one call
> >> > for drivers which support any mixture of OF, ACPI and/or I2C matching.
> >> >
> >> > The initial aim is for of_match_device() to be replaced by this call
> >> > in all I2C device drivers.
> >> >
> >> > [1] Documentation/i2c/instantiating-devices
> >> >
> >> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >>
> >> I don't like this. It drops all type safety on the match entry
> >> and the caller has no idea what it got back.
> >
> > Okay, so what's the best way forward?
> >
> > Introduce a i2c_of_match_device() call instead?
> 
> I still think the way to do it is to emulate the missing i2c_device_id
> when calling the drivers .probe() hook by having a temporary copy on
> the stack and filling it with data from the OF or ACPI table....

That's the opposite of what I'm trying to achieve.  I'm trying to get
rid of unused i2c_device_id tables, rather than reinforce their
mandatory existence.  I think an i2c_of_match_device() with knowledge
of how to match via pure DT principles (of_node/compatible) and a
fall-back, which is able to match on a provided of_device_id table
alone i.e. without the requirement of an existing of_node.

I've also been mulling over the idea of removing the second probe()
parameter, as suggested by Wolfram.  However, this has quite deep
ramifications which would require a great deal of driver adaptions.

> Actually I would completely skip trying to get the data from ACPI.
> Since all of this is to continue supporting instantiating devices from
> sysfs, having a fallback to the OF table completely solves that use
> case.

> Anticipating an objection of: "what do we do with drivers that are
> ACPI only?"... That will be an incredibly rare case. If that ever does
> happen then we'll solve it by simply adding an of_device_id table.

I'm fine with leaving out ACPI support for now.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
