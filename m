Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbaDIBf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:35:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:14502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628AbaDIBf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:35:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,822,1389772800"; 
   d="scan'208";a="517246708"
Date: Tue, 8 Apr 2014 18:35:57 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140409013557.GA32556@tassilo.jf.intel.com>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
 <20140408204906.GA3616@cloud>
 <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 03:44:25PM -0700, Linus Torvalds wrote:
> On Tue, Apr 8, 2014 at 1:49 PM,  <josh@joshtriplett.org> wrote:
> >
> > In addition to making the kernel smaller and such (I'll leave the
> > specific stats there to Andi), here's the key awesomeness of LTO that
> > you, personally, should find useful and compelling: LTO will eliminate
> > the need to add many lower-level Kconfig symbols to compile out bits of
> > the kernel.
> 
> Actually that, to me, is a negative right now.
> 
> Since there's no way we'll make LTO the default in the foreseeable
> future, people starting to use it like that is just a bad bad thing.
> 
> So really, the main advantage of LTO would be any actual optimizations
> it can do. And call me anal, but I want *numbers* for that before I
> merge it. Not handwaving. I'm not actually aware of how well - if at
> all - code generation actually improves.

Well it looks very different if you look at the generated code. gcc becomes
a lot more aggressive.

But as I said there's currently no significant performance improvement known,
so if your only goal is better performance this patch (as currently) 
known is not a big winner.  My suspicion is that's mostly because
the standard benchmarks we run are not too compiler sensitive.

However the users seem to care about the other benefits, like code size.

And there may well be loads that are compiler sensitive.
As Honza posted, for non kernel workloads LTO is known to have large benefits.

Besides at this point it's pretty much just some additions to the Makefiles.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
