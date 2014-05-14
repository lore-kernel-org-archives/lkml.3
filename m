Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaENTeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:34:36 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36372 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaENTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <5373C36E.3020900@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
	<1400093999-18703-14-git-send-email-richard@nod.at>
	<CAMuHMdUddNc3Suq25JU7UC+YdWQHmk0nCRzCEbqmKg1+a+=FXw@mail.gmail.com>
	<5373C36E.3020900@nod.at>
Date: Wed, 14 May 2014 21:34:34 +0200
X-Google-Sender-Auth: PZ1lDYloWWzN57rDYmOdief6RX0
Message-ID: <CAMuHMdVWp8-aByVf+7M=8HEXXJRJBbZLdfj1v0rgDU-UEQM=8Q@mail.gmail.com>
Subject: Re: [PATCH 13/27] m68k: Use common bits from generic tlb.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Wed, May 14, 2014 at 9:26 PM, Richard Weinberger <richard@nod.at> wrote:
>> But why this sudden #ifdef checks?
>
> They are needed because in pgalloc.h you have:
> #ifdef CONFIG_MMU
> #include <asm/virtconvert.h>
> #if defined(CONFIG_COLDFIRE)
> #include <asm/mcf_pgalloc.h>
> #elif defined(CONFIG_SUN3)
> #include <asm/sun3_pgalloc.h>
> #else
> #include <asm/motorola_pgalloc.h>
> #endif
>
> And only asm/motorola_pgalloc.h have __pte/pmd_free_tlb as static inline functions.
> Therefore we need to define them such that the generic tlb.h versions will not clash
> with yours.

Thanks for the clarification!

Perhaps this deserves a comment:

/* Applies to Classic m68k MMU only */

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
