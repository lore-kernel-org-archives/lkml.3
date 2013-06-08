Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3FHIcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:32:04 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33934 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3FHIcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:32:00 -0400
MIME-Version: 1.0
In-Reply-To: <51B2E262.3030603@asianux.com>
References: <51B2E262.3030603@asianux.com>
Date: Sat, 8 Jun 2013 10:31:59 +0200
X-Google-Sender-Auth: 6wKbNrlj5AYKEiFehMMfjRQElAI
Message-ID: <CAMuHMdVg12Wm4fZYDdgV0m4+Bo76hm=nckGtSkobRfbsmNo2wA@mail.gmail.com>
Subject: Re: [PATCH] arch: asm-geniric: for atomic_set_mask() 1st param, use
 'unsigned int' instead of 'unsigned long'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, realmz paranoid <realmz6@gmail.com>,
        linux390@de.ibm.com,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-s390@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haven't done a real review, but my eye fell on it:

On Sat, Jun 8, 2013 at 9:50 AM, Chen Gang <gang.chen@asianux.com> wrote:
> diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
> index 0d81697..233c743 100644
> --- a/arch/m32r/include/asm/atomic.h
> +++ b/arch/m32r/include/asm/atomic.h
> @@ -264,7 +264,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
>  }
>
>
> -static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
> +static __inline__ void atomic_clear_mask(unsigned int mask, atomic_t *addr)
>  {
>         unsigned long flags;
>         unsigned long tmp;

Shouldn't this become "unsigned int tmp" for consistency, too?

> @@ -286,7 +286,7 @@ static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
>         local_irq_restore(flags);
>  }
>
> -static __inline__ void atomic_set_mask(unsigned long  mask, atomic_t *addr)
> +static __inline__ void atomic_set_mask(unsigned int mask, atomic_t *addr)
>  {
>         unsigned long flags;
>         unsigned long tmp;

Likewise.

There may be other places that need changes.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
