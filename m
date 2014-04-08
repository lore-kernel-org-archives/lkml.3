Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbaDHWuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:50:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:65415 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbaDHWuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:50:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,821,1389772800"; 
   d="scan'208";a="509664884"
Date: Tue, 8 Apr 2014 15:49:26 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hubicka@ucw.cz, jmario@redhat.com
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140408224926.GY32556@tassilo.jf.intel.com>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> So right now, I see several reasons not to merge it ("It's so
> experimental that we don't even want to encourage people to test it"

I don't want them to enable it during allyesconfig because they
might need more than 4GB of RAM to build it (especially with gcc 
4.8, 4.9 is better). But allyesconfig is a special case. More standard
kernels with smaller vmlinux don't have this problem, but build
somewhat slower.

> to "it's not fully fleshed out yet and makes compile times _much_
> longer").

It's functionally stable, I have a number of users who
don't report any problems.

> 
> And yet nobody has actually talked about why I *should* merge it.
> 
> Which - I think understandably - makes me less than enthusiastic.
> 
> So I think I'll let this wait a bit longer, _unless_ people start
> talking about the upsides. How much smaller is the end result? How
> much faster is it? How much more beautiful is it? Does it make new

The smaller part is mainly visible with small kernels, because
it's very good at throwing out unused code there.  All the
stuff in kernel etc. that is not used.

For example Tim Bird saw ~11% binary reduction on ARM with his 
configs [1]. We also see some reduction in small configs.

Some of the static measures like nice, for example
a LTO kernel has ~4% less calls.

We did some performance tests, but at least in the standard
macro benchmarks we do there wasn't a clear performance
win.  LKP had a small win, but nothing dramatic.
But I would like others to test it on their workloads.

In principle LTO can do cool optimizations, like propagating
constants into functions (e.g. generate specialized versions
of some code). I experimented a bit with this, however
it currently seems to bloat the code quite a bit.

There are some other possible future optimizations
that can be enabled by a global optimizer.

Honza may have more reasons for LTO.

Other benefits are global warnings and some additional
type checking. The LTO log files are really useful
to do global call graph analysis and similar.

-Andi

[1] http://elinux.org/images/9/9e/Bird-Kernel-Size-Optimization-LCJ-2013.pdf

-- 
ak@linux.intel.com -- Speaking for myself only
