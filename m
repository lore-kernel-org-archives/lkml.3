Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaAXNFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:05:49 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46577 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaAXNFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140124093349.GK15586@e106331-lin.cambridge.arm.com>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
	<1390553044-11860-14-git-send-email-geert@linux-m68k.org>
	<20140124093349.GK15586@e106331-lin.cambridge.arm.com>
Date: Fri, 24 Jan 2014 14:05:46 +0100
X-Google-Sender-Auth: BRYcM5x4uF1nDiEY9AJXU_vPYBY
Message-ID: <CAMuHMdWFzJ-PfFQz-mgbtYdV9d_8=mr+F51=1Jhx0K-HrGrwFg@mail.gmail.com>
Subject: Re: [PATCH v4 13/14] spi: rspi: Add DT support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 10:33 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> +- interrupts       : 1 interrupt for RSPI cores using a single multiplexed
>> +                  interrupt,
>> +                  3 interrupts (SPEI, SPRI, SPTI) for RSPI cores using
>> +                  separate interrupts.
>> +- interrupt-names  : Array of strings associated with the interrupt numbers:
>> +                  "error" for SPEI, "rx" for SPRI, and "tx" for SPTI.
>> +                  For RSPI cores using a single multiplexed interrupt, the
>> +                  name "mux" is optional.
>
> Rather than defining the set of interrupts twice, it would be nice to
> have interrupts defined in terms of interrupt-names:
>
> - interrupts: a list of interrupt-specifiers, one for each entry in
>   interrupt-names. If interrupt-names is not present, an interrupt
>   specifier for a single muxed interrupt.
>
> - interrupt-names: A list of interrupt names. Should contain (if
>   present):
>   * "error" for SPEI
>   * "rx" for SPRI
>   * "tx" to SPTI
>   * "mux" for a single muxed interrupt

Yes, that sounds much better, thank you.
Will update.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
