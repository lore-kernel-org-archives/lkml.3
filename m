Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbbAUG3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:29:46 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51274 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbbAUG3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:29:42 -0500
Message-ID: <1421821779.16275.5.camel@marge.simpson.net>
Subject: Re: [PATCH] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Date: Wed, 21 Jan 2015 07:29:39 +0100
In-Reply-To: <20150121051008.GX9719@linux.vnet.ibm.com>
References: <20150107165223.GA21555@linux.vnet.ibm.com>
	 <20150108043329.GB27996@mail.thefacebook.com>
	 <20150108045306.GJ5280@linux.vnet.ibm.com>
	 <20150108214644.GC27996@mail.thefacebook.com>
	 <alpine.DEB.2.11.1501131215380.5526@nanos>
	 <20150113184301.GO9719@linux.vnet.ibm.com>
	 <20150113211618.GA21498@mail.thefacebook.com>
	 <alpine.DEB.2.11.1501201419550.5526@nanos>
	 <20150120203022.GR9719@linux.vnet.ibm.com>
	 <1421811639.5285.25.camel@marge.simpson.net>
	 <20150121051008.GX9719@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 21:10 -0800, Paul E. McKenney wrote: 
> On Wed, Jan 21, 2015 at 04:40:39AM +0100, Mike Galbraith wrote:

> > I've been curious about this for ages, so now is a great time to bite
> > the bullet and ask TheMan.  A context switch is not far away, why do we
> > need that quiescent state badly enough to tell what looks like a little
> > white lie to get it immediately?
> > 
> > (I commented it out in an -rt kernel I was testing yesterday, beat it
> > enthusiastically for a while, and box didn't _seem_ to notice that it
> > was missing anything)
> 
> Yeah, you do have to have a fairly violent network-based DoS attack
> to see the difference.  Robert Olsson was the first to make this happen
> back in the day.

Ah, my little NIC doesn't have enough poop to do that.  Thanks.

-Mike

