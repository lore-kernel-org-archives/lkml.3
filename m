Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3ILL7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:59:08 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63501 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3ILL7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:59:06 -0400
MIME-Version: 1.0
In-Reply-To: <2947789.S63SVUbC3N@tauon>
References: <10005394.BRCyBMYWy3@tauon>
	<CAMuHMdXcXGpgE5ArcjNU-RgAr52qB8ih_b48jwR=+OqK4RDhFA@mail.gmail.com>
	<20130910211454.GJ29237@thunk.org>
	<2947789.S63SVUbC3N@tauon>
Date: Thu, 12 Sep 2013 13:59:04 +0200
X-Google-Sender-Auth: gTrGaXts98AudvWLF5lLuygq12c
Message-ID: <CAMuHMdWMiD1kw34CUJ-KCbk4mKggjtMzxVPpkN=ddfaq_vs9sg@mail.gmail.com>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 8:49 AM, Stephan Mueller <smueller@chronox.de> wrote:
> __u64 tmp = random_get_fast_cycles() - random_get_fast_cycles();
> if(0 == tmp)
>         return fail;
> return pass;

That will fail if the cycle counter runs at less than say 4 times the
CPU clock...

BTW, I prefer a different name than "random_get_fast_cycles()", as it's better
to have something that returns different and unpredictable numbers than an
actual monotonic cycle counter.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
