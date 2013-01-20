Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3ATSIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 13:08:31 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:47875 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3ATSI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 13:08:29 -0500
MIME-Version: 1.0
Date: Sun, 20 Jan 2013 19:08:28 +0100
Message-ID: <CAAXf6LXkgLiBLFmwH_GR9hkjFgOJ5z1nSTQd9Q4pJud732Lb9Q@mail.gmail.com>
Subject: [RFC] Creating an eeprom class
From: Thomas De Schampheleire <patrickdepinguin@gmail.com>
To: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Anatolij Gustschin <agust@denx.de>, Frodo Looijaard <frodol@dds.nl>,
        Philip Edelbrock <phil@netroedge.com>,
        Greg Kroah-Hartman <greg@kroah.com>, Ben Gardner <bgardner@wabtec.com>
Cc: Ronny Meeus <Ronny.Meeus@gmail.com>,
        Thomas De Schampheleire <patrickdepinguin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[plaintext and fixed address of David Brownell]

Hi,

Several of the eeprom drivers that live in drivers/misc/eeprom export
a binary sysfs file 'eeprom'. If a userspace program or script wants
to access this file, it needs to know the full path, for example:

/sys/bus/spi/devices/spi32766.0/eeprom

The problem with this approach is that it requires knowledge about the
hardware configuration: is the eeprom on the SPI bus, the I2C bus, or
maybe memory mapped?

It would therefore be more interesting to have a bus-agnostic way to
access this eeprom file, for example:
/sys/class/eeprom/eeprom0/eeprom

Maybe it'd be even better to use a more generic class name than
'eeprom', since there are several types of eeprom-like devices that
you could export this way.

Or should we rather hook the eeprom code into the mtd subsystem?

What is your opinion?

Thanks,
Thomas
