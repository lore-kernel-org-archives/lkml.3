Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaLBOEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:04:47 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36102 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaLBOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:04:45 -0500
MIME-Version: 1.0
In-Reply-To: <20141201225747.GA24551@ti.com>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-3-git-send-email-bparrot@ti.com> <CAAVeFuKEXp68LF9LJuKbQ9JM4YiksiG2K0ekPHM=K2ZJHZYDJg@mail.gmail.com>
 <20141201225747.GA24551@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 2 Dec 2014 23:04:23 +0900
Message-ID: <CAAVeFuK=AdL-kgaXzCVrF-ATPmS4xwC-sfbtQNcVLNAbXGULgQ@mail.gmail.com>
Subject: Re: [Patch v2 2/2] gpio: Document GPIO hogging mechanism
To: Benoit Parrot <bparrot@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 7:57 AM, Benoit Parrot <bparrot@ti.com> wrote:
> Alexandre Courbot <gnurou@gmail.com> wrote on Fri [2014-Nov-28 16:31:19 +0900]:
>> On Fri, Nov 21, 2014 at 8:54 AM, Benoit Parrot <bparrot@ti.com> wrote:
>> > Add GPIO hogging documentation to gpio.txt
>> >
>> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> > ---
>> > Changes since v1:
>> >  * Split the devicetree bindings documentation in its own patch.
>> >
>> >  Documentation/devicetree/bindings/gpio/gpio.txt | 25 +++++++++++++++++++++++++
>> >  1 file changed, 25 insertions(+)
>> >
>> > diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
>> > index 3fb8f53..82755e2 100644
>> > --- a/Documentation/devicetree/bindings/gpio/gpio.txt
>> > +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
>> > @@ -103,6 +103,24 @@ Every GPIO controller node must contain both an empty "gpio-controller"
>> >  property, and a #gpio-cells integer property, which indicates the number of
>> >  cells in a gpio-specifier.
>> >
>> > +The GPIO chip may contain GPIO hog definitions. GPIO hogging is a mechanism
>> > +providing automatic GPIO request and configuration as part of the
>> > +gpio-controller's driver probe function.
>> > +
>> > +Each GPIO hog definition is represented as a child node of the GPIO controller.
>> > +Required properties:
>> > +- gpio-hog: a property specifying that this child node represent a gpio-hog.
>> > +- gpios: store the gpio information (id, flags, ...). Shall contain the
>> > +  number of cells specified in its parent node (GPIO controller node).
>> > +- input: a property specifying to set the GPIO direction as input.
>> > +- output-high: a property specifying to set the GPIO direction to output with
>> > +  the value high.
>> > +- output-low: a property specifying to set the GPIO direction to output with
>> > +  the value low.
>> > +
>> > +Optional properties:
>> > +- line-name: the GPIO label name. If not present the node name is used.
>> > +
>> >  Example of two SOC GPIO banks defined as gpio-controller nodes:
>> >
>> >         qe_pio_a: gpio-controller@1400 {
>> > @@ -110,6 +128,13 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
>> >                 reg = <0x1400 0x18>;
>> >                 gpio-controller;
>> >                 #gpio-cells = <2>;
>> > +
>> > +               line_b: line_b {
>>
>> Mmm what is the label used for? Can this node ever be referenced from
>> somewhere else?
>
> It's not used for anything else as far as I know other than as the line-name to be assigned to the gpio being hogged.
> I guess you agree with Linus and should make the line-name mandatory and remove the label altogether?
>
> I was trying to keep the verbosity to a minimum so as to have the possibilty to keep everything on a single line when possible.

It's just that when you see a label, you expect it to be referenced
somewhere, which is obviously not the case here. Just having

line_b {

would work just as well, wouldn't it?
