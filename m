Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaEHPMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:12:34 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38355 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaEHPMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:12:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140508135852.104572724@infradead.org>
References: <20140508135840.956784204@infradead.org>
	<20140508135852.104572724@infradead.org>
Date: Thu, 8 May 2014 17:12:31 +0200
X-Google-Sender-Auth: h0XyX4aaI2WuiDNJzGk8-Pdrs18
Message-ID: <CAMuHMdV7FUC+p5XqwLZmqJRLYv1qhu5hf0M_e5pASBRHgFAhCA@mail.gmail.com>
Subject: Re: [PATCH 07/20] arch,cris: Fold atomic_ops
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, May 8, 2014 at 3:58 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Many of the atomic op implementations are the same except for one
> instruction; fold the lot into a few CPP macros and reduce LoC.
>
> This also prepares for easy addition of new ops.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mikael Starvik <starvik@axis.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/cris/include/arch-v10/arch/system.h |    2 -
>  arch/cris/include/asm/atomic.h           |   57 +++++++++++++------------------
>  2 files changed, 25 insertions(+), 34 deletions(-)
>
> Index: linux-2.6/arch/cris/include/arch-v10/arch/system.h
> ===================================================================
> --- linux-2.6.orig/arch/cris/include/arch-v10/arch/system.h
> +++ linux-2.6/arch/cris/include/arch-v10/arch/system.h
> @@ -36,8 +36,6 @@ static inline unsigned long _get_base(ch
>    return 0;
>  }
>
> -#define nop() __asm__ __volatile__ ("nop");
> -

Is this change supposed to be part of this series?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
