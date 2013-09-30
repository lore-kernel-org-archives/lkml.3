Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3I3Sto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:49:44 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44050 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3I3Stm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAC24_3tuw2Ejcg_TLB0kd2XumhS8UDdBd_3YAmY9hh0G8y9kKQ@mail.gmail.com>
References: <CAC24_3tuw2Ejcg_TLB0kd2XumhS8UDdBd_3YAmY9hh0G8y9kKQ@mail.gmail.com>
Date: Mon, 30 Sep 2013 20:49:42 +0200
Message-ID: <CANq1E4QhpY1TdE2sXhwpY4RAHErAJs_Pek4-EKoRXCeGh_0j6A@mail.gmail.com>
Subject: Re: xpad input driver: Xbox 360 Wireless Adapter
From: David Herrmann <dh.herrmann@gmail.com>
To: Zachary Lund <admin@computerquip.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Marko Friedemann <mfr@bmx-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm not very familiar with the xbox-gamepad driver, but please see
below for some comments:

On Mon, Sep 23, 2013 at 2:34 AM, Zachary Lund <admin@computerquip.com> wrote:
> I'm apologize ahead of time if this thread isn't appropriate, I'm not
> very familiar with mailing lists, especially lkml. I'm also very new
> to kernel/module development (as of literally yesterday).

Input-drivers are discussed on <linux-input@vger.kernel.org> (now
CC'ed). I recommend subscribing to that list. I also put some driver
developers on CC as they are probably more qualified to answer your
questions.

Note that LKML is a high-traffic list mostly used in CC. Please always
CC the driver authors or maintainers.

> I was looking into getting the LED working properly for the Xbox 360
> controllers and learning about the basics of a kernel module at the
> same time. There were a few things that confused me. I will reference
> functions by name and all functions are from the current 3.12 branch.

It might be useful to mention the driver in question (it's
drivers/input/joystick/xpad.c I guess?).

> First, xpad_send_led_command seems to be geared only towards the
> "Microsoft X-Box 360 pad". Using xboxdrv as a reference, they use a
> completely different packet structure to set the LED status on the
> wireless controller which can be seen here:
> https://github.com/Grumbel/xboxdrv/blob/master/src/controller/xbox360_wireless_controller.cpp#L66

I don't think the kernel driver supports wireless pads, so it might
have a different "wireless optimized" wire-protocol. The driver is
USB-only, isn't it?

> Second, the driver acts strangely when setting the LED. It calls
> xpad_send_led_command during xpad_led_probe during xpad_probe but
> there's a chance that a controller might not even be connected if
> using the wireless adapter during that time!

What? During xpad_probe() a device must be fully functional. What
adapter are your talking about?

> The only way to seemingly
> tell if a controller is connected is by receiving the correct
> connection packets. If I use the correct packet structure (which I
> ripped almost directly from xboxdrv) and set the led after parsing a
> connection packet, the LED seemingly works fine!

Sounds reasonable. Do all devices send the connection-packets? If yes,
feel free to send a patch which moves LED initialization after receipt
of this package.

> Third, I'm incredibly new to really low level development. Whenever
> loading the module, it finds my wireless adapter but then creates 4
> devices (which seems to mean only 4 controllers are allowed per
> wireless adapter), each of which cause a call to xpad_probe. I
> couldn't figure out how to tell if other wireless controllers were
> already connected to the wireless adapter so I could light up the
> correct LED. How would I go about this properly?

Ugh? Sorry, but I don't understand what kind of wireless adapter this
is? Please give us a bit more information here. If the device is a
Bluetooth-device, why use an adapter at all?

Cheers
David
