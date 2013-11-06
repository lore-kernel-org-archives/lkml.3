Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3KFMvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:51:13 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65365 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3KFMvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:51:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131106123946.GJ10651@twins.programming.kicks-ass.net>
References: <20131103151704.GJ19466@laptop.lan>
	<CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
	<20131103200124.GK19466@laptop.lan>
	<20131103224242.GF3947@linux.vnet.ibm.com>
	<CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
	<20131104105059.GL3947@linux.vnet.ibm.com>
	<20131104112254.GK28601@twins.programming.kicks-ass.net>
	<20131104162732.GN3947@linux.vnet.ibm.com>
	<20131104191127.GW16117@laptop.programming.kicks-ass.net>
	<20131104205344.GW3947@linux.vnet.ibm.com>
	<20131106123946.GJ10651@twins.programming.kicks-ass.net>
Date: Wed, 6 Nov 2013 13:51:10 +0100
X-Google-Sender-Auth: ZQQBe5yKp30ocPiynU2YHxIfZGI
Message-ID: <CAMuHMdXZjQJvT7R4ODbDNBgAVwPUBPjB6UoR66_sNuFx7opUDw@mail.gmail.com>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Russell King <linux@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 1:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>  Documentation/memory-barriers.txt     |  157 +++++++++++++++++-----------------
>  arch/alpha/include/asm/barrier.h      |   15 +++
>  arch/arc/include/asm/barrier.h        |   15 +++
>  arch/arm/include/asm/barrier.h        |   15 +++
>  arch/arm64/include/asm/barrier.h      |   50 ++++++++++
>  arch/avr32/include/asm/barrier.h      |   14 +++
>  arch/blackfin/include/asm/barrier.h   |   15 +++
>  arch/cris/include/asm/barrier.h       |   15 +++
>  arch/frv/include/asm/barrier.h        |   15 +++
>  arch/h8300/include/asm/barrier.h      |   15 +++
>  arch/hexagon/include/asm/barrier.h    |   15 +++
>  arch/ia64/include/asm/barrier.h       |   49 ++++++++++
>  arch/m32r/include/asm/barrier.h       |   15 +++
>  arch/m68k/include/asm/barrier.h       |   15 +++
>  arch/metag/include/asm/barrier.h      |   15 +++
>  arch/microblaze/include/asm/barrier.h |   15 +++
>  arch/mips/include/asm/barrier.h       |   15 +++
>  arch/mn10300/include/asm/barrier.h    |   15 +++
>  arch/parisc/include/asm/barrier.h     |   15 +++
>  arch/powerpc/include/asm/barrier.h    |   21 ++++
>  arch/s390/include/asm/barrier.h       |   15 +++
>  arch/score/include/asm/barrier.h      |   15 +++
>  arch/sh/include/asm/barrier.h         |   15 +++
>  arch/sparc/include/asm/barrier_32.h   |   15 +++
>  arch/sparc/include/asm/barrier_64.h   |   15 +++
>  arch/tile/include/asm/barrier.h       |   15 +++
>  arch/unicore32/include/asm/barrier.h  |   15 +++
>  arch/x86/include/asm/barrier.h        |   15 +++
>  arch/xtensa/include/asm/barrier.h     |   15 +++
>  include/linux/compiler.h              |    9 +
>  30 files changed, 581 insertions(+), 79 deletions(-)

This is screaming for a default implementation in asm-generic.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
