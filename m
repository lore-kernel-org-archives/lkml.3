Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaFEISP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:18:15 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64298 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaFEIRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:17:47 -0400
Date: Thu, 5 Jun 2014 10:17:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605081742.GC4926@gmail.com>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604103003.GE11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Jun 03, 2014 at 02:50:51PM -0700, Davidlohr Bueso wrote:
> > On Tue, 2014-06-03 at 13:48 +0200, Ingo Molnar wrote:
> > > Linus,
> > > 
> > > Please pull the latest locking-core-for-linus git tree from:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-core-for-linus
> > > 
> > >    # HEAD: 3cf2f34e1a3d4d5ff209d087925cf950e52f4805 rwsem: Add comments to explain the meaning of the rwsem's count field
> > > 
> > > The main changes in this cycle were:
> > > 
> > >  - reduced/streamlined smp_mb__*() interface that allows more usecases 
> > >    and makes the existing ones less buggy, especially in rarer 
> > >    architectures
> > > 
> > >  - add rwsem implementation comments
> > > 
> > >  - bump up lockdep limits
> > 
> > So I guess the rwsem optimistic spinning stuff will be routed through
> > akpm then (which is already in -next for a while, through -mm).
> > 
> > Also curious about why Peter's rewrite of the qrwlock_t was 
> > removed from -tip... I noticed it was there for a few days then 
> > disappeared. What am I missing?

I merged it, but then it broke and I reported the breakage - and 
zapped the bits to not create dependencies on broken bits.

( There was also quite some discussion back and forth as recently as 
  two weeks ago, so it didn't feel cooked enough to me to pick it up 
  directly from email - but once it shows up in your queue I'm picking 
  it up. )

> Ingo is 'missing' most of the time, so while I sit here with a 
> massive queue of patches its nearly impossible for me to get 
> anything merged :-(

Right now I'm somewhat 'missing' because I fell ill right when the 
merge window began :-/ But I merged all your pending bits shortly 
before the merge window started. During the merge window itself I
try not to merge fresh patches.

Thanks,

	Ingo
