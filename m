Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3KYTw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:52:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:57046 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3KYTw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:52:28 -0500
Date: Mon, 25 Nov 2013 20:52:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        "Norton, Scott J" <scott.norton@hp.com>, tom.vaden@hp.com,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
In-Reply-To: <1385405723.15768.3.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1311252049580.30673@ionos.tec.linutronix.de>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>  <1385168197-8612-5-git-send-email-davidlohr@hp.com>  <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>  <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net> 
 <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>  <CA+55aFwzRqPHKp67EhJ9hsX4v5=p3uQxvnaVZko2ZXDf6CQAPQ@mail.gmail.com>  <alpine.DEB.2.02.1311251715490.30673@ionos.tec.linutronix.de>  <20131125163627.GC10022@twins.programming.kicks-ass.net> 
 <alpine.DEB.2.02.1311251803040.30673@ionos.tec.linutronix.de> <1385405723.15768.3.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013, Davidlohr Bueso wrote:
> On Mon, 2013-11-25 at 18:32 +0100, Thomas Gleixner wrote:
> > If the smp_mb() is heavy weight, then it will hurt massivly in the
> > case where the hash bucket is not empty, because we add the price for
> > the smp_mb() just for no gain.
> > 
> > In that context it would also be helpful to measure the overhead on
> > x86 for the !empty case.
> 
> Absolutely, I will add these comparisons. If we do notice that we end up
> hurting the !empty case, would the current patch using atomic ops still
> be considered? We have made sure that none of the changes in this set
> affects performance on other workloads/smaller systems.

Please read my last reply to the atomic ops approach.

Aside of that we need numbers for a significant range of !x86.

Thanks,

	tglx
