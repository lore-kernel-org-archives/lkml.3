Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3C0PX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:23:27 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:59480 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3C0PXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <201303271235.32346.poeschel@lemonage.de>
References: <1362414873-17676-1-git-send-email-larsi@wh2.tu-dresden.de>
	<CACRpkdYYsULLsDQuxoRHp=HXsaOAejwaO-CezdEK4sNprWpDYQ@mail.gmail.com>
	<201303271235.32346.poeschel@lemonage.de>
Date: Wed, 27 Mar 2013 16:23:25 +0100
Message-ID: <CACRpkdZue4QjQ+SS_go8i_LJZm7RJPFQr6sDcNaCp3FhkUrseQ@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: mcp23s08: convert driver to DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Peter Korsgaard <jacmet@sunsite.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:35 PM, Lars Poeschel <poeschel@lemonage.de> wrote:
> On Friday 22 March 2013 at 09:33:10, Linus Walleij wrote:

>> I would currently feel a lot better if you did not include this
>> flag. How would you control this the day drivers need to
>> enable/disable pull-up at runtime?
>
> For me it would also be easier to remove the flag (for DT boot case). I don't
> need the pullups. I did only include it, because this is how the driver is
> designed to work and what it did already. What I wanted was to make a good
> transfer from what the features of the driver are and how it works to be able
> to use it with device tree. If it now turns out that's bad for some reason, I
> have no problem to remove this from the patch completely.
> You're right: Runtime config is not possible this way.
> What should I do now ? Remove it ?

Remove. The less complicated binding, the better.

>> > +- gpio-controller : Marks the device node as a GPIO controller.
>> > +- reg : For an address on its bus
>>
>> On the I2C/SPI bus?
>
> Yes, both. For I2C it's the I2C address, for SPI it's the chip select to use
> for this chip.

OK please write these specifics in the binding doc.

>> Please state here what kind of buses it can be. Explain if multiple
>> buses are supported.
>
> Ok, I will add a line about it.

Thx.

>> > +Required device specific properties (only for SPI chips):
>> > +- mcp,spi-present-mask : This is a present flag, that makes only sense
>> > for SPI +        chips - as the name suggests.
>>
>> AFAIK this is not how we disable/enable devices in the device tree.
>>
>> Istead we include a property on the node called "status" and set it
>> to "disabled" if the device is not there.
>
> This would require multiple instances with the same reg property as up to 8
> chips can live on the same chip select. I wonder if this is possible ?

If there is not one instance/device node per chip things are
very wrong anyway. Maybe I don't understand fully... each
device on the system should have a node, you can't have a node
spanning several devices unless it's a bus node.

> Grant had the idea with the bitfield. You have the reg property specifying
> the chip select line. This bitfield is then used to indicate which of the 8
> possible chips on this same chip select line is really present. Not beeing
> able to support more than 8 devices is not problem, because it is a hardware
> limitation, that not more than 8 devices can share the same SPI chip select.
> This is again how the driver worked so far.
>
>> What about just using a number?
>
> This would again require multiple instances with the same reg property for
> SPI. Is this really possible ?

If Grant is OK with this then so am I, he surely know this better
than me. But you nee to trick him to come out and review it.

Yours,
Linus Walleij
