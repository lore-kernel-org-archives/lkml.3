Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaCHKYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 05:24:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaCHKYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 05:24:49 -0500
MIME-Version: 1.0
In-Reply-To: <20140308121106.2ff89ab0@tukaani.org>
References: <20140228230017.GE14970@merlin.infradead.org>
	<20140303145137.70819698@tukaani.org>
	<CAGVrzcZ7KU-m9s9KgoigK+WdSqeqwEmm=_pY6qF=ep2vFp6WUg@mail.gmail.com>
	<20140304202038.03b36109@tukaani.org>
	<53169123.4020909@lougher.demon.co.uk>
	<CAGVrzcYQ44fYA0kpRC84Qfe7v0vPGy+euWLfs8xF0XEMnsFmGA@mail.gmail.com>
	<CAMuHMdXJ+GKtbCr-fzq2tRf8yUeYmgSA2VpmL2aofybc84Wwog@mail.gmail.com>
	<20140308121106.2ff89ab0@tukaani.org>
Date: Sat, 8 Mar 2014 11:24:48 +0100
X-Google-Sender-Auth: 4tll5sV9WhF5nS1dviRmnn0-SeA
Message-ID: <CAMuHMdU1PNTy4KdqspWrcp=wFfWXJ3iGaM48ALzQb1msO9bOWw@mail.gmail.com>
Subject: Re: [PATCH] xz: make XZ_DEC_BCJ filters non-optional
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lasse Collin <lasse.collin@tukaani.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Kyle McMartin <kyle@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 11:11 AM, Lasse Collin <lasse.collin@tukaani.org> wrote:
> On 2014-03-06 Geert Uytterhoeven wrote:
>> I once tried xz with an initrd on ARM. The kernel complained it
>> couldn't decompress the initrd, oops. I didn't investigate it at that
>> time, but probably I didn't have the x86 BCJ filter enabled, while I
>> compressed the initrd on\ amd64.
>
> With so little information I can only guess, but it sounds unlikely

I understand. Will see if I find time to retry...

> that you would have enabled the x86 BCJ filter without knowing it
> unless you used some wrapper script that does it. It's more likely that
> the ARM kernel didn't support XZ at all, you forgot --check=crc32,

I definitely didn't pass --check=crc32, just plain xz (like I'm used to plain
gzip ;-) So that's the most likely culprit.

> or it ran out of RAM due to too big LZMA2 dictionary (if you used -9,
> the decompressor allocates 64 MiB of memory, but I cannot guess how
> much RAM the target system had).

2 GiB, so that shouldn't be an issue.

> In Documentation/xz.txt under "Notes on compression options" there are
> some tips about compressing files for the in-kernel XZ decompressor.

Thanks, the --check=crc32 is indeed mentioned there.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
