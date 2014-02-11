Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaBKJe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:34:27 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:38765 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBKJeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:34:21 -0500
MIME-Version: 1.0
In-Reply-To: <1392038191.6687.12.camel@pizza.hi.pengutronix.de>
References: <20140210125432.10683.86571.stgit@localhost> <1392038191.6687.12.camel@pizza.hi.pengutronix.de>
From: "Fuzzey, Martin" <mfuzzey@parkeon.com>
Date: Tue, 11 Feb 2014 10:34:00 +0100
Message-ID: <CANh8QzwERe-zxCaAd4QujZJ4zcZ7SchK+w8u52fvJj0s5tx2nA@mail.gmail.com>
Subject: Re: [PATCH] reset: Add generic GPIO reset driver.
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 10 February 2014 14:16, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Martin,
>
> Am Montag, den 10.02.2014, 13:54 +0100 schrieb Martin Fuzzey:
>> This driver allows GPIO lines to be used as reset signals.
>> It has two main use cases:
>>
>> 1) Allow drivers to reset their hardware via a GPIO line in a standard fashion
>> as supplied by the reset framework.
>> This allows adhoc driver code requesting GPIOs etc to be replaced with a
>> single call to device_reset().
>
> have you seen the patch at https://lkml.org/lkml/2014/1/8/190:
> "reset: Add GPIO support to reset controller framework" ?
>

Ah no missed that.

> Adding a GPIO reset controller device node to the device tree is the
> wrong approach for devices enumerated in the device tree. Those should
> just declare their reset-gpios directly.
>

Oh well if that was the conclusion.
My use case is 2) anyway - just thought it would be sensible to
implement a reset controller too.
As that simplifies the driver code and makes gpio / vs more complex
reset controller (FPGA, ..) a pure DT change.

I do get the point about having to continue to support the old way
anyway though.


>> 2) Allow hardware on discoverable busses to be rest via a GPIO line
>> without driver modifications.
>>
>> Examples of the second use case include:
>> * SDIO wifi modules
>> * USB hub chips with a reset line
>
> Now this is interesting. But if you export it to userspace anyway, why
> not use the existing gpio sysfs API?
>

In the normal case of reset on boot the userspace interface isn't needed.
Setting the "auto" dt property will make the kernel do the reset by
itself during
early boot. This is the standard use case.

The userspace interface is to let applications deal with special cases.
It is also simpler for userspace than manlually toggling the GPIO line
and keeps the configuration (active high / low, delay) centralised in
the DT and consistent between the automatic on boot reset and the
manually triggered reset.


> I think a proper solution should handle this in the kernel. For SDIO
> wifi modules you usually have a powerdown line that can be implemented
> as an rfkill switch.
>

I think this is too specific. It's not just for SDIO wifi. We also
have the problem
of a USB hub needing to be reset.

Also even for the SDIO wifi case rfkill doesn't ssem the right
abstraction to say "reset me"
(particularly when firmware fails to load on warm boot if you don't).

cheers,

Martin
