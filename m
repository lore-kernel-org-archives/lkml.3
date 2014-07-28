Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaG1O7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:59:18 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52317 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaG1O7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:59:15 -0400
MIME-Version: 1.0
In-Reply-To: <1405413956-2772-6-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-6-git-send-email-lftan@altera.com>
Date: Mon, 28 Jul 2014 16:59:13 +0200
X-Google-Sender-Auth: CWU_CJmg72QklLTZKMl95eVzi1M
Message-ID: <CAMuHMdUyif5JS9OdiamHhf+r5oeTRdd7Gzd6-rBUyamnNQ6C8A@mail.gmail.com>
Subject: Re: [PATCH v2 05/29] nios2: Memory management
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:45 AM, Ley Foon Tan <lftan@altera.com> wrote:
> --- /dev/null
> +++ b/arch/nios2/include/asm/mmu.h
> @@ -0,0 +1,18 @@
> +/*
> + * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
> + * Copyright (C) 2004 Microtronix Datacom Ltd.
> + *
> + * Taken from m68knommu.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License. See the file "COPYING" in the main directory of this archive
> + * for more details.
> + */
> +
> +#ifndef _ASM_NIOS2_MMU_H
> +#define _ASM_NIOS2_MMU_H
> +
> +/* Default "unsigned long" context */
> +typedef unsigned long mm_context_t;
> +
> +#endif /* _ASM_NIOS2_MMU_H */

Any chance you can use mmu.h from asm-generic instead?
It uses a struct with a single "unsigned long end_brk" member (unless
CONFIG_BINFMT_ELF_FDPIC is defined).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
