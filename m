Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaDHCxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:53:54 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:38875 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaDHCxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 22:53:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140407200022.GA20023@earth.universe>
References: <1396736821-14395-1-git-send-email-sre@kernel.org>
	<1396736821-14395-2-git-send-email-sre@kernel.org>
	<CAL_Jsq+46bPtgnQc5aAN8bcaw=te6MX=cvMMNP6+6xjG8Drkbg@mail.gmail.com>
	<20140407200022.GA20023@earth.universe>
Date: Mon, 7 Apr 2014 21:53:48 -0500
Message-ID: <CAL_Jsq+K7mJ_=Hv0gH+h0HK7BKeXz9F6vSdi6DFyfayePbohNg@mail.gmail.com>
Subject: Re: [PATCHv2 1/5] Input: add common DT binding for touchscreens
From: Rob Herring <robherring2@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 3:00 PM, Sebastian Reichel <sre@kernel.org> wrote:
> On Mon, Apr 07, 2014 at 11:38:01AM -0500, Rob Herring wrote:
>> On Sat, Apr 5, 2014 at 5:26 PM, Sebastian Reichel <sre@kernel.org> wrote:
>> > Add common DT binding documentation for touchscreen devices and
>> > implement input_parse_touchscreen_of_params, which parses the common
>> > properties and configures the input device accordingly.
>>
>> Good.
>>
>> [...]
>> > +Optional properties for Touchscreens:
>> > + - touchscreen-size-x          : horizontal resolution of touchscreen
>> > + - touchscreen-size-y          : vertical resolution of touchscreen
>>
>> While I like the consistency, x-size and y-size are already commonly
>> used. Perhaps the common binding should have both and x-size/y-size be
>> marked deprecated.
>
> So you want me to add something like the following?
>
> - x-size : deprecated name for touchscreen-size-x
> - y-size : deprecated name for touchscreen-size-y

Yes.

>
>> > + - touchscreen-max-pressure    : maximum reported pressure
>> > + - touchscreen-fuzz-x          : horizontal noise value of the absolute input device
>> > + - touchscreen-fuzz-y          : vertical noise value of the absolute input device
>> > + - touchscreen-fuzz-pressure   : pressure noise value of the absolute input device
>>
>> What are the units or are they just an arbitrary range dependent on
>> the controller? Several existing bindings appear to be in pixels, but
>> that seems wrong to me.
>
> x/y related properties: pixels
> pressure related properties: arbitrary range dependent on the controller

Please make this clear in the binding description.

>> There's also these various properties that should have common versions created:
>>
>> ti,x-plate-resistance and ti,x-plate-ohms (tsc2007)
>
> I think this is ti specific. But I should probably name the tsc2005
> property "ti,x-plate-ohms", so that its in sync with tsc2007.
>
>> - rohm,flip-x             : Flip touch coordinates on the X axis
>> - rohm,flip-y             : Flip touch coordinates on the Y axis
>> - x-invert: invert X axis
>> - y-invert: invert Y axis
>
> like this?
>
> - touchscreen-inverted-x: X axis is inverted
> - touchscreen-inverted-y: Y axis is inverted
> - x-invert: deprecated name for touchscreen-inverted-x
> - y-invert: deprecated name for touchscreen-inverted-y
>
> Inverting is currently not supported by the input system, though. So
> adding support for it to input_parse_touchscreen_of_params() is not
> trivial :/

Does not matter. I'm only asking you to define the property. Linux
does not have to use it currently.

>> - contact-threshold:
>> - moving-threshold:
>
> I think those are hardware specific. The properties are currently
> used by one driver, which writes them directly into some registers.
> The DT binding does not give more information about them.

moving-threshold is probably the same as fuzz. contact-threshold is
sounds like min pressure. I remember having to tune the minimum
pressure on a touchscreen I worked on long ago. So think think is
definitely not an uncommon property.

Rob
