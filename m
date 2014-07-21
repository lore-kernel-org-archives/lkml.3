Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaGUKvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:51:54 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:57927 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaGUKvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:51:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v2 19/29] nios2: Time keeping
Date: Mon, 21 Jul 2014 12:51:44 +0200
Message-ID: <17740341.0lUJQdnn9z@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ5-v7BEuLNEn0OyLpbLUJkeeZuKnDrFZZwQrjhFSU4PZSw@mail.gmail.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <5348663.eHVXUR5shS@wuerfel> <CAFiDJ5-v7BEuLNEn0OyLpbLUJkeeZuKnDrFZZwQrjhFSU4PZSw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WybureF8eIoVmBdEUgVvdf9LZgLA5YhfwEMUjOaSZCv
 QNmTtLQ11h4yuoWSl8Zbz+n4C4i++vJ/04XIGQKbv/FJDNFFVw
 y0UX+/dD7m410U2n+ujrSRc8y2kymupgxmSykUjj8UmFbGT8co
 TFA/+sshdR8MEoOMN++EwPA1j4zMJLAvrkdu8pLD0GBGCKlpKM
 m3DBD4oQDRk64FeBtB4cTQoCjB+GfhL32vO+XoHtk7eh4Xer/Y
 d0GShh7UeCDtiSJXvzwlFCjW3YGlUCHyucn/rd1cJsaz81h/57
 kHT3KGA894QMWz3y1RNndI9+UgtLZKPX70NGk8SvtAqeQ3RRoz
 ca6ENXGWzxICjvMBfBuI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2014 18:07:02 Ley Foon Tan wrote:
> >
> >> +#ifndef _ASM_NIOS2_TIMEX_H
> >> +#define _ASM_NIOS2_TIMEX_H
> >> +
> >> +/* Supply dummy tick-rate. Real value will be read from devicetree */
> >> +#define CLOCK_TICK_RATE              (HZ * 100000UL)
> >> +
> >> +#include <asm-generic/timex.h>
> >> +
> >> +#endif
> >
> > CLOCK_TICK_RATE is no longer used anywhere, no need for this file.
> 
> I found jiffies.h still using this define. Can we still remove this?
> In include/linux/jiffies.h:
> #define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)   /* For divider */
> 

Ah, I thought we had killed off LATCH, but at least it is only used
on architecture specific code, and only in two files:

arch/x86/kernel/apm_32.c:       outb_p(LATCH & 0xff, PIT_CH0);  /* LSB */
arch/unicore32/kernel/time.c:   writel(readl(OST_OSMR0) - LATCH, OST_OSCR);

We could decide to move the LATCH definition into those two files to
remove it from common code, but it doesn't really hurt otherwise,
and everything works fine if you don't define CLOCK_TICK_RATE on
architectures that don't need LATCH or CLOCK_TICK_RATE in their
architecture-specific code.

	Arnd
