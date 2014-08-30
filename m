Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaH3JgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 05:36:10 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:43706 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaH3JgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 05:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <5400E7B8.9050906@codeaurora.org>
References: <1409343731-5292-1-git-send-email-geert@linux-m68k.org>
	<5400E7B8.9050906@codeaurora.org>
Date: Sat, 30 Aug 2014 11:36:05 +0200
X-Google-Sender-Auth: RPRjf2RvU8ptYCCBWEDM7zIT85A
Message-ID: <CAMuHMdWHfe-32Y6uZgrk+yFjrbNrY1CUP+3sum2uMCK5G_uHtw@mail.gmail.com>
Subject: Re: [PATCH resend] nosave: Consolidate __nosave_{begin,end} in <asm/sections.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Aug 29, 2014 at 10:51 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 08/29/14 13:22, Geert Uytterhoeven wrote:
>> The different architectures used their own (and different) declarations:
>>
>>     extern __visible const void __nosave_begin, __nosave_end;
>>     extern const void __nosave_begin, __nosave_end;
>>     extern long __nosave_begin, __nosave_end;
>>
>> Consolidate them using the first variant in <asm/sections.h>.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>> This has been sent before, as part of the series "[PATCH 00/17] <asm/sections.h>
>> related cleanups", almost one year ago (https://lkml.org/lkml/2013/11/12/510).
>>
>>  arch/mips/include/asm/suspend.h   | 7 -------
>>  arch/mips/power/cpu.c             | 2 +-
>>  arch/powerpc/kernel/suspend.c     | 4 +---
>>  arch/s390/kernel/suspend.c        | 6 +-----
>>  arch/sh/include/asm/sections.h    | 1 -
>>  arch/sparc/power/hibernate.c      | 4 +---
>>  arch/unicore32/include/mach/pm.h  | 3 ---
>>  arch/unicore32/kernel/hibernate.c | 1 +
>>  arch/x86/power/hibernate_32.c     | 4 +---
>>  arch/x86/power/hibernate_64.c     | 4 +---
>>  include/asm-generic/sections.h    | 4 ++++
>>  11 files changed, 11 insertions(+), 29 deletions(-)
>>  delete mode 100644 arch/mips/include/asm/suspend.h
>
> There's one in arch/arm/kernel/hibernate.c now. Can we update ARM too?

Thanks, I'll fix that.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
