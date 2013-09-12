Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3ILMPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:15:37 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33315 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3ILMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:15:35 -0400
MIME-Version: 1.0
In-Reply-To: <5896310.H6rEVunj63@tauon>
References: <10005394.BRCyBMYWy3@tauon>
	<2947789.S63SVUbC3N@tauon>
	<CAMuHMdWMiD1kw34CUJ-KCbk4mKggjtMzxVPpkN=ddfaq_vs9sg@mail.gmail.com>
	<5896310.H6rEVunj63@tauon>
Date: Thu, 12 Sep 2013 14:15:35 +0200
X-Google-Sender-Auth: RE9yCy6bH5Fvz275GAWAOSegLoI
Message-ID: <CAMuHMdX5-kSWVJ_QFXY+L2L6iY0Zo7GAL5uF-uPGJAXM=wZxgw@mail.gmail.com>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 2:08 PM, Stephan Mueller <smueller@chronox.de> wrote:
>>BTW, I prefer a different name than "random_get_fast_cycles()", as it's
>>better to have something that returns different and unpredictable
>>numbers than an actual monotonic cycle counter.
>
> A monotonic counter is fully ok. Note, for /dev/random, the occurrence
> of events delivers entropy. Thus, we have to be able to precisely
> measure that occurrence. The timer itself does not need to deliver any
> entropy as long as it is fast.

Well, in my specific case (m68k/Amiga) I can use:
  - a 24-bit counter running at only ca. 15 or 31 kHz (actual
frequency may vary),
  - a 16-bit counter running at ca. 700 kHz.

That is, if they have to be monotonic cycle counters.

If not, I can mix the two (e.g. "a << 8 | (b & 0xff)") to get a 32-bit value.
That result would be fine for /dev/random, I guess, but it's not
really "get_cycles()".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
