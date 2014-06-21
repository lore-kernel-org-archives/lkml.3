Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaFUTzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 15:55:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:36860 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaFUTzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 15:55:08 -0400
Date: Sat, 21 Jun 2014 21:54:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand unprotected
 when accessed by /proc)
In-Reply-To: <20140618125307.3994b701@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406212153300.5170@nanos>
References: <20140611175934.GA28912@redhat.com> <20140611195613.GM4581@linux.vnet.ibm.com> <20140612172844.GA15795@redhat.com> <20140612203518.GZ4581@linux.vnet.ibm.com> <alpine.DEB.2.10.1406122337060.5170@nanos> <20140612222748.GF4581@linux.vnet.ibm.com>
 <20140612231944.GA30683@linux.vnet.ibm.com> <20140613150830.GB31794@redhat.com> <20140615054058.GJ4581@linux.vnet.ibm.com> <20140617185755.GA8600@linux.vnet.ibm.com> <20140618164359.GA18598@redhat.com> <20140618125307.3994b701@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Steven Rostedt wrote:

> On Wed, 18 Jun 2014 18:43:59 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
>  
> > And (contrary to what I said initially) we can rely on this because -rt
> > converts spinlock_t into rt_mutex ?
> 
> Correct. Because if spinlock_t has this behavior, rt_mutex must have it
> too, otherwise -rt will suffer greatly from that. Who knows, maybe this
> will fix some strange bug reports that we have had in the past.

Indeed. I found a few backtraces from Carstens test farm, where stuff
explodes in the slowpath raw_spin_unlock call. Happens once a year or
never ...

Thanks,

	tglx
