Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936758Ab3DJOTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:19:17 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40713 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120Ab3DJOTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130410122611.GB17541@sepie.suse.cz>
References: <1365585879-5321-1-git-send-email-geert@linux-m68k.org>
	<51653C5D.4060408@suse.cz>
	<CAMuHMdXEvLMz5rRjQrhENxJ6UHRnPCtzyNg=hqitspuY88G7sA@mail.gmail.com>
	<20130410122611.GB17541@sepie.suse.cz>
Date: Wed, 10 Apr 2013 16:19:14 +0200
X-Google-Sender-Auth: Ew8GDnfSXopi1v2uS2ucgOW5mYU
Message-ID: <CAMuHMdUHiiBEZm7eFYtL3PqCXF6PjscbFKjiJ33BEwQ+YLKOXQ@mail.gmail.com>
Subject: Re: [PATCH/RFC] m68k: Add -ffreestanding to KBUILD_CFLAGS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Wed, Apr 10, 2013 at 2:26 PM, Michal Marek <mmarek@suse.cz> wrote:
> On Wed, Apr 10, 2013 at 12:59:44PM +0200, Geert Uytterhoeven wrote:
>> On Wed, Apr 10, 2013 at 12:18 PM, Michal Marek <mmarek@suse.cz> wrote:
>> > On 10.4.2013 11:24, Geert Uytterhoeven wrote:
>> > My understanding is, that with -fnobuiltin, the compiler is not allowed
>> > to make assumptions about functions if it does not see their definition,
>> > even if they resemble standard functions. E.g. on x86_64, strlen() is
>> > out-of-line, so gcc would have to assume, that strcmp() has side
>> > effects. How about just naming the m68k inline function 'strlen'?
>>
>> Having an inline function named "strlen" is not sufficient, as it needs an
>> (exported) symbol named "strlen" at link time or module load time.
>
> Really? MIPS and Xtensa both have an inline version of strcpy() and no
> exported strcpy symbol. An I would naively assume, that if the compiler
> sees a static inline definition of a function, then it will not generate
> a function call. Although, the C standard does require the standard
> library functions be available as external functions, so the compiler
> would not be necessarily wrong :-/. Anyway, can you try if this
> (untested) patch fixes the issue?

Thanks for the patch, but modpost still fails with

ERROR: "strlen" [net/ipv4/ip_tunnel.ko] undefined!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
