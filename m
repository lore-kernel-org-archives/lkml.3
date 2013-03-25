Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3CYA7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 20:59:13 -0400
Received: from ozlabs.org ([203.10.76.45]:39072 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab3CYA7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 20:59:12 -0400
From: Michael Neuling <mikey@neuling.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: RFC: Kernel lock elision for TSX
In-reply-to: <1364134657.11644.16.camel@pasglop>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org> <CA+55aFyWMqwBfd6aYfRaLpX6gGqNxEkD5TFM3HRQpi9nAhn+0g@mail.gmail.com> <20130323180010.GK20853@two.firstfloor.org> <1364134657.11644.16.camel@pasglop>
Comments: In-reply-to Benjamin Herrenschmidt <benh@kernel.crashing.org>
   message dated "Sun, 24 Mar 2013 15:17:37 +0100."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 25 Mar 2013 11:59:07 +1100
Message-ID: <19753.1364173147@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 2013-03-23 at 19:00 +0100, Andi Kleen wrote:
> > Hi Linux,
> > 
> > Thanks.  Other code/design review would be still appreciated, even
> > under the current constraints.
> > 
> > > The other comment I have is that since it does touch non-x86 header
> > > files etc (although not a lot), you really need to talk to the POWER8
> > > people about naming of the thing. Calling it <linux/rtm.h> and having
> > > "generic" helpers called _xtest() used by the generic spinlock code
> > > sounds a bit suspect.
> > 
> > I can make up another name for _xtest()/_xabort() and linux/rtm.h,
> > (any suggestions?)
> > 
> > The basic concepts implemented there should be pretty universal.
> > If others have a equivalent of "is this a transaction" and "abort
> > this tranction" they can just plug it in. Otherwise they will nop it,
> > as it's only hints anyways.
> > 
> > The only things used outside x86 code is _xtest()/_xabort(), can
> > remove the rest from linux/*. Without transactions this is all nops.
> > The primary interface for the lock code is the much higher level
> > elide()/elide_lock_adapt() interface anyways.
> 
> Adding Michael Neuling to the CC list, he's probably the LTC person who
> is the most familiar with POWER8 TM at the moment.

Thanks. I'll respond inline, but agree, the naming convention is very
x86 centrinc and will not suit powerpc at all.

Also, like Andy, we don't have permission to post any performance
numbers so have held off on bothering with any thing like this for now.

Mikey

> 
> Cheers,
> Ben.
> 
> > -Andi
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
