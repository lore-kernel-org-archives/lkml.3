Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3IXVXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:23:53 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41092 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab3IXVXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:23:51 -0400
Date: Tue, 24 Sep 2013 16:23:48 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: new binutils needed for arm in 3.12-rc1
To: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Pavel Machek <pavel@ucw.cz>, Will Deacon <will.deacon@arm.com>,
        Trivial patch monkey <trivial@kernel.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
In-Reply-To: <yw1xpprywhad.fsf@unicorn.mansr.com> (from mans@mansr.com on
	Tue Sep 24 07:11:38 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1380057828.1974.73@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 07:11:38 AM, Måns Rullgård wrote:
> Rob Landley <rob@landley.net> writes:
> 
> > On 09/23/2013 06:59:17 PM, Pavel Machek wrote:
> >> During 3.12-rc, Will Deacon introduced code into arch/arm that
> >> requires binutils 2.22.
> >
> > Um, my toolchain is using the last gplv2 snapshot of binutils out of
> > git, which is just past 2.17 and can build armv7 (but not armv8).
> >
> > Binutils 2.12->2.22 is quite the jump. (11 years.) I'd except some
> > thought to have gone into that? Possibly a mention of it?
> 
> I seriously doubt that 2.12 still works at all (I doubt it can even be
> built on a modern system).  In my experience, binutils older than 2.19
> or so rarely works properly for ARM.

I've been building every kernel release with 2.17 for several years, on  
a bunch of different architectures. Toolchain releases after that are  
GPLv3* and I can't distribute those binaries, so I can't ship prebuilt  
binary toolchains.

(Lots of other people produce cross compilers, but nobody else seems to  
produce prebuilt statically linked _native_ compilers. It would be nice  
if they did.)

> What value is there in maintaining compatibility with a truly ancient
> binutils version anyway?

What value is there in requiring the new toolchain? From what I could  
see of the commits it was micro-optimizations around memory barriers.

*shrug* I can revert the patch locally, or patch the extra instruction  
into my toolchain. But I do object to changing the documentation  
globally for every architecture because one architecture did something  
they apparently never thought through (or they'd have commented in the  
commit that it requires a big toolchain version jump; pretty sure they  
didn't actually notice).

Rob

* The Free Software Foundation got so pissed that MacOS X and BSD and  
such were sticking with the last GPLv2 release of binutils that they  
deleted the binutils tarball off their website and replaced it with one  
including GPLv3 source code. Check the FTP site if you don't believe  
me. Some of us have it snapshotted though. In my case, I actually  
fished the last GPLv2 version out of source control, right before the  
license change was committed, because I wanted armv7 support.