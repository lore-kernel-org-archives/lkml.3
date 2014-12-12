Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326AbaLLIh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:37:27 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:58699 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbaLLIhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:37:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141210225006.GA13407@ti.com>
References: <1417726922-10376-1-git-send-email-bparrot@ti.com>
 <1417726922-10376-3-git-send-email-bparrot@ti.com> <CAAVeFuJHwGqXSgCu-FstUr32UZJaKjSBAUkfySkQVFqUhV75JQ@mail.gmail.com>
 <20141210225006.GA13407@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 12 Dec 2014 17:37:03 +0900
Message-ID: <CAAVeFuKR24LjLWPnFkX88b-x-aYoqCQoZHuneUtxHNp3T7=vjA@mail.gmail.com>
Subject: Re: [Patch v3 2/2] gpio: Document GPIO hogging mechanism
To: Benoit Parrot <bparrot@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 7:50 AM, Benoit Parrot <bparrot@ti.com> wrote:
> Alexandre Courbot <gnurou@gmail.com> wrote on Wed [2014-Dec-10 19:56:17 +0900]:
>> On Fri, Dec 5, 2014 at 6:02 AM, Benoit Parrot <bparrot@ti.com> wrote:
>> > Add GPIO hogging documentation to gpio.txt
>> >
>> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> > ---
>> > Changes since v2:
>> >  * Updated to the latest hog syntax.
>> >
>> > Changes since v1:
>> >  * Split the devicetree bindings documentation in its own patch.
>> >
>> >  Documentation/devicetree/bindings/gpio/gpio.txt | 23 +++++++++++++++++++++++
>> >  1 file changed, 23 insertions(+)
>> >
>> > diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
>> > index 3fb8f53..6d88133 100644
>> > --- a/Documentation/devicetree/bindings/gpio/gpio.txt
>> > +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
>> > @@ -103,6 +103,22 @@ Every GPIO controller node must contain both an empty "gpio-controller"
>> >  property, and a #gpio-cells integer property, which indicates the number of
>> >  cells in a gpio-specifier.
>> >
>> > +The GPIO chip may contain GPIO hog definitions. GPIO hogging is a mechanism
>> > +providing automatic GPIO request and configuration as part of the
>> > +gpio-controller's driver probe function.
>> > +
>> > +Each GPIO hog definition is represented as a child node of the GPIO controller.
>> > +Required properties:
>> > +- gpio-hog:  A property specifying that this child node represent a gpio-hog.
>> > +- gpios:     Store the gpio information (id, flags, ...). Shall contain the
>> > +            number of cells specified in its parent node (GPIO controller
>> > +            node).
>>
>> Since this property will only describe one GPIO, why use the plural
>> form? Would it not be confusing?
>
> I would tend to agree in this case but based on this original comment from Linus on this thread:

Ok, good for me then.

>
> http://marc.info/?l=linux-gpio&m=138917388625221&w=2
> where on 08/01/2014 10:37, Linus Walleij wrote:
>
>   > +Each GPIO hog definition is represented as a child node of the GPIO controller.
>   > +Required properties:
>   > +- gpio: store the gpio informations (id, flags, ...). Shall contain the
>   > +  number of cells specified in its parent node (GPIO controller node).
>
>   This property is alway plural "gpios".
>
> As long as everyone agree, I am fine with it.
>
>>
>> > +- direction: A property specifying the direction/value needed. This property
>> > +            can take the folowing values: input, output-high, output-low.
>>
>> nit: since this property not only describes the direction but also the
>> (potential) value, I suggest to rename it to "state".
>
> Since you are the one who suggested "direction" in the first place, as long as you agree with yourself :)

/me of today is not the same person as /me of yesterday... :P

This is just a suggestion though, please pick the name *you* think is
the most adequate.
