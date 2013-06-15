Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab3FOB2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:28:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:51056 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab3FOB2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:28:51 -0400
Message-ID: <1371259580.21896.18.camel@pasglop>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, ????????? <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>
Date: Sat, 15 Jun 2013 11:26:20 +1000
In-Reply-To: <51BB5E27.5010009@hp.com>
References: <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	 <1370974231.9844.212.camel@gandalf.local.home>
	 <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
	 <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>
	 <20130612233224.GH4165@ZenIV.linux.org.uk>
	 <CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com>
	 <20130613002058.GI4165@ZenIV.linux.org.uk>
	 <CA+55aFxEnNvj1SoOL+ChVQqK+ouSNgsM+6cQt+=PpmTGdcFggg@mail.gmail.com>
	 <20130613004941.GJ4165@ZenIV.linux.org.uk>
	 <CA+55aFz-=xewm_6MuxK9JK_GoqyFSo6L-beXyEv83awe+B_rVw@mail.gmail.com>
	 <51BB2FFC.8060209@hp.com>
	 <CA+55aFxmdPAeknSVH8fhdJW4VH=EcJ4dfBQUuQp_M_hnrr295g@mail.gmail.com>
	 <51BB5E27.5010009@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 14:17 -0400, Waiman Long wrote:
> 
> With some minor changes, the current patch can be modified to support 
> debugging lock for 32-bit system. For 64-bit system, we can apply a 
> similar concept for debugging lock with cmpxchg_double. However, for 
> architecture that does not have cmpxchg_double support, it will be out 
> of luck and we probably couldn't support the same feature in debugging 
> mode. It will have to fall back to taking the lock.

That means only x86_64 and s390 would benefit from it ... I'm sure we can do better :-)

Cheers,
Ben.


