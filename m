Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146AbaBDVqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:46:21 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:45445 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606AbaBDVqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:46:16 -0500
MIME-Version: 1.0
In-Reply-To: <52F15000.2080102@zytor.com>
References: <2039634.jSmQAS6tdi@myon.chronox.de>
	<20140204170823.GF12768@thunk.org>
	<52F13A1C.3040003@zytor.com>
	<20140204192325.GA11831@thunk.org>
	<CAMuHMdV5tLX7L6m4Q+1tMu_LF0bhxErVJuXDcga8VAmGV91dZg@mail.gmail.com>
	<52F15000.2080102@zytor.com>
Date: Tue, 4 Feb 2014 22:46:15 +0100
X-Google-Sender-Auth: gYtv17t77G009CLIHPiYHgprVw0
Message-ID: <CAMuHMdXdYBB9AfdE4qb846SmkO_pqEqtrUsFL=d09tAqgmkXTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
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

On Tue, Feb 4, 2014 at 9:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/04/2014 11:39 AM, Geert Uytterhoeven wrote:
>> On Tue, Feb 4, 2014 at 8:23 PM,  <tytso@mit.edu> wrote:
>>> However, where a decade ago the ethernet card probably had its own
>>> independent clock crystal/oscillator, I'm going to guess that these
>>> days with SOC's and even on laptops, with ethernet device part of the
>>> chipset, it is probably being driven off the same master oscillator.
>>
>> USB typically still has its own crystal.
>
> USB and the Ethernet PHY frequently do still have their own crystals,
> for reasons not entirely clear to me.  However, what all of these have
> in common is that they are way out in the periphery.

Because they're fixed frequency, and used for communication with other
devices, so accuracy matters?

Other clocks can be tuned for performance or power reasons, but clocks
for communication must be fixed and stable. You can run e.g. your CPU
or memory a bit slower or faster, but not your Ethernet.

>>> I wonder if there's anyway we can either figure out manually, or
>>> preferably, automatically at boot time, which devices actually have
>>> independent clock oscillators.
>>
>> You may find this information in the DT on some platforms (if you're
>> lucky).
>
> On most systems today, all the high speed clocks (CPU, memory, etc.) are
> all fed from a single oscillator.

Indeed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
