Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaBYRu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:50:26 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41318 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbaBYRuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:50:22 -0500
MIME-Version: 1.0
In-Reply-To: <1907400.ponjrTNCdS@avalon>
References: <1392926021-19526-1-git-send-email-geert@linux-m68k.org>
	<1392926021-19526-2-git-send-email-geert@linux-m68k.org>
	<1907400.ponjrTNCdS@avalon>
Date: Tue, 25 Feb 2014 18:50:21 +0100
X-Google-Sender-Auth: PDOMqBzNG9gpcJzGR9mOwYFLWxc
Message-ID: <CAMuHMdWt2OZaLT3Z9KODkxcAqtqS27BpOaKFmLDKdxk68KW2Zg@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: sh-pfc: r8a7791: Add alternative MSIOF pin groups
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Feb 25, 2014 at 6:19 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> +static const unsigned int msiof1_rx_d_pins[] = {
>> +     /* RXD */
>> +     RCAR_GP_PIN(0, 26),
>
> This should be (0, 27).

Wow, nice catch. Thanks a lot!

>> +static const unsigned int msiof2_ss2_d_pins[] = {
>> +     /* SS2 */
>> +     RCAR_GP_PIN(2, 18),
>
> This should be (2, 19).

p. 4-16 of Rev. 0.31 of the R-Car M2 datasheet states that GP2_18 can be
both MSIOF2_SS2_D (function 3) and MSIOF2_RXD_D (function 5),
but p. 5-37 disagrees?
It seems the whole function 3 column on p. 4-16 is offset by one,
compared to p. 5-37.

Well, (2, 19) sounds more logical, so let's assume p. 5-37 is correct for now.

> > +};
> > +static const unsigned int msiof2_ss2_d_mux[] = {
> > +     MSIOF2_SS2_D_MARK,
> > +};
> > +static const unsigned int msiof2_rx_d_pins[] = {
> > +     /* RXD */
> > +     RCAR_GP_PIN(2, 18),
> > +};

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
