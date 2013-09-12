Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3ILMgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:36:03 -0400
Received: from mail.eperm.de ([89.247.134.16]:44897 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3ILMgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:36:01 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Thu, 12 Sep 2013 14:35:53 +0200
Message-ID: <2140053.ysf7239sM3@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.10-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAMuHMdX5-kSWVJ_QFXY+L2L6iY0Zo7GAL5uF-uPGJAXM=wZxgw@mail.gmail.com>
References: <10005394.BRCyBMYWy3@tauon> <5896310.H6rEVunj63@tauon> <CAMuHMdX5-kSWVJ_QFXY+L2L6iY0Zo7GAL5uF-uPGJAXM=wZxgw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 12. September 2013, 14:15:35 schrieb Geert Uytterhoeven:

Hi Geert,

>On Thu, Sep 12, 2013 at 2:08 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
>>>BTW, I prefer a different name than "random_get_fast_cycles()", as
>>>it's better to have something that returns different and
>>>unpredictable numbers than an actual monotonic cycle counter.
>>>
>> A monotonic counter is fully ok. Note, for /dev/random, the
>> occurrence
>> of events delivers entropy. Thus, we have to be able to precisely
>> measure that occurrence. The timer itself does not need to deliver
>> any
>> entropy as long as it is fast.
>
>Well, in my specific case (m68k/Amiga) I can use:
>  - a 24-bit counter running at only ca. 15 or 31 kHz (actual
>frequency may vary),
>  - a 16-bit counter running at ca. 700 kHz.
>
>That is, if they have to be monotonic cycle counters.
>
>If not, I can mix the two (e.g. "a << 8 | (b & 0xff)") to get a 32-bit
>value. That result would be fine for /dev/random, I guess, but it's
>not really "get_cycles()".

Note, get_cycles should return an u64.

Not sure what a and b here is, but if a is the 24 bit value and b the 
faster 16 bit value, wouldn't there be a gap?

I.e. wouldn't it be better to use the full 16 bit counter as low value 
and OR the 24 bit on bits 48 to 17?

Yet, there is a break in that counter: the 16 low bits rotate several 
times (around 10 times) before bit 17 is changed once.


>
>Gr{oetje,eeting}s,
>
>                        Geert
>
>--
>Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
>geert@linux-m68k.org
>
>In personal conversations with technical people, I call myself a
>hacker. But when I'm talking to journalists I just say "programmer" or
>something like that. -- Linus Torvalds


Ciao
Stephan
