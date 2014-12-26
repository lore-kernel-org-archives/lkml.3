Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaLZUxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 15:53:06 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48240 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaLZUxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 15:53:02 -0500
MIME-Version: 1.0
In-Reply-To: <20141226203340.GA1791@amd>
References: <20141203214641.GA1390@amd> <20141224223434.GA20669@amd>
 <CAL_JsqJsDqYm-xfEM1CqNzJxfZY6vnYxaBYpT+3t4+gV2F3M1A@mail.gmail.com> <20141226203340.GA1791@amd>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 26 Dec 2014 14:52:40 -0600
Message-ID: <CAL_JsqJ4tsRfvb1XrGmwBJaFUGwMVGTjNp1mBykFBJDJF1uHbA@mail.gmail.com>
Subject: Re: [PATCHv2] media: i2c/adp1653: devicetree support for adp1653
To: Pavel Machek <pavel@ucw.cz>
Cc: Bryan Wu <cooloney@gmail.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>, freemangordon@abv.bg,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>, sakari.ailus@iki.fi,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 2:33 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > We are moving to device tree support on OMAP3, but that currently
>> > breaks ADP1653 driver. This adds device tree support, plus required
>> > documentation.
>> >
>> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>> >
>> > ---
>> >
>> > Changed -microsec to -us, as requested by devicetree people.
>> >
>> > Fixed checkpatch issues.
>> >
>> > diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
>> > index 2d88816..2c6c7c5 100644
>> > --- a/Documentation/devicetree/bindings/leds/common.txt
>> > +++ b/Documentation/devicetree/bindings/leds/common.txt
>> > @@ -14,6 +14,15 @@ Optional properties for child nodes:
>> >       "ide-disk" - LED indicates disk activity
>> >       "timer" - LED flashes at a fixed, configurable rate
>> >
>> > +- max-microamp : maximum intensity in microamperes of the LED
>> > +                (torch LED for flash devices)
>> > +- flash-max-microamp : maximum intensity in microamperes of the
>> > +                       flash LED; it is mandatory if the LED should
>> > +                      support the flash mode
>> > +- flash-timeout-microsec : timeout in microseconds after which the flash
>> > +                           LED is turned off
>>
>> Doesn't all this go in your flash led binding patch?
>
> No, I should not have included this part.
>
>> > +Example:
>> > +
>> > +        adp1653: led-controller@30 {
>> > +                compatible = "adi,adp1653";
>> > +               reg = <0x30>;
>> > +                gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* 88 */
>> > +
>> > +               flash {
>> > +                        flash-timeout-us = <500000>;
>> > +                        flash-max-microamp = <320000>;
>> > +                        max-microamp = <50000>;
>> > +               };
>> > +                indicator {
>>
>> These are different LEDs or different modes?
>
> flash & indicator are different LEDs. One is white, one is red. Flash
> can be used as a flash and as a torch.
>
>> > +                        max-microamp = <17500>;
>>
>> This is a bit inconsistent. The binding says this is for flash LEDs
>> torch mode, but I see no reason why it can't be common. Can you update
>> the binding doc to be clear here.
>
> By inconsisnent, you mean you want patch below?

Yes.

>> Also, aren't you missing label properties?
>
> label is optional, and as my driver does not yet use it, I forgot
> about it.

Based on your node names, there are obviously user defined functions
for them already. So they should have labels whether or not the driver
uses them.

Rob

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> index 2c6c7c5..92d4dac 100644
> --- a/Documentation/devicetree/bindings/leds/common.txt
> +++ b/Documentation/devicetree/bindings/leds/common.txt
> @@ -15,7 +15,6 @@ Optional properties for child nodes:
>       "timer" - LED flashes at a fixed, configurable rate
>
>  - max-microamp : maximum intensity in microamperes of the LED
> -                (torch LED for flash devices)
>  - flash-max-microamp : maximum intensity in microamperes of the
>                         flash LED; it is mandatory if the LED should
>                        support the flash mode
>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
