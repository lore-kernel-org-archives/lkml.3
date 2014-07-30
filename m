Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaG3IS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:18:57 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:65121 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaG3ISx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAFiDJ5_9a7pr+16gjV5-cA_Ruoz1LDMKivFemNiOf_Me4bLEUg@mail.gmail.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-6-git-send-email-lftan@altera.com>
	<CAMuHMdUyif5JS9OdiamHhf+r5oeTRdd7Gzd6-rBUyamnNQ6C8A@mail.gmail.com>
	<CAFiDJ5_9a7pr+16gjV5-cA_Ruoz1LDMKivFemNiOf_Me4bLEUg@mail.gmail.com>
Date: Wed, 30 Jul 2014 10:18:49 +0200
X-Google-Sender-Auth: 3gVSyljJdEh_HKp_6-roUalEs9A
Message-ID: <CAMuHMdWw7WGibh38OdAQEmFzV3J9-z3=B74y8i8XxNsdTvOEyw@mail.gmail.com>
Subject: Re: [PATCH v2 05/29] nios2: Memory management
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 8:42 AM, Ley Foon Tan <lftan@altera.com> wrote:
> On Mon, Jul 28, 2014 at 10:59 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Tue, Jul 15, 2014 at 10:45 AM, Ley Foon Tan <lftan@altera.com> wrote:
>>> --- /dev/null
>>> +++ b/arch/nios2/include/asm/mmu.h
>>> @@ -0,0 +1,18 @@
>>> +/*
>>> + * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
>>> + * Copyright (C) 2004 Microtronix Datacom Ltd.
>>> + *
>>> + * Taken from m68knommu.
>>> + *
>>> + * This file is subject to the terms and conditions of the GNU General Public
>>> + * License. See the file "COPYING" in the main directory of this archive
>>> + * for more details.
>>> + */
>>> +
>>> +#ifndef _ASM_NIOS2_MMU_H
>>> +#define _ASM_NIOS2_MMU_H
>>> +
>>> +/* Default "unsigned long" context */
>>> +typedef unsigned long mm_context_t;
>>> +
>>> +#endif /* _ASM_NIOS2_MMU_H */
>>
>> Any chance you can use mmu.h from asm-generic instead?
>> It uses a struct with a single "unsigned long end_brk" member (unless
>> CONFIG_BINFMT_ELF_FDPIC is defined).
> From asm-generic/mmu.h, it is for nommu implementations.
> So, I will keep this as it is now.

Right, you have a MMU.
I got confused by the "Taken from m68knommu" comment, and you still
only need a single "unsigned long".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
