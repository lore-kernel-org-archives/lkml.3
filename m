Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaA3WGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:06:01 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:61017 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaA3WF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:05:58 -0500
MIME-Version: 1.0
In-Reply-To: <20140130213232.GC26861@pengutronix.de>
References: <1386364179-28650-1-git-send-email-delicious.quinoa@gmail.com>
	<CANk1AXS=CADN53aO5KVN3UorddJ0wZ2PTqwo2XmeRuxYe_DoLg@mail.gmail.com>
	<20131212090838.GD25478@pengutronix.de>
	<CANk1AXRxTGRMJMvXe4jgG2GfuELsDTNJnRLXK-MGe3gGxinmLA@mail.gmail.com>
	<20140130205000.GB26861@pengutronix.de>
	<CANk1AXS9fbNafLxiUz8OoPVUtwPDhHhYx7+MGi_JyDdG6J9F-Q@mail.gmail.com>
	<20140130213232.GC26861@pengutronix.de>
Date: Thu, 30 Jan 2014 16:05:56 -0600
Message-ID: <CANk1AXQHY2cMf4vTyj1EJs1Dz_C69ppJU9xCX58CUO122y84Hw@mail.gmail.com>
Subject: Re: [PATCH v9] gpio: add a driver for Synopsys DesignWare APB GPIO
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 3:32 PM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
> On Thu, Jan 30, 2014 at 03:15:11PM -0600, delicious quinoa wrote:
>> On Thu, Jan 30, 2014 at 2:50 PM, Steffen Trumtrar
>> <s.trumtrar@pengutronix.de> wrote:
>> > Hi!
>> >
>> > On Thu, Jan 30, 2014 at 01:40:04PM -0600, delicious quinoa wrote:
>> >> On Thu, Dec 12, 2013 at 3:08 AM, Steffen Trumtrar
>> >> <s.trumtrar@pengutronix.de> wrote:
>> >>
>> >> > Second: The interrupt is registered as "GIC 37", which is a real interrupt on
>> >> > the Socfpga. I would expect it to be marked as "GPIO 2xx" (or something in that
>> >> > range). The interrupt from the gpiochip itself isn't registered at all ?!
>> >>
>> >> Hi Stephen,
>> >>
>> >> Did you export the gpio lines and set the edge in sysfs?  Because the
>> >> interrupts aren't allocated otherwise.
>> >>
>> >> For instance:
>> >>
>> >> root@socfpga_cyclone5:~# echo 195 > /sys/class/gpio/export
>> >> root@socfpga_cyclone5:~# echo rising > /sys/class/gpio/gpio195/edge
>> >>
>> >> Now I can see a pretty nicely named interrupt in /proc/interrupts:
>> >>
>> >> 256:          0          0  gpio-dwapb  24  gpiolib
>> >>
>> >
>> > I didn't try that and I think this behaviour is pretty uncommon.
>> > This should be fixed in the driver. I never wrote a gpiochip-driver,
>> > so I don't know what is missing, but maybe just some functioncall ?!
>> > All other drivers I came across have that entry from probing without
>> > any fiddling.
>>
>> Hi Steffen,
>>
>> Do you mean 'all other gpio drivers' or 'all other non-gpio drivers'?
>
> I meant gpio drivers (at least the ones I have used).
>
>>
>> This is the behavior that is implemented in the community gpio
>> framework drivers/gpio/gpiolib.c, not anything special implemented in
>> this dw gpio driver.
>>
>> It's documented in Documentation/gpio/sysfs.txt and
>> Documentation/ABI/testing/sysfs-gpio.
>>
>> You get userspace control of a gpio by 'export'ing it in sysfs.  And
>> then by default, the interrupt edge is set to 'none' (no irq) until
>> you set the edge in sysfs.
>>
>
> Hm, okay...for GPIOs I'm with you. But when I specify a gpio as
> interrupt for a device, I have to first export it manually before I can
> use the device? Sounds weird.
>
> Steffen

Seems normal usage both in userspace and in kernel drivers that need a gpio.

Looking at other kernel drivers that use a gpio, I can see examples
that do gpio_request() to get the gpio that they care about.  Then
gpio_to_irq() and request_irq().  If you grep for 'gpio_to_irq' then
look to see how they got the gpio, you'll see it pretty quickly.

Alan
