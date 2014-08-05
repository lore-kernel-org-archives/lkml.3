Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbaHEI5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:57:32 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:45452 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbaHEI52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <87mwcakpzw.wl%kuninori.morimoto.gx@renesas.com>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
	<1404908623-909-6-git-send-email-geert+renesas@glider.be>
	<20140711091358.GK12420@verge.net.au>
	<1405435735.28592.50.camel@rzhang1-toshiba>
	<87mwcakpzw.wl%kuninori.morimoto.gx@renesas.com>
Date: Tue, 5 Aug 2014 10:57:25 +0200
X-Google-Sender-Auth: QsRCrHtFm4bl5AA2sl78BYXH1GU
Message-ID: <CAMuHMdVHRcXYgCPtWcMzRvofp7OK3ugLW9ztOHM5ey3_atz6MA@mail.gmail.com>
Subject: Re: [PATCH 05/13] thermal: rcar: Document SoC-specific bindings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 4:16 AM, Kuninori Morimoto
<kuninori.morimoto.gx@renesas.com> wrote:
>> > > The documentation only mentioned the generic fallback compatible property.
>> > > Add the missing SoC-specific compatible properties, some of which are
>> > > already in use.
>> > >
>> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> > > Cc: Zhang Rui <rui.zhang@intel.com>
>> > > Cc: Eduardo Valentin <eduardo.valentin@ti.com>
>> > > Cc: linux-pm@vger.kernel.org
>> >
>> > Acked-by: Simon Horman <horms+renesas@verge.net.au>
>>
>> Kuninori,
>>
>> what' your opinion of this patch?
>>
>> thanks,
>> rui
>> >
>> > > ---
>> > >  .../devicetree/bindings/thermal/rcar-thermal.txt       | 18 ++++++++++++------
>> > >  1 file changed, 12 insertions(+), 6 deletions(-)
>> > >
>> > > diff --git a/Documentation/devicetree/bindings/thermal/rcar-thermal.txt b/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
>> > > index 28ef498a66e5..0ef00be44b01 100644
>> > > --- a/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
>> > > +++ b/Documentation/devicetree/bindings/thermal/rcar-thermal.txt
>> > > @@ -1,7 +1,13 @@
>> > >  * Renesas R-Car Thermal
>> > >
>> > >  Required properties:
>> > > -- compatible             : "renesas,rcar-thermal"
>> > > +- compatible             : "renesas,thermal-<soctype>", "renesas,rcar-thermal"
>> > > +                   as fallback.
>> > > +                   Examples with soctypes are:
>> > > +                     - "renesas,thermal-r8a73a4" (R-Mobile AP6)
>> > > +                     - "renesas,thermal-r8a7779" (R-Car H1)
>> > > +                     - "renesas,thermal-r8a7790" (R-Car H2)
>> > > +                     - "renesas,thermal-r8a7791" (R-Car M2)
>> > >  - reg                    : Address range of the thermal registers.
>> > >                     The 1st reg will be recognized as common register
>> > >                     if it has "interrupts".
>> > > @@ -12,18 +18,18 @@ Option properties:
>> > >
>> > >  Example (non interrupt support):
>> > >
>> > > -thermal@e61f0100 {
>> > > - compatible = "renesas,rcar-thermal";
>> > > - reg = <0xe61f0100 0x38>;
>> > > +thermal@ffc48000 {
>> > > + compatible = "renesas,thermal-r8a7779", "renesas,rcar-thermal";
>> > > + reg = <0xffc48000 0x38>;
>> > >  };
>> > >
>> > >  Example (interrupt support):
>> > >
>> > >  thermal@e61f0000 {
>> > > - compatible = "renesas,rcar-thermal";
>> > > + compatible = "renesas,thermal-r8a73a4", "renesas,rcar-thermal";
>> > >   reg = <0xe61f0000 0x14
>> > >           0xe61f0100 0x38
>> > >           0xe61f0200 0x38
>> > >           0xe61f0300 0x38>;
>> > > - interrupts = <0 69 4>;
>> > > + interrupts = <0 69 IRQ_TYPE_LEVEL_HIGH>;
>> > >  };
>
> This patch and [12/13] are adding SoC-specific compatible name.
> Of course we don't know future request,
> and, adding SoC-specific compatible name for
> fallbacking is nice safety for us.
> So, I don't have strong objection about it.
>
> But, thermal driver side do nothing for each
> SoC-specific compatible name at this point.
> This means
>
>  -> There is no trouble in driver/SoC
>  -> Add new (and not used) compatible name
>  -> Nothing happen in driver/SoC
>
> My questions are...
>  1) How to verify this patch ?
>  2) Do we need to update example SoC "specific name" list in rcar-thermal.txt.
>     Few example codes are very enough ?

One important thing to note in my patch description is "some of which
are already in use.".

$ git grep renesas,thermal -- arch/arm/boot/ | cat
arch/arm/boot/dts/r8a7790.dtsi: compatible =
"renesas,thermal-r8a7790", "renesas,rcar-thermal";
arch/arm/boot/dts/r8a7791.dtsi: compatible =
"renesas,thermal-r8a7791", "renesas,rcar-thermal";
$

So these 2 should be added to the documentation for sure.
Adding the 2 others, and adding them to the respective DTSes (cfr. the
other patches in the series) doesn't hurt, and will help if an incompatibility
ever arises.

(I assume the driver works with the other DTSes that already claim to have
a device compatible with "renesas,rcar-thermal").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
