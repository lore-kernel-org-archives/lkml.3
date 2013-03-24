Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3CXOWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:22:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:48579 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab3CXOWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:22:13 -0400
Message-ID: <1364134657.11644.16.camel@pasglop>
Subject: Re: RFC: Kernel lock elision for TSX
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Michael Neuling <michael.neuling@au1.ibm.com>
Date: Sun, 24 Mar 2013 15:17:37 +0100
In-Reply-To: <20130323180010.GK20853@two.firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
	 <CA+55aFyWMqwBfd6aYfRaLpX6gGqNxEkD5TFM3HRQpi9nAhn+0g@mail.gmail.com>
	 <20130323180010.GK20853@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-23 at 19:00 +0100, Andi Kleen wrote:
> Hi Linux,
> 
> Thanks.  Other code/design review would be still appreciated, even
> under the current constraints.
> 
> > The other comment I have is that since it does touch non-x86 header
> > files etc (although not a lot), you really need to talk to the POWER8
> > people about naming of the thing. Calling it <linux/rtm.h> and having
> > "generic" helpers called _xtest() used by the generic spinlock code
> > sounds a bit suspect.
> 
> I can make up another name for _xtest()/_xabort() and linux/rtm.h,
> (any suggestions?)
> 
> The basic concepts implemented there should be pretty universal.
> If others have a equivalent of "is this a transaction" and "abort
> this tranction" they can just plug it in. Otherwise they will nop it,
> as it's only hints anyways.
> 
> The only things used outside x86 code is _xtest()/_xabort(), can
> remove the rest from linux/*. Without transactions this is all nops.
> The primary interface for the lock code is the much higher level
> elide()/elide_lock_adapt() interface anyways.

Adding Michael Neuling to the CC list, he's probably the LTC person who
is the most familiar with POWER8 TM at the moment.

Cheers,
Ben.

> -Andi
> 


