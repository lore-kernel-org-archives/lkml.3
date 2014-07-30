Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaG3I5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:57:53 -0400
Received: from sym2.noone.org ([178.63.92.236]:60555 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaG3I5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:57:48 -0400
Date: Wed, 30 Jul 2014 10:57:43 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ley Foon Tan <lftan@altera.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v2 05/29] nios2: Memory management
Message-ID: <20140730085743.GC10301@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
 <1405413956-2772-6-git-send-email-lftan@altera.com>
 <CAMuHMdUyif5JS9OdiamHhf+r5oeTRdd7Gzd6-rBUyamnNQ6C8A@mail.gmail.com>
 <CAFiDJ5_9a7pr+16gjV5-cA_Ruoz1LDMKivFemNiOf_Me4bLEUg@mail.gmail.com>
 <CAMuHMdWw7WGibh38OdAQEmFzV3J9-z3=B74y8i8XxNsdTvOEyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWw7WGibh38OdAQEmFzV3J9-z3=B74y8i8XxNsdTvOEyw@mail.gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-30 at 10:18:49 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, Jul 30, 2014 at 8:42 AM, Ley Foon Tan <lftan@altera.com> wrote:
> > On Mon, Jul 28, 2014 at 10:59 PM, Geert Uytterhoeven
> > <geert@linux-m68k.org> wrote:
> >> On Tue, Jul 15, 2014 at 10:45 AM, Ley Foon Tan <lftan@altera.com> wrote:
> >>> --- /dev/null
> >>> +++ b/arch/nios2/include/asm/mmu.h
> >>> @@ -0,0 +1,18 @@
> >>> +/*
> >>> + * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
> >>> + * Copyright (C) 2004 Microtronix Datacom Ltd.
> >>> + *
> >>> + * Taken from m68knommu.
> >>> + *
> >>> + * This file is subject to the terms and conditions of the GNU General Public
> >>> + * License. See the file "COPYING" in the main directory of this archive
> >>> + * for more details.
> >>> + */
> >>> +
> >>> +#ifndef _ASM_NIOS2_MMU_H
> >>> +#define _ASM_NIOS2_MMU_H
> >>> +
> >>> +/* Default "unsigned long" context */
> >>> +typedef unsigned long mm_context_t;
> >>> +
> >>> +#endif /* _ASM_NIOS2_MMU_H */
> >>
> >> Any chance you can use mmu.h from asm-generic instead?
> >> It uses a struct with a single "unsigned long end_brk" member (unless
> >> CONFIG_BINFMT_ELF_FDPIC is defined).
> > From asm-generic/mmu.h, it is for nommu implementations.
> > So, I will keep this as it is now.
> 
> Right, you have a MMU.
> I got confused by the "Taken from m68knommu" comment, and you still
> only need a single "unsigned long".

That comment stems from the initial Nios II NOMMU port done by
Microtronix. Since Nios II NOMMU support was dropped for mainline
submission anyhow, it might be better to drop that comment to avoid any
future confusion :)

Cheers
Tobias
