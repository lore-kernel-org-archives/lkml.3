Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3IZPxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:53:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54837 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab3IZPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:53:39 -0400
Date: Thu, 26 Sep 2013 16:53:31 +0100
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 1/4] asm-generic: cmpxchg: implement dummy
 cmpxchg64_relaxed operation
Message-ID: <20130926155330.GC4175@mudshark.cambridge.arm.com>
References: <1380208411-31403-1-git-send-email-will.deacon@arm.com>
 <CA+55aFzCiOxpgdJagSVdsBYEU66zBSBXZpnU5-jvQpAX6T7SiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzCiOxpgdJagSVdsBYEU66zBSBXZpnU5-jvQpAX6T7SiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:34:04PM +0100, Linus Torvalds wrote:
> On Thu, Sep 26, 2013 at 8:13 AM, Will Deacon <will.deacon@arm.com> wrote:
> >
> > This patch implements a dummy implementation for asm-generic, falling
> > back to the usual cmpxchg64 code.
> 
> I don't like the "let's add dummy operations for everybody who doesn't
> care" when it is this specialized.
> 
> I'd much rather just add a single
> 
>    #ifndef cmpxchg64_relaxed
>    # define cmpxchg64_relaxed cmpxchg64
>    #endif
> 
> to the LOCKREF code, and then ARM (and others) can define it as they wish.

Okey doke.

> And *if* anybody else ever realizes that they want this outside of the
> lockref code, let's look at doing that then. Right now I don't know of
> any users, and I'd be leery of people using this willy-nilly, because
> very few people really understand memory ordering.

Agreed, and I really doubt there are many cases where the cmpxchg hazarding
works out nicely so as to obviate the need for memory barriers.

I'll send a revised patch.

Cheers,

Will
