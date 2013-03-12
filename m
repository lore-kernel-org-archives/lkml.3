Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3CLXfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:35:03 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:47510 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3CLXfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130312231054.GA6379@kroah.com>
References: <1363129342-24310-1-git-send-email-ynvich@gmail.com>
	<20130312231054.GA6379@kroah.com>
Date: Wed, 13 Mar 2013 03:34:59 +0400
Message-ID: <CAL0eWdGYvdun=ChQ5gra67cBEgLFrzQ9dBGHL3ubAHOdww4FrQ@mail.gmail.com>
Subject: Re: [PATCH] allow alternative name for PXA serial console
From: =?UTF-8?B?0KHQtdGA0LPQtdC5INCv0L3QvtCy0LjRhw==?= <ynvich@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 March 2013 03:10, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 13, 2013 at 03:02:22AM +0400, Sergey Yanovich wrote:
>> +config SERIAL_PXA_TTYSA_NAME
>> +     bool "as /dev/ttySA[0-3]"
>
> Does that config text really make sense?  What does it look like when
> you run "make oldconfig"?

--------------------
* Non-8250 serial port support
*
PXA serial port support (SERIAL_PXA) [Y/n/?] y
  Console on PXA serial port (SERIAL_PXA_CONSOLE) [Y/n/?] y
  as /dev/ttySA[0-3] (SERIAL_PXA_TTYSA_NAME) [N/y/?] (NEW)
---------------------

So the kernel will have PXA serial port, a console on it, and it will
have a name (and numbers) /dev/ttySA0 to /dev/ttySA3.

>> ICP DAS LP-8x4x is an industrial data acquision device. It is based
>> on PXA270 CPU. The board containsi a lot of (up to 36) standard UARTi
>> 8250i serial ports. System console on the board is provided with
>> an on-chip PXA serial port. Both modules use /dev/ttyS0 by default.
>>
>> To solve the collision, PXA ports could be configured with different
>> name and device numbers.

> Ugh, why does it matter what it is named?
>
> Use udev, or a tool like it, to rename serial ports if you really need
> it, don't do this in the kernel please.

It doesn't matter what it is named. It matters that both drivers try
to use the same major device number. I have to change major device
number for PXA tty, as a result I need a different name in /dev

Maybe I am missing something obvious, but it seems that such a
collision is a kernel bug. Someone assumed that PXA cannot have a 8250
tty device and used 8250's parameters in PXA tty driver.
