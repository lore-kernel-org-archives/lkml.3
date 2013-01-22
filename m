Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3AVAOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:14:51 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56286 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3AVAOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:14:50 -0500
Date: Mon, 21 Jan 2013 16:14:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Anatolij Gustschin <agust@denx.de>, Frodo Looijaard <frodol@dds.nl>,
        Philip Edelbrock <phil@netroedge.com>,
        Ben Gardner <bgardner@wabtec.com>, Ronny Meeus <Ronny.Meeus@gmail.com>
Subject: Re: [RFC] Creating an eeprom class
Message-ID: <20130122001445.GA4308@kroah.com>
References: <CAAXf6LXkgLiBLFmwH_GR9hkjFgOJ5z1nSTQd9Q4pJud732Lb9Q@mail.gmail.com>
 <20130120223907.GA8424@kroah.com>
 <CAAXf6LXGOzqu=VeSdeuu3kNBjVBcobp-2keDmSZ_JSL-72Uu+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAXf6LXGOzqu=VeSdeuu3kNBjVBcobp-2keDmSZ_JSL-72Uu+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 08:25:59AM +0100, Thomas De Schampheleire wrote:
> On Sun, Jan 20, 2013 at 11:39 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Sun, Jan 20, 2013 at 07:08:28PM +0100, Thomas De Schampheleire wrote:
> >> [plaintext and fixed address of David Brownell]
> >
> > David passed away a year or so ago, so that's really not going to help :(
> 
> So sorry to hear that, I was not aware...
> 
> >
> >> Hi,
> >>
> >> Several of the eeprom drivers that live in drivers/misc/eeprom export
> >> a binary sysfs file 'eeprom'. If a userspace program or script wants
> >> to access this file, it needs to know the full path, for example:
> >>
> >> /sys/bus/spi/devices/spi32766.0/eeprom
> >>
> >> The problem with this approach is that it requires knowledge about the
> >> hardware configuration: is the eeprom on the SPI bus, the I2C bus, or
> >> maybe memory mapped?
> >>
> >> It would therefore be more interesting to have a bus-agnostic way to
> >> access this eeprom file, for example:
> >> /sys/class/eeprom/eeprom0/eeprom
> >>
> >> Maybe it'd be even better to use a more generic class name than
> >> 'eeprom', since there are several types of eeprom-like devices that
> >> you could export this way.
> >
> > Does all of the existing "eeprom" devices use the same userspace
> > interface?  If so, yes, having a "class" would make sense.
> 
> All but one do. That one (eeprom_93cx6.c) exports its read/write
> functions to other kernel code, and is used in several
> wireless/ethernet drivers.

Then it shouldn't be used here, right?

> >> Or should we rather hook the eeprom code into the mtd subsystem?
> >
> > Why mtd?
> 
> Because an eeprom is a piece of memory. Maybe mtd is overkill in term
> of the operations supported, but from a high-level perspective an
> eeprom is a memory technology device, right?

Everything is a memory device in the end :)

Feel free to send patches, but I don't think this is really a big deal
that deserves this type of change at the moment.  Feel free to prove me
wrong though.

greg k-h
