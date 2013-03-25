Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3CYIyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:54:24 -0400
Received: from ozlabs.org ([203.10.76.45]:55048 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706Ab3CYIyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:54:23 -0400
From: Michael Neuling <mikey@neuling.org>
To: Andi Kleen <ak@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        x86@kernel.org
Subject: Re: [PATCH 02/29] x86, tsx: Add RTM intrinsics
In-reply-to: <20130325081556.GS19692@tassilo.jf.intel.com>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org> <1364001923-10796-3-git-send-email-andi@firstfloor.org> <30471.1364182834@ale.ozlabs.ibm.com> <20130325081556.GS19692@tassilo.jf.intel.com>
Comments: In-reply-to Andi Kleen <ak@linux.intel.com>
   message dated "Mon, 25 Mar 2013 01:15:56 -0700."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 25 Mar 2013 19:54:21 +1100
Message-ID: <15400.1364201661@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> wrote:

> > FYI the TM spec can be downloaded here:
> >   https://www.power.org/documentation/power-isa-transactional-memory/
> > 
> > You're example code looks like this:
> 
> I don't think portable code will use this directly. Note it's in arch/x86/
> 
> Generally portable code should use higher level interfaces, like
> elide_lock/elide_lock_adapt that hide the architecture specific 
> details.
> 
> If you want to do lock elision you would plug in some elision
> algorithm that works well at that level.
> 
> > Secondly, can we make xbegin just return true/false and get the status
> > later if needed?
> 
> I now removed xbegin() from the portable file, as it's only used
> in arch specific code. 

OK, well most of my objections go away now.

> And FWIW I'm considering to change it to save a few instructions and
> go for the more efficient goto based interface in glibc.
> 
> > 
> > ppc = tcheck... should be fine, other than the name.
> 
> Well x and tm doesn't really matter, but I already have x* so i'm inclined
> to keep it, unless people bikeshed too strongly. It should work for PPC too.

Well if you're moving it out of generic code then it doesn't really
matter anymore.  

Mikey

> 
> BTW if the percpu include loop hell is ever sorted out _xtest may
> even stop using XTEST.
