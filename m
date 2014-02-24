Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaBXCp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:45:26 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:58994 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaBXCpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:45:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUByWPcYM8M_m5NVM4QP5cQE_tOLGQg=2fTNF7gqkUhig@mail.gmail.com>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
	<1392907389-21798-8-git-send-email-geert@linux-m68k.org>
	<CANqRtoQVJzEgo_AdVxrPSRUY6ocyPaQ=RKQJyxoExDrfYxiJ3w@mail.gmail.com>
	<CAMuHMdUByWPcYM8M_m5NVM4QP5cQE_tOLGQg=2fTNF7gqkUhig@mail.gmail.com>
Date: Mon, 24 Feb 2014 11:45:19 +0900
Message-ID: <CANqRtoSJTROkkbGxV_p+B2S7b7jZ7jgHQ+q4_WG54m+Pxgfcpw@mail.gmail.com>
Subject: Re: [PATCH 07/10] spi: sh-msiof: Add support for R-Car H2 and M2
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        linux-spi <linux-spi@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Fri, Feb 21, 2014 at 1:13 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Feb 20, 2014 at 4:41 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> On thing stuck out a bit with the bindings. I can see that you specify
>> both fifo size and use the SoC suffix for the r8a7790 and r8a7791
>> bindings. Isn't that a bit of redundant information there, if we know
>> that the SoC is r8a7790 or r8a7791 then can't we simply put that
>> information in r8a779x_data above and perhaps keep the binding
>> simpler? Perhaps same thing applies to other properties as well?
>
> "renesas,tx-fifo-size" and "renesas,rx-fifo-size" are part of the existing
> bindings, so I'm a bit reluctant to change these.
> Hmm, since the original bindings didn't specify the default values,
> I could make them chip-specific, though.

Thanks, yes I think treating the "renesas,tx-fifo-size" and
"renesas,rx-fifo-size" bindings as optional and allow us to rely on
chip-specific default values makes sense.

> The only other property is "num-cs", which can have any value if you
> start using the generic "cs-gpios".

I see. It looks to me that such a setting is board-specific, so what
is a sane default in the SoC DTSI? You seem to have it set to "1"
today, but if the board is supposed to override it anyway then do we
need to set it?

Anyway, "num-cs" is a minor detail so no need to bother about that too much!

Cheers,

/ magnus
