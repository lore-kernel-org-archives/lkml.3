Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaGQKi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:38:27 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:32912 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaGQKiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:38:24 -0400
Date: Thu, 17 Jul 2014 12:38:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 38/38] asm-generic: introduc Kbuild.generic
Message-ID: <20140717103815.GA16291@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
 <1405350546-28467-38-git-send-email-sam@ravnborg.org>
 <4667634.oiTEQ4v5vj@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667634.oiTEQ4v5vj@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 09:03:00AM +0200, Arnd Bergmann wrote:
> On Monday 14 July 2014 17:09:06 Sam Ravnborg wrote:
> > Kbuild.generic is for asm-generic files that are used
> > by all architectures.
> > So rather than adding the file to the individual Kbuild files
> > it is enough to add it to this file
> > 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> 
> This has been suggested in the past, and I remember there being some
> controversy around it, but I don't really mind it, so you have my
> ok in principle. Two points though that we have to work out first:
> 
> > diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
> > index 96e54be..e09f8e7 100644
> > --- a/arch/alpha/include/asm/Kbuild
> > +++ b/arch/alpha/include/asm/Kbuild
> > @@ -1,9 +1,9 @@
> > -
> > +# Generic wrappers from include/asm-generic
> > +include include/asm-generic/Kbuild.generic
> 
> We have the same kind of header for the uapi files, it's called 
> include/uapi/asm-generic/Kbuild.asm. I don't know why I picked that
> name back then, Kbuild.generic seems more appropriate, but I think
> either way it would be good to be consistent.
> 
> Can you either rename the existing file to Kbuild.generic, or call
> the new one Kbuild.asm as well?
There was already a file name Kbuild.asm in that directory - therefore I picked another name.
But the original Kbuild.asm was in reality not used so I have deleted it in
my patch-set and will re-introduce it with a different purpose.
People are used to the name "Kbuild.asm" so let's stick to that.

> * We could improve the situation if the definition of this list is
>   changed so we only generate the generic header files that are not
>   already provided by an architecture. If we do this, we can consolidate
>   a lot more here, which is nice, but the cost would be equivalent to
>   another level of indirection and a potential for subtle bugs if it's
>   not done very careful.
I think this is the way to go - and will try to give it a spin.

Something along these lines:
include/asm-generic/Kbuild.asm will include a list of all header files
that shall be present for any architecture and may come from asm-generic.
If the architecture provide there own file - good.
If the architecture do not provide their own file => create wrapper.

The arch provided header file comes first in the search path,
so if a wrapper was generated and later a dedicated file is added
then we will use the dedicated file and not the wrapper that points
back to asm-generic.

The same logic applies for uapi/asm-generic as well.

I will try to come up with an implementation of this,
then we can see if this flys.

	Sam
