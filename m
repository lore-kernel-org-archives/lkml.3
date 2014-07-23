Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbaGWSFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:05:10 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:56963 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbaGWSFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:05:08 -0400
Date: Wed, 23 Jul 2014 20:05:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dirk Gouders <dirk@gouders.net>,
        mmarek@suse.cz
Subject: Re: [PATCH 1/2] kbuild: Support split debug info v3
Message-ID: <20140723180501.GA15749@ravnborg.org>
References: <1405466172-17055-1-git-send-email-andi@firstfloor.org>
 <20140720190420.GA4630@ravnborg.org>
 <20140720211901.GQ5803@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720211901.GQ5803@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 02:19:01PM -0700, Andi Kleen wrote:
> > Why are as only called with -Wa,-gdwarf-2 in the non-split case?
> > Is this a bug or intentional?
> > If it is intentional then it is not explained.
> 
> Probably was a merging mistake. Will fix.
> 
> > > +	help
> > > +	  Generate debug info into separate .dwo files. This can be
> > > +	  faster for building than including the debug information directly
> > Here the "faster" part is promoted.
> > But in your cover letter you actually highlight the "smaller" case
> > as more significant.
> > Maybe include info on both positive items.
> 
> I currently don't see it significantly faster in my setup, will
> mention size. It may be in others though. Feel free to test.

I tried to test this on my setup - it is a Intel Atom with 2 cores.
16 GB RAM, a 7200 RPM stat disk.
In other words a low-spec setup.

Base config was "make allnoconfig"

make KCFLAGS=-g
real    3m35.967s
user    12m19.270s
sys     1m15.082s

make KCFLAGS=-gsplit-dwarf
real    3m33.366s
user    12m11.156s
sys     1m17.772s

I did like this:
echo time make -j4 -s KCFLAGS=-gsplit-dwarf
time make -j4 -s KCFLAGS=-gsplit-dwarf
echo time make -j4 -s KCFLAGS=-g
time make -j4 -s KCFLAGS=-g
echo time make -j4 -s KCFLAGS=-gsplit-dwarf
time make -j4 -s KCFLAGS=-gsplit-dwarf
echo time make -j4 -s KCFLAGS=-g
time make -j4 -s KCFLAGS=-g
echo time make -j4 -s KCFLAGS=-gsplit-dwarf
time make -j4 -s KCFLAGS=-gsplit-dwarf
echo time make -j4 -s KCFLAGS=-g
time make -j4 -s KCFLAGS=-g

The figures are from last run - but the other runs had compareable times.
So in short I see a ~3 seconds speedup - out of 210 seconds.
Thats less than I anticipated.

But a speed-up never the less - which was consistent over all three runs.

	Sam
