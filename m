Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbaDIPni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:43:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:62814 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbaDIPng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:43:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,826,1389772800"; 
   d="scan'208";a="490052731"
Date: Wed, 9 Apr 2014 08:40:11 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140409154011.GB32556@tassilo.jf.intel.com>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
 <20140408204906.GA3616@cloud>
 <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
 <20140409013557.GA32556@tassilo.jf.intel.com>
 <20140409060133.GA6766@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409060133.GA6766@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   1) There was very little if any measurable LTO runtime speedup, 
>      despite agressive GCC options and despite user-space generally 
>      offering more optimizations opportunities than kernel space.

See Honza's email. There are lots of benefits in various
large projects.

Also BTW compiler technology is not static. It's often
hard to interpolate from older releases, and to see
project benefits for different projects.

>   2) LTO with current build tools meant a 1.5x-3x build speed
>      slowdown (on a very fast box with tons of CPUs and RAM),

I see about 40-60% build time penalty with gcc 4.9 / single link.

>      which made LTO essentially a non-starter for development
>      work. (And that was with the Gold linker.)

I see LTO as a "release build", as opposed to a development build.
I don't think it's a big problem in such a model. If you don't
like that model, just don't enable it.

> I'm willing to be convinced by actual numbers, and LTO tooling might 
> eventually improve, etc., but right now LTO is much ado about very 
> little, being pushed in a somewhat dishonest way.

The concrete tangible advantages at this point are code size
on smaller configs.  There are a variety of users who use it for that.

I think it's worth merging for that alone.

-Andi
