Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3A1M3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:29:23 -0500
Received: from antcom.de ([188.40.178.216]:40045 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330Ab3A1M3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:29:20 -0500
Message-ID: <51066F1B.9010102@antcom.de>
Date: Mon, 28 Jan 2013 13:29:15 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Stijn Devriendt <highguy@gmail.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Subject: Re: [PATCH 5/6 v14] gpio: Add device tree support to block GPIO API
References: <1358856404-8975-1-git-send-email-stigge@antcom.de> <1358856404-8975-6-git-send-email-stigge@antcom.de> <CAOY=C6E-+uKQGbRDjNh5ZP9Wrmd+PNbt7djkBTzwe29=qA1_PA@mail.gmail.com> <510539C5.8000208@antcom.de> <CAOY=C6HTRFY=rXOAhTwuR3NvtaRFbfbkkpn7FeyK+eqG7sVcKg@mail.gmail.com>
In-Reply-To: <CAOY=C6HTRFY=rXOAhTwuR3NvtaRFbfbkkpn7FeyK+eqG7sVcKg@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 12:39 PM, Stijn Devriendt wrote:
>>> In the device-tree this is specified as:
>>>
>>> powr@0x20 {
>>>    // other properties
>>>
>>>   gpios = <&gpio 4 0
>>>                &gpio 5 0>;
>>> };
>>>
>>> Is this kind of integration also possible?
>>
>> You can reference the gpio block via a phandle, e.g.:
>>
>>         blockgpio {
>>                 compatible = "linux,gpio-block";
>>
>>                 selector1 {
>>                         gpios = <&gpio 4 0>,
>>                                 <&gpio 5 0>;
>>                 };
>>         };
>>
>>         powr@0x20 {
>>                 // ...
>>
>>                 gpios = <&selector1>;
>>         };
>>
>>
>> In the driver, you can get the gpio block like this:
>>
>> block = gpio_block_find_by_name(of_parse_phandle(powr, "gpios", 0)->name);
>>
>> (Simplified by removed error/NULL handling!)
>>
>> If this turns out to be a common pattern, I can add a convenience "get"
>> function for this.
> 
> Given the pick-up of device-tree in ARM and MIPS, I think this stands
> a good chance
> of becoming a common pattern. Do mind the "gpios" name; it's already used by the
> normal GPIO request functions...

Right, when providing the respective convenience function, I'll better
use sth. like "gpioblock" as property name.

Specifying a traditional list of GPIOs instead is easy, actually. The
respective driver just needs to allocate a gpio block explicitly
(insteady of implicitly via phandle as above). Unfortunately, gpio
blocks that should be exported and available to userspace can't be
specified this way. Therefore the strategy as above.

Roland
