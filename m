Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab3LJSFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:05:20 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:37162 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3LJSFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:05:18 -0500
Date: Tue, 10 Dec 2013 10:05:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v5 tip/core/locking 5/7]
 Documentation/memory-barriers.txt: Downgrade UNLOCK+LOCK
Message-ID: <20131210180511.GZ4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131210012738.GA24317@linux.vnet.ibm.com>
 <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386638883-25379-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131210131422.GG12849@twins.programming.kicks-ass.net>
 <20131210171247.GQ4208@linux.vnet.ibm.com>
 <20131210172528.GQ12849@twins.programming.kicks-ass.net>
 <20131210174320.GB10311@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210174320.GB10311@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121018-1344-0000-0000-000003FF0CBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:43:20AM -0800, Josh Triplett wrote:
> On Tue, Dec 10, 2013 at 06:25:28PM +0100, Peter Zijlstra wrote:
> > On Tue, Dec 10, 2013 at 09:12:47AM -0800, Paul E. McKenney wrote:
> > > > The way I read the above it says that you need
> > > > smp_mb__after_unlock_lock() when the UNLOCK and LOCK are on the same
> > > > variable. That doesn't make sense, I thought that was the one case we
> > > > all agreed on it would indeed be a full barrier without extra trickery.
> > > 
> > > On x86, sure, but smp_mb__after_unlock_lock() is nothingness on x86
> > > anyway.  Other architectures might benefit from requiring that the
> > > smp_mb__after_unlock_lock() be used in this case.
> > 
> > Confused, UNLOCK X, LOCK X, must always be fully serializing. That's the
> > entire purpose of the thing.
> > 
> > The only place you can go play games (and clearly we are going there) is
> > when the UNLOCK and LOCK are on different variables.
> 
> That would certainly be a good assumption to preserve, and it would
> eliminate most of the need for smp_mb__after_unlock_lock().

Perhaps RCU is an outlier, but most of the places where I added
smp_mb__after_unlock_lock() had an unlock of one rcu_node structure's
->lock followed by a lock of another rcu_node structure's ->lock.

							Thanx, Paul

