Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaFDRWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:22:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaFDRWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:22:31 -0400
Date: Wed, 4 Jun 2014 19:22:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140604172220.GI13930@laptop.programming.kicks-ass.net>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <CA+55aFzTGHrR2dr64BsMOE--QXqw_=mwqypmweebRe-1UkJGZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTGHrR2dr64BsMOE--QXqw_=mwqypmweebRe-1UkJGZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:17:20AM -0700, Linus Torvalds wrote:
> On Wed, Jun 4, 2014 at 3:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Ingo is 'missing' most of the time, so while I sit here with a massive
> > queue of patches its nearly impossible for me to get anything merged :-(
> 
> Ugh. I'd love to get this whole locking stuff sorted out. At worst,
> could you just set up a git tree of your own with the locking patches?
> Or I could even just take an emailed patch-series, although I do
> prefer the convenience of a git pull.. This has been going on for a
> _loong_ time now.

I wrote a script a week or so ago that exports my quilt series to a git
tree based on tip branches; the locking/core tree is:

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git locking/core

It has the rwsem opt spinning patches and the qrwlock in.

I still need to look at the last qspinlock thing, the last time I looked
at that the paravirt stuff wrecked the native case.


I _think_ tip/locking/core is empty and you could pull that into your
tree without getting tons of extra weird stuff, but if you prefer a tree
based on your git tree I'll have to do some manual stuff but that is
certainly possible.

Also, this 'obviously' does not have the normal tip build coverage,
because I usually rely on the tip build robots to do that. But it does
build and run for all my local machines.
