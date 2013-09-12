Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3ILMIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:08:40 -0400
Received: from mail.eperm.de ([89.247.134.16]:36439 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3ILMIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:08:38 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Thu, 12 Sep 2013 14:08:28 +0200
Message-ID: <5896310.H6rEVunj63@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.10-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAMuHMdWMiD1kw34CUJ-KCbk4mKggjtMzxVPpkN=ddfaq_vs9sg@mail.gmail.com>
References: <10005394.BRCyBMYWy3@tauon> <2947789.S63SVUbC3N@tauon> <CAMuHMdWMiD1kw34CUJ-KCbk4mKggjtMzxVPpkN=ddfaq_vs9sg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 12. September 2013, 13:59:04 schrieb Geert Uytterhoeven:

Hi Geert,

>On Wed, Sep 11, 2013 at 8:49 AM, Stephan Mueller <smueller@chronox.de> 
wrote:
>> __u64 tmp = random_get_fast_cycles() - random_get_fast_cycles();
>> if(0 == tmp)
>> 
>>         return fail;
>> 
>> return pass;
>
>That will fail if the cycle counter runs at less than say 4 times the
>CPU clock...

Well...
>
>BTW, I prefer a different name than "random_get_fast_cycles()", as it's
>better to have something that returns different and unpredictable
>numbers than an actual monotonic cycle counter.

A monotonic counter is fully ok. Note, for /dev/random, the occurrence 
of events delivers entropy. Thus, we have to be able to precisely 
measure that occurrence. The timer itself does not need to deliver any 
entropy as long as it is fast.
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
