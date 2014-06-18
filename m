Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaFRRAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:00:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58108 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaFRRAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:00:44 -0400
Date: Wed, 18 Jun 2014 10:00:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140618170038.GQ4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140611195613.GM4581@linux.vnet.ibm.com>
 <20140612172844.GA15795@redhat.com>
 <20140612203518.GZ4581@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406122337060.5170@nanos>
 <20140612222748.GF4581@linux.vnet.ibm.com>
 <20140612231944.GA30683@linux.vnet.ibm.com>
 <20140613150830.GB31794@redhat.com>
 <20140615054058.GJ4581@linux.vnet.ibm.com>
 <20140617185755.GA8600@linux.vnet.ibm.com>
 <20140618164359.GA18598@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618164359.GA18598@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061817-1542-0000-0000-000002A984A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:43:59PM +0200, Oleg Nesterov wrote:
> On 06/17, Paul E. McKenney wrote:
> >
> > +		if (drop_boost_mutex) {
> > +			rt_mutex_unlock(&rnp->boost_mtx);
> >  			complete(&rnp->boost_completion);
> 
> Well, I still do not understand this ->boost_completion...
> 
> > -	/* Wait until boostee is done accessing mtx before reinitializing. */
> > +	/* Wait for boostee to be done w/boost_mtx before reinitializing. */
> >  	wait_for_completion(&rnp->boost_completion);
> 
> OK, at least we have a comment.
> 
> But let me repeat. Thomas has already fixed rt_mutex, unlock is atomic.
> It doesn't touch this memory after it makes another lock() possible.
> 
> And (contrary to what I said initially) we can rely on this because -rt
> converts spinlock_t into rt_mutex ?

Well, perhaps I should rein in my paranoia on this one.  That said, the
cost of my paranoia is minimal in this slowpath.

							Thanx, Paul

