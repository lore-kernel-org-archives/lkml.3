Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3IWAee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 20:34:34 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:48518 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3IWAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 20:34:33 -0400
MIME-Version: 1.0
X-Originating-IP: [99.22.209.41]
Date: Sun, 22 Sep 2013 19:34:31 -0500
Message-ID: <CAC24_3tuw2Ejcg_TLB0kd2XumhS8UDdBd_3YAmY9hh0G8y9kKQ@mail.gmail.com>
Subject: xpad input driver: Xbox 360 Wireless Adapter
From: Zachary Lund <admin@computerquip.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm apologize ahead of time if this thread isn't appropriate, I'm not
very familiar with mailing lists, especially lkml. I'm also very new
to kernel/module development (as of literally yesterday).

I was looking into getting the LED working properly for the Xbox 360
controllers and learning about the basics of a kernel module at the
same time. There were a few things that confused me. I will reference
functions by name and all functions are from the current 3.12 branch.

First, xpad_send_led_command seems to be geared only towards the
"Microsoft X-Box 360 pad". Using xboxdrv as a reference, they use a
completely different packet structure to set the LED status on the
wireless controller which can be seen here:
https://github.com/Grumbel/xboxdrv/blob/master/src/controller/xbox360_wireless_controller.cpp#L66

Second, the driver acts strangely when setting the LED. It calls
xpad_send_led_command during xpad_led_probe during xpad_probe but
there's a chance that a controller might not even be connected if
using the wireless adapter during that time! The only way to seemingly
tell if a controller is connected is by receiving the correct
connection packets. If I use the correct packet structure (which I
ripped almost directly from xboxdrv) and set the led after parsing a
connection packet, the LED seemingly works fine!

Third, I'm incredibly new to really low level development. Whenever
loading the module, it finds my wireless adapter but then creates 4
devices (which seems to mean only 4 controllers are allowed per
wireless adapter), each of which cause a call to xpad_probe. I
couldn't figure out how to tell if other wireless controllers were
already connected to the wireless adapter so I could light up the
correct LED. How would I go about this properly?

Any feedback would be awesome.
