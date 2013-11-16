Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3KPUnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 15:43:40 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57533 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3KPUnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 15:43:32 -0500
MIME-Version: 1.0
In-Reply-To: <1383833644-27091-2-git-send-email-kirill.shutemov@linux.intel.com>
References: <1383833644-27091-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1383833644-27091-2-git-send-email-kirill.shutemov@linux.intel.com>
Date: Sat, 16 Nov 2013 21:43:32 +0100
X-Google-Sender-Auth: 5xfau0xpVqFXhUIvZ0AWV2iTNgo
Message-ID: <CAMuHMdV33zBfsztXGsSv5YO+r4c2Fxh+0tH7togtS7EjdhDXeA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: create a separate slab for page->ptl allocation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 3:14 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h

> +static inline void pgtable_init(void)
> +{
> +       ptlock_cache_init();
> +       pgtable_cache_init();
> +}

sparc64defconfig:

include/linux/mm.h:1391:2: error: implicit declaration of function
'pgtable_cache_init' [-Werror=implicit-function-declaration]
arch/sparc/include/asm/pgtable_64.h:978:13: error: conflicting types
for 'pgtable_cache_init' [-Werror]

http://kisskb.ellerman.id.au/kisskb/buildresult/10040274/

Has this been in -next?

Probably it needs <asm/pgtable.h>.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
