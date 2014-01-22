Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaAVNZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:25:42 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47998 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaAVNZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:25:41 -0500
MIME-Version: 1.0
Date: Wed, 22 Jan 2014 13:25:40 +0000
X-Google-Sender-Auth: 8Sg4ySJS-Y57hZ21eBRejf_QuII
Message-ID: <CAOMwXhMvefuQJPZ_sbzySmvcyqkR+Lfh-11Gx3unGqyR2pREww@mail.gmail.com>
Subject: Re: [RFC] Creating an eeprom class
From: Laszlo Papp <lpapp@kde.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: patrickdepinguin@gmail.com, gregkh@linuxfoundation.org,
        linux-i2c@vget.kernel.org, curt@cumulusnetworks.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jan 20, 2013 at 07:08:28PM +0100, Thomas De Schampheleire wrote:
>> [plaintext and fixed address of David Brownell]
>
> David passed away a year or so ago, so that's really not going to help :(
>
>> Hi,
>>
>> Several of the eeprom drivers that live in drivers/misc/eeprom export
>> a binary sysfs file 'eeprom'. If a userspace program or script wants
>> to access this file, it needs to know the full path, for example:
>>
>> /sys/bus/spi/devices/spi32766.0/eeprom
>>
>> The problem with this approach is that it requires knowledge about the
>> hardware configuration: is the eeprom on the SPI bus, the I2C bus, or
>> maybe memory mapped?
>>
>> It would therefore be more interesting to have a bus-agnostic way to
>> access this eeprom file, for example:
>> /sys/class/eeprom/eeprom0/eeprom
>>
>> Maybe it'd be even better to use a more generic class name than
>> 'eeprom', since there are several types of eeprom-like devices that
>> you could export this way.
>
> Does all of the existing "eeprom" devices use the same userspace
> interface?  If so, yes, having a "class" would make sense.

Was there any progress done? I saw the following thread, too, so
including CC in the loop:
http://www.spinics.net/lists/linux-i2c/msg13141.html

Needless to say that I am writing this email because I would also be
interested in a handy and convenient class interface - as opposed to
the raw bus specific path -, similarly to hwmon, gpio, leds, etc.

I could probably even try to volunteer, with very limited resources
admittedly, to get some driver done for our EEPROM if that is needed.
