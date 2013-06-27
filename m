Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab3F0NGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:06:18 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:54278 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3F0NGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:06:14 -0400
Date: Thu, 27 Jun 2013 15:06:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de
Subject: Re: deadlock in scheduler enabling HRTICK feature
Message-ID: <20130627130609.GA6655@gmail.com>
References: <51CA0622.8010105@gmail.com>
 <20130625211713.GA18796@laptop.programming.kicks-ass.net>
 <51CA0980.8010409@gmail.com>
 <20130626070533.GA3601@dyad.programming.kicks-ass.net>
 <51CB1AE9.5090709@gmail.com>
 <20130627104309.GQ28407@twins.programming.kicks-ass.net>
 <20130627105303.GD27378@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627105303.GD27378@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jun 27, 2013 at 12:43:09PM +0200, Peter Zijlstra wrote:
> > On Wed, Jun 26, 2013 at 10:46:33AM -0600, David Ahern wrote:
> > > On 6/26/13 1:05 AM, Peter Zijlstra wrote:
> > > >>What is the expectation that the feature provides? not a whole lot of
> > > >>documentation on it. I walked down the path wondering if it solved an odd
> > > >>problem we are seeing with the CFS in 2.6.27 kernel.
> > > >
> > > >Its supposed to use hrtimers for slice expiry instead of the regular tick.
> > > 
> > > So theoretically CPU bound tasks would get preempted sooner? That was my
> > > guess/hope anyways.
> > 
> > Doth the below worketh?
> > 
> 
> Related to all this; the reason its not enabled by default is that 
> mucking about with hrtimers all the while is god awful expensive.
> 
> I've had ideas about making this a special purpose 'hard-coded' timer in 
> the hrtimer guts that's only ever re-programmed when the new value is 
> sooner.
> 
> By making it a 'special' timer we can avoid the whole rb-tree song and 
> dance; and by taking 'spurious' short interrupts we can avoid prodding 
> the hardware too often.

Sounds neat ...

> Then again; Thomas will likely throw frozen seafood my way for even 
> proposing stuff like this and I'm not even sure that's going to be 
> enough to make the cost acceptable.

(Could be worse: rotten seafood?)

Thanks,

	Ingo
