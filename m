Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbaDIGCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:02:01 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33076 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175AbaDIGBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:01:37 -0400
Date: Wed, 9 Apr 2014 08:01:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140409060133.GA6766@gmail.com>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
 <20140408204906.GA3616@cloud>
 <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
 <20140409013557.GA32556@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409013557.GA32556@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> On Tue, Apr 08, 2014 at 03:44:25PM -0700, Linus Torvalds wrote:
> > On Tue, Apr 8, 2014 at 1:49 PM,  <josh@joshtriplett.org> wrote:
> > >
> > > In addition to making the kernel smaller and such (I'll leave the
> > > specific stats there to Andi), here's the key awesomeness of LTO that
> > > you, personally, should find useful and compelling: LTO will eliminate
> > > the need to add many lower-level Kconfig symbols to compile out bits of
> > > the kernel.
> > 
> > Actually that, to me, is a negative right now.
> > 
> > Since there's no way we'll make LTO the default in the foreseeable
> > future, people starting to use it like that is just a bad bad thing.
> > 
> > So really, the main advantage of LTO would be any actual 
> > optimizations it can do. And call me anal, but I want *numbers* 
> > for that before I merge it. Not handwaving. I'm not actually aware 
> > of how well - if at all - code generation actually improves.
> 
> Well it looks very different if you look at the generated code. gcc 
> becomes a lot more aggressive.
> 
> But as I said there's currently no significant performance 
> improvement known, so if your only goal is better performance this 
> patch (as currently) known is not a big winner.  My suspicion is 
> that's mostly because the standard benchmarks we run are not too 
> compiler sensitive.
> 
> However the users seem to care about the other benefits, like code 
> size.
> 
> And there may well be loads that are compiler sensitive. As Honza 
> posted, for non kernel workloads LTO is known to have large 
> benefits.
> 
> Besides at this point it's pretty much just some additions to the 
> Makefiles.

So the reason I've been mostly ignoring the LTO patches myself (I only 
took LTO related changes that had other justifications such as 
cleanups) is that I've actually implemented full LTO in a userspace 
project myself, and my experience was:

  1) There was very little if any measurable LTO runtime speedup, 
     despite agressive GCC options and despite user-space generally 
     offering more optimizations opportunities than kernel space.

  2) LTO with current build tools meant a 1.5x-3x build speed
     slowdown (on a very fast box with tons of CPUs and RAM),
     which made LTO essentially a non-starter for development
     work. (And that was with the Gold linker.)

and looking at your characterisation of LTO you only conceded
#1 much after you started pushing LTO and you are clearly trying
to avoid talking about #2 while it's very much relevant...

I'm willing to be convinced by actual numbers, and LTO tooling might 
eventually improve, etc., but right now LTO is much ado about very 
little, being pushed in a somewhat dishonest way.

Thanks,

	Ingo
