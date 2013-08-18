Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3HRUZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:25:17 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33449 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3HRUZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:25:16 -0400
MIME-Version: 1.0
In-Reply-To: <1376841688.11104.8.camel@t520.redhat.com>
References: <1376841688.11104.8.camel@t520.redhat.com>
Date: Sun, 18 Aug 2013 22:25:15 +0200
X-Google-Sender-Auth: hmzscyM7yBLqzxwg0pN8JYVXzZE
Message-ID: <CAMuHMdXfXAaNeCAhmxTQb007Um7AjqRdF2=85t1Po_63T7XT5w@mail.gmail.com>
Subject: Re: [PATCH] arm64: wire in generic parport.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 6:01 PM, Mark Salter <msalter@redhat.com> wrote:
> The arm64 port doesn't provide a parport.h which causes a build failure
> with some configurations:
>
>   drivers/parport/parport_pc.c:67:25: fatal error: asm/parport.h: No such file or directory
>    #include <asm/parport.h>
>
> This patch wires in the generic parport.h for arm64.

Can arm64 have a PC-style parport?

If not, you're better off disabling it in drivers/parport/Kconfig.

You will receive bonus points for introducing ARCH_MAY_HAVE_PC_PARPORT,
cfr. ARCH_MAY_HAVE_PC_FDC.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
