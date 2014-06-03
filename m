Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaFCWCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:02:34 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:39824 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaFCWCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:02:33 -0400
Message-ID: <1401832948.8843.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [GIT PULL] locking tree changes for v3.16
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 03 Jun 2014 15:02:28 -0700
In-Reply-To: <20140603145526.f78e1cb7462048376709b6f0@linux-foundation.org>
References: <20140603114821.GA23711@gmail.com>
	 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
	 <20140603145526.f78e1cb7462048376709b6f0@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 14:55 -0700, Andrew Morton wrote:
> On Tue, 03 Jun 2014 14:50:51 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
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
> 
> I'd prefer not - I put it in there just to get some linux-next exposure.
> A change like this should be carefully poked at by people who understand
> what they're poking.

The patch was reviewed, tested and taken for tip by tglx -- then dropped
because of the gcc warnings for archs that use the spinlock rwsem
variant, which was quickly fixed and confirmed by Peter.

So I'm not sure why it dropped in the first place (the same thing
occurred with the qrwlock_t stuff).

This is a pretty big change that boosts performance significantly. I
really wouldn't want to wait another development cycle for nothing. If
it's too late in the pull request and tip maintainers are ok with it, I
would very much like it to be merged either directly through Linux
(who's occasionally done such things in the past) or by you.

Thanks,
Davidlohr

