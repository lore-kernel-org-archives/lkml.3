Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaFEIUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:20:18 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:64105 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaFEIUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:20:14 -0400
Date: Thu, 5 Jun 2014 09:20:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 7/7] OF/ACPI/I2C: Add generic match function for the
 aforementioned systems
Message-ID: <20140605082008.GC19550@lee--X1>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <1401883796-17841-8-git-send-email-lee.jones@linaro.org>
 <5769487.6cMQUCkisu@vostro.rjw.lan>
 <20140604125141.GB5214@lahna.fi.intel.com>
 <20140604132820.GA19550@lee--X1>
 <20140605080000.GE5214@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140605080000.GE5214@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014, Mika Westerberg wrote:
> On Wed, Jun 04, 2014 at 02:28:20PM +0100, Lee Jones wrote:
> > On Wed, 04 Jun 2014, Mika Westerberg wrote:
> > > On Wed, Jun 04, 2014 at 02:37:42PM +0200, Rafael J. Wysocki wrote:
> > > > On Wednesday, June 04, 2014 01:09:56 PM Lee Jones wrote:
> > > > > Currently this is a helper function for the I2C subsystem to aid the
> > > > > matching of non-standard compatible strings and devices which use DT
> > > > > and/or ACPI, but do not supply any nodes (see: [1] Method 4).  However,
> > > > > it has been made more generic as it can be used to only make one call
> > > > > for drivers which support any mixture of OF, ACPI and/or I2C matching.
> > > > > 
> > > > > The initial aim is for of_match_device() to be replaced by this call
> > > > > in all I2C device drivers.
> > > > > 
> > > > > [1] Documentation/i2c/instantiating-devices
> > > > > 
> > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > 
> > > > Mika, can you please have a look at this, please?
> > > 
> > > I don't see any fundamental problems with this wrt. ACPI.
> > > 
> > > That said, I find it kind of weird to have generic function that then
> > > has knowledge of how different buses do their matching.
> > > 
> > > I would rather see something like firmware_device_match(dev) that goes
> > > and matches from DT/ACPI and leave bus specific match to happen internal
> > > to that bus.
> > 
> > Unfortunately that completely defeats the object of the patch.  When a
> > of_match_device() is invoked it solely looks up devices based on OF
> > matching, but I2C is special in that devices can be registered via
> > sysfs, thus will no have device node.  If of_match_device() is called
> > in one of these instances it will fail.  The idea of this patch is to
> > generify the matching into something does has the knowledge to firstly
> > attempt a traditional match, and if that fails will fall back to a
> > special i2c_{of,acpi}_match_device() which knows how to deal with
> > node-less registration.
> 
> OK, then but since this is now I2C specific, why call it device_match()
> instead of something like i2c_device_match()? Or do you have plans to

So in an early incarnation of the patch I did just that, and it might
not actually be such a bad idea still - I'm open to other people's
opinions on this.

> add there more knowledge about other buses like SPI and PCI to name few?

... but yes, this is the new idea - that it can be expanded as required.
-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
