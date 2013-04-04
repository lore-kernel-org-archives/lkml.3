Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762424Ab3DDBo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 21:44:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:52065 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761107Ab3DDBoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 21:44:55 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: GPS driver for Linux - kernel or user-space driver?
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20130404011915.GA20339@kroah.com>
Date: Wed, 3 Apr 2013 18:44:51 -0700
Cc: Tim Bird <tim.bird@am.sony.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A000CE96-F47C-4E59-B0B1-74295779A13B@holtmann.org>
References: <515CCEB3.4020309@am.sony.com> <20130404010604.GC19599@kroah.com> <52ACDBA8-BAEC-4687-94D7-586F494A7373@holtmann.org> <20130404011915.GA20339@kroah.com>
To: Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>>>> I've been approached by a developer at Sony who wants to publish an
>>>> open source driver for a Sony GPS receiver module.
>>> 
>>> What does the device look like?  USB device?  UART?  Something else?
>>> 
>>>> I've looked in the kernel source, and only see one standalone GPS
>>>> driver, for Garmin.  It appears that most GPS support in Linux is done
>>>> via user-space drivers.  Many GPS hardware modules appear to be
>>>> accessed via a serial line, or USB/serial port.  The Sony
>>>> module is pretty much the same, accepting commands and delivering
>>>> data via a uart from the chip.
>>>> 
>>>> I planning to recommend writing a user-space driver (based on
>>>> gpsd and/or the Android GPS HAL specification).  But I'm worried
>>>> I'm missing something.  Is this the correct approach, or is there
>>>> an established kernel API for GPS modules - such that I should
>>>> recommend that this developer writes a kernel module instead
>>>> of, or in addition to, the user-space support for the hardware?
>>> 
>>> If it's just a uart-like device, just write a serial driver and drive it
>>> from gpsd.  That way seems to be the simplest and then the kernel just
>>> becomes a dumb-pipe, which is fine.
>> 
>> the one thing that still bugs me is that detecting an UART with GPS
>> functionality behind it is extremely bad experience. If we could get
>> something like DEVTYPE=gps support for the TTY layer, that would be
>> helpful.
> 
> I would love that, but there's tons of USB gps devices that we don't
> know if they are a USB serial device, or a GPS device as the device id
> is the same (companies just embed a usb to serial chip in their
> devices.)
> 
> So, someone has to guess, right now it's userspace.
> 
> Unless you have a better idea?

we could at least try to fix the good ones where we have proper vendor and product IDs dedicated for these devices. Or where things can be labeled through device tree or some similar methods. The less guess work userspace has to do, the smooth the experience will be.

Regards

Marcel

