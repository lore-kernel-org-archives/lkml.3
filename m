Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965932AbaLMILr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 03:11:47 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40661 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655AbaLMILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 03:11:46 -0500
Date: Sat, 13 Dec 2014 09:11:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Chris Mason <clm@fb.com>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141213081140.GF32572@gmail.com>
References: <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417542432.3924.39.camel@maggy.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417542432.3924.39.camel@maggy.simpson.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> On Tue, 2014-12-02 at 08:33 -0800, Linus Torvalds wrote:
> 
> > Looking again at that patch (the commit message still doesn't strike
> > me as wonderfully explanatory :^) makes me worry, though.
> > 
> > Is that
> > 
> >         if (rq->skip_clock_update-- > 0)
> >                 return;
> > 
> > really right? If skip_clock_update was zero (normal), it now gets set
> > to -1, which has its own specific meaning (see "force clock update"
> > comment in kernel/sched/rt.c). Is that intentional? That seems insane.
> 
> Yeah, it was intentional.  Least lines.
> 
> > Or should it be
> > 
> >         if (rq->skip_clock_update > 0) {
> >                 rq->skip_clock_update = 0;
> >                 return;
> >         }
> > 
> > or what? Maybe there was a reason the patch never got applied even to -tip.
> 
> Peterz was looking at corner case proofing the thing.  Saving those
> cycles has been entirely too annoying.
> 
> https://lkml.org/lkml/2014/4/8/295

Hm, so that discussion died with:

  https://lkml.org/lkml/2014/4/8/343

Did you ever get around to trying Peter's patch?

But ... I've yet to see rq_clock problems cause actual lockups. 
That's the main problem we have with its (un)robustness and why 
Peter created that rq_clock debug facility: bugs there cause 
latencies but no easily actionable symptoms, which are much 
harder to debug.

Thanks,

	Ingo
