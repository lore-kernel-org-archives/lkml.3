Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3ATWjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:39:14 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59170 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3ATWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:39:13 -0500
Date: Sun, 20 Jan 2013 14:39:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Anatolij Gustschin <agust@denx.de>, Frodo Looijaard <frodol@dds.nl>,
        Philip Edelbrock <phil@netroedge.com>,
        Ben Gardner <bgardner@wabtec.com>, Ronny Meeus <Ronny.Meeus@gmail.com>
Subject: Re: [RFC] Creating an eeprom class
Message-ID: <20130120223907.GA8424@kroah.com>
References: <CAAXf6LXkgLiBLFmwH_GR9hkjFgOJ5z1nSTQd9Q4pJud732Lb9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAXf6LXkgLiBLFmwH_GR9hkjFgOJ5z1nSTQd9Q4pJud732Lb9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 07:08:28PM +0100, Thomas De Schampheleire wrote:
> [plaintext and fixed address of David Brownell]

David passed away a year or so ago, so that's really not going to help :(

> Hi,
> 
> Several of the eeprom drivers that live in drivers/misc/eeprom export
> a binary sysfs file 'eeprom'. If a userspace program or script wants
> to access this file, it needs to know the full path, for example:
> 
> /sys/bus/spi/devices/spi32766.0/eeprom
> 
> The problem with this approach is that it requires knowledge about the
> hardware configuration: is the eeprom on the SPI bus, the I2C bus, or
> maybe memory mapped?
> 
> It would therefore be more interesting to have a bus-agnostic way to
> access this eeprom file, for example:
> /sys/class/eeprom/eeprom0/eeprom
> 
> Maybe it'd be even better to use a more generic class name than
> 'eeprom', since there are several types of eeprom-like devices that
> you could export this way.

Does all of the existing "eeprom" devices use the same userspace
interface?  If so, yes, having a "class" would make sense.

> Or should we rather hook the eeprom code into the mtd subsystem?

Why mtd?

thanks,

greg k-h
