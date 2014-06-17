Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbaFQPaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:30:07 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56681 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869AbaFQPaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:30:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Pinski <apinski@cavium.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/24] ARM64:UAPI: Set the correct __BITS_PER_LONG for ILP32.
Date: Tue, 17 Jun 2014 17:29:33 +0200
Message-ID: <13888874.KX24HfA3hx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140617152250.GC21752@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com> <1400914939-9708-6-git-send-email-apinski@cavium.com> <20140617152250.GC21752@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vhVVe0j8WjYm6EF01CY1mEPn5wdbJ2zR8Ybk+0QG+ud
 FbMFrCPmevzJmRzJ+LOTaEAuDY5x/XzvHVu0NGJjkc+71CRsA/
 Mk+KynITYjuxvVm1IOo9b68wNFyZxeFkNc3yUOTfs3aVzYJcvH
 7nc24z4DGbLZGAlaa0TaI/AQ816cow2apIVfQEkgjSGHUzJ7pw
 i7YWBs3bu5SwoR7aSeG4YnuV1vjzdGOW60QUV+5cdNjUWRJDYs
 PHoAWgA/ebmOes76LFFzsd3x4k0KNBb1AYZOou6JdxlVwr2bPx
 oUrBr1apVmDyoL83Co39rnHNTv9W7T7EbwBbabd8gsPlgBUfGW
 OQ43xrO4LxBDxVTcW8Lg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2014 16:22:50 Catalin Marinas wrote:
> On Sat, May 24, 2014 at 12:02:00AM -0700, Andrew Pinski wrote:
> > diff --git a/arch/arm64/include/uapi/asm/bitsperlong.h b/arch/arm64/include/uapi/asm/bitsperlong.h
> > index fce9c29..5e06c59 100644
> > --- a/arch/arm64/include/uapi/asm/bitsperlong.h
> > +++ b/arch/arm64/include/uapi/asm/bitsperlong.h
> > @@ -16,7 +16,12 @@
> >  #ifndef __ASM_BITSPERLONG_H
> >  #define __ASM_BITSPERLONG_H
> >  
> > -#define __BITS_PER_LONG 64
> > +/* Assuming __LP64__ will be defined for native ELF64's and not for ILP32. */
> > +#ifdef __LP64__
> > +# define __BITS_PER_LONG 64
> > +#else
> > +# define __BITS_PER_LONG 32
> > +#endif
> 
> I think it's enough to just define it for the __LP64__ case.
> 
> >  #include <asm-generic/bitsperlong.h>
> 
> The asm-generic definition if 32 by default.

Andrew's version does seem more readable though, and is obviously correct.

	Arnd
