Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbaGRDKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:10:32 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:12389 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465AbaGRDKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:10:31 -0400
Message-ID: <1405653021.21735.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:locking/urgent] locking/mutex: Disable optimistic spinning
 on some architectures
From: Davidlohr Bueso <davidlohr@hp.com>
To: mingo@kernel.org
Cc: torvalds@linux-foundation.org, catalin.marinas@arm.com,
        peterz@infradead.org, cmetcalf@tilera.com, jason.low2@hp.com,
        linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, dave.anglin@bell.net,
        James.Bottomley@hansenpartnership.com, will.deacon@arm.com,
        waiman.long@hp.com, james.hogan@imgtec.com, mpatocka@redhat.com,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, vgupta@synopsys.com,
        benh@kernel.crashing.org, jejb@parisc-linux.org,
        linux-tip-commits@vger.kernel.org, stable@kernel.org
Date: Thu, 17 Jul 2014 20:10:21 -0700
In-Reply-To: <1405652857.21735.7.camel@buesod1.americas.hpqcorp.net>
References: <20140606175316.GV13930@laptop.programming.kicks-ass.net>
	 <tip-4badad352a6bb202ec68afa7a574c0bb961e5ebc@git.kernel.org>
	 <1405652857.21735.7.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 20:07 -0700, Davidlohr Bueso wrote:
> On Wed, 2014-07-16 at 12:24 -0700, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  4badad352a6bb202ec68afa7a574c0bb961e5ebc
> > Gitweb:     http://git.kernel.org/tip/4badad352a6bb202ec68afa7a574c0bb961e5ebc
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Fri, 6 Jun 2014 19:53:16 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 16 Jul 2014 14:57:07 +0200
> > 
> > locking/mutex: Disable optimistic spinning on some architectures
> > 
> > The optimistic spin code assumes regular stores and cmpxchg() play nice;
> > this is found to not be true for at least: parisc, sparc32, tile32,
> > metag-lock1, arc-!llsc and hexagon.
> > 
> > There is further wreckage, but this in particular seemed easy to
> > trigger, so blacklist this.
> > 
> > Opt in for known good archs.
> > 
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> > Cc: Vineet Gupta <vgupta@synopsys.com>
> > Cc: Jason Low <jason.low2@hp.com>
> > Cc: Waiman Long <waiman.long@hp.com>
> > Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> > Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: John David Anglin <dave.anglin@bell.net>
> > Cc: James Hogan <james.hogan@imgtec.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Davidlohr Bueso <davidlohr@hp.com>
> > Cc: stable@vger.kernel.org
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Cc: sparclinux@vger.kernel.org
> > Link: http://lkml.kernel.org/r/20140606175316.GV13930@laptop.programming.kicks-ass.net
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Cc'ing stable: this issue was reported to begin after commit fb0527bd,
> so since v3.13.

Bah, never mind, I missed it when scanning the Cc list. Sorry about the
noise.

