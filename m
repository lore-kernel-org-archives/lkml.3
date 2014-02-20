Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaBTQNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:13:22 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60787 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbaBTQNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <CANqRtoQVJzEgo_AdVxrPSRUY6ocyPaQ=RKQJyxoExDrfYxiJ3w@mail.gmail.com>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
	<1392907389-21798-8-git-send-email-geert@linux-m68k.org>
	<CANqRtoQVJzEgo_AdVxrPSRUY6ocyPaQ=RKQJyxoExDrfYxiJ3w@mail.gmail.com>
Date: Thu, 20 Feb 2014 17:13:16 +0100
X-Google-Sender-Auth: YJ4u7F6X6qb-MfAcHecwwO3bn8A
Message-ID: <CAMuHMdUByWPcYM8M_m5NVM4QP5cQE_tOLGQg=2fTNF7gqkUhig@mail.gmail.com>
Subject: Re: [PATCH 07/10] spi: sh-msiof: Add support for R-Car H2 and M2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        linux-spi <linux-spi@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 4:41 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> On thing stuck out a bit with the bindings. I can see that you specify
> both fifo size and use the SoC suffix for the r8a7790 and r8a7791
> bindings. Isn't that a bit of redundant information there, if we know
> that the SoC is r8a7790 or r8a7791 then can't we simply put that
> information in r8a779x_data above and perhaps keep the binding
> simpler? Perhaps same thing applies to other properties as well?

"renesas,tx-fifo-size" and "renesas,rx-fifo-size" are part of the existing
bindings, so I'm a bit reluctant to change these.
Hmm, since the original bindings didn't specify the default values,
I could make them chip-specific, though.

The only other property is "num-cs", which can have any value if you
start using the generic "cs-gpios".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
