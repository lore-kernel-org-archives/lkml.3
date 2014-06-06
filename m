Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaFFPma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:42:30 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:44758 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaFFPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:42:29 -0400
Message-ID: <1402069339.14433.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>,
        mingo@kernel.org
Date: Fri, 06 Jun 2014 08:42:19 -0700
In-Reply-To: <20140606150607.GT13930@laptop.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
	 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
	 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
	 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com>
	 <20140606150607.GT13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 17:06 +0200, Peter Zijlstra wrote:
> On Mon, Jun 02, 2014 at 10:09:35AM -0700, Linus Torvalds wrote:
> > On Mon, Jun 2, 2014 at 9:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > And I can't say I'm a particular fan of these ops either, as alternative
> > > I'm almost inclined to just exclude parisc from using opt spinning.
> > 
> > Please do.
> 
> Something like so; if the rwsem stuff lands in .15 we need more for
> that, it doesn't have a convenient CONFIG symbol like this.
> 
> Linus will you take this from email, or should I get it through
> tip/locking/urgent or so?
> 
> ---
> Subject: locking, mutex: Disable optimistic spinning for PA-RISC
> 
> PA-RISC's cmpxchg is not save against normal stores and the code used
> for optimistic spinning is known broken because of this.
> 
> Disable for now.

I almost hit the send button :)

> 
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

