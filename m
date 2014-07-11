Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaGKKTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:19:46 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:40531 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaGKKTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:19:45 -0400
MIME-Version: 1.0
In-Reply-To: <1405072301-8719-1-git-send-email-bp@alien8.de>
References: <1405072301-8719-1-git-send-email-bp@alien8.de>
Date: Fri, 11 Jul 2014 12:19:43 +0200
X-Google-Sender-Auth: h8whtMDok2DTvBVW4Tsl7Vwm1eU
Message-ID: <CAMuHMdXz9dYaWizBo1hxuPx_-Y40tx+TfzuTihR6BySU6a+3qw@mail.gmail.com>
Subject: Re: [PATCH] x86: Get rid of __HAVE_ARCH_CMPXCHG
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 11:51 AM, Borislav Petkov <bp@alien8.de> wrote:
> From: Borislav Petkov <bp@suse.de>
>
> Both the 32-bit and 64-bit cmpxchg.h header define __HAVE_ARCH_CMPXCHG
> and there's ifdeffery which checks it. But since both bitness define it,
> we can just as well drop it and simpify a bit of code in doing that.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/cmpxchg.h     |  2 --
>  arch/x86/include/asm/cmpxchg_32.h  |  2 --
>  arch/x86/include/asm/cmpxchg_64.h  |  2 --
>  arch/x86/include/asm/mc146818rtc.h |  2 +-
>  arch/x86/include/asm/mutex_32.h    | 16 ++--------------
>  arch/x86/kernel/acpi/boot.c        |  4 ----
>  kernel/locking/rtmutex.c           |  2 +-
>  7 files changed, 4 insertions(+), 26 deletions(-)

> --- a/kernel/locking/rtmutex.c
> +++ b/kernel/locking/rtmutex.c
> @@ -73,7 +73,7 @@ static void fixup_rt_mutex_waiters(struct rt_mutex *lock)
>   * We can speed up the acquire/release, if the architecture
>   * supports cmpxchg and if there's no debugging state to be set up
>   */
> -#if defined(__HAVE_ARCH_CMPXCHG) && !defined(CONFIG_DEBUG_RT_MUTEXES)
> +#ifndef CONFIG_DEBUG_RT_MUTEXES
>  # define rt_mutex_cmpxchg(l,c,n)       (cmpxchg(&l->owner, c, n) == c)
>  static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
>  {

What about non-x86? __HAVE_ARCH_CMPXCHG isn't always defined.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
