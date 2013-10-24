Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3JXKPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:15:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:35215 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3JXKPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:15:13 -0400
Date: Thu, 24 Oct 2013 12:14:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <waiman.long@hp.com>
cc: walken@google.com, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v4 1/3] qrwlock: A queue read/write lock implementation
In-Reply-To: <52680022.1020200@hp.com>
Message-ID: <alpine.DEB.2.02.1310241207500.4983@ionos.tec.linutronix.de>
References: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com> <1380722946-30468-2-git-send-email-Waiman.Long@hp.com> <20131023120004.GD2862@localhost> <52680022.1020200@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Oct 2013, Waiman Long wrote:
> On 10/23/2013 08:00 AM, walken@google.com wrote:
> > > +	/*
> > > +	 * Wait until the next one in queue set up the next field
> > > +	 */
> > > +	while (likely(!(next = ACCESS_ONCE(node->next))))
> > > +		cpu_relax();
> > > +	/*
> > > +	 * The next one in queue is now at the head
> > > +	 */
> > > +notify_next:
> > > +	barrier();
> > > +	ACCESS_ONCE(next->wait) = false;
> > > +	smp_wmb();
> > > +}
> > I believe this could be unified with mspin_lock() / mspin_unlock() in
> > kernel/mutex.c ? (there is already talk of extending these functions
> > to be used by rwsem for adaptive spinning as well...)
> 
> It probably can, but the unification can wait until the code are in.

The unification has to be done as a part of this series. Cleanups are
part of the development process of new code and not an optional
feature.

Thanks,

	tglx

