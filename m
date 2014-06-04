Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaFDLAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:00:19 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6678 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbaFDLAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:00:16 -0400
X-IronPort-AV: E=Sophos;i="4.98,972,1392159600"; 
   d="scan'208";a="77997003"
Date: Wed, 4 Jun 2014 13:00:07 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        David Laight <David.Laight@aculab.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        "iss_storagedev@hp.com" <iss_storagedev@hp.com>,
        scsi <linux-scsi@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/10] use safer test on the result of
 find_first_zero_bit
In-Reply-To: <CAMuHMdXPBQTYA0c=1hkC7943-_J59TVSFaEKsfY1F2ogV=Ld+A@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406041258200.2441@hadrien>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr> <CAMuHMdXsoFUXj4jLMWN6NY7Um19KwWO9Rhx=9=gqWu_K5Ev2kQ@mail.gmail.com> <alpine.DEB.2.10.1406041137270.2441@hadrien> <063D6719AE5E284EB5DD2968C1650D6D1725705F@AcuExch.aculab.com>
 <alpine.DEB.2.10.1406041148590.2441@hadrien> <CAMuHMdXPBQTYA0c=1hkC7943-_J59TVSFaEKsfY1F2ogV=Ld+A@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Jun 2014, Geert Uytterhoeven wrote:

> Hi Julia,
>
> On Wed, Jun 4, 2014 at 11:52 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> >> Maybe the documented return code should be changed to allow for the
> >> existing behaviour.
> >
> > Sorry, I'm not sure to understand what you suggest here.
>
> include/asm-generic/bitops/find.h:
>
> | /**
> |  * find_first_zero_bit - find the first cleared bit in a memory region
> |  * @addr: The address to start the search at
> |  * @size: The maximum number of bits to search
> |  *
> |  * Returns the bit number of the first cleared bit.
> |  * If no bits are zero, returns @size.
>
> "If no bits are zero, returns @size or a number larger than @size."

OK, thanks.  I was only looking at the C code.

But the C code contains a loop that is followed by:

        if (!size)
                return result;
        tmp = *p;

found_first:
        tmp |= ~0UL << size;
        if (tmp == ~0UL)        /* Are any bits zero? */
                return result + size;   /* Nope. */

In the first return, it would seem that result == size.  Could the second
one be changed to just return size?  It should not hurt performance.

julia

>
> |  */
> | extern unsigned long find_first_zero_bit(const unsigned long *addr,
> |                                          unsigned long size);
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>
