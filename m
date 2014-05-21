Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaEUJWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:22:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49559 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbaEUJWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:22:43 -0400
Date: Wed, 21 May 2014 10:22:40 +0100
From: Will Deacon <will.deacon@arm.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] x86: io: implement dummy relaxed accessor macros
 for writes
Message-ID: <20140521092240.GD11932@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <1397742261-15621-17-git-send-email-will.deacon@arm.com>
 <20140422160821.GA31322@arm.com>
 <20140521015327.GF22233@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521015327.GF22233@ld-irv-0074>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 02:53:27AM +0100, Brian Norris wrote:
> Hi Will,

Hello,

> On Tue, Apr 22, 2014 at 05:08:21PM +0100, Will Deacon wrote:
> > On Thu, Apr 17, 2014 at 02:44:19PM +0100, Will Deacon wrote:
> > > write{b,w,l,q}_relaxed are implemented by some architectures in order to
> > > permit memory-mapped I/O accesses with weaker barrier semantics than the
> > > non-relaxed variants.
> > > 
> > > This patch adds dummy macros for the write accessors to x86, in the
> > > same vein as the dummy definitions for the relaxed read accessors.
> [...]
> > > --- a/arch/x86/include/asm/io.h
> > > +++ b/arch/x86/include/asm/io.h
> > > @@ -74,6 +74,9 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
> > >  #define __raw_readw __readw
> > >  #define __raw_readl __readl
> > >  
> > > +#define writeb_relaxed(v, a) __writeb(v, a)
> > > +#define writew_relaxed(v, a) __writew(v, a)
> > > +#define writel_relaxed(v, a) __writel(v, a)
> > >  #define __raw_writeb __writeb
> > >  #define __raw_writew __writew
> > >  #define __raw_writel __writel
> [...]
> > 
> > Actually, I should be using the regular (i.e. without the double underscore
> > prefix) accessors for the relaxed variants, including the existing read
> > flavours here. The proposed semantics are that the accessors are ordered
> > with respect to each other, which necessitates a compiler barrier.
> 
> Are you planning on resubmitting this series? I've run into several
> situations in which I can't compile-test a driver on a different ARCH
> just because of this issue.

Yeah, I was just hoping for some input from Ben on the semantics I proposed.

I have a fix for the x86 patch, so I guess that justifies a v2. I'll post
something later on.

Cheers,

Will
