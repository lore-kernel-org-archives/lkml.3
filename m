Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaEUBxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 21:53:33 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51962 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaEUBxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 21:53:31 -0400
Date: Tue, 20 May 2014 18:53:27 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] x86: io: implement dummy relaxed accessor macros
 for writes
Message-ID: <20140521015327.GF22233@ld-irv-0074>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <1397742261-15621-17-git-send-email-will.deacon@arm.com>
 <20140422160821.GA31322@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422160821.GA31322@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Tue, Apr 22, 2014 at 05:08:21PM +0100, Will Deacon wrote:
> On Thu, Apr 17, 2014 at 02:44:19PM +0100, Will Deacon wrote:
> > write{b,w,l,q}_relaxed are implemented by some architectures in order to
> > permit memory-mapped I/O accesses with weaker barrier semantics than the
> > non-relaxed variants.
> > 
> > This patch adds dummy macros for the write accessors to x86, in the
> > same vein as the dummy definitions for the relaxed read accessors.
[...]
> > --- a/arch/x86/include/asm/io.h
> > +++ b/arch/x86/include/asm/io.h
> > @@ -74,6 +74,9 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
> >  #define __raw_readw __readw
> >  #define __raw_readl __readl
> >  
> > +#define writeb_relaxed(v, a) __writeb(v, a)
> > +#define writew_relaxed(v, a) __writew(v, a)
> > +#define writel_relaxed(v, a) __writel(v, a)
> >  #define __raw_writeb __writeb
> >  #define __raw_writew __writew
> >  #define __raw_writel __writel
[...]
> 
> Actually, I should be using the regular (i.e. without the double underscore
> prefix) accessors for the relaxed variants, including the existing read
> flavours here. The proposed semantics are that the accessors are ordered
> with respect to each other, which necessitates a compiler barrier.

Are you planning on resubmitting this series? I've run into several
situations in which I can't compile-test a driver on a different ARCH
just because of this issue.

Thanks,
Brian
