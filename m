Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaHFHJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 03:09:10 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:49161 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaHFHJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 03:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <878un2lat1.wl%kuninori.morimoto.gx@gmail.com>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
	<1404908623-909-6-git-send-email-geert+renesas@glider.be>
	<20140711091358.GK12420@verge.net.au>
	<1405435735.28592.50.camel@rzhang1-toshiba>
	<87mwcakpzw.wl%kuninori.morimoto.gx@renesas.com>
	<CAMuHMdVHRcXYgCPtWcMzRvofp7OK3ugLW9ztOHM5ey3_atz6MA@mail.gmail.com>
	<878un2lat1.wl%kuninori.morimoto.gx@gmail.com>
Date: Wed, 6 Aug 2014 09:09:04 +0200
X-Google-Sender-Auth: s_JmFqMpQ6QKON8sKdOmOzF3fBA
Message-ID: <CAMuHMdV1PcH-Xcn9Qkc0GoLv7vg7roXfXh1f++Sn3bycAcsKww@mail.gmail.com>
Subject: Re: [PATCH 05/13] thermal: rcar: Document SoC-specific bindings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
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

Hi Morimoto-san,

On Wed, Aug 6, 2014 at 2:30 AM, Kuninori Morimoto
<kuninori.morimoto.gx@gmail.com> wrote:
>> >> > >  Required properties:
>> >> > > -- compatible             : "renesas,rcar-thermal"
>> >> > > +- compatible             : "renesas,thermal-<soctype>", "renesas,rcar-thermal"
>> >> > > +                   as fallback.
>> >> > > +                   Examples with soctypes are:
>> >> > > +                     - "renesas,thermal-r8a73a4" (R-Mobile AP6)
>> >> > > +                     - "renesas,thermal-r8a7779" (R-Car H1)
>> >> > > +                     - "renesas,thermal-r8a7790" (R-Car H2)
>> >> > > +                     - "renesas,thermal-r8a7791" (R-Car M2)
>> >> > >  - reg                    : Address range of the thermal registers.
>> >> > >                     The 1st reg will be recognized as common register
>> >> > >                     if it has "interrupts".
> (snip)
>> One important thing to note in my patch description is "some of which
>> are already in use.".
>>
>> $ git grep renesas,thermal -- arch/arm/boot/ | cat
>> arch/arm/boot/dts/r8a7790.dtsi: compatible =
>> "renesas,thermal-r8a7790", "renesas,rcar-thermal";
>> arch/arm/boot/dts/r8a7791.dtsi: compatible =
>> "renesas,thermal-r8a7791", "renesas,rcar-thermal";
>> $
>>
>> So these 2 should be added to the documentation for sure.
>> Adding the 2 others, and adding them to the respective DTSes (cfr. the
>> other patches in the series) doesn't hurt, and will help if an incompatibility
>> ever arises.
>>
>> (I assume the driver works with the other DTSes that already claim to have
>> a device compatible with "renesas,rcar-thermal").
>
> I reconsidered about this.
> Actually, I'm still wondering about this approach
> because driver side doesn't have SoC specific matching table.
> Of course SoC-specific name in .compatible can be backup plan for us,
> but, we don't know it is 100% true.
> (we might have new driver for some specific SoC, like R-Car DMA driver ?)
>
> Adding to SoC specific compatible name in SoC side DTSes are no problem,
> it can be backup plan.
> but, we can't say 100% true that <driver>.txt has SoC specific name list.
> because, driver doesn't care about it today, and we don't know the future

If the SoC-specific name is used in a DTS, it must[*] be documented in the
bindings. Checkpatch.pl checks for that.

[*] The only exception is devices for which no driver exists yet. But then the
    bindings are preliminary and in limbo.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
