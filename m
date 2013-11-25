Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3KYRi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:38:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48283 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3KYRi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:38:27 -0500
Date: Mon, 25 Nov 2013 18:38:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        "Norton, Scott J" <scott.norton@hp.com>, tom.vaden@hp.com,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131125173811.GD10022@twins.programming.kicks-ass.net>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
 <1385168197-8612-5-git-send-email-davidlohr@hp.com>
 <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>
 <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net>
 <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>
 <CA+55aFwzRqPHKp67EhJ9hsX4v5=p3uQxvnaVZko2ZXDf6CQAPQ@mail.gmail.com>
 <alpine.DEB.2.02.1311251715490.30673@ionos.tec.linutronix.de>
 <20131125163627.GC10022@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1311251803040.30673@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311251803040.30673@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 06:32:55PM +0100, Thomas Gleixner wrote:
> In that context it would also be helpful to measure the overhead on
> x86 for the !empty case.

Yes, because mfence is by no means a cheap instruction on x86.
