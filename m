Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005AbaBDVnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:43:40 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64780 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934815AbaBDVnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:43:35 -0500
MIME-Version: 1.0
In-Reply-To: <1874855.zG4mP2DzbB@tauon>
References: <2039634.jSmQAS6tdi@myon.chronox.de>
	<20140204170823.GF12768@thunk.org>
	<52F13A1C.3040003@zytor.com>
	<1874855.zG4mP2DzbB@tauon>
Date: Tue, 4 Feb 2014 22:43:34 +0100
X-Google-Sender-Auth: UEEvXljWxNckx-8MbAsn2VgCTxQ
Message-ID: <CAMuHMdX_UNk0fhin=NwydE4h+awiVmEy6xjdmBCR3dD8H=_iug@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, Dave Taht <dave.taht@gmail.com>,
        John Crispin <blogic@openwrt.org>,
        Andrew McGregor <andrewmcgr@gmail.com>, Thorsten Glaser <tg@mirbsd.de>,
        sandyinchina@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 9:31 PM, Stephan Mueller <smueller@chronox.de> wrote:
>>On 02/04/2014 09:08 AM, Theodore Ts'o wrote:
>>> I really wish we could get someone inside Intel who has deep
>>> knowledge
>>> about CPU internals to render an opinion about this.  My reaction to
>>> "I can't explain where the entropy is coming from" seems very similar
>>> to what my home grown attempts to create an encryption algoritm when
>>> I
>>> was much younger and much more foolish --- "it must be secure because
>>> I can't break it".
>>
>>I think I have deep enough knowledge about CPU architectures in general
>>(as opposed to specific Intel designs, which I wouldn't be able to
>>comment on anyway) to comment.  The more modern and high performance a
>>design you have the more sources of unpredictability there are.
>>However, there are very few, if any, (unintentional) sources of actual
>>quantum noise in a synchronous CPU, which means that this is at its
>>core a PRNG albeit with a large and rather obfuscated state space.
>>
>>The quantum noise sources there are in a system are generally two
>>independent clocks running against each other.  However, independent
>>clocks are rare; instead, most clocks are in fact slaved against each
>>other using PLLs and similar structures.  When mixing spread spectrum
>>clocks and non-spread-spectrum clocks that relationship can be very
>>complex, but at least for some designs it is still at its core
>>predictable.
>
> But isn't there an additional clock? The clock used to drive the cache
> and memory bus? When measuring memory accesses timings, larger
> variations in the execution time are evident. This also applies when
> hitting the caches (for L1, the variations are less than for L2 than for
> L3). The variations in access timings would come from the CPU wait
> states and their duration, would it not?

CPU, cache, and memory bus clocks are usually derived from the same
crystal. Hence they're not independent.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
