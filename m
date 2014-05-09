Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaEIJIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:08:41 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:46758 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaEIJIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140508135852.387473090@infradead.org>
References: <20140508135840.956784204@infradead.org>
	<20140508135852.387473090@infradead.org>
Date: Fri, 9 May 2014 11:08:37 +0200
X-Google-Sender-Auth: ohBRxkkvdzN2Z53zUy8OV_A6dmk
Message-ID: <CAMuHMdUrG6pR0_6VhL8P_=HDmVBQxa9kinRm=AFxddyHQFBNeQ@mail.gmail.com>
Subject: Re: [PATCH 11/20] arch,m68k: Fold atomic_ops
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, May 8, 2014 at 3:58 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> +#ifdef CONFIG_RMW_INSNS
>
> -static inline void atomic_sub(int i, atomic_t *v)
> -{
> -       __asm__ __volatile__("subl %1,%0" : "+m" (*v) : ASM_DI (i));
> -}
> +#define ATOMIC_OP(op, c_op, asm_op)                                    \
> +static inline void atomic_##op(int i, atomic_t *v)                     \
> +{                                                                      \
> +       __asm__ __volatile__(#asm_op "l %1,%0" : "+m" (*v) : ASM_DI (i));\
> +}                                                                      \

> +#else
> +
> +#define ATOMIC_OP(op, c_op, asm_op)                                    \
> +static inline void atomic_##op(int i, atomic_t *v)                     \
> +{                                                                      \
> +       __asm__ __volatile__(#asm_op "l %1,%0" : "+m" (*v) : ASM_DI (i));\
> +}                                                                      \

These two chunks are identical, so please move them out of the #ifdef.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
