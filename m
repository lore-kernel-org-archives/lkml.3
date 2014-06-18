Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaFRQpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:45:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbaFRQpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:45:30 -0400
Date: Wed, 18 Jun 2014 18:43:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140618164359.GA18598@redhat.com>
References: <20140611175934.GA28912@redhat.com> <20140611195613.GM4581@linux.vnet.ibm.com> <20140612172844.GA15795@redhat.com> <20140612203518.GZ4581@linux.vnet.ibm.com> <alpine.DEB.2.10.1406122337060.5170@nanos> <20140612222748.GF4581@linux.vnet.ibm.com> <20140612231944.GA30683@linux.vnet.ibm.com> <20140613150830.GB31794@redhat.com> <20140615054058.GJ4581@linux.vnet.ibm.com> <20140617185755.GA8600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617185755.GA8600@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Paul E. McKenney wrote:
>
> +		if (drop_boost_mutex) {
> +			rt_mutex_unlock(&rnp->boost_mtx);
>  			complete(&rnp->boost_completion);

Well, I still do not understand this ->boost_completion...

> -	/* Wait until boostee is done accessing mtx before reinitializing. */
> +	/* Wait for boostee to be done w/boost_mtx before reinitializing. */
>  	wait_for_completion(&rnp->boost_completion);

OK, at least we have a comment.

But let me repeat. Thomas has already fixed rt_mutex, unlock is atomic.
It doesn't touch this memory after it makes another lock() possible.

And (contrary to what I said initially) we can rely on this because -rt
converts spinlock_t into rt_mutex ?

Oleg.

