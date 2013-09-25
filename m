Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab3IYBNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:13:34 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:65412 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab3IYBNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:13:31 -0400
Date: Tue, 24 Sep 2013 20:13:27 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: new binutils needed for arm in 3.12-rc1
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Andrew Morton <akpm@osdl.org>,
        Trivial patch monkey <trivial@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20130924214800.GV25647@n2100.arm.linux.org.uk> (from
	linux@arm.linux.org.uk on Tue Sep 24 16:48:00 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1380071607.1974.78@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 04:48:00 PM, Russell King - ARM Linux wrote:
> On Tue, Sep 24, 2013 at 04:23:48PM -0500, Rob Landley wrote:
> > What value is there in requiring the new toolchain? From what I  
> could
> > see of the commits it was micro-optimizations around memory  
> barriers.
> >
> > *shrug* I can revert the patch locally, or patch the extra  
> instruction
> > into my toolchain. But I do object to changing the documentation
> > globally for every architecture because one architecture did  
> something
> > they apparently never thought through (or they'd have commented in  
> the
> > commit that it requires a big toolchain version jump; pretty sure  
> they
> > didn't actually notice).
> 
> Some of us are notoriously slow at updating our toolchains.
...

Some of us can't ship GPLv3 binaries and are looking forward to the day  
LLVM or some such provides a complete solution.

> Now, if you feel strongly about this, we _could_ introduce a
> CONFIG_OLD_BINUTILS and give everyone their cake - but it will be
> fragile.  Not everyone will remember to get that right, because  
> they'll
> be using the later binutils.  Also, we already have an excessive  
> number
> of potential breakage-inducing options and we certainly don't need
> another.

I'm doing the regression testing either way, on several different  
architectures. (Although I tend to to only really do a thorough job  
quarterly when a new kernel comes out and it's time to make it work.)  
So I'm going to be doing something locally like this anyway, and if a  
CONFIG_OLD_BINUTILS is acceptable I might as well push it upstream.

My use case is running all these targets under qemu, so it's not  
exactly performance-critical. :)

> Use IS_ENABLED() I hear you say.  That won't get the one dsb  
> instruction
> in some SoC code which was missed which will break the build on older
> toolchains.

My regression test is my http://landley.net/aboriginal/about.html  
project, where I:

1) build cross compilers for ~15 different architecture variants (maybe  
half unique, the rest variants of the others).

2) Use them to build the smallest native development environment  
capable of reproducing itself from soruce code.

3) Boot it under qemu.

4) Build linux from scratch under the result.

I've sometimes had it the whole mess automated from a cron job, but the  
server I had it on blew out its hard drive controller and I haven't  
bothered to set it up again...

Next couple days are crazy but I'll try to get you a patch this weekend.

Thanks,

Rob